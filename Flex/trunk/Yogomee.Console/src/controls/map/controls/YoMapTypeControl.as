package controls.map.controls
{
	import com.google.maps.MapType;
	import com.google.maps.interfaces.IMapType;
	
	import controls.panel.YoPanel;
	
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;

	public class YoMapTypeControl extends YoPanel
	{
		public function YoMapTypeControl()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  type
    	//----------------------------------
    	
    	private var _type:IMapType;
    	
    	private var _typeChanged:Boolean;
    	
    	public function get type():IMapType
    	{
    		return _type;
    	}
    	
    	public function set type(type:IMapType):void
    	{
    		if(_type != type)
    		{
    			_type = type;
    			_typeChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  group
    	//----------------------------------
    	
    	private var _group:RadioButtonGroup;
    	
    	private var _groupChanged:Boolean;
    	
    	protected function get group():RadioButtonGroup
    	{
    		return _group;
    	}
    	
    	protected function set group(group:RadioButtonGroup):void
    	{
    		if(_group != group)
    		{
    			_group = group;
    			_groupChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createGroup():void
    	{
    		if(_group == null)
    		{
    			_group = new RadioButtonGroup();
    			_group.labelPlacement = ButtonLabelPlacement.RIGHT;
    			
    			_group.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					_type = _group.selectedValue as IMapType;
    					dispatchEvent(new Event(Event.CHANGE));
    				});
    		}
    	}
    	
    	protected function updateGroup():void
    	{
    		if(_group != null)
    		{
    			_group.selectedValue = type;
    		}
    	}
    	
    	//----------------------------------
    	//  normal control
    	//----------------------------------
    	
    	private var _normalControl:RadioButton;
    	
    	private var _normalControlChanged:Boolean;
    	
    	protected function get normalControl():RadioButton
    	{
    		return _normalControl;
    	}
    	
    	protected function set normalControl(normalControl:RadioButton):void
    	{
    		if(_normalControl != normalControl)
    		{
    			_normalControl = normalControl;
    			_normalControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createNormalControl():void
    	{
    		if(_normalControl == null)
    		{
    			_normalControl = new RadioButton();
    			_normalControl.label = "normal";
    			_normalControl.styleName = "MapTypeNormal";
    			_normalControl.group = group;
    			_normalControl.value = MapType.NORMAL_MAP_TYPE;
    			
    			content.addChild(_normalControl);
    		}
    	}
    	
    	//----------------------------------
    	//  hybrid control
    	//----------------------------------
    	
    	private var _hybridControl:RadioButton;
    	
    	private var _hybridControlChanged:Boolean;
    	
    	protected function get hybridControl():RadioButton
    	{
    		return _hybridControl;
    	}
    	
    	protected function set hybridControl(hybridControl:RadioButton):void
    	{
    		if(_hybridControl != hybridControl)
    		{
    			_hybridControl = hybridControl;
    			_hybridControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createHybridControl():void
    	{
    		if(_hybridControl == null)
    		{
    			_hybridControl = new RadioButton();
    			_hybridControl.label = "hybrid";
    			_hybridControl.styleName = "MapTypeHybrid";
    			_hybridControl.group = group;
    			_hybridControl.value = MapType.HYBRID_MAP_TYPE;
    			
    			content.addChild(_hybridControl);
    		}
    	}
    	
    	//----------------------------------
    	//  physical control
    	//----------------------------------
    	
    	private var _physicalControl:RadioButton;
    	
    	private var _physicalControlChanged:Boolean;
    	
    	protected function get physicalControl():RadioButton
    	{
    		return _physicalControl;
    	}
    	
    	protected function set physicalControl(physicalControl:RadioButton):void
    	{
    		if(_physicalControl != physicalControl)
    		{
    			_physicalControl = physicalControl;
    			_physicalControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createPhysicalControl():void
    	{
    		if(_physicalControl == null)
    		{
    			_physicalControl = new RadioButton();
    			_physicalControl.label = "physical";
    			_physicalControl.styleName = "MapTypePhysical";
    			_physicalControl.group = group;
    			_physicalControl.value = MapType.PHYSICAL_MAP_TYPE;
    			
    			content.addChild(_physicalControl);
    		}
    	}
    	
    	//----------------------------------
    	//  satellite control
    	//----------------------------------
    	
    	private var _satelliteControl:RadioButton;
    	
    	private var _satelliteControlChanged:Boolean;
    	
    	protected function get satelliteControl():RadioButton
    	{
    		return _satelliteControl;
    	}
    	
    	protected function set satelliteControl(satelliteControl:RadioButton):void
    	{
    		if(_satelliteControl != satelliteControl)
    		{
    			_satelliteControl = satelliteControl;
    			_satelliteControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createSatelliteControl():void
    	{
    		if(_satelliteControl == null)
    		{
    			_satelliteControl = new RadioButton();
    			_satelliteControl.label = "satellite";
    			_satelliteControl.styleName = "MapTypeSatellite";
    			_satelliteControl.group = group;
    			_satelliteControl.value = MapType.SATELLITE_MAP_TYPE;
    			
    			content.addChild(_satelliteControl);
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Overriden proteceted methods
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
    			content.styleName = "MapTypeContent";
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
			
			createGroup();
			createNormalControl();
			createHybridControl();
			createPhysicalControl();
			createSatelliteControl();
			
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
    		
    		// update type
    		if(_typeChanged)
    		{
    			updateGroup();
    			
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