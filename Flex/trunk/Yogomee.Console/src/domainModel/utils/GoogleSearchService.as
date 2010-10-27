package domainModel.utils
{
	import com.adobe.serialization.json.JSON;
	import com.google.maps.LatLngBounds;
	
	import defer.Deferred;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class GoogleSearchService
	{
		public function GoogleSearchService()
		{
		}
		
		public function search(query:String, bounds:LatLngBounds):Deferred
		{
			function send(...args):Deferred
			{
				function check_pages(result:Object):Deferred
				{
					var r:Array = result.responseData.results;
					for(var i:int = 0; i < r.length; i++)
					{
						results.push(r[i]);
					}
					
					if(!result.responseData.cursor.hasOwnProperty("currentPageIndex"))
					{
						return Deferred.succeed(true);
					}
					
					var currIndex:int = result.responseData.cursor.currentPageIndex;
					var pages:Array = result.responseData.cursor.pages;
					
					if(currIndex < pages.length - 1)
					{
						return _send(query, bounds, pages[currIndex + 1].start).addCallback(check_pages);
					}
					
					return Deferred.succeed(true);	
				}
				
				return _send(query, bounds, 0).addCallback(check_pages);
			}
			
			function complete(...args):Deferred
			{
				return Deferred.succeed(results);
			}
			
			var results:Array = new Array();
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		private function _send(query:String, bounds:LatLngBounds, start:int = 0):Deferred
		{
			function send(...args):Deferred
			{
				var service:HTTPService = new HTTPService();
				service.url = "http://ajax.googleapis.com/ajax/services/search/local";
				service.request.v = '1.0';
				service.resultFormat = 'text';
				service.request.rsz = "large";
				service.request.hl = "en";
				service.request.q = query;
				service.request.start = start;
				service.request.sll = bounds.getCenter().toUrlValue();
				service.request.sspn =  bounds.toSpan().toUrlValue();
				
				var d:Deferred = new Deferred();
				service.addEventListener(
					ResultEvent.RESULT,
					function(event:ResultEvent):void
					{
						d.callback(JSON.decode(event.result as String));
					});
				
				service.addEventListener(
					FaultEvent.FAULT,
					function(event:FaultEvent):void
					{
						d.errback(event.message);
					});
				
				service.send();
				
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
	}
}