package domainModel.repositories
{
	import com.adobe.serialization.json.JSON;
	import com.google.maps.LatLng;
	
	import defer.Deferred;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	import domainModel.entities.User;
	import domainModel.utils.YoService;
	
	import flash.utils.Dictionary;
	
	public class GomeeRepository
		implements IGomeeRepository
	{
		private var _uow:UnitOfWork;
		
		public function GomeeRepository(uow:UnitOfWork)
		{
			_uow = uow;	
		}
		
		public function get service():YoService
		{
			return _uow.service;
		}
		
		public function addGomee(gomee:Gomee):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/gomees", "POST", null, JSON.encode(gomee));
			}
			
			function set_id(result:Object):Deferred
			{
				gomee.id = result.id;
				return Deferred.succeed(result);
			}
			
			function set_owner(result:Object):Deferred
			{
				function get_me(...args):Deferred
				{
					return _uow.userRepository.getMe();
				}
				
				function complete(me:User):Deferred
				{
					gomee.owner = me;
					return Deferred.succeed(gomee);
				}
				
				var d:Deferred = new Deferred();
				
				d.addCallback(get_me);
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, null);
				return d;
			}
			
			function add_to_cache(...args):Deferred
			{
				return Deferred.succeed(gomee);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(set_id);
			d.addCallback(set_owner);
			d.addCallback(add_to_cache);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function saveGomee(gomee:Gomee):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/gomees/" + gomee.id, "PUT", null, JSON.encode(gomee));
			}
			
			function complete(...args):Deferred
			{
				return Deferred.succeed(gomee);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getGomee(id:String):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/gomees/" + id, "GET");
			}
			
			function create_gomee(result:Object):Deferred
			{
				var gomee:Gomee = new Gomee();
				gomee.id = result.id;
				gomee.lat = result.lat;
				gomee.lng = result.lng;
				gomee.caption = result.caption;
				gomee.address = result.address;
				gomee.description = result.description;
				gomee.type = result.type;
				gomee.common = result.common;
				gomee.tags = result.tags;
				
				return Deferred.succeed([gomee, result.owner]);
			}
			
			function get_owner(params:Array):Deferred
			{
				var gomee:Gomee = params[0] as Gomee;
				var owner_id:String = params[1] as String;
				
				function complete(owner:User):Deferred
				{
					gomee.owner = owner;
					return Deferred.succeed(gomee);
				}
				
				var d:Deferred = _uow.userRepository.getUser(owner_id);
				d.addCallback(complete);
				return d
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_gomee);
			d.addCallback(get_owner);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function removeGomee(gomee:Gomee):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/gomees/" + gomee.id, "DELETE");
			}
			
			function complete(result:Object):Deferred
			{
				return Deferred.succeed(true);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getGomees(ll1:LatLng, ll2:LatLng, user:User = null, tags:Array = null):Deferred
		{
			function check_user(...args):Deferred
			{
				if (user == null)
				{
					return _uow.userRepository.getMe();
				}
				
				return Deferred.succeed(user);
			}
			
			function send(_user:User):Deferred
			{
				var params:Dictionary = new Dictionary();
				params["lat1"] = ll1.lat();
				params["lat2"] = ll2.lat();
				params["lng1"] = ll1.lng();
				params["lng2"] = ll2.lng();
				
				if(tags != null)
				{
					params["tags"] = tags;
				}
				
				user = _user;
				return service.send("/users/" + user.id + "/gomees", "GET", params);
			}
			
			function create(results:Array):Deferred
			{
				var gomees:Array = [];
				
				for(var i:int; i < results.length; i++)
				{
					var result:Object = results[i];
					var gomee:Gomee = new Gomee();
					gomee.id = result.id;
					gomee.owner = user;
					gomee.lat = result.lat;
					gomee.lng = result.lng;
					gomee.caption = result.caption;
					gomee.address = result.address;
					gomee.description = result.description;
					gomee.type = result.type;
					gomee.common = result.common;
					gomee.tags = result.tags;
					
					gomees.push(gomee);
				}
				
				return Deferred.succeed(gomees);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(check_user);
			d.addCallback(send);
			d.addCallback(create);
			
			Deferred.callLater(0, d.callback, null);			
			return d;
		}
	}
}