package controls.map.controls
{
	import controls.panel.YoPanel;
	
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.CheckBox;
	import mx.core.UIComponent;

	public class YoTagFilterControl extends YoPanel
	{
		public function YoTagFilterControl()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Proerties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  tags filter enabled
    	//----------------------------------
    	
    	private var _tagsEnabled:Boolean;
    	
    	private var _tagsEnabledChanged:Boolean;
    	
    	public function get tagsEnabled():Boolean
    	{
    		return _tagsEnabled;
    	}
    	
    	public function set tagsEnabled(tagsEnabled:Boolean):void
    	{
    		if(_tagsEnabled != tagsEnabled)
    		{
    			_tagsEnabled = tagsEnabled;
    			_tagsEnabledChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  tag
    	//----------------------------------
    	
    	private var _tag:String;
    	
    	private var _tagChanged:Boolean;
    	
    	public function get tag():String
    	{
    		return _tag;
    	}
    	
    	public function set tag(tag:String):void
    	{
    		if(_tag != tag)
    		{
    			_tag = tag;
    			_tagChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  tags filter enabled
    	//----------------------------------
    	
    	private var _tagsEnabledControl:UIComponent;
    	
    	private var _tagsEnabledControlChanged:Boolean;
    	
    	protected function get tagsEnabledControl():UIComponent
    	{
    		return _tagsEnabledControl;
    	}
    	
    	protected function set tagsEnabledControl(tagsEnabledControl:UIComponent):void
    	{
    		if(_tagsEnabledControl != tagsEnabledControl)
    		{
    			_tagsEnabledControl = tagsEnabledControl;
    			_tagsEnabledControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createTagsEnabledControl():void
    	{
    		var box:CheckBox = new CheckBox();
    			box.label = "enabled";
    			box.labelPlacement = ButtonLabelPlacement.RIGHT;
    			box.percentWidth = 100;
    			box.styleName = "TagFilterEnabled";
    			
    			_tagsEnabledControl = box;
    			content.addChild(_tagsEnabledControl);
    			
				_tagsEnabledControl.addEventListener(
					Event.CHANGE,
					function(event:Event):void
					{
						_tagsEnabled = !_tagsEnabled;
						dispatchEvent(new Event("tagsEnabledChanged"));
					});
    	}
    	
    	protected function updateTagsEnabled():void
    	{
    		var box:CheckBox = tagsEnabledControl as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = tagsEnabled;
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Overriden protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	protected override function createChildren():void
    	{
    		super.createChildren();
    		
    		createTagsEnabledControl();
    		
    		substrate.styleName = "YoPanelSubstrate";
    	}
    	
    	protected override function createContent():void
    	{
    		if(content == null)
    		{
    			content = new VBox();
    			content.styleName = "TagFilterContent";
    			addChild(content);
    		}
    	}
    	
    	protected override function commitProperties():void
    	{
    		super.commitProperties();
    		
    		var needInvalidateSize:Boolean = false;
    		var needInvalidateDisplayList:Boolean = false;
    		
    		// update tags enabled
    		if(_tagsEnabledChanged || _tagsEnabledControlChanged)
    		{
    			updateTagsEnabled();
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