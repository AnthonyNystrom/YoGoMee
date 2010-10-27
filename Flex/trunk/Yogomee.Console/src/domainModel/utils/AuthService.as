package domainModel.utils
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import com.sourcestream.flex.http.HttpEvent;
	import com.sourcestream.flex.http.RestHttpService;
	
	import defer.Deferred;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	public class AuthService
	{
		private var _baseUrl:String;
		private var _base:String;
		private var _consumer:String;
		private var _secret:String;
		private var _services:Dictionary;
		
		public function AuthService(baseUrl:String, base:String, consumer:String, secret:String)
		{
			_baseUrl = baseUrl;
			_base = base;
			_consumer = consumer;
			_secret = secret;
			_services = new Dictionary();
		}
		
		public function get consumer():String
		{
			return _consumer;
		}
		
		public function get secret():String
		{
			return _secret;
		}
		
		public function send(path:String, method:String = "GET", params:Dictionary = null, data:String = null):Deferred
		{
			function sign(...args):Deferred
			{
				function addParams(...args):Deferred
				{
					if (params == null)
					{
						params = new Dictionary();
					}
					
					params["oauth_consumer_key"] = _consumer;
					params["oauth_timestamp"] = "123";
					params["oauth_nonce"] = "123";
					
					return Deferred.succeed(true);
				}
				
				function makeBaseString(...args):Deferred
				{
					var _method:String = encodeURIComponent(method.toUpperCase());
					var _path:String = encodeURIComponent(_base.toLowerCase() + path.toLowerCase());
					var _args:String = encodeURIComponent(
						"oauth_consumer_key=" + encodeURIComponent(params["oauth_consumer_key"]) +
						"&oauth_nonce=" + encodeURIComponent(params["oauth_nonce"]) +
						"&oauth_timestamp=" + encodeURIComponent(params["oauth_timestamp"]));
						
					return Deferred.succeed(_method + "&" + _path + "&" + _args);
				}
				
				function addSignature(base_string:String):Deferred
				{
					var hmac:HMAC = Crypto.getHMAC("sha1");
					var key:ByteArray = Hex.toArray(Hex.fromString(_secret + "&"));
					var message:ByteArray = Hex.toArray(Hex.fromString(base_string));

					var result:ByteArray = hmac.compute(key, message);
					var signature:String = Base64.encodeByteArray(result);
					
					params["oauth_signature"] = signature;
					
					return Deferred.succeed(true);
				}
				
				var d:Deferred = new Deferred();
				
				d.addCallback(addParams);
				d.addCallback(makeBaseString);
				d.addCallback(addSignature);
				
				Deferred.callLater(0, d.callback, null);
				return d; 
			}
			
			function send(...args):Deferred
			{
				var service:RestHttpService = new RestHttpService(_baseUrl, 8080);
				_services[service] = service;
				service.contentType = "application/json";
				service.method = method;
				service.resource = path;
				
				var d:Deferred = new Deferred();
				service.addEventListener(
					RestHttpService.EVENT_FAULT,
					function(event:HttpEvent):void
					{
						d.errback(event.data);
						delete _services[service];
					});
					
				service.addEventListener(
					RestHttpService.EVENT_RESULT,
					function(event:HttpEvent):void
					{
						d.callback(event.response.body);
						delete _services[service];
					});
				
				service.send(data, params);
					
				return d;
			}
			
			function complete(result:Object):Deferred
			{
				return Deferred.succeed(result);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(sign);
			d.addCallback(send);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
	}
}
