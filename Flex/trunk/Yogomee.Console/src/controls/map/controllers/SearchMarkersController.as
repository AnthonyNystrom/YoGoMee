package controls.map.controllers
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import controls.map.marker.YoGomeeMarker;
	import controls.map.marker.YoMarker;
	import controls.map.marker.events.YoMarkerEvent;
	
	import defer.Deferred;
	import defer.Failure;
	
	import domainModel.entities.Gomee;
	import domainModel.utils.GoogleSearchService;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class SearchMarkersController extends GomeeMarkersController
	{
		public function SearchMarkersController(layer:UIComponent)
		{
			super(layer);
		}
		
		private var _query:String;
		
		public function get query():String
		{
			return _query;
		}
		
		public function set query(query:String):void
		{
			if(_query != query)
			{
				_query = query;
				clearMarkers();
			}
		}
		
		private var _markersVisible:Boolean;
		
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
		
		public function updateMarkersVisibility():void
		{
			for(var marker:String in markers)
			{
				var m:YoMarker = markers[marker] as YoMarker;
				m.visible = markersVisible;
			}
		}
		
		public override function updateMarkers(bounds:LatLngBounds):void
		{
			if(_query == null) return;
			
			var ll1:LatLng = bounds.getNorthWest();
			var ll2:LatLng = bounds.getSouthEast();
			
			var service:GoogleSearchService = new GoogleSearchService();
			
			service.search(query, bounds)
				.addCallback(
					function(results:Array):void
					{
						function add(s:Boolean, result:Object):Deferred
						{
							var gomee:Gomee = new Gomee();
							gomee.id = "_" + result.lat.toString() + "_" + result.lng.toString();
							gomee.lat = result.lat;
							gomee.lng = result.lng;
							gomee.type = 2;
							gomee.caption = result.titleNoFormatting;
							
							if(result.addressLines != null)
							{
								if(result.addressLines.length > 0)
								{
									gomee.address = result.addressLines.join(", ");
								}
							}
							
							if(gomee.address == null)
							{
								gomee.address = "";
								
								if(result.streetAddress != null)
								{
									gomee.address += result.streetAddress + ", "; 
								}
								
								if(result.city != null)
								{
									gomee.address += result.city + ", ";	
								}
								
								if(result.country != null)
								{
									gomee.address += result.country + ", ";	
								}
							} 
							
							return _addMarker(gomee);
						}
						
						var d:Deferred = new Deferred();
						
						for(var i:int = 0; i < results.length; i++)
						{
							d.addCallback(add, results[i]);
						}
						
						Deferred.callLater(0, d.callback, true);
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error getting gomees:", fail.value);
					});
		}
		
		protected override function createMarker():YoMarker
		{
			var m:YoGomeeMarker = new YoGomeeMarker();
			m.deletable = false;
			m.iconColor = 0x333333;
			
			if(uow == null || uow.service.login == "guest")
			{
				m.editable = false;
			}
			else
			{
				m.addEventListener(
					YoMarkerEvent.ContentChanged,
					function(event:YoMarkerEvent):void
					{
						var g:Gomee = m.data as Gomee;
						
						uow.gomeeRepository.addGomee(g)
							.addCallback(
								function(gomee:Gomee):void
								{
									dispatchEvent(new Event("markerAdded"));
								})
							.addErrback(
								function(fail:Failure):void
								{
									trace("error adding gomee: ", fail.value);
								});
					});
			}
			
			return m;		
		}
		
	}
}