package controls.map.controllers
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import controls.map.YoMap;
	import controls.map.controls.YoInvitesFilterControl;
	import controls.map.marker.YoHomeMarker;
	import controls.map.marker.YoMarker;
	import controls.notifier.YoNotifierEvent;
	
	import defer.Deferred;
	import defer.Failure;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	import domainModel.entities.Invitation;
	import domainModel.entities.Profile;
	import domainModel.entities.User;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.DynamicEvent;

	public class TheirsProfileMarkersController extends ProfileMarkersController
	{
		public function TheirsProfileMarkersController(
			map:UIComponent, layer:UIComponent,
			gomeesFilter:UIComponent, invitesFilter:UIComponent, tagFilter:UIComponent)
		{
			super(layer);
			gomeesFilter.addEventListener("homesVisibleChanged", homesVisibleChangedHandler);
			invitesFilter.addEventListener("friendsVisibleChanged", friendsVisibleChangedHandler);
			invitesFilter.addEventListener(YoNotifierEvent.NOTIFIER_CLICKED, notifierClickedHandler);
			
			_invitesFilter = invitesFilter as YoInvitesFilterControl;
			_map = map as YoMap;
		}
		
		private var _invitesFilter:YoInvitesFilterControl;
		private var _map:YoMap;
		
		private var _markersVisible:Boolean = true;
		
		public function get markersVisible():Boolean
		{
			return _markersVisible;
		}
		
		public function set markersVisible(markersVisible:Boolean):void
		{
			if(_markersVisible != markersVisible)
			{
				_markersVisible = markersVisible;
				updateMarkersVisibility();
				updateInvitesVisibility();
			}
		}
		
		private var _invitesVisible:Boolean = true;
		
		public function get invitesVisible():Boolean
		{
			return _invitesVisible;
		}
		
		public function set invitesVisible(invitesVisible:Boolean):void
		{
			if(_invitesVisible != invitesVisible)
			{
				_invitesVisible = invitesVisible;
				updateMarkersVisibility();
				updateInvitesVisibility();
			}
		}
		
		private function updateMarkersVisibility():void
		{
			for(var marker:String in markers)
			{
				var m:YoMarker = markers[marker] as YoMarker;
				m.visible = markersVisible;
			}
		}
		
		private function updateInvitesVisibility():void
		{
			_invitesFilter.notifierVisible = invitesVisible && _usersCount > 0;
			_invitesFilter.notifierLabel = _usersCount.toString();
			
			for(var marker:String in markers)
			{
				var m:YoHomeMarker = markers[marker] as YoHomeMarker;
				var g:Gomee = m.data.gomee as Gomee;
				
				if(_users[g.owner.id])
				{
					m.sendInviteVisible = false;
					m.acceptInviteVisible = true;
					m.rejectInviteVisible = true;
					m.notifierVisible = invitesVisible;
					m.visible = markersVisible || invitesVisible;
				}
			}
		}
		
		private function homesVisibleChangedHandler(event:Event):void
		{
			markersVisible = !markersVisible;
		}
		
		private function friendsVisibleChangedHandler(event:Event):void
		{
			invitesVisible = !invitesVisible;
		}
		
		private function notifierClickedHandler(event:YoNotifierEvent):void
		{
			var g:Gomee = event.object as Gomee;
			
			if(g != null)
			{
				_map.setCenter(new LatLng(g.lat, g.lng), 6);
			}
		}
		
		protected override function updateMarker(marker:YoMarker, object:Object):void
		{
			super.updateMarker(marker, object);
			marker.data = object;
		}
		
		public override function set uow(uow:UnitOfWork):void
		{
			if(_updating != null)
			{
				_updating.pause();
				_updating = null;
			}
			
			if(_adding != null)
			{
				_adding.pause();
				_adding = null;
			}
			
			super.uow = uow;
			_invitesFilter.clearNotifications();
			_users = new Object();
		}
		
		private var _updating:Deferred;
		private var _adding:Deferred;
		
		private var _users:Object = new Object();
		private var _usersCount:int = 0;
		
		public override function updateMarkers(bounds:LatLngBounds):void
		{
			if(!markersVisible || uow == null) return;
			
			if(_updating == null)
			{
				_updating = new Deferred();
				_updating.callback(true);
			}
			
			if(_adding == null)
			{
				_adding = new Deferred();
				_adding.callback(true);
			}
			
			_updating.addCallback(
				function(o:*, upd:Deferred, ad:Deferred, bounds:LatLngBounds):Deferred
				{
					var ll1:LatLng = bounds.getNorthWest();
					var ll2:LatLng = bounds.getSouthEast();
					
					return uow.userRepository.getUsers(ll1, ll2)
						.addCallback(
							function(users:Array):Deferred
							{
								return updateInvites(upd, ad)
									.addCallback(
										function(...args):Deferred
										{
											return Deferred.succeed(users);
										});
							})
						.addCallback(
							function(users:Array):Deferred
							{
								function fetch(b:*, user:User):Deferred
								{
									return fetchUserProfile(upd, ad, user);
								}
						
								var d:Deferred = new Deferred();
								
								for(var i:int = 0; i < users.length; i++)
								{
									var user:User = users[i];
									if(user.login != uow.service.login)
									{
										if(!_users[user.id])
										{
											d.addCallback(fetch, user);
										}
									}
								}
								
								Deferred.callLater(0, d.callback, true);
								return d;
							})
						.addCallback(
							function(...args):Deferred
							{
								updateInvitesVisibility();
								return Deferred.succeed(true);
							})
						.addErrback(
							function(fail:Failure):void
							{
								trace("error fetching users:", fail.value);
							});
			}, _updating, _adding, bounds);
		}
		
		private function updateInvites(upd:Deferred, ad:Deferred):Deferred
		{
			if(uow == null || uow.service.login == "guest") return Deferred.succeed(true);
			
			return uow.invitationRepository.getReceivedInvitations(Invitation.FRIEND_INVITATION, Invitation.WAITING_INVITATION)
				.addCallback(
					function(invites:Array):Deferred
					{
						function fetch(b:*, invite:Invitation):Deferred
						{
							return fetchUserProfile(upd, ad, invite.creator, invite);
						}
						
						_usersCount = invites.length;
						
						for(var i:int = 0; i < invites.length; i++)
						{
							var inv:Invitation = invites[i] as Invitation;
							
							if(!_users[inv.creator.id])
							{
								_users[inv.creator.id] = true;
								upd.addCallback(fetch, inv);
							}
						}
						
						var d:Deferred = new Deferred();
						Deferred.callLater(0, d.callback, true);
						return d;
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error get invites: ", fail.value);
					});
		}
		
		
		private function fetchUserProfile(upd:Deferred, ad:Deferred, user:User, invite:Invitation = null):Deferred
		{
			return uow.profileRepository.getProfile(user)
				.addCallback(
					function(profile:Profile):Deferred
					{
						function add(b:*, object:Object):Deferred
						{
							return _addMarker(object);
						}
						
						var gomees:Array = profile.getGomees();
						
						for(var i:int = 0; i < gomees.length; i++)
						{
							var object:Object = new Object();
							object.gomee = gomees[i];
							object.profile = profile;
							object.invite = invite;
							
							if(invite != null && i == 0)
							{
								_invitesFilter.addNotification(object.gomee);
							}
							
							ad.addCallback(add, object);
						}						
						
						var d:Deferred = new Deferred();
						Deferred.callLater(0, d.callback, true);
						return d;					
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error fecthing profile:", fail.value);
					});
		}
		
		protected override function createMarker():YoMarker
		{
			var marker:YoHomeMarker = new YoHomeMarker();
			marker.editable = false;
			marker.deletable = false;
			marker.twitterVisible = false;
			marker.setStyle("iconColor", 0x000000);
			
			if(uow != null && uow.service.login != "guest")
			{
				marker.sendInviteVisible = true;
				
				marker.addEventListener(
					"inviteClicked",
					function(event:Event):void
					{
						var g:Gomee = marker.data.gomee as Gomee;
						var i:Invitation = new Invitation();
						uow.invitationRepository.addInvitation(g.owner, i)
							.addCallback(
								function(result:Invitation):void
								{
									marker.sendInviteVisible = false;
								})
							.addErrback(
								function(fail:Failure):void
								{
									trace("error add invite: ", fail.value);
								});
					});
					
				marker.addEventListener(
					"acceptInviteClicked",
					function(event:Event):void
					{
						var i:Invitation = marker.data.invite as Invitation;
						uow.invitationRepository.acceptInvitation(i)
							.addCallback(
								function(invite:Invitation):void
								{
									_usersCount--;
									_invitesFilter.removeNotification(marker.data.gomee);
									_invitesFilter.notifierLabel = _usersCount.toString();
									
									for(var markerid:String in markers)
									{	
										var m:YoHomeMarker = markers[markerid] as YoHomeMarker;
										var g:Gomee = m.data.gomee as Gomee;
				
										if(g.owner.id == invite.creator.id)
										{
											if(layer.contains(m))
											{
												layer.removeChild(m);
											}
											
											markers[markerid] = null;
											delete markers[markerid]
										}
									}
									
									var e:DynamicEvent = new DynamicEvent("friendInviteAccepted");
									e.invite = invite;
									dispatchEvent(e);
								})
							.addErrback(
								function(fail:Failure):void
								{
									trace("error accept invite: ", fail.value);
								});
								
					});
			}
			
			return marker;
		}
	}
}