package domainModel.repositories
{
	import com.adobe.serialization.json.JSON;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import defer.Deferred;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Event;
	import domainModel.entities.Gomee;
	import domainModel.entities.Target;
	import domainModel.entities.User;
	import domainModel.utils.YoService;
	
	import flash.utils.Dictionary;

	public class TargetRepository implements ITargetRepository
	{
		private var _uow:UnitOfWork;
		
		public function TargetRepository(uow:UnitOfWork)
		{
			_uow = uow;
		}
		
		public function get service():YoService
		{
			return _uow.service;
		}
		
		public function addTarget(target:Target):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/targets", "POST", null, JSON.encode(target));
			}
			
			function set_id(result:Object):Deferred
			{
				target.id = result.id;
				return Deferred.succeed(result);
			}
			
			function set_owner(result:Object):Deferred
			{
				function get_me(...args):Deferred
				{
					return _uow.userRepository.getMe();
				}
				
				function complete(user:User):Deferred
				{
					target.owner = user;
					return Deferred.succeed(target);
				}
				
				var d:Deferred = new Deferred();
				
				d.addCallback(get_me);
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, null);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(set_id);
			d.addCallback(set_owner);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function removeTarget(target:Target):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/targets/" + target.id, "DELETE");
			}
			
			function complete(...args):Deferred
			{
				return Deferred.succeed(true);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(complete);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getTarget(id:String):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/targets/" + id, "GET");
			}	
			
			function create_target(result:Object):Deferred
			{
				var target:Target = new Target();
				target.id = result.id;
				return Deferred.succeed([target, result.owner, result.event]);
			}
			
			function set_owner(params:Array):Deferred
			{
				var target:Target = params[0] as Target;
				var owner_id:String = params[1] as String;
				
				function complete(owner:User):Deferred
				{
					target.owner = owner;
					return Deferred.succeed([target, params[2]]);
				}
				
				var d:Deferred = _uow.userRepository.getUser(owner_id);
				d.addCallback(complete);
				return d;
			}
			
			function set_event(params:Array):Deferred
			{
				var target:Target = params[0] as Target;
				var event_id:String = params[1] as String;
				
				function complete(event:Event):Deferred
				{
					target.event = event;
					return Deferred.succeed(target);
				}
				
				var d:Deferred = _uow.eventRepository.getEvent(event_id);
				d.addCallback(complete);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_target);
			d.addCallback(set_owner);
			d.addCallback(set_event);
			
			Deferred.callLater(0, d.callback, null);
			return null;
		}
		
		public function getTargets(bounds:LatLngBounds):Deferred
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
				
				return service.send("/targets", "GET", params);
			}
			
			function create_targets(results:Array):Deferred
			{
				function create_target(s:Boolean, result:Object):Deferred
				{
					function get_owner(...args):Deferred
					{
						return _uow.userRepository.getUser(result.owner);
					}
					
					function get_event(owner:User):Deferred
					{
						function complete(event:Event):Deferred
						{
							return Deferred.succeed([owner, event]);
						}
						
						var d:Deferred = _uow.eventRepository.getEvent(result.event);
						d.addCallback(complete);
						return d;
					}
					
					function complete(params:Array):Deferred
					{
						var owner:User = params[0] as User;
						var event:Event = params[1] as Event;
						
						var target:Target = new Target();
						target.id = result.id;
						target.owner = owner;
						target.event = event;
						targets.push(target);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_owner);
					d.addCallback(get_event);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(targets);
				}
				
				var targets:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_target, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_targets);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getUserTargets(bounds:LatLngBounds, user:User = null):Deferred
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
				
				return service.send("/users/" + user.id + "/targets", "GET", params);
			}
			
			function create_targets(results:Array):Deferred
			{
				function create_target(s:Boolean, result:Object):Deferred
				{
					function get_event(...args):Deferred
					{
						return _uow.eventRepository.getEvent(result.event);
					}
					
					function complete(event:Event):Deferred
					{
						var target:Target = new Target();
						target.id = result.id;
						target.owner = user;
						target.event = event;
						targets.push(target);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_event);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(targets);
				}
				
				var targets:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_target, results[i]);
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
			d.addCallback(create_targets);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getGomeeTargets(gomee:Gomee):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/gomees/" + gomee.id + "/targets");
			}
			
			function create_targets(results:Array):Deferred
			{
				function create_target(s:Boolean, result:Object):Deferred
				{
					function get_owner(...args):Deferred
					{
						return _uow.userRepository.getUser(result.owner);
					}
					
					function get_event(owner:User):Deferred
					{
						function complete(event:Event):Deferred
						{
							return Deferred.succeed([owner, event]);
						}
						
						var d:Deferred = _uow.eventRepository.getEvent(result.event);
						d.addCallback(complete);
						return d;
					}
					
					function complete(params:Array):Deferred
					{
						var owner:User = params[0] as User;
						var event:Event = params[1] as Event;
						
						var target:Target = new Target();
						target.id = result.id;
						target.owner = owner;
						target.event = event;
						targets.push(target);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_owner);
					d.addCallback(get_event)
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(targets);
				}
				
				var targets:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_target, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_targets);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getEventTargets(event:Event):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/events/" + event.id + "/targets", "GET");
			}
			
			function create_targets(results:Array):Deferred
			{
				function create_target(s:Boolean, result:Object):Deferred
				{
					function get_owner(...args):Deferred
					{
						return _uow.userRepository.getUser(result.owner);
					}
					
					function get_event(owner:User):Deferred
					{
						function complete(event:Event):Deferred
						{
							return Deferred.succeed([owner, event]);
						}
						
						var d:Deferred = _uow.eventRepository.getEvent(result.event);
						d.addCallback(complete)
						return d;
					}
					
					function complete(params:Array):Deferred
					{
						var owner:User = params[0] as User;
						var event:Event = params[1] as Event;
						
						var target:Target = new Target();
						target.id = result.id;
						target.owner = owner;
						target.event = event;
						targets.push(target);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_owner);
					d.addCallback(get_event);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(targets);
				}
				
				var targets:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_target, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_targets);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
	}
}