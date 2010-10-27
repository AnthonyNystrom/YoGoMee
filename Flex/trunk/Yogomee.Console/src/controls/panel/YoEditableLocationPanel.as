package controls.panel
{
	import controls.text.YoTagsInput;
	import controls.text.YoTextArea;
	import controls.text.YoTextInput;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.CheckBox;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	/**
	 * Represents panel that allow to edit locations. 
	 */	
	public class YoEditableLocationPanel extends YoLocationPanel
	{
		/**
		 * Constructor. 
		 */		
		public function YoEditableLocationPanel()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Proerties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  typedCaption
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for _typedCaption property. 
		 */		
		private var _typedCaption:String;
		
		/**
		 * Specifies new caption typed by user. 
		 */		
		public function get typedCaption():String
		{
			return _typedCaption;
		}
		
		/**
		 * @protected
		 * Specifies new caption typed by user. 
		 */		
		protected function set newCaption(newCaption:String):void
		{
			if(_typedCaption != newCaption)
			{
				_typedCaption = newCaption;
				dispatchEvent(new Event("CaptionChanged"));
			}
		}
		
		/**
		 * @override
		 */		
		public override function set caption(caption:String):void
		{
			super.caption = caption;
			_typedCaption = caption;
		}
		
		//----------------------------------
    	//  typedAddress
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedAddress property. 
		 */		
		private var _typedAddress:String;
		
		/**
		 * Specifies new address typed by user. 
		 */		
		public function get typedAddress():String
		{
			return _typedAddress;
		}
		
		/**
		 * @protected
		 * Specifies new address typed by user. 
		 */
		protected function set newAddress(newAddress:String):void
		{
			if(_typedAddress != newAddress)
			{
				_typedAddress = newAddress;
				dispatchEvent(new Event("AddressChanged"));
			}	
		}
		
		/**
		 * @override 
		 */		
		public override function set address(address:String):void
		{
			super.address = address;
			_typedAddress = address;
		}
		
		//----------------------------------
    	//  typedDescription
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedDescription property. 
		 */		
		private var _typedDescription:String;
		
		/**
		 * Specifies new description typed by user. 
		 */		
		public function get typedDescription():String
		{
			return _typedDescription;
		}
		
		/**
		 * @protected
		 * Specifies new description typed by user. 
		 */
		protected function set newDescription(newDescription:String):void
		{
			if(_typedDescription != newDescription)
			{
				_typedDescription = newDescription;
				dispatchEvent(new Event("DescriptionChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set description(description:String):void
		{
			super.description = description;
			_typedDescription = description;
		}
		
		//----------------------------------
    	//  typedCommon
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedCommon property. 
		 */		
		private var _typedCommon:Boolean;
		
		/**
		 * Specifies new common typed by user. 
		 */		
		public function get typedCommon():Boolean
		{
			return _typedCommon;
		}
		
		/**
		 * @protected
		 * Specifies new common typed by user. 
		 */
		protected function set newCommon(newCommon:Boolean):void
		{
			if(_typedCommon != newCommon)
			{
				_typedCommon = newCommon;
				dispatchEvent(new Event("CommonChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set common(common:Boolean):void
		{
			super.common = common;
			_typedCommon = common;
		}
		
		//----------------------------------
    	//  typedTags
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedTags property. 
		 */		
		private var _typedTags:String;
		
		/**
		 * Specifies new tags typed by user. 
		 */		
		public function get typedTags():String
		{
			return _typedTags;
		}
		
		/**
		 * @protected
		 * Specifies new tags typed by user. 
		 */
		protected function set newTags(newTags:String):void
		{
			if(_typedTags != newTags)
			{
				_typedTags = newTags;
				dispatchEvent(new Event("TagsChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set tags(tags:String):void
		{
			super.tags = tags;
			_typedTags = tags;
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
				_typedFindAddress = findAddress;
				
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  typedFindAddress
    	//----------------------------------
		
		private var _typedFindAddress:Boolean;
		
		public function get typedFindAddress():Boolean
		{
			return _typedFindAddress;
		}
		
		protected function set newFindAddress(newFindAddress:Boolean):void
		{
			if(_typedFindAddress != newFindAddress)
			{
				_typedFindAddress = newFindAddress;
				dispatchEvent(new Event("FindAddressChanged"));
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
    	//  caption
    	//----------------------------------
		
		/**
		 * @override
		 * Creates caption text component. 
		 */		
		protected override function createCaptionText():void
		{
			if(captionText == null)
			{
				var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Caption";
    			label.styleName = "YoEditableLocationPanelCaptionLabel";
    			label.width = 80;
    			
    			captionText = new YoTextInput();
    			captionText.styleName = "YoEditableLocationPanelCaption";
    			captionText.percentWidth = 100;
    			
    			captionText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTextInput = captionText as YoTextInput;
    					
    					if(text != null)
    					{
    						newCaption = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(captionText);
    			
    			content.addChild(box);
			}
		}
		
		/**
		 * @override 
		 * Updates caption component with new value.
		 */		
		protected override function updateCaption():void
		{
			var text:YoTextInput = captionText as YoTextInput;
			
			if(text != null)
			{
				text.text = caption;
			}
		}
		
		//----------------------------------
    	//  address
    	//----------------------------------
		
		/**
		 * @override 
		 * Creates address text component.
		 */		
		protected override function createAddressText():void
		{
			if(addressText == null)
			{
				var box:HBox = new HBox();
				box.percentWidth = 100;
				
				var label:Text = new Text();
				label.text = "Address";
				label.styleName = "YoEditableLocationPanelAddressLabel";
				label.width = 80;
				
				addressText = new YoTextInput();
				addressText.styleName = "YoEditableLocationPanelAddress";
				addressText.percentWidth = 100;
				
				addressText.addEventListener(
					Event.CHANGE,
					function(event:Event):void
					{
						var text:YoTextInput = addressText as YoTextInput;
						
						if(text != null)
						{
							newAddress = text.text;
						}
					});
				
				box.addChild(label);
				box.addChild(addressText);
				
				content.addChild(box);
			}
		}
		
		/**
		 * @override 
		 * Updates address component with new value.
		 */		
		protected override function updateAddress():void
		{
			var text:YoTextInput = addressText as YoTextInput;
			
			if(text != null)
			{
				text.text = address;
			}
		}
		
		//----------------------------------
    	//  dragCross
    	//----------------------------------
		
		private var _dragCross:UIComponent;
		
		private var _dragCrossCanged:Boolean;
		
		protected function get dragCross():UIComponent
		{
			return _dragCross;
		}
		
		protected function set dragCross(dragCross:UIComponent):void
		{
			if(_dragCross != dragCross)
			{
				_dragCross = dragCross;
				_dragCrossCanged = true;
				invalidateProperties();
			}
		} 
		
		protected function createDragCross():void
		{
			if(_dragCross == null)
			{
				var image:Image = new Image();
				image.source = "resources/cross.png";
				image.mouseChildren = false;
				image.useHandCursor = true;
				image.buttonMode = true;
				
				image.addEventListener(
					MouseEvent.MOUSE_MOVE,
					function(event:MouseEvent):void
					{
						var e:MouseEvent = new MouseEvent("crossMouseMove");
						e.buttonDown = event.buttonDown;
						
						dispatchEvent(e);
					});
				
				_dragCross = image;
				
				if(dragCrossVisible)
				{
					addressText.parent.getChildAt(0).width = 52;
					addressText.parent.addChildAt(_dragCross, 0);
				}
			}
		}
		
		//----------------------------------
    	//  findAddress
    	//----------------------------------
		
		private var _findAddressBox:UIComponent;
		
		private var _findAddressBoxChanged:Boolean;
		
		protected function get findAddressBox():UIComponent
		{
			return _findAddressBox;
		}
		
		protected function set findAddressBox(findAddressBox:UIComponent):void
		{
			_findAddressBox = findAddressBox;
			_findAddressBoxChanged = true;
			invalidateProperties();
		}
		
		protected function createFindAddressBox():void
		{
			if(findAddressBox == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.styleName = "YoEditableLocationPanelFindAddress";
    			box.label = "Find address by location";
    			box.labelPlacement = ButtonLabelPlacement.LEFT;
    			box.percentWidth = 100;
    			
    			box.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					newFindAddress = box.selected;
    				});
    			
    			findAddressBox = box;
    			
    			if(findAddressVisible)
    			{
    				content.addChildAt(findAddressBox, 2);
    			}
    		}
		}
		
		protected function updateFindAddress():void
		{
			var box:CheckBox = findAddressBox as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = findAddress;
    		}
		}
		
		//----------------------------------
    	//  description
    	//----------------------------------
    	
    	/**
    	 * @override
    	 * Creates description text component. 
    	 */    	
    	protected override function createDescriptionText():void
    	{
    		if(descriptionText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Description";
    			label.styleName = "YoEditableLocationPanelDescriptionLabel";
    			label.width = 80;
    			
    			descriptionText = new YoTextArea();
    			descriptionText.styleName = "YoEditableLocationPanelDescription";
    			descriptionText.percentWidth = 100;
    			
    			descriptionText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTextArea = descriptionText as YoTextArea;
    					
    					if(text != null)
    					{
    						newDescription = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(descriptionText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Updates description component with new value.
    	 */    	
    	protected override function updateDescription():void
    	{
    		var text:YoTextArea = descriptionText as YoTextArea;
    		
    		if(text != null)
    		{
    			text.text = description;
    		}
    	}
    	
    	//----------------------------------
    	//  common
    	//----------------------------------
    	
    	/**
    	 * @override 
    	 * Creates commonText component.
    	 */    	
    	protected override function createCommonText():void
    	{
    		if(commonText == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.styleName = "YoEditableLocationPanelCommon";
    			box.label = "Make this gomee public";
    			box.labelPlacement = ButtonLabelPlacement.LEFT;
    			box.percentWidth = 100;
    			
    			box.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					newCommon = box.selected;
    				});
    			
    			commonText = box;
    			content.addChild(commonText);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Updates commonText component with new value.
    	 */    	
    	protected override function updateCommon():void
    	{
    		var box:CheckBox = commonText as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = common;
    		}
    	}
    	
    	//----------------------------------
    	//  tags
    	//----------------------------------
    	
    	/**
    	 * @protected
    	 * Creates tagsText component. 
    	 */
    	protected override function createTagsText():void
    	{
    		if(tagsText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Tags";
    			label.styleName = "YoEditableLocationPanelTagsLabel";
    			label.width = 80;
    			
    			tagsText = new YoTagsInput();
    			tagsText.styleName = "YoEditableLocationPanelTags";
    			tagsText.percentWidth = 100;
    			
    			tagsText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTagsInput = tagsText as YoTagsInput;
    					
    					if(text != null)
    					{
    						newTags = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(tagsText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	/**
    	 * @override
    	 * Updates tagsText component with new value. 
    	 */    	
    	protected override function updateTags():void
    	{
    		var text:YoTagsInput = tagsText as YoTagsInput;
    		
    		if(text != null)
    		{
    			text.typedText = tags;
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Overriden protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	/**
    	 * @override
    	 * Creates content component.  
    	 */    	
    	protected override function createContent():void
    	{
    		super.createContent();
    		content.styleName = "YoEditableLocationPanelContent";
    	}
    	
    	protected override function createChildren():void
    	{
    		super.createChildren();
    		
    		createDragCross();
    		createFindAddressBox();
    	}
    	
    	protected override function commitProperties():void
    	{
    		super.commitProperties();
    		
    		var needInvalidateSize:Boolean = false;
    		var needInvalidateDisplayList:Boolean = false;
    		
    		if(_dragCrossVisibleChanged)
    		{
    			if(dragCrossVisible)
    			{
    				if(!addressText.parent.contains(dragCross))
    				{
    					addressText.parent.getChildAt(0).width = 52;
						addressText.parent.addChildAt(_dragCross, 0);
    				}
    			}
    			else
    			{
    				if(addressText.parent.contains(dragCross))
    				{
    					addressText.parent.removeChild(dragCross);
    					addressText.parent.getChildAt(0).width = 80;
    				}
    			}
    			
    			_dragCrossVisibleChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		if(_findAddressVisibleChanged)
    		{
    			if(findAddressVisible)
    			{
    				if(!content.contains(findAddressBox))
    				{
    					content.addChildAt(findAddressBox, 2);
    				}
    			}
    			else
    			{
    				if(content.contains(findAddressBox))
    				{
    					content.removeChild(findAddressBox);
    				}
    			}
    			
    			_findAddressVisibleChanged = true;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		if(_findAddressChanged)
    		{
    			updateFindAddress();
    			
    			_findAddressChanged = false;
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