package controls.map.controllers
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import controls.map.marker.YoGomeeMarker;
	import controls.map.marker.YoMarker;
	
	import defer.Deferred;
	import defer.Failure;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	import domainModel.entities.User;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class TheirsGomeeMarkersController extends GomeeMarkersController
	{
		public function TheirsGomeeMarkersController(
			layer:UIComponent,
			gomeesFilter:UIComponent, invitesFilter:UIComponent, tagFilter:UIComponent)
		{
			super(layer);
			gomeesFilter.addEventListener("gomeesVisibleChanged", gomeesVisibleChangedHandler);
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
		
		private function gomeesVisibleChangedHandler(event:Event):void
		{
			markersVisible = !markersVisible;
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
		
		public function removeUsersMarkers(user:User):void
		{
			for(var marker:String in markers)
			{
				var m:YoGomeeMarker = markers[marker] as YoGomeeMarker;
				var g:Gomee = m.data as Gomee;
				
				if(g.owner.id == user.id)
				{
					if(layer.contains(m))
					{
						layer.removeChild(m);
					}
					
					markers[marker] = null;
					delete markers[marker];
				}
			}
		}
		
		private var _updating:Deferred;
		private var _adding:Deferred;
		
		public override function updateMarkers(bounds:LatLngBounds):void
		{
			if(!markersVisible || uow == null) return;
			
			if(_updating == null)
			{
				_updating = new Deferred();
				_updating.callback(null);
			}
			
			if(_adding == null)
			{
				_adding = new Deferred();
				_adding.callback(null);
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
								function fetch(b:*, user:User, bounds:LatLngBounds):Deferred
								{
									return fetchTheirsGomees(upd, ad, user, bounds);
								}
						
								var d:Deferred = new Deferred();
								
								for(var i:int = 0; i < users.length; i++)
								{
									var user:User = users[i];
									if(user.login != uow.service.login)
									{
										d.addCallback(fetch, user, bounds);						
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
		
		private function fetchTheirsGomees(upd:Deferred, ad:Deferred, user:User, bounds:LatLngBounds):Deferred
		{
			var ll1:LatLng = bounds.getNorthWest();
			var ll2:LatLng = bounds.getSouthEast();
			
			return uow.gomeeRepository.getGomees(ll1, ll2, user)
				.addCallback(
					function(gomees:Array):Deferred
					{
						function add(b:*, gomee:Gomee):Deferred
						{
							return _addMarker(gomee);
						}
						
						for(var i:int = 0; i < gomees.length; i++)
						{
							var gomee:Gomee = gomees[i] as Gomee;
							if(gomee.type != 0 && gomee.common)
							{
								ad.addCallback(add, gomee);
							}
						}
						
						var d:Deferred = new Deferred();
						Deferred.callLater(0, d.callback, true);
						return d;
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error getting gomees:", fail.value);
					});
		}
		
		protected override function createMarker():YoMarker
		{
			var marker:YoGomeeMarker = new YoGomeeMarker();
			marker.editable = false;
			marker.deletable = false;
			marker.setStyle("iconColor", 0x000000);
			
			return marker;
		}
	}
}