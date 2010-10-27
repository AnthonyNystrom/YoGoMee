package controls.panel
{
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	/**
	 * Represents panel that displays twitter information. 
	 */	
	public class YoTwitterPanel extends YoPanel
	{
		/**
		 * Constructor. 
		 */		
		public function YoTwitterPanel()
		{
			super();
			updateOnAddGomee = true;
			updateOnSaveGomee = true;
			updateOnDeleteGomee = false;
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  login
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for login property. 
		 */		
		private var _login:String;
		
		/**
		 * @private
		 * Flag to indicate when _login changes. 
		 */		
		private var _loginChanged:Boolean;
		
		/**
		 * Specifies twitter login. 
		 */		
		public function get login():String
		{
			return _login;
		}
		
		/**
		 * Specifies twitter login. 
		 */
		public function set login(login:String):void
		{
			if(_login != login)
			{
				_login = login;
				_loginChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  updateOnAddGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for updateOnAddGomee proeprty. 
		 */		
		private var _updateOnAddGomee:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _updateOnAddGomee changes.
		 */		
		private var _updateOnAddGomeeChanged:Boolean;
		
		/**
		 * If true, twitter status will be updated when gomee added. 
		 */		
		public function get updateOnAddGomee():Boolean
		{
			return _updateOnAddGomee;
		}
		
		/**
		 * If true, twitter status will be updated when gomee added. 
		 */
		public function set updateOnAddGomee(updateOnAddGomee:Boolean):void
		{
			if(_updateOnAddGomee != updateOnAddGomee)
			{
				_updateOnAddGomee = updateOnAddGomee;
				_updateOnAddGomeeChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  updateOnSaveGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for updateOnSaveGomee property. 
		 */		
		private var _updateOnSaveGomee:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _updateOnSvaeGomee changes. 
		 */		
		private var _updateOnSaveGomeeChanged:Boolean;
		
		/**
		 * If true, twitter status will be updated when gomee saved.
		 */		
		public function get updateOnSaveGomee():Boolean
		{
			return _updateOnSaveGomee;
		}
		
		/**
		 * If true, twitter status will be updated when gomee saved.
		 */
		public function set updateOnSaveGomee(updateOnSaveGomee:Boolean):void
		{
			if(_updateOnSaveGomee != updateOnSaveGomee)
			{
				_updateOnSaveGomee = updateOnSaveGomee;
				_updateOnSaveGomeeChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  updateOnDeleteGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for updateOnDeleteGomee property. 
		 */		
		private var _updateOnDeleteGomee:Boolean = true;
		
		/**
		 * @private
		 * Flag to indicate when _updateOnDeleteGomee changes. 
		 */		
		private var _updateOnDeleteGomeeChanged:Boolean;
		
		/**
		 * If true, twitter status will be updated when gomee deleted. 
		 */		
		public function get updateOnDeleteGomee():Boolean
		{
			return _updateOnDeleteGomee;
		}
		
		/**
		 * If true, twitter status will be updated when gomee deleted. 
		 */		
		public function set updateOnDeleteGomee(updateOnDeleteGomee:Boolean):void
		{
			if(_updateOnDeleteGomee != updateOnDeleteGomee)
			{
				_updateOnDeleteGomee = updateOnDeleteGomee;
				_updateOnDeleteGomeeChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  login
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for loginText component. 
    	 */    	
    	private var _loginText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _loginText changes. 
    	 */    	
    	private var _loginTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to display login. 
    	 */    	
    	protected function get loginText():UIComponent
    	{
    		return _loginText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display login. 
    	 */
    	protected function set loginText(loginText:UIComponent):void
    	{
    		if(_loginText != loginText)
    		{
    			_loginText = loginText;
    			_loginTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates loginText component. 
    	 */    	
    	protected function createLoginText():void
    	{
    		if(_loginText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Login";
    			label.styleName = "YoTwitterPanelLoginLabel";
    			label.width = 70;
    			
    			loginText = new Text();
    			loginText.styleName = "YoTwitterPanelLogin";
    			loginText.percentWidth = 100;
    			
    			box.addChild(label);
    			box.addChild(loginText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Updates loginText component with new value. 
    	 */    	
    	protected function updateLogin():void
    	{
    		var text:Text = loginText as Text;
    		
    		if(text != null)
    		{
    			text.text = login;
    		}
    	}
    	
    	//----------------------------------
    	//  updateOnAddGomee
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for updateOnAddGomeeBox component.
    	 */    	
    	private var _updateOnAddGomeeBox:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _updateOnAddGomeeBoxChanged. 
    	 */    	
    	private var _updateOnAddGomeeBoxChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component that displays updateOnAddGomee property. 
    	 */    	
    	protected function get updateOnAddGomeeBox():UIComponent
    	{
    		return _updateOnAddGomeeBox;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component that displays updateOnAddGomee property. 
    	 */
    	protected function set updateOnAddGomeeBox(updateOnAddGomeeBox:UIComponent):void
    	{
    		if(_updateOnAddGomeeBox != updateOnAddGomeeBox)
    		{	
    			_updateOnAddGomeeBox = updateOnAddGomeeBox;
    			_updateOnAddGomeeBoxChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates updateOnAddGomeeBox component. 
    	 */    	
    	protected function createUpdateOnAddGomeeBox():void
    	{
    		if(_updateOnAddGomeeBox == null)
    		{
    			var box:Text = new Text();
    			box.styleName = "YoTwitterPanelOnAdd";
    			
    			_updateOnAddGomeeBox = box;
    			content.addChild(_updateOnAddGomeeBox);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates updateOnAddGomeeBox component with new value.
    	 */    	
    	protected function updateUpdateOnAddGomee():void
    	{
    		var text:Text = updateOnAddGomeeBox as Text;
    		
    		if(text != null)
    		{
    			if(updateOnAddGomee)
    			{
    				text.text = "Status will be updated wned gomee added.";
    			}
    			else
    			{
    				text.text = "Status will not be updated when gomee added.";
    			}
    		}
    	}
    	
    	//----------------------------------
    	//  updateOnSaveGomee
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for updateOnSaveGomeeBox component. 
    	 */    	
    	private var _updateOnSaveGomeeBox:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _updateOnSaveGomeeBox changes. 
    	 */    	
    	private var _updateOnSaveGomeeBoxChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component that displays updateOnSaveGomee property. 
    	 */    	
    	protected function get updateOnSaveGomeeBox():UIComponent
    	{
    		return _updateOnSaveGomeeBox;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component that displays updateOnSaveGomee property. 
    	 */
    	protected function set updateOnSaveGomeeBox(updateOnSaveGomeeBox:UIComponent):void
    	{
    		if(_updateOnSaveGomeeBox != updateOnSaveGomeeBox)
    		{
    			_updateOnSaveGomeeBox = updateOnSaveGomeeBox;
    			_updateOnSaveGomeeBoxChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates updateOnSaveGomeeBox component.
    	 */    	
    	protected function createUpdateOnSaveGomeeBox():void
    	{
    		if(_updateOnSaveGomeeBox == null)
    		{
    			var box:Text = new Text();
    			box.styleName = "YoTwitterPanelOnSave";
    			
    			_updateOnSaveGomeeBox = box;
    			content.addChild(_updateOnSaveGomeeBox);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates updateOnSaveGomeeBox with new value.
    	 */    	
    	protected function updateUpdateOnSaveGomee():void
    	{
    		var text:Text = updateOnSaveGomeeBox as Text;
    		
    		if(text != null)
    		{
    			if(updateOnSaveGomee)
    			{
    				text.text = "Status will be updated when gomee saved.";
    			}
    			else
    			{
    				text.text = "Status will not be updated when gomee saved.";
    			}
    		}
    	}
    	
    	//----------------------------------
    	//  updateOnDeleteGomee
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for updateOnDeleteGomee component. 
    	 */    	
    	private var _updateOnDeleteGomeeBox:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _updateOnDeleteGomeeBoxChanges. 
    	 */    	
    	private var _updateOnDeleteGomeeBoxChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to diplay updateOnDeleteGomee property. 
    	 */    	
    	protected function get updateOnDeleteGomeeBox():UIComponent
    	{
    		return _updateOnDeleteGomeeBox;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to diplay updateOnDeleteGomee property. 
    	 */
    	protected function set updateOnDeleteGomeeBox(updateOnDeleteGomeeBox:UIComponent):void
    	{
    		if(_updateOnDeleteGomeeBox != updateOnDeleteGomeeBox)
    		{
    			_updateOnDeleteGomeeBox = updateOnDeleteGomeeBox;
    			_updateOnDeleteGomeeBoxChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates updateOnDeleteGomeeBox component.
    	 */    	
    	protected function createUpdateOnDeleteGomeeBox():void
    	{
    		if(_updateOnDeleteGomeeBox == null)
    		{
    			var box:Text = new Text();
    			box.styleName = "YoTwitterPanelOnDelete";
    			
    			_updateOnDeleteGomeeBox = box;
    			content.addChild(_updateOnDeleteGomeeBox);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates updateOnDeleteGomeeBox with new value.
    	 */    	
    	protected function updateUpdateOnDeleteGomee():void
    	{
    		var text:Text = updateOnDeleteGomeeBox as Text;
			
			if(text != null)
			{
				if(updateOnDeleteGomee)
				{
					text.text = "Status will be updated when gomee deleted.";
				}
				else
				{
					text.text = "Status will not be updated when gomee deleted.";
				}
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
    			content.styleName = "YoTwitterPanelContent";
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
			
			createLoginText();
			createUpdateOnAddGomeeBox();
			createUpdateOnSaveGomeeBox();
			createUpdateOnDeleteGomeeBox();
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
    		
    		// update login
    		if(_loginChanged || _loginTextChanged)
    		{
    			if(loginText != null)
    			{
    				updateLogin();
    			}
    			
    			_loginChanged = false;
    			_loginTextChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update updateOnAddGomee
    		if(_updateOnAddGomeeChanged || _updateOnAddGomeeBoxChanged)
    		{
    			if(updateOnAddGomeeBox != null)
    			{
    				updateUpdateOnAddGomee();
    			}
    			
    			_updateOnAddGomeeChanged = false;
    			_updateOnAddGomeeBoxChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update updateOnSaveGomee
    		if(_updateOnSaveGomeeChanged || _updateOnSaveGomeeBoxChanged)
    		{
    			if(updateOnSaveGomeeBox != null)
    			{
    				updateUpdateOnSaveGomee();
    			}
    			
    			_updateOnSaveGomeeChanged = false;
    			_updateOnSaveGomeeBoxChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update updateOnDeleteGomee
    		if(_updateOnDeleteGomeeChanged || _updateOnDeleteGomeeBoxChanged)
    		{
    			if(updateOnDeleteGomeeBox != null)
    			{
    				updateUpdateOnDeleteGomee();
    			}
    			
    			_updateOnDeleteGomeeChanged = false;
    			_updateOnDeleteGomeeBoxChanged = false;
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