package controls.map.marker
{
	import controls.panel.YoEditableLocationPanel;
	import controls.panel.YoLocationPanel;
	import controls.panel.YoPanelState;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.core.UIComponent;
	
	/**
	 * Marker that can display location. 
	 */	
	public class YoLocationMarker extends YoMarker
	{
		/**
		 * Constructor. 
		 */		
		public function YoLocationMarker()
		{
			super();
			_common = true;
			_locationVisible = true;
			_editableLocationVisible = true;
			
			_locationState = YoPanelState.Expanded;
			_editableLocationState = YoPanelState.Expanded;
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  caption
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for caption property. 
		 */		
		private var _caption:String;
		
		/**
		 * @private
		 * Flag to indicate when _caption changes. 
		 */		
		private var _captionChanged:Boolean;
		
		/**
		 * Specifies location caption. 
		 */		
		public function get caption():String
		{
			return _caption;
		}
		
		/**
		 * Specifies location caption. 
		 */
		public function set caption(caption:String):void
		{
			if(_caption != caption)
			{
				_caption = caption;
				_captionChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  address
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for address property. 
		 */		
		private var _address:String;
		
		/**
		 * @private
		 * Flag to indicate when _address changes. 
		 */		
		private var _addressChanged:Boolean;
		
		/**
		 * Specifies location address. 
		 */		
		public function get address():String
		{
			return _address;
		}
		
		/**
		 * Specifies location address. 
		 */
		public function set address(address:String):void
		{
			if(_address != address)
			{
				_address = address;
				_addressChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  findAddress
    	//----------------------------------
		
		private var _findAddress:Boolean;
		
		private var _findAddressChanged:Boolean;
		
		public function get findAddress():Boolean
		{
			return _findAddress;
		}
		
		public function set findAddress(findAddress:Boolean):void
		{
			if(_findAddress != findAddress)
			{
				_findAddress = findAddress;
				_findAddressChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  description
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for description property. 
		 */		
		private var _description:String;
		
		/**
		 * @private
		 * Flag to indicate when _description changes. 
		 */		
		private var _descriptionChanged:Boolean;
		
		/**
		 * Specifies location description. 
		 */		
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * Specifies location description. 
		 */
		public function set description(description:String):void
		{
			if(_description != description)
			{
				_description = description;
				_descriptionChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  common
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for common property. 
		 */		
		private var _common:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _common changes. 
		 */		
		private var _commonChanged:Boolean;
		
		/**
		 * Specifies marker visibilty: true - public, false - private. 
		 */		
		public function get common():Boolean
		{
			return _common;
		}
		
		/**
		 * Specifies marker visibilty: true - public, false - private. 
		 */
		public function set common(common:Boolean):void
		{
			if(_common != common)
			{
				_common = common;
				_commonChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  tags
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for tags property. 
		 */		
		private var _tags:String;
		
		/**
		 * @private
		 * Flag to indicate whne _tags changes. 
		 */		
		private var _tagsChanged:Boolean;
		
		/**
		 * Specifies marker tags. 
		 */		
		public function get tags():String
		{
			return _tags;
		}
		
		/**
		 * Specifies marker tags. 
		 */
		public function set tags(tags:String):void
		{
			if(_tags != tags)
			{
				_tags = tags;
				_tagsChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  locationState
    	//----------------------------------
		
		private var _locationState:YoPanelState;
		
		private var _locationStateChanged:Boolean;
		
		public function get locationState():YoPanelState
		{
			return _locationState;
		}
		
		public function set locationState(locationState:YoPanelState):void
		{
			if(_locationState != locationState)
			{
				_locationState = locationState;
				_locationStateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  locationVisible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for locationVisible peoperty.  
		 */		
		private var _locationVisible:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _locationVisible changes. 
		 */				
		private var _locationVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of location panel. 
		 */		
		public function get locationVisible():Boolean
		{
			return _locationVisible;
		}
		
		/**
		 * Specifies visibility of location panel. 
		 */
		public function set locationVisible(locationVisible:Boolean):void
		{
			if(_locationVisible != locationVisible)
			{
				_locationVisible = locationVisible;
				_locationVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  editableLocationState
    	//----------------------------------
		
		private var _editableLocationState:YoPanelState;
		
		private var _editableLocationStateChanged:Boolean;
		
		public function get editableLocationState():YoPanelState
		{
			return _editableLocationState;
		}
		
		public function set editableLocationState(editableLocationState:YoPanelState):void
		{
			if(_editableLocationState != editableLocationState)
			{
				_editableLocationState = editableLocationState;
				_editableLocationStateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  editableLocationVisible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for editableLocationVisible property.
		 */		
		private var _editableLocationVisible:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _editableLocationVisible changes. 
		 */		
		private var _editableLocationVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of location panel on edit state. 
		 */		
		public function get editableLocationVisible():Boolean
		{
			return _editableLocationVisible;
		}
		
		/**
		 * Specifies visibility of location panel on edit state. 
		 */
		public function set editableLocationVisible(editableLocationVisible:Boolean):void
		{
			if(_editableLocationVisible != editableLocationVisible)
			{
				_editableLocationVisible = editableLocationVisible;
				_editableLocationVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  dragCrossVisible
    	//----------------------------------
		
		private var _dragCrossVisible:Boolean;
		
		private var _dragCrossVisibleChanged:Boolean;
		
		public function get dragCrossVisible():Boolean
		{
			return _dragCrossVisible;
		}
		
		public function set dragCrossVisible(dragCrossVisible:Boolean):void
		{
			if(_dragCrossVisible != dragCrossVisible)
			{
				_dragCrossVisible = dragCrossVisible;
				_dragCrossVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  findAddressVisible
    	//----------------------------------
		
		private var _findAddressVisible:Boolean;
		
		private var _findAddressVisibleChanged:Boolean;
		
		public function get findAddressVisible():Boolean
		{
			return _findAddressVisible;
		}
		
		public function set findAddressVisible(findAddressVisible:Boolean):void
		{
			if(_findAddressVisible != findAddressVisible)
			{
				_findAddressVisible = findAddressVisible;
				_findAddressVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  locationPanel
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for location panel component.   
		 */		
		private var _locationPanel:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _locationPanel changes. 
		 */		
		private var _locationPanelChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to display location information. 
		 */		
		protected function get locationPanel():UIComponent
		{
			return _locationPanel;
		}
		
		/**
		 * @protected
		 * Specifies component to display location information. 
		 */
		protected function set locationPanel(locationPanel:UIComponent):void
		{
			if(_locationPanel != locationPanel)
			{
				_locationPanel = locationPanel;
				_locationPanelChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates location panel component. 
		 */		
		protected function createLocationPanel():void
		{
			if(_locationPanel == null)
			{
				var locationPanel:YoLocationPanel = new YoLocationPanel();
				_locationPanel = locationPanel;
				_locationPanel.percentWidth = 100;
				contentFrame.addChild(_locationPanel);
			}
		}
		
		/**
		 * @protected
		 * Updates location panel component with new values. 
		 */		
		protected function updateLocation():void
		{
			var panel:YoLocationPanel = locationPanel as YoLocationPanel;
			
			if(panel != null)
			{
				panel.caption = caption;
				panel.address = address;
				panel.description = description;
				panel.common = common;
				panel.tags = tags;
				panel.state = locationState;
			}
		}
		
		//----------------------------------
    	//  editableLocationPanel
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for editableLocationPanel component. 
		 */		
		private var _editableLocationPanel:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _editableLocationPanel changes. 
		 */		
		private var _editableLocationPanelChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies to display location information in edit state. 
		 */		
		protected function get editableLocationPanel():UIComponent
		{
			return _editableLocationPanel;
		}
		
		/**
		 * @protected
		 * Specifies to display location information in edit state. 
		 */
		protected function set editableLocationPanel(editableLocationPanel:UIComponent):void
		{
			if(_editableLocationPanel != editableLocationPanel)
			{
				_editableLocationPanel = editableLocationPanel;
				_editableLocationPanelChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates editable location panel component. 
		 */		
		protected function createEditableLocationPanel():void
		{
			if(_editableLocationPanel == null)
			{
				var locationPanel:YoEditableLocationPanel = new YoEditableLocationPanel();
				
				locationPanel.addEventListener(
					"CaptionChanged",
					function(event:Event):void
					{
						caption = locationPanel.typedCaption;
					});
				
				locationPanel.addEventListener(
					"AddressChanged",
					function(event:Event):void
					{
						address = locationPanel.typedAddress;
					});
				
				locationPanel.addEventListener(
					"FindAddressChanged",
					function(event:Event):void
					{
						findAddress = locationPanel.typedFindAddress;
					});
				
				locationPanel.addEventListener(
					"DescriptionChanged",
					function(event:Event):void
					{
						description = locationPanel.typedDescription;
					});
				
				locationPanel.addEventListener(
					"CommonChanged",
					function(event:Event):void
					{
						common = locationPanel.typedCommon;
					});
					
				locationPanel.addEventListener(
					"TagsChanged",
					function(event:Event):void
					{
						tags = locationPanel.typedTags;
					});
				
				locationPanel.addEventListener(
					"crossMouseMove",
					function(event:MouseEvent):void
					{
						var e:MouseEvent = new MouseEvent("crossMouseMove");
						e.buttonDown = event.buttonDown;
						
						dispatchEvent(e);
					});
					
				_editableLocationPanel = locationPanel;
				_editableLocationPanel.percentWidth = 100;
				editFrame.addChild(_editableLocationPanel);
			}
		}
		
		/**
		 * @protected
		 * Updates location panel with new values. 
		 */		
		protected function updateEditableLocation():void
		{
			var panel:YoEditableLocationPanel = editableLocationPanel as YoEditableLocationPanel;
			
			if(panel != null)
			{
				panel.caption = caption;
				panel.address = address;
				panel.findAddress = findAddress;
				panel.findAddressVisible = findAddressVisible;
				panel.dragCrossVisible = dragCrossVisible;
				panel.description = description;
				panel.common = common;
				panel.tags = tags;
				panel.state = editableLocationState;
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Override protected methods
    	//
    	//--------------------------------------------------------------------------
		
		/**
    	 * @override
    	 * Create and add children. 
    	 */    	
    	protected override function createChildren():void
    	{
    		super.createChildren();	
    		createLocationPanel();
    		createEditableLocationPanel();
    	}
		
		/**
    	 * @override
		 * Creates frame to display in content state.
		 */
    	protected override function createContentFrame():void
    	{
    		if(contentFrame == null)
    		{
    			contentFrame = new VBox();
    			contentFrame.styleName = "YoLocationMarkerContent";
    			addChild(contentFrame);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Creates frame to display in edit state.
    	 */    	
    	protected override function createEditFrame():void
    	{
    		if(editFrame == null)
    		{
    			editFrame = new VBox();
    			editFrame.styleName = "YoLocationMarkerEdit";
    			addChild(editFrame);
    		}
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
    		
    		// update location
    		if(
    			_locationPanelChanged ||
    			_editableLocationPanelChanged ||
    			_captionChanged ||
    			_addressChanged ||
    			_findAddressChanged ||
    			_findAddressVisibleChanged ||
    			_dragCrossVisibleChanged ||
    			_descriptionChanged ||
    			_commonChanged ||
    			_tagsChanged ||
    			_locationVisibleChanged ||
    			_editableLocationVisibleChanged)
    		{
    			if(locationPanel != null)
    			{
    				updateLocation();
    			}
    			
    			if(locationPanel != null && contentFrame != null)
    			{
    				if(locationVisible)
    				{
    					if(!contentFrame.contains(locationPanel))
    					{
    						contentFrame.addChild(locationPanel);
    					}
    				}
    				else
    				{
    					if(contentFrame.contains(locationPanel))
    					{
    						contentFrame.removeChild(locationPanel);
    					}
    				}
    			}
    			
    			if(editableLocationPanel != null)
    			{
    				updateEditableLocation();
    			}
    			
    			if(editableLocationPanel != null && editFrame != null)
    			{
    				if(editableLocationVisible)
    				{
    					if(!editFrame.contains(editableLocationPanel))
    					{
    						editFrame.addChild(editableLocationPanel);
    					}
    				}
    				else
    				{
    					if(editFrame.contains(editableLocationPanel))
    					{
    						editFrame.removeChild(editableLocationPanel);
    					}
    				}
    			}
    			
    			_locationPanelChanged = false;
    			_captionChanged = false;
    			_addressChanged = false;
    			_findAddressChanged = false;
    			_findAddressVisibleChanged = false;
    			_dragCrossVisibleChanged = false;
    			_descriptionChanged = false;
    			_commonChanged = false;
    			_tagsChanged = false;
    			_locationVisibleChanged = false;
    			_editableLocationVisibleChanged = false;
    			
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