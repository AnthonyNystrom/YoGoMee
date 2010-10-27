package controls.map.controllers
{
	import com.google.maps.LatLng;
	
	import controls.map.marker.YoGomeeMarker;
	import controls.map.marker.YoLocationMarker;
	import controls.map.marker.YoMarker;
	import controls.text.YoTagsInput;
	
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	
	import mx.core.UIComponent;

	public class GomeeMarkersController extends YoMarkersController
	{
		public function GomeeMarkersController(layer:UIComponent)
		{
			super(layer);
		}
		
		protected override function getId(object:Object):Object
		{
			if(object is Gomee)
			{
				return (object as Gomee).id;
			}
			
			return super.getId(object);
		}
		
		protected override function updateMarker(marker:YoMarker, object:Object):void
		{
			var g:Gomee = object as Gomee;
			var m:YoLocationMarker = marker as YoLocationMarker;
			
			if(g == null || m == null)
			{
				super.updateMarker(marker, object);
			}
			else
			{
				m.latLng = new LatLng(g.lat, g.lng);
				m.caption = g.caption;
				m.address = g.address;
				m.description = g.description;
				m.common = g.common;
				m.data = g;
				if(g.tags != null)
				{
					m.tags = g.tags.join(", ");
					YoTagsInput.addTags(g.tags);
				}	
			}
		}
		
		protected override function createMarker():YoMarker
		{
			return new YoGomeeMarker();
		}
	}
}