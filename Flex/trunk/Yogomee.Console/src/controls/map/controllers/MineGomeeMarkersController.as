package controls.map.controllers
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.ClientGeocoderOptions;
	import com.google.maps.services.GeocodingEvent;
	
	import controls.map.marker.YoGomeeMarker;
	import controls.map.marker.YoMarker;
	import controls.map.marker.YoMarkerState;
	import controls.map.marker.events.YoMarkerEvent;
	
	import defer.Deferred;
	import defer.Failure;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	
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

	public class MineGomeeMarkersController extends GomeeMarkersController
	{
		public function MineGomeeMarkersController(
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
			if(_adding != null)
			{
				_adding.pause();
				_adding = null;
			}
			
			if(_updating != null)
			{
				_updating.pause();
				_updating = null;
			}
			
			super.uow = uow;
		}
		
		public override function addMarker(data:Object):void
		{
			var marker:YoGomeeMarker = new YoGomeeMarker();
			marker.data = data.gomee;
			
			var g:Gomee = data.gomee as Gomee;
			marker.latLng = new LatLng(g.lat, g.lng);
			marker.caption = g.caption;
			marker.address = g.address;
			marker.description = g.description;
			marker.dragCrossVisible = true;
			marker.findAddressVisible = true;
			
			var m:YoGomeeMarker = new YoGomeeMarker();
			m.data = marker;
			m.latLng = new LatLng(g.lat, g.lng);
			
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
			
			function delhandler(event:YoMarkerEvent):void
			{
				layer.removeChild(marker);
				layer.removeChild(m);
			}
			
			function handler(event:YoMarkerEvent):void
			{
				var g:Gomee = marker.data as Gomee;
					
				g.caption = marker.caption;
				g.address = marker.address;
				g.description = marker.description;
				g.common = marker.common;
				if(m.tags) g.tags = StringUtil.trimArrayElements(marker.tags, ",").split(",");
					
				uow.gomeeRepository.addGomee(g)
					.addCallback(
						function(gomee:Gomee):void
						{
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
			
			marker.findAddress = true;
			
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
					function(marker:YoGomeeMarker):void
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
		
		public function dropMarker(marker:YoGomeeMarker):void
		{
			var m:YoGomeeMarker = marker.data as YoGomeeMarker;
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
				function(o:*, upd:Deferred, ad:Deferred, bounds:LatLngBounds):Deferred
				{
					var ll1:LatLng = bounds.getNorthWest();
					var ll2:LatLng = bounds.getSouthEast();
			
					return uow.gomeeRepository.getGomees(ll1, ll2)
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
									if(gomee.type != 0)
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
				}, _updating, _adding, bounds);
		}
		
		protected override function createMarker():YoMarker
		{
			var marker:YoMarker = super.createMarker();
			marker.visible = markersVisible;
			
			marker.addEventListener(
				YoMarkerEvent.ContentChanged,
				function(event:YoMarkerEvent):void
				{
					var g:Gomee = marker.data as Gomee;
					var m:YoGomeeMarker = marker as YoGomeeMarker;
					
					g.caption = m.caption;
					g.address = m.address;
					g.description = m.description;
					g.common = m.common;
					g.tags = StringUtil.trimArrayElements(m.tags, ",").split(",");
					
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
			
			return marker;
		}
		
	}
}