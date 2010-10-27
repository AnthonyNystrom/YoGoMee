package controls.map.controls
{
	import controls.panel.YoPanel;
	
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.CheckBox;
	import mx.core.UIComponent;

	/**
	 * Represents component to display markers filter. 
	 */	
	public class YoMarkersFilterControl extends YoPanel
	{
		/**
		 * Constructor 
		 */		
		public function YoMarkersFilterControl()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Proerties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  homes visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for homesVisible property. 
    	 */    	
    	private var _homesVisible:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _homesVisible changes. 
    	 */    	
    	private var _homesVisibleChanged:Boolean;
    	
    	/**
    	 * Specifies visibility of home markers. 
    	 */    	
    	public function get homesVisible():Boolean
    	{
    		return _homesVisible;
    	}
    	
    	/**
    	 * Specifies visibility of home markers. 
    	 */
    	public function set homesVisible(homesVisible:Boolean):void
    	{
    		if(_homesVisible != homesVisible)
    		{
    			_homesVisible = homesVisible;
    			_homesVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  gomees visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for gomeesVisible property. 
    	 */    	
    	private var _gomeesVisible:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _gomeesVisible changed. 
    	 */    	
    	private var _gomeesVisibleChanged:Boolean;
    	
    	/**
    	 * Specifies visiblity of gomee markers. 
    	 */    	
    	public function get gomeesVisible():Boolean
    	{
    		return _gomeesVisible;
    	}
    	
    	/**
    	 * Specifies visiblity of gomee markers. 
    	 */
    	public function set gomeesVisible(gomeesVisible:Boolean):void
    	{
    		if(_gomeesVisible != gomeesVisible)
    		{
    			_gomeesVisible = gomeesVisible;
    			_gomeesVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  homes visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for homesVisibleComtrol component. 
    	 */    	
    	private var _homesVisibleControl:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _gomesVisbleControl changes. 
    	 */    	
    	private var _homesVisibleControlChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display homesVisble property.  
    	 */    	
    	protected function get homesVisibleControl():UIComponent
    	{
    		return _homesVisibleControl;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display homesVisble property.  
    	 */
    	protected function set homesVisibleControl(homesVisibleControl:UIComponent):void
    	{
    		if(_homesVisibleControl != homesVisibleControl)
    		{
    			_homesVisibleControl = homesVisibleControl;
    			_homesVisibleControlChanged = false;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates homesVisibleControl component.
    	 */    	
    	protected function createHomesVisibleControl():void
    	{
    		if(_homesVisibleControl == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.label = "home";
    			box.labelPlacement = ButtonLabelPlacement.RIGHT;
    			box.percentWidth = 100;
    			box.styleName = "MarkersFilterGomees";
    			
    			_homesVisibleControl = box;
    			content.addChild(_homesVisibleControl);
    			
				_homesVisibleControl.addEventListener(
					Event.CHANGE,
					function(event:Event):void
					{
						_homesVisible = !_homesVisible;
						dispatchEvent(new Event("homesVisibleChanged"));
					});
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates homesVisbleControl with new value.
    	 */    	
    	protected function updateHomesVisible():void
    	{
    		var box:CheckBox = homesVisibleControl as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = homesVisible;
    		}
    	}
    	
    	//----------------------------------
    	//  gomees visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for gomeesVisibleControl component. 
    	 */    	
    	private var _gomeesVisibleControl:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _gomeesVisbleControl changes. 
    	 */    	
    	private var _gomeesVisibleControlChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display gomeesVisble property. 
    	 */    	
    	protected function get gomeesVisibleControl():UIComponent
    	{
    		return _gomeesVisibleControl;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display gomeesVisble property. 
    	 */
    	protected function set gomeesVisibleControl(gomeesVisibleControl:UIComponent):void
    	{
    		if(_gomeesVisibleControl != gomeesVisibleControl)
    		{
    			_gomeesVisibleControl = gomeesVisibleControl;
    			_gomeesVisibleControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates gomeesVisibleControl component.
    	 */    	
    	protected function createGomeesVisbleControl():void
    	{
    		if(_gomeesVisibleControl == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.label = "gomees";
    			box.labelPlacement = ButtonLabelPlacement.RIGHT;
    			box.percentWidth = 100;
    			box.styleName = "MarkersFilterGomees";
    			
    			_gomeesVisibleControl = box;
    			content.addChild(_gomeesVisibleControl);
    			
    			_gomeesVisibleControl.addEventListener(
					Event.CHANGE,
					function(event:Event):void
					{
						_gomeesVisible = !_gomeesVisible;
						dispatchEvent(new Event("gomeesVisibleChanged"));
					});
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates gomeesVisibleControl with new value.
    	 */    	
    	protected function updateGomeesVisible():void
    	{
    		var box:CheckBox = gomeesVisibleControl as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = gomeesVisible;
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Overriden protected methods.
    	//
    	//--------------------------------------------------------------------------
    	
    	/**
    	 * @override
    	 * Creates content component.
    	 */    	
    	protected override function createContent():void
    	{
    		if(content == null)
    		{
    			content = new VBox();
    			content.styleName = "MarkersFilterContent";
    			addChild(content);
    		}
    	}
    	
    	/**
    	 * @override
    	 * Create and add children.  
    	 */
    	protected override function createChildren():void
    	{
    		super.createChildren();
    		
    		createHomesVisibleControl();
    		createGomeesVisbleControl();
    		
    		substrate.styleName = "YoPanelSubstrate";
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
    		
    		// update homes visible
    		if(_homesVisibleChanged || _homesVisibleControlChanged)
    		{
    			updateHomesVisible();
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update homes visible
    		if(_gomeesVisibleChanged || _gomeesVisibleControlChanged)
    		{
    			updateGomeesVisible();
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