package controls.panel
{
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.core.UIComponent;

	/**
	 * Component to display target. 
	 */	
	public class YoTarget extends UIComponent
	{
		/**
		 * Constructor. 
		 */		
		public function YoTarget()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  owner
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for owner property. 
		 */		
		private var _owner:String;
		
		/**
		 * @private
		 * Flag to indicate when _owner changes. 
		 */		
		private var _ownerChanged:Boolean;
		
		/**
		 * Specifies target owner. 
		 */		
		public function get owner():String
		{
			return _owner;
		}
		
		/**
		 * Specifies target owner. 
		 */
		public function set owner(owner:String):void
		{
			if(_owner != owner)
			{
				_owner = owner;
				_ownerChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  creator
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for creator property. 
    	 */    	
    	private var _creator:String;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _creator changes. 
    	 */    	
    	private var _creatorChanged:Boolean;
    	
    	/**
    	 * Specifies target creator. 
    	 */    	
    	public function get creator():String
    	{
    		return _creator;
    	}
    	
    	/**
    	 * Specifies target creator. 
    	 */
    	public function set creator(creator:String):void
    	{
    		if(_creator != creator)
    		{
    			_creator = creator;
    			_creatorChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  type
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for type property. 
    	 */    	
    	private var _type:int;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _type changes. 
    	 */    	
    	private var _typeChanged:Boolean;
    	
    	/**
    	 * Specifies target type. 
    	 */    	
    	public function get type():int
    	{
    		return _type;
    	}
    	
    	/**
    	 * Specifies target type. 
    	 */
    	public function set type(type:int):void
    	{
    		if(_type != type)
    		{
    			_type = type;
    			_typeChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  text
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for text property. 
    	 */    	
    	private var _text:String;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _text changes. 
    	 */    	
    	private var _textChanged:Boolean;
    	
    	/**
    	 * Specifies targets text. 
    	 */    	
    	public function get text():String
    	{
    		return _text;
    	}
    	
    	/**
    	 * Specifies targets text. 
    	 */
    	public function set text(text:String):void
    	{
    		if(_text != text)
    		{
    			_text = text;
    			_textChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  content
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for content component. 
    	 */    	
    	private var _content:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _content changes. 
    	 */    	
    	private var _contentChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies content component. 
    	 */    	
    	protected function get content():UIComponent
    	{
    		return _content;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies content component. 
    	 */
    	protected function set content(content:UIComponent):void
    	{
    		if(_content != content)
    		{
    			_content = content;
    			_contentChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates content component. 
    	 */    	
    	protected function createContent():void
    	{
    		if(_content == null)
    		{
    			_content = new VBox();
    			addChild(_content);
    		}
    	}
    	
    	//----------------------------------
    	//  owner
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for ownerText component. 
    	 */    	
    	private var _ownerText:UIComponent;
    	
    	/**
    	 * @peivate
    	 * Flag to indicate when _owherText changes.
    	 */    	
    	private var _ownerTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display owner property.
    	 */    	
    	protected function get ownerText():UIComponent
    	{
    		return _ownerText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display owner property.
    	 */
    	protected function set ownerText(ownerText:UIComponent):void
    	{
    		if(_ownerText != ownerText)
    		{
    			_ownerText = ownerText;
    			_ownerTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates ownerText component. 
    	 */    	
    	protected function createOwnerText():void
    	{
    		if(_ownerText == null)
    		{
    			_ownerText = new Text();
    			addChild(_ownerText);
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Updates ownerText component with new value. 
    	 */    	
    	protected function updateOwner():void
    	{
    		var text:Text = ownerText as Text;
    		
    		if(text != null)
    		{
    			text.text = owner;
    		}
    	}
    	
    	//----------------------------------
    	//  creator
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for creatorText component. 
    	 */    	
    	private var _creatorText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _creatorText changes. 
    	 */    	
    	private var _creatorTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display creator property. 
    	 */    	
    	protected function get creatorText():UIComponent
    	{
    		return _creatorText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display creator property. 
    	 */
    	protected function set creatorText(creatorText:UIComponent):void
    	{
    		if(_creatorText != creatorText)
    		{
    			_creatorText = creatorText;
    			_creatorTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates creatorText component. 
    	 */    	
    	protected function createCreatorText():void
    	{
    		if(_creatorText == null)
    		{
    			_creatorText = new Text();
    			addChild(_creatorText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates creatorText component with new value.
    	 */    	
    	protected function updateCreatorText():void
    	{
    		var text:Text = creatorText as Text;
    		
    		if(text != null)
    		{
    			text.text = creator;
    		}
    	}
    	
    	//----------------------------------
    	//  type
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for typeText component. 
    	 */    	
    	private var _typeText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _typeText changes. 
    	 */    	
    	private var _typeTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display type property.  
    	 */    	
    	protected function get typeText():UIComponent
    	{
    		return _typeText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display type property.  
    	 */
    	protected function set typeText(typeText:UIComponent):void
    	{
    		if(_typeText != typeText)
    		{
    			_typeText = typeText;
    			_typeTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates typeText component.
    	 */    	
    	protected function createTypeText():void
    	{
    		if(_typeText == null)
    		{
    			_typeText = new Text();
    			content.addChild(_typeText);
    		}
    	}
    	
    	/**
    	 * @private
    	 * Update typeText component with new value. 
    	 */    	
    	protected function updateType():void
    	{
    	
    	}
    	
    	//----------------------------------
    	//  text
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for textText component. 
    	 */    	
    	private var _textText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _textText changes. 
    	 */    	
    	private var _textTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display text property. 
    	 */    	
    	protected function get textText():UIComponent
    	{
    		return _textText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display text property. 
    	 */
    	protected function set textText(textText:UIComponent):void
    	{
    		if(_textText != textText)
    		{
    			_textText = textText;
    			_textTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates textText component. 
    	 */    	
    	protected function createTextText():void
    	{
    		if(_textText == null)
    		{
    			_textText = new Text();
    			content.addChild(_textText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates textText component with new value.
    	 */    	
    	protected function updateText():void
    	{
    		var text:Text = textText as Text;
    		
    		if(text != null)
    		{
    			text.text = this.text;
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
    		
    		createContent();
    		
    		createOwnerText();
    		createCreatorText();
    		createTypeText();
    		createTextText();
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
    		
    		// update owner
    		if(_ownerChanged || _ownerTextChanged)
    		{
    			if(ownerText != null)
    			{
    				updateOwner();
    			}
    			
    			_ownerChanged = false;
    			_ownerTextChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update creator
    		if(_creatorChanged || _creatorTextChanged)
    		{
    			if(creatorText != null)
    			{
    				updateCreator();
    			}
    			
    			_creatorChanged = false;
    			_creatorTextChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update type
    		if(_typeChanged || _typeTextChanged)
    		{
    			if(typeText != null)
    			{
    				updateType();
    			}
    			
    			_typeChanged = false;
    			_typeTextChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update text
    		if(_textChanged || _textTextChanged)
    		{
    			if(textText != null)
    			{
    				updateText();
    			}
    			
    			_textChanged = false;
    			_textTextChanged = false;
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
    	 * Draws component. 
    	 */    	
    	protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    	{
    		super.updateDisplayList(unscaledWidth, unscaledHeight);
    		
    		if(content != null)
    		{
    			content.move(0, 0);
    			content.setActualSize(unscaledWidth, unscaledHeight);
    		}
    	}
    	
    	/**
    	 * @override
    	 * Calculates default component size. 
    	 */    	
    	protected override function measure():void
    	{
    		super.measure();
    		
    		measuredWidth = content.measuredWidth;
    		measuredHeight = content.measuredHeight;
    	}
	}
}