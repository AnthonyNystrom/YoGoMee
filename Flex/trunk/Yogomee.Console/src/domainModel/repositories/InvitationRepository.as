package domainModel.repositories
{
	import com.adobe.serialization.json.JSON;
	
	import defer.Deferred;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Event;
	import domainModel.entities.Invitation;
	import domainModel.entities.User;
	import domainModel.utils.YoService;

	public class InvitationRepository implements IInvitationRepository
	{
		private var _uow:UnitOfWork;
		
		private static var _statuses:Array = ["/accepted", "/rejected", "/waiting"];
		private static var _types:Array = ["/targets", "/friends"];
		
		public function InvitationRepository(uow:UnitOfWork)
		{
			_uow = uow;
		}
		
		public function get service():YoService
		{
			return _uow.service;
		}
		
		public function addInvitation(user:User, invitation:Invitation):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/users/" + user.id + "/invitations", "POST", null, JSON.encode(invitation));
			}
			
			function set_id(result:Object):Deferred
			{
				invitation.id = result.id;
				invitation.status = result.status;
				return Deferred.succeed(result);
			}
			
			function set_owner(result:Object):Deferred
			{
				function complete(owner:User):Deferred
				{
					invitation.owner = owner;
					return Deferred.succeed(result);
				}
				
				var d:Deferred = _uow.userRepository.getUser(result.owner);
				d.addCallback(complete);
				return d;
			}
			
			function set_creator(result:Object):Deferred
			{
				function complete(creator:User):Deferred
				{
					invitation.creator = creator;
					return Deferred.succeed(invitation);
				}
				
				var d:Deferred = _uow.userRepository.getUser(result.creator);
				d.addCallback(complete);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(set_id);
			d.addCallback(set_creator);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function removeInvitation(invitation:Invitation):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/invitations/sent/waiting/" + invitation.id, "DELETE");
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
		
		public function acceptInvitation(invitation:Invitation):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/invitations/received/waiting/" + invitation.id + "/accept", "GET");
			}
			
			function set_status(result:Object):Deferred
			{
				invitation.status = result.status;
				return Deferred.succeed(invitation);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(set_status);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function rejectInvitation(invitation:Invitation):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/invitations/received/waiting/" + invitation.id + "/reject", "GET");
			}
			
			function set_status(result:Object):Deferred
			{
				invitation.status = result.status;
				return Deferred.succeed(invitation);
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(set_status);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getSentInvitations(type:int, status:int):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/invitations/sent" + _types[type] + _statuses[status], "GET");
			}
			
			function create_invitations(results:Array):Deferred
			{
				function create_invitation(s:Boolean, result:Object):Deferred
				{
					function get_owner(...args):Deferred
					{
						return _uow.userRepository.getUser(result.owner);
					}
					
					function get_creator(owner:User):Deferred
					{
						function complete(creator:User):Deferred
						{
							return Deferred.succeed([owner, creator]);
						}
						
						var d:Deferred = _uow.userRepository.getUser(result.creator);
						d.addCallback(complete);
						return d;
					}
					
					function get_event(params:Array):Deferred
					{
						if(!result.hasOwnProperty("event"))
						{
							return Deferred.succeed([params[0], params[1], null]);
						}
						
						function complete(event:Event):Deferred
						{
							return Deferred.succeed([params[0], params[1], event]);
						}
						
						var d:Deferred = _uow.eventRepository.getEvent(result.event);
						d.addCallback(complete);
						return d;
					}
					
					function complete(params:Array):Deferred
					{
						var owner:User = params[0] as User;
						var creator:User = params[1] as User;
						var event:Event = params[2] as Event;
						
						var invitation:Invitation = new Invitation();
						invitation.id = result.id;
						invitation.owner = owner;
						invitation.creator = creator;
						invitation.status = result.status;
						invitation.type = result.type;
						invitation.event = event;
						invitations.push(invitation);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_owner);
					d.addCallback(get_creator);
					d.addCallback(get_event);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(invitations);
				}
				
				var invitations:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_invitation, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_invitations);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
		public function getReceivedInvitations(type:int, status:int):Deferred
		{
			function send(...args):Deferred
			{
				return service.send("/me/invitations/received" + _types[type] + _statuses[status], "GET");
			}
			
			function create_invitations(results:Array):Deferred
			{
				function create_invitation(s:Boolean, result:Object):Deferred
				{
					function get_owner(...args):Deferred
					{
						return _uow.userRepository.getUser(result.owner);
					}
					
					function get_creator(owner:User):Deferred
					{
						function complete(creator:User):Deferred
						{
							return Deferred.succeed([owner, creator]);
						}
						
						var d:Deferred = _uow.userRepository.getUser(result.creator);
						d.addCallback(complete);
						return d;
					}
					
					function get_event(params:Array):Deferred
					{
						if(!result.hasOwnProperty("event"))
						{
							return Deferred.succeed([params[0], params[1], null]);
						}
						
						function complete(event:Event):Deferred
						{
							return Deferred.succeed([params[0], params[1], event]);
						}
						
						var d:Deferred = _uow.eventRepository.getEvent(result.event);
						d.addCallback(complete);
						return d;
					}
					
					function complete(params:Array):Deferred
					{
						var owner:User = params[0] as User;
						var creator:User = params[1] as User;
						var event:Event = params[2] as Event;
						
						var invitation:Invitation = new Invitation();
						invitation.id = result.id;
						invitation.owner = owner;
						invitation.creator = creator;
						invitation.status = result.status;
						invitation.type = result.type;
						invitation.event = event;
						invitations.push(invitation);
						return Deferred.succeed(true);
					}
					
					var d:Deferred = new Deferred();
					
					d.addCallback(get_owner);
					d.addCallback(get_creator);
					d.addCallback(get_event);
					d.addCallback(complete);
					
					Deferred.callLater(0, d.callback, null);
					return d;
				}
				
				function complete(...args):Deferred
				{
					return Deferred.succeed(invitations);
				}
				
				var invitations:Array = [];
				
				var d:Deferred = new Deferred();
				
				for(var i:int = 0; i < results.length; i++)
				{
					d.addCallback(create_invitation, results[i]);
				}
				
				d.addCallback(complete);
				
				Deferred.callLater(0, d.callback, true);
				return d;
			}
			
			var d:Deferred = new Deferred();
			
			d.addCallback(send);
			d.addCallback(create_invitations);
			
			Deferred.callLater(0, d.callback, null);
			return d;
		}
		
	}
}