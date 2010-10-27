package controls.map
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.MapType;
	import com.google.maps.MapZoomEvent;
	import com.google.maps.interfaces.IMapType;
	
	import controls.map.events.YoMapEvent;
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	public class YoMapLayer extends UIComponent
	{
		/**
		 * Constructor. 
		 */		
		public function YoMapLayer()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  key
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for key property. 
		 */		
		private var _key:String;
		
		/**
		 * @private
		 * Flag to indicate when _key changes. 
		 */		
		private var _keyChanged:Boolean;
		
		/**
		 * Specifies map key. 
		 */		
		public function get key():String
		{
			return _key;
		}
		
		/**
		 * Specifies map key. 
		 */
		public function set key(key:String):void
		{
			if(_key != key)
			{
				_key = key;
				_keyChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  map
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for map component. 
		 */		
		private var _map:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _map changes. 
		 */		
		private var _mapChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to display map. 
		 */		
		protected function get map():UIComponent
		{
			return _map;
		}
		
		/**
		 * @protected
		 * Specifies component to display map. 
		 */
		protected function set map(map:UIComponent):void
		{
			if(_map != map)
			{
				_map = map;
				_mapChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates map component. 
		 */		
		protected function createMap():void
		{
			if(_map == null)
			{
				var m:Map = new Map();
				
				//m.addControl(new ZoomControl());
				//m.addControl(new PositionControl());
				
				m.addEventListener(MapMoveEvent.MOVE_STEP, mapMoveStepHandler);
				m.addEventListener(MapMoveEvent.MOVE_END, mapMoveEndHandler);
				m.addEventListener(MapZoomEvent.ZOOM_CHANGED, mapZoomChangedHandler);
				m.addEventListener(MapEvent.MAP_READY, mapReadyHandler);
				
				_map = m;
				addChild(_map);
			}
		}
		
		/**
		 * @protected
		 * Updates map component with new values. 
		 */		
		protected function updateMap():void
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				m.key = key;
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Public methods
    	//
    	//--------------------------------------------------------------------------
		
		public function panBy(point:Point):void
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				m.panBy(point);
			}
		}
		
		public function setCenter(latlng:LatLng, l:Number):void
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				m.setCenter(latlng, l);
			}
		}
		
		public function getZoom():Number
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				return m.getZoom();
			}
			
			return 0;
		}
		
		public function setZoom(zoom:Number):void
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				m.setZoom(zoom);
			}
		}
		
		public function fromLatLngToViewport(latlng:LatLng):Point
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				return m.fromLatLngToViewport(latlng);
			}
			else
			{
				return null;
			}
		}
		
		public function fromViewportToLatLng(point:Point):LatLng
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				return m.fromViewportToLatLng(point);
			}
			else
			{
				return null;
			}
		}
		
		public function getLatLngBounds():LatLngBounds
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				return m.getLatLngBounds();
			}
			else
			{
				return null;
			}
		}
		
		public function setMapType(type:IMapType):void
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				m.setMapType(type);
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Overriden protected methods
    	//
    	//--------------------------------------------------------------------------
		
		/**
		 * @override
		 * Create and add children. 
		 */		
		protected override function createChildren():void
		{
			super.createChildren();
			createMap();
		}
		
		/**
    	 * @override
    	 * Coordinates modifications to component properties. 
    	 */
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			var needInvalidateSize:Boolean = false;
    		var needInvalidateDisplayList:Boolean = false;
    		
    		// update key
    		if(_keyChanged || _mapChanged)
    		{
    			if(map != null)
    			{
    				updateMap();
    			}
    			
    			_keyChanged = false;
    			_mapChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// ---------------------
    		// Validate
    		// ---------------------
    		
    		// validate size if need
    		if(needInvalidateSize)
    		{
    			invalidateSize();
    		}
    		
    		// validate display list if need
    		if(needInvalidateDisplayList)
    		{
    			invalidateDisplayList();
    		}
  		}
		
		/**
		 * @override
		 * Draws map. 
		 */		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(_map != null)
			{
				_map.move(0,0);
				_map.setActualSize(unscaledWidth, unscaledHeight);
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Private methods
    	//
    	//--------------------------------------------------------------------------
		
		private function mapReadyHandler(event:MapEvent):void
		{
			var m:Map = map as Map;
			
			if(m != null)
			{
				m.disableContinuousZoom();
				m.enableScrollWheelZoom();
				m.setZoom(3);
				
				m.addMapType(MapType.NORMAL_MAP_TYPE);
				m.addMapType(MapType.HYBRID_MAP_TYPE);
				m.addMapType(MapType.PHYSICAL_MAP_TYPE);
				m.addMapType(MapType.SATELLITE_MAP_TYPE);
				
				dispatchEvent(new YoMapEvent(YoMapEvent.MapReady));
			}
		}
		
		private function mapMoveEndHandler(event:MapMoveEvent):void
		{
			dispatchEvent(new YoMapEvent(YoMapEvent.ViewChangeEnd));
		}
		
		private function mapZoomChangedHandler(event:MapZoomEvent):void
		{
			dispatchEvent(new YoMapEvent(YoMapEvent.ViewChangeEnd));
		}
		
		private function mapMoveStepHandler(vent:MapMoveEvent):void
		{
			dispatchEvent(new YoMapEvent(YoMapEvent.ViewChangeStep));
		}
	}
}