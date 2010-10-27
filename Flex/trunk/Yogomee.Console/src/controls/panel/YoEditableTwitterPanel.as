package controls.panel
{
	import controls.text.YoTextInput;
	
	import flash.events.Event;
	
	import mx.containers.HBox;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.CheckBox;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	/**
	 * Represents panel that allow to edit twitter information. 
	 */
	public class YoEditableTwitterPanel extends YoTwitterPanel
	{
		/**
		 * Constructor. 
		 */		
		public function YoEditableTwitterPanel()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  secret
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for secret property. 
		 */		
		private var _secret:String;
		
		/**
		 * @private
		 * Flag to indicate when _secret changes. 
		 */		
		private var _secretChanged:Boolean;
		
		/**
		 * Specifies twitter password. 
		 */		
		public function get secret():String
		{
			return _secret;
		}
		
		/**
		 * Specifies twitter password. 
		 */
		public function set secret(secret:String):void
		{
			if(_secret != secret)
			{
				_secret = secret;
				_secretChanged = true;
				invalidateProperties();
			}
			
			_typedSecret = secret;
		}
		
		//----------------------------------
    	//  typed secret
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedSecretProperty. 
		 */		
		private var _typedSecret:String;
		
		/**
		 * Specifies new secret typed by user. 
		 */		
		public function get typedSecret():String
		{
			return _typedSecret;
		}
		
		/**
		 * @protected
		 * Specifies new secret typed by user. 
		 */
		protected function set newSecret(newSecret:String):void
		{
			if(_typedSecret != newSecret)
			{
				_typedSecret = newSecret;
				dispatchEvent(new Event("SecretChanged"));
			}
		}
		
		//----------------------------------
    	//  typed login
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedLogin property. 
		 */		
		private var _typedLogin:String;
		
		/**
		 * Specifies new login typed by user. 
		 */		
		public function get typedLogin():String
		{
			return _typedLogin;
		}
		
		/**
		 * @protected
		 * Specifies new login typed by user. 
		 */
		protected function set newLogin(newLogin:String):void
		{
			if(_typedLogin != newLogin)
			{
				_typedLogin = newLogin;
				dispatchEvent(new Event("LoginChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set login(login:String):void
		{
			super.login = login;
			_typedLogin = login;
		}
		
		//----------------------------------
    	//  typed updateOnAddGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedUpdateOnAddGomee property. 
		 */		
		private var _typedUpdateOnAddGomee:Boolean;
		
		/**
		 * Specifies updateOnAddGomee typed by user. 
		 */		
		public function get typedUpdateOnAddGomee():Boolean
		{
			return _typedUpdateOnAddGomee;
		}
		
		/**
		 * @protected
		 * Specifies updateOnAddGomee typed by user. 
		 */
		protected function set newUpdateOnAddGomee(newUpdateOnAddGomee:Boolean):void
		{
			if(_typedUpdateOnAddGomee != newUpdateOnAddGomee)
			{
				_typedUpdateOnAddGomee = newUpdateOnAddGomee;
				dispatchEvent(new Event("UpdateOnAddGomeeChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set updateOnAddGomee(updateOnAddGomee:Boolean):void
		{
			super.updateOnAddGomee = updateOnAddGomee;
			_typedUpdateOnAddGomee = updateOnAddGomee;
		}
		
		//----------------------------------
    	//  typed updateOnSaveGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedUpdateOnSaveGomee property. 
		 */		
		private var _typedUpdateOnSaveGomee:Boolean;
		
		/**
		 * Specifies new updateOnSaveGomee typed by user. 
		 */		
		public function get typedUpdateOnSaveGomee():Boolean
		{
			return _typedUpdateOnSaveGomee;
		}
		
		/**
		 * @protected
		 * Specifies new updateOnSaveGomee typed by user. 
		 */		
		protected function set newUpdateOnSaveGomee(newUpdateOnSaveGomee:Boolean):void
		{
			if(_typedUpdateOnSaveGomee != newUpdateOnSaveGomee)
			{
				_typedUpdateOnSaveGomee = newUpdateOnSaveGomee;
				dispatchEvent(new Event("UpdateOnSaveGomeeChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set updateOnSaveGomee(updateOnSaveGomee:Boolean):void
		{
			super.updateOnSaveGomee = updateOnSaveGomee;
			_typedUpdateOnSaveGomee = updateOnSaveGomee;
		}
		
		//----------------------------------
    	//  typed updateOnDeleteGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typeUpdateOnDeleteGomee property. 
		 */		
		private var _typedUpdateOnDeleteGomee:Boolean;
		
		/**
		 * Specifies new updateOnDeleteGomee typed by user. 
		 */		
		public function get typedUpdateOnDeleteGomee():Boolean
		{
			return _typedUpdateOnDeleteGomee;
		}
		
		/**
		 * @protected
		 * Specifies new updateOnDeleteGomee typed by user. 
		 */		
		protected function set newUpdateOnDeleteGomee(newUpdateOnDeleteGomee:Boolean):void
		{
			if(_typedUpdateOnDeleteGomee != newUpdateOnDeleteGomee)
			{
				_typedUpdateOnDeleteGomee = newUpdateOnDeleteGomee;
				dispatchEvent(new Event("UpdateOnDeleteGomeeChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set updateOnDeleteGomee(updateOnDeleteGomee:Boolean):void
		{
			super.updateOnDeleteGomee = updateOnDeleteGomee;
			_typedUpdateOnDeleteGomee = updateOnDeleteGomee;
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
    	 * @override
    	 * Creates loginText component. 
    	 */
    	protected override function createLoginText():void
    	{
    		if(loginText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Login";
    			label.styleName = "YoEditableTwitterPanelLoginLabel";
    			label.width = 70;
    			
    			loginText = new YoTextInput();
    			loginText.styleName = "YoEditableTwitterPanelLogin";
    			loginText.percentWidth = 100;
    			
    			loginText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTextInput = loginText as YoTextInput;
    					
    					if(text != null)
    					{
    						newLogin = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(loginText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Updates loginText component with new value.
    	 */    	
    	protected override function updateLogin():void
    	{
    		var text:YoTextInput = loginText as YoTextInput;
    		
    		if(text != null)
    		{
    			text.text = login;
    		}
    	}
    	
    	//----------------------------------
    	//  secret
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for secretText component. 
    	 */    	
    	private var _secretText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _secretText changes. 
    	 */    	
    	private var _secretTextChanged:Boolean; 
    	
    	/**
    	 * @protected
    	 * Specifies component to display secret. 
    	 */    	
    	protected function get secretText():UIComponent
    	{
    		return _secretText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to display secret. 
    	 */
    	protected function set secretText(secretText:UIComponent):void
    	{
    		if(_secretText != secretText)
    		{
    			_secretText = secretText;
    			_secretTextChanged=  true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates secretText component.
    	 */    	
    	protected function createSecretText():void
    	{
    		if(_secretText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Secret";
    			label.styleName = "YoEditableTwitterPanelSecretLabel";
    			label.width = 70;
    			
    			secretText = new YoTextInput();
    			secretText.styleName = "YoEditableTwitterPanelSecret";
    			secretText.percentWidth = 100;
    			
    			secretText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTextInput = secretText as YoTextInput;
    					
    					if(text != null)
    					{
    						newSecret = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(secretText);
    			
    			content.addChild(box);
    			content.setChildIndex(box, 1);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates secretText component with new value.
    	 */    	
    	protected function updateSecret():void
    	{
    		var text:Text = secretText as Text;
    		
    		if(text != null)
    		{
    			text.text = secret;
    		}
    	}
    	
    	//----------------------------------
    	//  updateOnAddGomee
    	//----------------------------------
    	
    	/**
    	 * @override 
    	 * Creates updateOnAddGomeeBox component.
    	 */    	
    	protected override function createUpdateOnAddGomeeBox():void
    	{
    		if(updateOnAddGomeeBox == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.styleName = "YoEditableTwitterPanelOnAdd";
    			box.label = "Update status when gomee added";
    			box.percentWidth = 100;
    			box.labelPlacement = ButtonLabelPlacement.LEFT;
    			
    			box.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					newUpdateOnAddGomee = box.selected;
    				});
    			
    			updateOnAddGomeeBox = box;
    			content.addChild(updateOnAddGomeeBox);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Updates updateOnAddGomeeBox with new value.
    	 */    	
    	protected override function updateUpdateOnAddGomee():void
    	{
    		var box:CheckBox = updateOnAddGomeeBox as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = updateOnAddGomee;
    		}
    	}
    	
    	//----------------------------------
    	//  updateOnSaveGomee
    	//----------------------------------
    	
    	/**
    	 * @override 
    	 * Creates updateOnSaveGomeeBox component.
    	 */    	
    	protected override function createUpdateOnSaveGomeeBox():void
    	{
    		if(updateOnSaveGomeeBox == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.styleName = "YoEditableTwitterPanelOnSave";
    			box.label = "Update status when gomee saved";
    			box.percentWidth = 100;
    			box.labelPlacement = ButtonLabelPlacement.LEFT;
    			
    			box.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					newUpdateOnSaveGomee = box.selected;
    				});
    			
    			updateOnSaveGomeeBox = box;
    			content.addChild(updateOnSaveGomeeBox);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Updates updateOnSaveGomeeBox component with new value.
    	 */    	
    	protected override function updateUpdateOnSaveGomee():void
    	{
    		var box:CheckBox = updateOnSaveGomeeBox as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = updateOnSaveGomee;
    		}
    	}
    	
    	//----------------------------------
    	//  updateOnDeleteGomee
    	//----------------------------------
    	
    	/**
    	 * @override 
    	 * Creates updateOnDeleteGomeeBox component.
    	 */    	
    	protected override function createUpdateOnDeleteGomeeBox():void
    	{
    		if(updateOnDeleteGomeeBox == null)
    		{
    			var box:CheckBox = new CheckBox();
    			box.styleName = "YoEditableTwitterPanelOnDelete";
    			box.label = "Update status when gomee deleted";
    			box.percentWidth = 100;
    			box.labelPlacement = ButtonLabelPlacement.LEFT;
    			
    			box.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					newUpdateOnDeleteGomee = box.selected;
    				});
    			
    			updateOnDeleteGomeeBox = box;
    			content.addChild(updateOnDeleteGomeeBox);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Updates updateOnDeleteGomeeBox component with new value. 
    	 */    	
    	protected override function updateUpdateOnDeleteGomee():void
    	{
    		var box:CheckBox = updateOnDeleteGomeeBox as CheckBox;
    		
    		if(box != null)
    		{
    			box.selected = updateOnDeleteGomee;
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
    		super.createContent();
    		content.styleName = "YoEditableTwitterPanelContent";
    	}
    	
    	/**
    	 * @override
    	 * Create and add children.  
    	 */
		protected override function createChildren():void
		{
			super.createChildren();
			createSecretText();
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
    		
    		// update secret
    		if(_secretChanged || _secretTextChanged)
    		{
    			if(secretText != null)
    			{
    				updateSecret();
    			}
    			
    			_secretChanged = false;
    			_secretTextChanged = false;
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