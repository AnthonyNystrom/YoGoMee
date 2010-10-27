package controls.map.controllers
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import controls.map.marker.YoHomeMarker;
	import controls.map.marker.YoMarker;
	
	import defer.Deferred;
	import defer.Failure;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Profile;
	import domainModel.entities.User;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class FriendsProfileMarkersController extends ProfileMarkersController
	{
		public function FriendsProfileMarkersController(
			layer:UIComponent,
			gomeesFilter:UIComponent, ivitesFilter:UIComponent, tagFilter:UIComponent)
		{
			super(layer);
			gomeesFilter.addEventListener("homesVisibleChanged", homesVisibleChangedHandler);
		}
		
		private function homesVisibleChangedHandler(event:Event):void
		{
			markersVisible = !markersVisible;
		}
		
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
		}
		
		private var _updating:Deferred;
		private var _adding:Deferred;
		
		public override function updateMarkers(bounds:LatLngBounds):void
		{
			if(!markersVisible || uow == null || uow.service.login == "guest") return;
			
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
			
					return uow.userRepository.getFriends()
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
										d.addCallback(fetch, user);
									}
								}
						
								Deferred.callLater(0, d.callback, true);
								return d;
							})
						.addErrback(
							function(fail:Failure):void
							{
								trace("error fetching users:", fail.value);
							});
			}, _updating, _adding, bounds);
		}
		
		private function fetchUserProfile(upd:Deferred, ad:Deferred, user:User):Deferred
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
			marker.setStyle("iconColor", 0xcccc01);
			
			return marker;
		}
		
	}
}