package controls.map
{
	import controls.map.events.YoMapEvent;
	import controls.map.marker.YoMarker;
	import controls.map.marker.events.YoMarkerEvent;
	
	import defer.Deferred;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class YoMarkersLayer extends Container
	{
		/**
		 * Constructor. 
		 */
		public function YoMarkersLayer()
		{
			super();
			
			clipContent = true;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  map
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for map property. 
		 */		
		private var _map:YoMap;
		
		/**
		 * @private
		 * Flag to indicate when _map changes. 
		 */		
		private var _mapChanged:Boolean;
		
		/**
		 * Specifies map component. 
		 */		
		public function get map():YoMap
		{
			return _map;
		}
		
		/**
		 * Specifies map component. 
		 */
		public function set map(map:YoMap):void
		{
			if(_map != map)
			{
				_map = map;
				
				_map.addEventListener(YoMapEvent.MapReady, mapReadyHandler);
				_map.addEventListener(YoMapEvent.ViewChangeEnd, mapViewChangeEndHandler);
				_map.addEventListener(YoMapEvent.ViewChangeStep, mapViewChangeStepHandler);
				
				_mapChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  mapReady
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for mapReady property. 
		 */		
		private var _mapReady:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _mapReady changes. 
		 */		
		private var _mapReadyChanged:Boolean;
		
		/**
		 * @protected
		 * True, if map loded and initialized. 
		 */		
		protected function get mapReady():Boolean
		{
			return _mapReady;
		}
		
		/**
		 * @protected
		 * True, if map loded and initialized. 
		 */
		protected function set mapReady(mapReady:Boolean):void
		{
			if(_mapReady != mapReady)
			{
				_mapReady = mapReady;
				_mapReadyChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  dragMode
    	//----------------------------------
		
		private var _dragMode:Boolean;
		
		public function get dragMode():Boolean
		{
			return _dragMode;
		}
		
		public function set dragMode(dragMode:Boolean):void
		{
			if(_dragMode != dragMode)
			{
				_dragMode = dragMode;
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Public methods methods
    	//
    	//--------------------------------------------------------------------------
		
		public function addMarker(marker:YoMarker):Deferred
		{
			var d:Deferred = new Deferred();
			
			marker.addEventListener(
				FlexEvent.CREATION_COMPLETE,
				function(event:FlexEvent):void
				{
					Deferred.callLater(0, d.callback, marker);	
				});
			
			addChild(marker);
			
			return d;
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Overridden protected methods
    	//
    	//--------------------------------------------------------------------------
		
		/**
		 * @override
		 * Draws markers. 
		 */		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(mapReady)
			{
				var i:int;
				for(i = 0; i < numChildren; i++)
				{
					var marker:YoMarker = getChildAt(i) as YoMarker;
				
					if(marker.visible)
					{
						var point:Point = map.fromLatLngToViewport(marker.latLng);
						marker.setActualSize(
							Math.min(marker.measuredWidth, unscaledWidth - 80),
							Math.min(marker.measuredHeight, unscaledHeight - 50));
						marker.move(point.x - marker.tailX, point.y - marker.tailY);
					}
				}
			}
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			child.addEventListener(MouseEvent.MOUSE_OVER, markerMouseOverHandler);
			child.addEventListener(MouseEvent.MOUSE_OUT, markerMouseOutHandler);
			child.addEventListener(YoMarkerEvent.ResizePan, markerResizePanHandler);
			return super.addChild(child);
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Private methods
    	//
    	//--------------------------------------------------------------------------
    	
    	private function markerResizePanHandler(event:YoMarkerEvent):void
		{
			var marker:UIComponent = event.target as UIComponent;
			
			var rect:Rectangle = new Rectangle(marker.x, marker.y, marker.width, marker.height);
			var point:Point = new Point();
			
			if(rect.left < 70)
			{
				point.x += rect.left - 70;
			}
			
			if(rect.right > width - 10)
			{
				point.x += rect.right - width + 10;
			}
			
			if(rect.top < 50)
			{
				point.y += rect.top - 50;
			}
			
			if(rect.bottom > height - 10)
			{
				point.y += rect.bottom - height + 10;
			}
			
			map.panBy(point);
		}
		
		private function markerMouseOverHandler(event:MouseEvent):void
		{
			var marker:UIComponent = event.currentTarget as UIComponent;
			
			if(dragMode)
			{
				marker.alpha = 0.1;
			}
			else
			{
				setChildIndex(marker, numChildren - 1);
			}
		}
		
		private function markerMouseOutHandler(event:MouseEvent):void
		{
			var marker:UIComponent = event.currentTarget as UIComponent;
			
			if(dragMode)
			{
				marker.alpha = 1.0;
			}
		}
		
		private function mapReadyHandler(event:YoMapEvent):void
		{
			mapReady = true;
		}
		
		private function mapViewChangeStepHandler(event:YoMapEvent):void
		{
			invalidateDisplayList();
		}
		
		private function mapViewChangeEndHandler(event:YoMapEvent):void
		{
			
		}
	}
}