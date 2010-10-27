package domainModel.utils
{
	import com.adobe.serialization.json.JSON;
	
	import defer.Deferred;
	
	import flash.utils.Dictionary;
	
	public class YoService extends AuthService
	{
		public function YoService(baseUrl:String, base:String, login:String, secret:String)
		{
			super(baseUrl, base, login, secret);
		}
		
		public function get login():String
		{
			return super.consumer;
		}
		
		public override function send(path:String, method:String = "GET", params:Dictionary = null, data:String = null):Deferred
		{
			function decode(result:String):Deferred
			{
				return Deferred.succeed(JSON.decode(result));
			}
			
			function check(result:Object):Deferred
			{
				if (result.status == "FAIL")
				{
					return Deferred.fail(result.error);
				}
				
				return Deferred.succeed(result.data);
			}
			
			var d:Deferred = super.send(path, method, params, data);
			
			d.addCallback(decode);
			d.addCallback(check);
			
			return d;
		}
		
	}
}