package controls.map.controllers
{
	import com.google.maps.LatLngBounds;
	
	import controls.map.YoMarkersLayer;
	
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	
	public class MarkersController extends EventDispatcher
	{
		public function MarkersController(layer:UIComponent)
		{
			_layer = layer as YoMarkersLayer;
		}

		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  layer
    	//----------------------------------
    	
    	private var _layer:YoMarkersLayer;
    	
    	public function get layer():YoMarkersLayer
    	{
    		return _layer;
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Public methods
    	//
    	//--------------------------------------------------------------------------
    	
    	public function addMarker(data:Object):void
    	{
    	
    	}
    	
    	public function updateMarkers(bounds:LatLngBounds):void
    	{
    	
    	}
	}
}