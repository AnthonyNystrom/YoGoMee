package controls.map.controllers
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.ClientGeocoderOptions;
	import com.google.maps.services.GeocodingEvent;
	
	import controls.map.marker.YoHomeMarker;
	import controls.map.marker.YoMarker;
	import controls.map.marker.YoMarkerState;
	import controls.map.marker.events.YoMarkerEvent;
	import controls.panel.YoPanelState;
	
	import defer.Deferred;
	import defer.Failure;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	import domainModel.entities.Profile;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.managers.DragManager;
	import mx.utils.StringUtil;

	public class MineProfileMarkersController extends ProfileMarkersController
	{
		public function MineProfileMarkersController(
			layer:UIComponent,
			gomeesFilter:UIComponent, eventsFilter:UIComponent, tagFilter:UIComponent)
		{
			super(layer);
			gomeesFilter.addEventListener("homesVisibleChanged", homesVisibleChangedHandler);
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
		
		private function homesVisibleChangedHandler(event:Event):void
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
		
		public override function addMarker(data:Object):void
		{
			var marker:YoHomeMarker = new YoHomeMarker();
			marker.data = new Object();
			marker.data.gomee = data.gomee;
			
			var g:Gomee = data.gomee as Gomee;
			marker.latLng = new LatLng(g.lat, g.lng);
			marker.caption = g.caption;
			marker.address = g.address;
			marker.description = g.description;
			marker.dragCrossVisible = true;
			marker.findAddressVisible = true;
			marker.editableLocationState = YoPanelState.Expanded;
			marker.findAddress = true;
			
			var m:YoHomeMarker = new YoHomeMarker();
			m.data = marker;
			m.latLng = new LatLng(g.lat, g.lng);
			
			uow.profileRepository.getProfile()
				.addCallback(
					function(profile:Profile):void
					{
						marker.login = profile.user.login;
						marker.firstName = profile.firstName;
						marker.lastName = profile.lastName;
						marker.email = profile.email;
						marker.twitterLogin = profile.twitterLogin;
						marker.twitterUpdateOnAddGomee = profile.twitterUpdateOnAddGomee;
						marker.twitterUpdateOnDeleteGomee = profile.twitterUpdateOnDeleteGomee;
						marker.twitterUpdateOnSaveGomee = profile.twitterUpdateOnSaveGomee;
						
						marker.data.profile = profile;
					});
			
			function delhandler(event:YoMarkerEvent):void
			{
				layer.removeChild(marker);
				layer.removeChild(m);
			}
			
			function handler(event:YoMarkerEvent):void
			{
				var g:Gomee = marker.data.gomee as Gomee;
				var p:Profile = marker.data.profile as Profile;
					
				g.caption = marker.caption;
				g.address = marker.address;
				g.description = marker.description;
				g.common = marker.common;
				if(m.tags) g.tags = StringUtil.trimArrayElements(marker.tags, ",").split(",");
				
				p.firstName = marker.firstName;
				p.lastName = marker.lastName;
				p.email = marker.email;
				p.twitterLogin = marker.twitterLogin;
				p.twitterSecret = marker.twitterSecret;
				p.twitterUpdateOnAddGomee = marker.twitterUpdateOnAddGomee;
				p.twitterUpdateOnDeleteGomee = marker.twitterUpdateOnDeleteGomee;
				p.twitterUpdateOnSaveGomee = marker.twitterUpdateOnSaveGomee;
					
				uow.gomeeRepository.addGomee(g)
					.addCallback(
						function(gomee:Gomee):void
						{
							uow.profileRepository.saveProfile(p)
								.addErrback(
									function(fail:Failure):void
									{
										trace("error saving profile: ", fail.value);
									});
									
							marker.removeEventListener(YoMarkerEvent.ContentChanged, handler);
							marker.removeEventListener(YoMarkerEvent.RemoveClick, delhandler);
							layer.removeChild(m);
							
							marker.dragCrossVisible = false;
							marker.findAddressVisible = false;
							
							marker.visible = markersVisible;
			
							marker.addEventListener(
								YoMarkerEvent.ContentChanged,
								function(event:YoMarkerEvent):void
								{
									var g:Gomee = marker.data as Gomee;
									
									g.caption = marker.caption;
									g.address = marker.address;
									g.description = marker.description;
									g.common = marker.common;
									if(marker.tags) g.tags = StringUtil.trimArrayElements(marker.tags, ",").split(",");
					
									uow.gomeeRepository.saveGomee(g)
										.addErrback(
											function(fail:Failure):void
											{
												trace("gomee save error: ", fail.value);
											});
					
								});
								
							marker.addEventListener(
								YoMarkerEvent.RemoveClick,
								function(event:YoMarkerEvent):void
								{
									var g:Gomee = marker.data as Gomee;
									uow.gomeeRepository.removeGomee(g)
										.addCallback(
											function(result:*):void
											{
												layer.removeChild(marker);
												markers[g.id] = null;
												delete markers[g.id];
											})
										.addErrback(
											function(fail:Failure):void
											{
												trace("error deleting gomee: ", fail.value);
											});
								});
								
							markers[gomee.id] = marker;
						})
					.addErrback(
						function(fail:Failure):void
						{
							trace("gomee add error: ", fail.value);
						});
			}
			
			marker.addEventListener(
				"crossMouseMove",
				function(event:MouseEvent):void
				{
					var data:BitmapData = new BitmapData(m.width + 1, m.height, true, 0);
					data.draw(m);
					var bitmap:BitmapAsset = new BitmapAsset(data);
					
					if(event.buttonDown)
					{
						marker.alpha = 0.2;
						m.visible = false;
					}
					
					DragManager.doDrag(m, new DragSource(), event, bitmap, marker.tailX, marker.height, 1.0);
				});
			
			var o:ClientGeocoderOptions = new ClientGeocoderOptions();
			o.language = "en";
			var cl:ClientGeocoder = new ClientGeocoder(o);
			
			cl.addEventListener(
				GeocodingEvent.GEOCODING_SUCCESS,
				function(event:GeocodingEvent):void
				{
					marker.address = event.response.placemarks[0].address;
				});
				
			cl.addEventListener(
				GeocodingEvent.GEOCODING_FAILURE,
				function(event:GeocodingEvent):void
				{
					trace(event);
				});
				
			cl.reverseGeocode(marker.latLng);
			
			marker.addEventListener(YoMarkerEvent.ContentChanged, handler);
			marker.addEventListener(YoMarkerEvent.RemoveClick, delhandler);
			
			layer.addMarker(m);
			
			layer.addMarker(marker)
				.addCallback(
					function(marker:YoHomeMarker):void
					{
						var t:Timer = new Timer(500, 1);
						t.addEventListener(
							TimerEvent.TIMER,
							function(event:TimerEvent):void
							{
								marker.state = YoMarkerState.Edit;
							});
						t.start();
					});
		}
		
		public function dropMarker(marker:YoHomeMarker):void
		{
			var m:YoHomeMarker = marker.data as YoHomeMarker;
			var g:Gomee = m.data as Gomee;
			
			m.latLng = new LatLng(marker.latLng.lat(), marker.latLng.lng());
			g.lat = m.latLng.lat();
			g.lng = m.latLng.lng();
			m.alpha = 1.0;
			marker.visible = true;
			layer.invalidateDisplayList();
			
			if(m.findAddress)
			{
				var o:ClientGeocoderOptions = new ClientGeocoderOptions();
				o.language = "en";
				var cl:ClientGeocoder = new ClientGeocoder(o);
			
				cl.addEventListener(
					GeocodingEvent.GEOCODING_SUCCESS,
					function(event:GeocodingEvent):void
					{
						m.address = event.response.placemarks[0].address;
					});
				
				cl.addEventListener(
					GeocodingEvent.GEOCODING_FAILURE,
					function(event:GeocodingEvent):void
					{
						trace(event);
					});
				
				cl.reverseGeocode(m.latLng);
			}
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
				function(o:*, upd:Deferred, ad:Deferred):Deferred
				{
					return uow.profileRepository.getProfile()
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
								trace("error fetching profile:", fail.value);
							});
				}, _updating, _adding);
		}
		
		protected override function createMarker():YoMarker
		{
			var marker:YoMarker = super.createMarker();
			
			marker.addEventListener(
				YoMarkerEvent.RemoveClick,
				function(event:YoMarkerEvent):void
				{
					var g:Gomee = marker.data as Gomee;
					
					uow.gomeeRepository.removeGomee(g)
						.addCallback(
							function(...args):void
							{
								if(layer.contains(marker))
								{
									layer.removeChild(marker);
								}
								
								markers[g.id] = null;
								delete markers[g.id];
							})
						.addErrback(
							function(fail:Failure):void
							{
								trace("error deleting gomee: ", fail.value);
							});
				});
			
			return marker;
		}
	}
}