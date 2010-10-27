package controls.map.controls
{
	import controls.map.marker.YoMarker;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.core.BitmapAsset;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.managers.DragManager;
	
	public class YoNewMarkerControl extends VBox
	{
		/**
		 * Constructor. 
		 */		
		public function YoNewMarkerControl()
		{
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  marker
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for marker component. 
    	 */    	
    	private var _marker:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _marker changes. 
    	 */    	
    	private var _markerChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to diasplay dragable marker. 
    	 */    	
    	protected function get marker():UIComponent
    	{
    		return _marker;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to diasplay dragable marker. 
    	 */
    	protected function set marker(marker:UIComponent):void
    	{
    		if(_marker != marker)
    		{
    			_marker = marker;
    			_markerChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates marker component.
    	 * Must be implemented in subclasses. 
    	 */    	
    	protected function createMarker():void {}
    	
    	/**
    	 * @protected
    	 * Add events to marker. 
    	 */    	
    	protected function updateMarker():void
    	{
    		if(marker != null)
    		{
    			marker.addEventListener(
    				MouseEvent.MOUSE_MOVE,
    				function(event:MouseEvent):void
    				{
    					var m:YoMarker = marker as YoMarker;
    					var data:BitmapData = new BitmapData(marker.width, marker.height, true, 0);
						data.draw(marker);
						var bitmap:BitmapAsset = new BitmapAsset(data);
						
    					DragManager.doDrag(marker, new DragSource(), event, bitmap, m.tailX - m.contentMouseX, marker.height - m.contentMouseY);
    				});
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
    		
    		createMarker();
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
    		
    		// update marker
    		if(_markerChanged)
    		{
    			if(marker != null)
    			{
    				updateMarker();
    			}
    			
    			_markerChanged = false;
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
	}
}