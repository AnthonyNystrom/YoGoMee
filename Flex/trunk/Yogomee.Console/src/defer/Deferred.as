package defer
{
	import flash.utils.Timer;
	
	import mx.core.Application;
	
	/**
	 * Ported from twisted.
	 * 
	 * Support for results that aren't immediately available.
	 * 
	*/
	public class Deferred
	{
		/**
		 * @private
		 * Are we currently running a user-installed callback? Meant to prevent
		 * recursive running of callbacks when a reentrant call to add a callback is
		 * used.
		*/
		private var _runningCallbacks:Boolean;
		
		private var _callbacks:Array;
		private var _called:Boolean;
		private var _paused:int;
		
		private var _result:*;
		
		private static var calls:Array;
		private static var _timer:Timer;
		
		(function ():void
		{
			/*calls = new Array();
			_timer = new Timer(20);
			
			Application.application.callLater(nextCall);*/
			
			/*_timer.addEventListener(
				TimerEvent.TIMER,
				function(event:TimerEvent):void
				{
					if(calls.length > 0)
					{
						var c:Object = calls.shift();
						var fn:Function = c.fn as Function;
						fn.apply(null, c.args);
					}
				});
				
			_timer.start();*/
			
		})();
		
		public static function nextCall():void
		{
			/*if(calls.length > 0)
			{
				var c:Object = calls.shift();
				var fn:Function = c.fn as Function;
				fn.apply(null, c.args);
			}*/
			
			for(var i:int = 0; i < calls.length; i++)
			{
				var c:Object = calls.shift();
				var fn:Function = c.fn as Function;
				fn.apply(null, c.args);
			}
			
			Application.application.callLater(nextCall);
		}
		
		public static function callLater(delay:int, fn:Function, ...args):void
		{
			/*var timer:Timer = new Timer(delay, 1);
			
			timer.addEventListener(
				TimerEvent.TIMER,
				function(event:TimerEvent):void
				{
					fn.apply(null, args);
				});
				
			timer.start();*/
			/*var c:Object = new Object();
			c.fn = fn;
			c.args = args;
			calls.push(c);*/
			Application.application.callLater(fn, args);
		}
		
		/**
		 * Return a <code>Deferred</code> that has already had <code>callback(result)</code> called. 
		 * This is useful when you're writing synchronous code to an
		 * asynchronous interface: i.e., some code is calling you expecting a
		 * <code>Deferred</code> result, but you don't actually need to do anything
		 * asynchronous. Just return <code>Deferred.succeed(result)</code>.
		 * 
		 * See <code>Deferred.fail(result)</code> for a version of this function that uses a failing
		 * <code>Deferred</code> rather than a successful one.
		 * 
		 * @param result The result to give to the Deferred's <code>callback</code> method.
		 * 
		 * @return <code>Deferred</code>
		*/
		public static function succeed(result:*):Deferred
		{
			var d:Deferred = new Deferred();
			//Deferred.callLater(0, d.callback, result);
			d.callback(result);
			return d;
		}
		
		/**
		 * Return a <code>Deferred</code> that has already had <code>errback(result)</code> called.
		 * See <code>Deferred.succeed</code> for rationale.
		 * 
		 * @param result The same argument that <code>Deferred.errback</code> takes.
		 * 
		 * @return <code>Deferred</code>
		*/
		public static function fail(result:* = null):Deferred
		{
			var d:Deferred = new Deferred();
			d.errback(result);
			return d;
		}
		
		public function Deferred()
		{
			this._runningCallbacks = false;
			this._callbacks = [];
			this._called = false;
			this._paused = 0;
		}
		
		/**
		 * Add a pair of callbacks (success and error) to this <code>Deferred</code>.
		 * These will be executed when the 'master' callback is run.
		*/
		public function addCallbacks(
			callback:Function,
			errback:Function=null,
			callbackArgs:Array=null,
			errbackArgs:Array=null):Deferred
		{
			if (errback == null)
			{
				errback = passthru;
			}
			
			var cbs:Array = [[callback, callbackArgs], [errback, errbackArgs]]
			this._callbacks.push(cbs);
			
			if (this._called)
			{
				this._runCallbacks();
			}
			
			return this;
		}
		
		/**
		 * Convenience method for adding just a callback.
		*/
		public function addCallback(callback:Function, ...args):Deferred
		{
			return this.addCallbacks(callback, null, args);
		}
		
		/**
		 * Convenience method for adding just an errback.
		*/
		public function addErrback(errback:Function, ...args):Deferred
		{
			return this.addCallbacks(passthru, errback, [], args);
		}
		
		/**
		 * Convenience method for adding a single callable as both a callback
		 * and an errback.
		*/
		public function addBoth(callback:Function, ...args):Deferred
		{
			return this.addCallbacks(callback, callback, args, args);
		}
		
		/**
		 * Chain another <code>Deferred</code> to this <code>Deferred</code>.
		 * This method adds callbacks to this <code>Deferred</code> to call <code>deferred</code>'s callback or
		 * errback, as appropriate. It is merely a shorthand way of performing
		 * the following:
		 * 
		 * 		<code>this.addCallbacks(deferred.callback, deferred.errback)</code>
		 * 
		 * When you chain a deferred d2 to another deferred d1 with
		 * <code>d1.chainDeferred(d2)</code>, you are making d2 participate in the callback
		 * chain of d1. Thus any event that fires d1 will also fire d2.
		 * However, the converse is not true; if d2 is fired d1 will not be
		 * affected.
		*/
		public function chainDeferred(deferred:Deferred):Deferred
		{
			return this.addCallbacks(deferred.callback, deferred.errback);
		}
		
		/**
		 * Run all success callbacks that have been added to this <code>Deferred</code>.
		 * 
		 * Each callback will have its result passed as the first
		 * argument to the next; this way, the callbacks act as a
		 * 'processing chain'. Also, if the success-callback returns a <code>Failure</code>
		 * or raises an <code>Exception</code>, processing will continue on the *error*-
		 * callback chain.
		*/
		public function callback(result:*):void
		{
			this._startRunCallbacks(result);
		}
		
		/**
		 * Run all error callbacks that have been added to this <code>Deferred</code>.
		 * 
		 * Each callback will have its result passed as the first
		 * argument to the next; this way, the callbacks act as a
		 * 'processing chain'. Also, if the error-callback returns a non-Failure
		 * or doesn't raise an Exception, processing will continue on the
		 * *success*-callback chain.
		 * 
		 * If the argument that's passed to me is not a <code>Failure</code> instance,
		 * it will be embedded in one.
		*/
		public function errback(fail:*=null):void
		{
			if (!(fail is Failure))
			{
				fail = new Failure(fail);
			}
			
			this._startRunCallbacks(fail);
		}
		
		/**
		 * Stop processing on a <code>Deferred</code> until <code>unpause()</code> is called.
		*/
		public function pause():void
		{
			this._paused++;
		}
		
		/**
		 * Process all callbacks made since <code>pause()</code> was called.
		*/
		public function unpause():void
		{
			this._paused--;
			
			if (this._paused > 0)
			{
				return;
			}
			
			if (this._called)
			{
				this._runCallbacks();
			}
		}
		
		/**
		 * @private
		*/
		private function _continue(result:*):void
		{
			this._result = result;
			this.unpause();
		}
		
		/**
		 * @private
		*/
		private function _startRunCallbacks(result:*):void
		{
			this._called = true;
			this._result = result;
			this._runCallbacks()
		}
		
		/**
		 * @private
		*/
		private function _runCallbacks():void
		{
			// Don't recursively run callbacks
			if (this._runningCallbacks)
			{
				return;
			}
			
			if (this._paused == 0)
			{
				while (this._callbacks.length > 0)
				{
					var item:Array = this._callbacks.shift()
					if (this._result is Failure)
					{
						item = item[1];
					}
					else
					{
						item = item[0];
					}
					
					var callback:Function = item[0];
					var args:Array = item[1];
					
					if (args == null)
					{
						args = [];
					}
					
					try
					{
						this._runningCallbacks = true;
						
						try
						{
							args.unshift(this._result);
							this._result = callback.apply(null, args);
						}
						finally
						{
							this._runningCallbacks = false;
						}
						
						if (this._result is Deferred)
						{
							this.pause();
							this._result.addBoth(this._continue);
							break;
						}
					}
					catch (e:Error)
					{
						this._result = new Failure(e);
					}		
				}
			}
		}
	}
}

function passthru(arg:*):*
{
	return arg;
}