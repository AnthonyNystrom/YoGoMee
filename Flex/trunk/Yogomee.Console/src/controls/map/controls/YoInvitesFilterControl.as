package controls.map.controls
{
	import controls.panel.YoPanel;
	
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.CheckBox;
	import mx.core.UIComponent;

	/**
	 * Represents component to display invitations filter. 
	 */	
	public class YoInvitesFilterControl extends YoPanel
	{
		/**
		 * Constructor 
		 */		
		public function YoInvitesFilterControl()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Proerties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  friends visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for friendsVisible property. 
    	 */    	
    	private var _friendsVisible:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _friendsVisible changes. 
    	 */    	
    	private var _friendsVisibleChanged:Boolean;
    	
    	/**
    	 * Specifies visibility of friends invites. 
    	 */    	
    	public function get friendsVisible():Boolean
    	{
    		return _friendsVisible;
    	}
    	
    	/**
    	 * Specifies visibility of friends invites. 
    	 */
    	public function set friendsVisible(friendsVisible:Boolean):void
    	{
    		if(_friendsVisible != friendsVisible)
    		{
    			_friendsVisible = friendsVisible;
    			_friendsVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  events visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for eventsVisible property. 
    	 */    	
    	private var _eventsVisible:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _eventsVisible changes.  
    	 */    	
    	private var _eventsVisibleChanged:Boolean;
    	
    	/**
    	 * Specifies visibility of events invites. 
    	 */    	
    	public function get eventsVisible():Boolean
    	{
    		return _eventsVisible;
    	}
    	
    	/**
    	 * Specifies visibility of events invites. 
    	 */
    	public function set eventsVisible(eventsVisible:Boolean):void
    	{
    		if(_eventsVisible != eventsVisible)
    		{
    			_eventsVisible = eventsVisible;
    			_eventsVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  friends visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for friendsVisibleControl component. 
    	 */    	
    	private var _friendsVisibleControl:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _friendsVisibleControl changes. 
    	 */    	
    	private var _friendsVisibleControlChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display friendsVisible property. 
    	 */    	
    	protected function get friendsVisibleControl():UIComponent
    	{
    		return _friendsVisibleControl;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display friendsVisible property. 
    	 */
    	protected function set friendsVisibleControl(friendsVisibleControl:UIComponent):void
    	{
    		if(_friendsVisibleControl != friendsVisibleControl)
    		{
    			_friendsVisibleControl = friendsVisibleControl;
    			_friendsVisibleControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates friendsVisibleControl component. 
    	 */    	
    	protected function createFriendsVisibleControl():void
    	{
    		if(_friendsVisibleControl == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.label = "friends";
    			box.labelPlacement = ButtonLabelPlacement.RIGHT;
    			box.percentWidth = 100;
    			box.styleName = "InvitesFilterFriends";
    			
    			_friendsVisibleControl = box;
    			content.addChild(_friendsVisibleControl);
    			
				_friendsVisibleControl.addEventListener(
					Event.CHANGE,
					function(event:Event):void
					{
						_friendsVisible = !_friendsVisible;
						dispatchEvent(new Event("friendsVisibleChanged"));
					});
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Updates friendsVisibleComponent with new value. 
    	 */    	
    	protected function updateFriendsVisible():void
    	{
    		var box:CheckBox = friendsVisibleControl as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = friendsVisible;
    		}
    	}
    	
    	//----------------------------------
    	//  events visible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for eventsVisibleComtrol component. 
    	 */    	
    	private var _eventsVisibleControl:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _eventsVisibleControl changes. 
    	 */    	
    	private var _eventsVisibleControlChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display feventsVisble property. 
    	 */    	
    	protected function get eventsVisibleControl():UIComponent
    	{
    		return _eventsVisibleControl;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display feventsVisble property. 
    	 */
    	protected function set eventsVisibleControl(eventsVisibleControl:UIComponent):void
    	{
    		if(_eventsVisibleControl != eventsVisibleControl)
    		{
    			_eventsVisibleControl = eventsVisibleControl;
    			_eventsVisibleControlChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates eventsVisibleControl component. 
    	 */    	
    	protected function createEventsVisbleControl():void
    	{
    		if(_eventsVisibleControl == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.label = "events";
    			box.labelPlacement = ButtonLabelPlacement.RIGHT;
    			box.percentWidth = 100;
    			box.styleName = "InvitesFilterEvents";
    			
    			_eventsVisibleControl = box;
    			content.addChild(_eventsVisibleControl);
    			
				_eventsVisibleControl.addEventListener(
					Event.CHANGE,
					function(event:Event):void
					{
						_eventsVisible = !_eventsVisible;
						dispatchEvent(new Event("eventsVisibleChanged"));
					});
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates eventsVisibleControl with new value.
    	 */    	
    	protected function updateEventsVisible():void
    	{
    		var box:CheckBox = eventsVisibleControl as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = eventsVisible;
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
    			content.styleName = "InvitesFilterContent";
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
    		
    		createFriendsVisibleControl();
    		createEventsVisbleControl();
    		
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
    		
    		// update friends visible
    		if(_friendsVisibleChanged || _friendsVisibleControlChanged)
    		{
    			updateFriendsVisible();
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update events visible
    		if(_eventsVisibleChanged || _eventsVisibleControlChanged)
    		{
    			updateEventsVisible();
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