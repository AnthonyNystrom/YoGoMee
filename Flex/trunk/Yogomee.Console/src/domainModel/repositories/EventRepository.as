package domainModel.repositories
{
	import com.adobe.serialization.json.JSON;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import defer.Deferred;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Event;
	import domainModel.entities.Gomee;
	import domainModel.entities.User;
	import domainModel.utils.YoService;
	
	import flash.utils.Dictionary;

	public class EventRepository implements IEventRepository
	{
		private var _uow:UnitOfWork;
		
		public function EventRepository(uow:UnitOfWork)
		{
			_uow = uow;
		}
		
		public function get service():YoService
		{
			return _uow.service;
		}
		
		public function addEvent(event:Event):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/events", "POST", null, JSON.encode(event));
			}
			
			function set_id(result:Object):Deferred
			{
				event.id = result.id;
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
					event.owner = me;
					return Deferred.succeed(event);
				}
				
				var d:Deferred = new Deferred()
				
				d.addCallback(get_me);
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, null);
				return d;
			}
			
			var d:Deferred = new Deferred()
			
			d.addCallback(send);
			d.addCallback(set_id);
			d.addCallback(set_owner);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function saveEvent(event:Event):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/events/" + event.id, "PUT", null, JSON.encode(event));
			}
			
			function complete(...args):Deferred
			{
				return Deferred.succeed(event);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function removeEvent(event:Event):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/events/" + event.id, "DELETE");
			}
			
			function complete(...args):Deferred
			{
				return Deferred.succeed(true);
			}
			
			var d:Deferred = new Deferred();
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getEvent(id:String):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/events/" + id, "GET");
			}
			
			function create_event(result:Object):Deferred
			{
				var event:Event = new Event();
				event.id = result.id;
				event.type = result.type;
				event.radius = result.radius;
				event.data = result.data;
				return Deferred.succeed([event, result.owner, result.gomee]);
			}
			
			function set_owner(params:Array):Deferred
			{
				var event:Event = params[0] as Event;
				var owner_id:String = params[1] as String;
				
				function complete(owner:User):Deferred
				{
					event.owner = owner;
					return Deferred.succeed([event, params[2]]);
				}
				
				var d:Deferred = _uow.userRepository.getUser(owner_id);
				d.addCallback(complete);
				return d;
			}
			
			function set_gomee(params:Array):Deferred
			{
				var event:Event = params[0] as Event;
				var gomee_id:String = params[1] as String;
				
				function complete(gomee:Gomee):Deferred
				{
					event.gomee = gomee;
					return Deferred.succeed(event);
				}
				
				var d:Deferred = _uow.gomeeRepository.getGomee(gomee_id);
				d.addCallback(complete);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_event);
			d.addCallback(set_owner);
			d.addCallback(set_gomee);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getEvents(bounds:LatLngBounds):Deferred
		{
			function send(...args):Deferred
			{
				var ll1:LatLng = bounds.getNorthWest();
				var ll2:LatLng = bounds.getSouthEast();
				
				var params:Dictionary = new Dictionary();
				params["lat1"] = ll1.lat();
				params["lat2"] = ll2.lat();
				params["lng1"] = ll1.lng();
				params["lng2"] = ll2.lng();
				
				return service.send("/events", "GET", params);
			}
			
			function create_events(results:Array):Deferred
			{
				function create_event(s:Boolean, result:Object):Deferred
				{
					function get_owner(...args):Deferred
					{
						return _uow.userRepository.getUser(result.owner);
					}
					
					function get_gomee(owner:User):Deferred
					{
						function complete(gomee:Gomee):Deferred
						{
							return Deferred.succeed([owner, gomee]);
						}
						
						var d:Deferred = _uow.gomeeRepository.getGomee(result.gomee);
						d.addCallback(complete);
						return d;
					}
					
					function complete(params:Array):Deferred
					{
						var owner:User = params[0] as User;
						var gomee:Gomee = params[1] as Gomee;
						
						var event:Event = new Event();
						event.id = result.id;
						event.owner = owner;
						event.gomee = gomee;
						event.radius = result.radius;
						event.type = result.type;
						event.data = result.data;
						events.push(event);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_owner);
					d.addCallback(get_gomee);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(events);
				}
				
				var events:Array = [];
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_event, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_events);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getUserEvents(bounds:LatLngBounds, user:User=null):Deferred
		{
			function get_me(...args):Deferred
			{
				function complete(me:User):Deferred
				{
					user = me;
					return Deferred.succeed(user);
				}
				
				var d:Deferred = _uow.userRepository.getMe();
				d.addCallback(complete);
				return d;
			}
			
			function send(...args):Deferred
			{
				var ll1:LatLng = bounds.getNorthWest();
				var ll2:LatLng = bounds.getSouthEast();
				
				var params:Dictionary = new Dictionary();
				params["lat1"] = ll1.lat();
				params["lat2"] = ll2.lat();
				params["lng1"] = ll1.lng();
				params["lng2"] = ll2.lng();
				
				return service.send("/users/" + user.id + "/events", "GET", params);
			}
			
			function create_events(results:Array):Deferred
			{
				function create_event(s:Boolean, result:Object):Deferred
				{
					function get_gomee(...args):Deferred
					{
						return _uow.gomeeRepository.getGomee(result.gomee);
					}
					
					function complete(gomee:Gomee):Deferred
					{
						var event:Event = new Event();
						event.id = result.id;
						event.owner = user;
						event.gomee = gomee;
						event.radius = result.radius;
						event.type = result.type;
						event.data = result.data;
						events.push(event);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_gomee);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(events);
				}
				
				var events:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_event, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			if(user == null)
			{
				d.addCallback(get_me);
			}
			
			d.addCallback(send);
			d.addCallback(create_events);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getGomeeEvents(gomee:Gomee):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/gomees/" + gomee.id + "/events", "GET");
			}
			
			function create_events(results:Array):Deferred
			{
				function create_event(s:Boolean, result:Object):Deferred
				{
					function get_owner(...args):Deferred
					{
						return _uow.userRepository.getUser(result.owner);
					}
					
					function complete(owner:User):Deferred
					{
						var event:Event = new Event();
						event.id = result.id;
						event.owner = owner;
						event.gomee = gomee;
						event.radius = result.radius;
						event.type = result.type;
						event.data = result.data;
						events.push(event);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_owner);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(events);
				}
				
				var events:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_event, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_events);
			
			Deferred.callLater(0, d.callback, null); 
			return d;
		}
		
	}
}