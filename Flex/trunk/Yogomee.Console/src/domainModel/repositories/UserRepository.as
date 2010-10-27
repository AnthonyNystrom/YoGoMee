package domainModel.repositories
{
	import com.adobe.serialization.json.JSON;
	import com.google.maps.LatLng;
	
	import defer.Deferred;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.User;
	import domainModel.utils.YoService;
	
	import flash.utils.Dictionary;
	
	public class UserRepository implements IUserRepository
	{
		private var _uow:UnitOfWork;
		
		private var _idMap:Object;
		private var _me:User;
		
		private var _initialized:Boolean;
		private var _initd:Deferred;
		
		public function UserRepository(uow:UnitOfWork)
		{
			_uow = uow;
			_me = new User();
			_idMap = new Object();
		}
		
		public function get service():YoService
		{
			return _uow.service;
		}
		
		public function init(...args):Deferred
		{
			if (_initialized)
			{
				return Deferred.succeed(true);
			}
			
			if (_initd != null)
			{
				return _initd;
			}
			
			function fetch_me(...args):Deferred
			{
				function send(...args):Deferred
				{
					return service.send("/me", "GET");
				}
				
				function update_user(result:Object):Deferred
				{
					_me.id = result.id;
					_me.login = result.login;
					_me.secret = service.secret;
					
					return Deferred.succeed(true);
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(true);
				}
				
				var d:Deferred = new Deferred();
				
				d.addCallback(send);
				d.addCallback(update_user);
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, null);
				return d;
			}
			
			function complete(...args):Deferred
			{
				_initialized = true;
				return Deferred.succeed(true);
			}
			
			_initd = new Deferred();
			
			_initd.addCallback(fetch_me);
			_initd.addCallback(complete);
			
			Deferred.callLater(0, _initd.callback, null);
			return _initd;
		}
		
		public function addUser(user:User):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/users", "POST", null, JSON.encode(user));		
			}
			
			function set_id(result:Object):Deferred
			{
				user.id = result.id;
				return Deferred.succeed(user);
			}
			
			function add_to_cache(user:User):Deferred
			{
				_idMap[user.id] = user;
				return Deferred.succeed(user);
			}			
			 
			var d:Deferred = new Deferred();
			
			d.addCallback(init);
			d.addCallback(send);
			d.addCallback(set_id);
			d.addCallback(add_to_cache);
			
			Deferred.callLater(0, d.callback, null);
			return d;			
		}
		
		public function getMe():Deferred
		{
			function complete(...args):Deferred
			{
				return Deferred.succeed(_me);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(init);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getUsers(ll1:LatLng, ll2:LatLng):Deferred
		{
			function send(...arg):Deferred
			{
				var params:Dictionary = new Dictionary();
				params["lat1"] = ll1.lat();
				params["lat2"] = ll2.lat();
				params["lng1"] = ll1.lng();
				params["lng2"] = ll2.lng();
				return service.send("/users", "GET", params);
			}
			
			function create(results:Array):Deferred
			{
				var users:Array = new Array();
				
				for(var i:int = 0; i < results.length; i++)
				{
					var result:Object = results[i];
					var user:User = new User();
					user.id = result.id;
					user.login = result.login;
					
					users.push(user);
				}
				
				return Deferred.succeed(users);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getFriends():Deferred
		{
			function send(...arg):Deferred
			{
				return service.send("/me/friends", "GET");
			}
			
			function create(results:Array):Deferred
			{
				var users:Array = new Array();
				
				for(var i:int = 0; i < results.length; i++)
				{
					var result:Object = results[i];
					var user:User = new User();
					user.id = result.id;
					user.login = result.login;
					
					users.push(user);
				}
				
				return Deferred.succeed(users);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getUser(id:String):Deferred
		{
			var d:Deferred = new Deferred();
			d.addCallback(init);
			
			var user:User = _idMap[id];
			
			if (user == null)
			{
				function send(...args):Deferred
				{
					return service.send("/users/" + id, "GET");
				}
				
				function create_user(result:Object):Deferred
				{
					user = new User();
					user.id = result.id;
					user.login = result.login;
					
					return Deferred.succeed(user);
				}
				
				function add_to_cache(result:User):Deferred
				{
					_idMap[result.id] = result;
					return Deferred.succeed(true);
				}
				
				d.addCallback(send);
				d.addCallback(create_user);
				d.addCallback(add_to_cache);	
			}
			
			function complete(...args):Deferred
			{
				return Deferred.succeed(user);
			}
			
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
	}
}