package controls.panel
{
	import controls.text.YoTags;
	
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	/**
	 * Represents panel with location informayion. 
	 */	
	public class YoLocationPanel extends YoPanel
	{
		/**
		 * Constructor. 
		 */		
		public function YoLocationPanel()
		{
			super();
			common = true;
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
		 * Represents location caption. 
		 */		
		public function get caption():String
		{
			return _caption;
		}
		
		/**
		 * Represents location caption. 
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
    	 * Flag to indicate when _addresc changes. 
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
    	 * Specifies location visibility: true - public, false - private. 
    	 */    	
    	public function get common():Boolean
    	{
    		return _common;
    	}
    	
    	/**
    	 * Specifies location visibility: true - public, false - private. 
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
    	 * Flag to indicate when _tags changed. 
    	 */    	
    	private var _tagsChanged:Boolean;
    	
    	public function get tags():String
    	{
    		return _tags;
    	}
    	
    	public function set tags(tags:String):void
    	{
    		if(_tags != tags)
    		{
    			_tags = tags;
    			_tagsChanged = true;
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
    	 * @private
    	 * Storage for caption component. 
    	 */    	
    	private var _captionText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _captionText changes. 
    	 */    	
    	private var _captionTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component that display caption. 
    	 */    	
    	protected function get captionText():UIComponent
    	{
    		return _captionText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component that display caption. 
    	 */
    	protected function set captionText(captionText:UIComponent):void
    	{
    		if(_captionText != captionText)
    		{
    			_captionText = captionText;
    			_captionTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates caption component. 
    	 */    	
    	protected function createCaptionText():void
    	{
    		if(_captionText == null)
    		{
    			_captionText = new Text();
    			_captionText.styleName = "YoLocationPanelCaption";
    			content.addChild(_captionText);
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Updates caption component with new value. 
    	 */    	
    	protected function updateCaption():void
    	{
    		var text:Text = captionText as Text;
    		
    		if(text != null)
    		{
    			text.text = caption;
    		}
    	}
    	
    	//----------------------------------
    	//  address
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for address component. 
    	 */    	
    	private var _addressText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _addressTextChanges. 
    	 */    	
    	private var _addressTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display address. 
    	 */    	
    	protected function get addressText():UIComponent
    	{
    		return _addressText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display address. 
    	 */
    	protected function set addressText(addressText:UIComponent):void
    	{
    		if(_addressText != addressText)
    		{
    			_addressText = addressText;
    			_addressTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates address component. 
    	 */    	
    	protected function createAddressText():void
    	{
    		if(_addressText == null)
    		{
    			_addressText = new Text();
    			_addressText.styleName = "YoLocationPanelAddress";
    			content.addChild(_addressText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates address componenet with new value.
    	 */    	
    	protected function updateAddress():void
    	{
    		var text:Text = addressText as Text;
    		
    		if(text != null)
    		{
    			text.text = address;
    		}
    	}
    	
    	//----------------------------------
    	//  description
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for description component. 
    	 */    	
    	private var _descriptionText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _descriptionText changes. 
    	 */    	
    	private var _descriptionTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component that displays description. 
    	 */    	
    	protected function get descriptionText():UIComponent
    	{
    		return _descriptionText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component that displays description. 
    	 */
    	protected function set descriptionText(descriptionText:UIComponent):void
    	{
    		if(_descriptionText != descriptionText)
    		{
    			_descriptionText = descriptionText;
    			_descriptionTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates description component. 
    	 */    	
    	protected function createDescriptionText():void
    	{
    		if(_descriptionText == null)
    		{
    			_descriptionText = new Text();
    			_descriptionText.styleName = "YoLocationPanelDescription";
    			content.addChild(_descriptionText);
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Updates description componenet with new value.
    	 */    	
    	protected function updateDescription():void
    	{
    		var text:Text = descriptionText as Text;
    		
    		if(text != null)
    		{
    			text.text = description;
    		}
    	}
    	
    	//----------------------------------
    	//  common
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for commonText component. 
    	 */    	
    	private var _commonText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _commonText changes. 
    	 */    	
    	private var _commonTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display common property. 
    	 */    	
    	protected function get commonText():UIComponent
    	{
    		return _commonText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display common property. 
    	 */
    	protected function set commonText(commonText:UIComponent):void
    	{
    		if(_commonText != commonText)
    		{
    			_commonText = commonText;
    			_commonTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates commonText component.
    	 */    	
    	protected function createCommonText():void
    	{
    		if(_commonText == null)
    		{
    			var text:Text = new Text();
    			text.styleName = "YoLocationPanelCommon";
    			_commonText = text;
    			content.addChild(_commonText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates commonText component with new value.
    	 */    	
    	protected function updateCommon():void
    	{
    		var text:Text = commonText as Text;
    		
    		if(text != null)
    		{
    			if(common)
    			{
    				text.text = "It`s a public gomee.";
    			}
    			else
    			{
    				text.text = "It`s a private gomee.";
    			}
    		}
    	}
    	
    	//----------------------------------
    	//  tags
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for tagsText component. 
    	 */    	
    	private var _tagsText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _tagsText changes. 
    	 */    	
    	private var _tagsTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display tags 
    	 */    	
    	protected function get tagsText():UIComponent
    	{
    		return _tagsText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display tags 
    	 */
    	protected function set tagsText(tagsText:UIComponent):void
    	{
    		if(_tagsText != tagsText)
    		{
    			_tagsText = tagsText;
    			_tagsTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates tagsText component. 
    	 */    	
    	protected function createTagsText():void
    	{
    		if(tagsText == null)
    		{
    			tagsText = new YoTags();
    			content.addChild(tagsText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates tagsText component with new values.
    	 */    	
    	protected function updateTags():void
    	{
    		var t:YoTags = tagsText as YoTags;
    		
    		if(t != null)
    		{
    			t.tags = tags;
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Override protected methods
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
    			content.styleName = "YoLocationPanelContent";
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
			
			createCaptionText();
			createAddressText();
			createDescriptionText();
			createCommonText();
			createTagsText();
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
    		
    		// update caption
    		if(_captionChanged || _captionTextChanged)
    		{
    			if(captionText != null)
    			{
    				updateCaption();
    			}
    			
    			_captionChanged = false;
    			_captionTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update address
    		if(_addressChanged || _addressTextChanged)
    		{
    			if(addressText != null)
    			{
    				updateAddress();
    			}
    			
    			_addressChanged = false;
    			_addressTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update description
    		if(_descriptionChanged || _descriptionTextChanged)
    		{
    			if(descriptionText != null)
    			{
    				updateDescription();
    			}
    			
    			_descriptionChanged = false;
    			_descriptionTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update common
    		if(_commonChanged || _commonTextChanged)
    		{
    			if(commonText != null)
    			{
    				updateCommon();
    			}
    			
    			_commonChanged = false;
    			_commonTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update tags
    		if(_tagsChanged || _tagsTextChanged)
    		{
    			if(tagsText != null)
    			{
    				updateTags();
    			}
    			
    			_tagsChanged = false;
    			_tagsTextChanged = false;
    			
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