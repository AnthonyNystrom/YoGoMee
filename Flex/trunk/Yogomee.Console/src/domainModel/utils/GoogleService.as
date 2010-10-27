package domainModel.utils
{
	import com.sourcestream.flex.http.HttpEvent;
	import com.sourcestream.flex.http.RestHttpService;
	
	import defer.Deferred;
	
	import flash.utils.Dictionary;
	
	public class GoogleService
	{
		private var _baseUrl:String;
		private var _services:Dictionary;
		
		public function GoogleService()
		{
			_baseUrl = "ajax.googleapis.com";
			_services = new Dictionary();
		}
		
		public function send(path:String, params:Dictionary):Deferred
		{
			function send(...args):Deferred
			{
				var service:RestHttpService = new RestHttpService(_baseUrl, 80);
				_services[service] = service;
				service.method = "GET";
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
				
				service.send(null, params);
					
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
	}
}