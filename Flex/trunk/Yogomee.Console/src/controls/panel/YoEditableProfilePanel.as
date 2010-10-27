package controls.panel
{
	import controls.text.YoTextInput;
	
	import flash.events.Event;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Text;
	
	/**
	 * Represents panel that allow to edit profiles. 
	 */	
	public class YoEditableProfilePanel extends YoProfilePanel
	{
		/**
		 * Constructor. 
		 */		
		public function YoEditableProfilePanel()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Proerties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  typed first name
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedFirstName property. 
		 */		
		private var _typedFirstName:String;
		
		/**
		 * Specifies new first name typed by user. 
		 */		
		public function get typedFirstName():String
		{
			return _typedFirstName;
		}
		
		/**
		 * @protected
		 * Specifies new first name typed by user. 
		 */
		protected function set newFirstName(newFirstName:String):void
		{
			if(_typedFirstName != newFirstName)
			{
				_typedFirstName = newFirstName;
				dispatchEvent(new Event("FirstNameChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set firstName(firstName:String):void
		{
			super.firstName = firstName;
			_typedFirstName = firstName;
		}
		
		//----------------------------------
    	//  typed last name
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedLastName property. 
		 */		
		private var _typedLastName:String;
		
		/**
		 * Specifies new last name typed by user. 
		 */		
		public function get typedLastName():String
		{
			return _typedLastName;
		}
		
		/**
		 * @protected
		 * Specifies new last name typed by user. 
		 */
		protected function set newLastName(newLastName:String):void
		{
			if(_typedLastName != newLastName)
			{
				_typedLastName = newLastName;
				dispatchEvent(new Event("LastNameChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set lastName(lastName:String):void
		{
			super.lastName = lastName;
			_typedLastName = lastName;
		}
		
		//----------------------------------
    	//  typed email
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedEmail property. 
		 */		
		private var _typedEmail:String;
		
		/**
		 * Specifies new email typed by user. 
		 */		
		public function get typedEmail():String
		{
			return _typedEmail;
		}
		
		/**
		 * @protected
		 * Specifies new email typed by user. 
		 */		
		protected function set newEmail(newEmail:String):void
		{
			if(_typedEmail != newEmail)
			{
				_typedEmail = newEmail;
				dispatchEvent(new Event("EmailChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set email(email:String):void
		{
			super.email = email;
			_typedEmail = email;
		}
		
		//----------------------------------
    	//  typed twitter login
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for twitterLoginProperty. 
		 */		
		private var _typedTwitterLogin:String;
		
		/**
		 * Specifies new twitter login typed by user. 
		 */		
		public function get typedTwitterLogin():String
		{
			return _typedTwitterLogin;
		}
		
		/**
		 * @protected
		 * Specifies new twitterLogin typed by user. 
		 */		
		protected function set newTwitterLogin(newTwitterLogin:String):void
		{
			if(_typedTwitterLogin != newTwitterLogin)
			{
				_typedTwitterLogin = newTwitterLogin;
				dispatchEvent(new Event("TwitterLoginChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set twitterLogin(twitterLogin:String):void
		{
			super.twitterLogin = twitterLogin;
			_typedTwitterLogin = twitterLogin;
		}
		
		//----------------------------------
    	//  twitter secret
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for twitterSecret property. 
		 */		
		private var _twitterSecret:String;
		
		/**
		 * @private
		 * Flag to indicate when _twitterSecret changes. 
		 */
		private var _twitterSecretChanged:Boolean;
		
		/**
		 * Specifies twitter password. 
		 */
		public function get twitterSecret():String
		{
			return _twitterSecret;
		}
		
		/**
		 * Specifies twitter password. 
		 */		
		public function set twitterSecret(twitterSecret:String):void
		{
			if(_twitterSecret != twitterSecret)
			{
				_twitterSecret = twitterSecret;
				_twitterSecretChanged = true;
				invalidateProperties();
			}
			
			_typedTwitterSecret = twitterSecret;
		}
		
		//----------------------------------
    	//  typed twitter secret
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedTwitterSecret property. 
		 */		
		private var _typedTwitterSecret:String;
		
		/**
		 * Specifies new twitter secret typed by user. 
		 */		
		public function get typedTwitterSecret():String
		{
			return _typedTwitterSecret;
		}
		
		/**
		 * @protected
		 * Specifies new twitter secret typed by user. 
		 */
		protected function set newTwitterSecret(newTwitterSecret:String):void
		{
			if(_typedTwitterSecret != newTwitterSecret)
			{
				_typedTwitterSecret = newTwitterSecret;
				dispatchEvent(new Event("TwitterSceretChanged"));
			}
		}
		
		//----------------------------------
    	//  typed twitterUpdateOnAddGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedTwitterUpdateOnAddGomee property. 
		 */		
		private var _typedTwitterUpdateOnAddGomee:Boolean;
		
		/**
		 * Specifies new twitterUpdateOnAddGomee typed by user. 
		 */		
		public function get typedTwitterUpdateOnAddGomee():Boolean
		{
			return _typedTwitterUpdateOnAddGomee;
		}
		
		/**
		 * @protected
		 * Specifies new twitterUpdateOnAddGomee typed by user. 
		 */
		protected function set newTwitterUpdateOnAddGomee(newTwitterUpdateOnAddGomee:Boolean):void
		{
			if(_typedTwitterUpdateOnAddGomee != newTwitterUpdateOnAddGomee)
			{
				_typedTwitterUpdateOnAddGomee = newTwitterUpdateOnAddGomee;
				dispatchEvent(new Event("TwitterUpdateOnAddGomeeChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set twitterUpdateOnAddGomee(twitterUpdateOnAddGomee:Boolean):void
		{
			super.twitterUpdateOnAddGomee = twitterUpdateOnAddGomee;
			_typedTwitterUpdateOnAddGomee = twitterUpdateOnAddGomee;
		}
		
		//----------------------------------
    	//  typed twitterUpdateOnSaveGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for typedTwitterUpdateOnSaveGomee property. 
		 */		
		private var _typedTwitterUpdateOnSaveGomee:Boolean;
		
		/**
		 * Specifies new twitterUpdateOnSaveGomee typed by user. 
		 */		
		public function get typedTwitterUpdateOnSaveGomee():Boolean
		{
			return _typedTwitterUpdateOnSaveGomee;
		}
		
		/**
		 * @protected
		 * Specifies new twitterUpdateOnSaveGomee typed by user. 
		 */
		protected function set newTwitterUpdateOnSaveGomee(newTwitterUpdateOnSaveGomee:Boolean):void
		{
			if(_typedTwitterUpdateOnSaveGomee != newTwitterUpdateOnSaveGomee)
			{
				_typedTwitterUpdateOnSaveGomee = newTwitterUpdateOnSaveGomee;
				dispatchEvent(new Event("TwitterUpdateOnSaveGomeeChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set twitterUpdateOnSaveGomee(twitterUpdateOnSaveGomee:Boolean):void
		{
			super.twitterUpdateOnSaveGomee = twitterUpdateOnSaveGomee;
			_typedTwitterUpdateOnSaveGomee = twitterUpdateOnSaveGomee;
		}
		
		//----------------------------------
    	//  typed twitterUpdateOnDeleteGomee
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for twitterUpdateOnDeleteGomee property. 
		 */		
		private var _typedTwitterUpdateOnDeleteGomee:Boolean;
		
		/**
		 * Specifies new twitterUpdateOnDeleteGomee typed by user. 
		 */
		public function get typedTwitterUpdateOnDeleteGomee():Boolean
		{
			return _typedTwitterUpdateOnDeleteGomee;
		}
		
		/**
		 * @protected
		 * Specifies new twitterUpdateOnDeleteGomee typed by user. 
		 */		
		protected function set newTwitterUpdateOnDeleteGomee(newTwitterUpdateOnDeleteGomee:Boolean):void
		{
			if(_typedTwitterUpdateOnDeleteGomee != newTwitterUpdateOnDeleteGomee)
			{
				_typedTwitterUpdateOnDeleteGomee = newTwitterUpdateOnDeleteGomee;
				dispatchEvent(new Event("TwitterUpdateOnDeleteGomeeChanged"));
			}
		}
		
		/**
		 * @override 
		 */		
		public override function set twitterUpdateOnDeleteGomee(twitterUpdateOnDeleteGomee:Boolean):void
		{
			super.twitterUpdateOnDeleteGomee = twitterUpdateOnDeleteGomee;
			_typedTwitterUpdateOnDeleteGomee = twitterUpdateOnDeleteGomee;
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
    	 * Creates login component. 
    	 */    	
    	protected override function createLoginText():void
    	{
    		if(loginText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Login";
    			label.styleName = "YoEditableProfilePanelLoginLabel";
    			label.width = 70;
    			
    			loginText = new Text();
    			loginText.styleName = "YoEditableProfilePanelLogin";
    			loginText.percentWidth = 100;
    			
    			box.addChild(label);
    			box.addChild(loginText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	//----------------------------------
    	//  name
    	//----------------------------------
		
		/**
    	 * @override
    	 * Creates componenet that stores first and last names. 
    	 */
		protected override function createNameConatiner():void
		{
			if(nameContainer == null)
			{
				nameContainer = new VBox();
				nameContainer.styleName = "YoEditableProfilePanelName";
				content.addChild(nameContainer);
			}
		}
		
		//----------------------------------
    	//  first name
    	//----------------------------------
    	
    	/**
    	 * @override
    	 * Create first name component. 
    	 */    	
    	protected override function createFirstNameText():void
    	{
    		if(firstNameText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "First Name";
    			label.styleName = "YoEditableProfilePanelFirstNameLabel";
    			label.width = 70;
    			
    			firstNameText = new YoTextInput();
    			firstNameText.styleName = "YoEditableProfilePanelFirstName";
    			firstNameText.percentWidth = 100;
    			
    			firstNameText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTextInput = firstNameText as YoTextInput;
    					
    					if(text != null)
    					{
    						newFirstName = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(firstNameText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	/**
    	 * @override
    	 * Updates first name component with new value. 
    	 */    	
    	protected override function updateFirstName():void
    	{
    		var text:YoTextInput = firstNameText as YoTextInput;
    		
    		if(text != null)
    		{
    			text.text = firstName;
    		}
    	}
    	
    	//----------------------------------
    	//  last name
    	//----------------------------------
    	
    	/**
    	 * @override
    	 * Create last name component. 
    	 */    	
    	protected override function createLastNameText():void
    	{
    		if(lastNameText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Last Name";
    			label.styleName = "YoEditableProfilePanelLastNameLabel";
    			label.width = 70;
    			
    			lastNameText = new YoTextInput();
    			lastNameText.styleName = "YoEditableProfilePanelLastName";
    			lastNameText.percentWidth = 100;
    			
    			lastNameText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTextInput = lastNameText as YoTextInput;
    					
    					if(text != null)
    					{
    						newLastName = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(lastNameText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	/**
    	 * @override
    	 * Updates last name component with new value. 
    	 */    	
    	protected override function updateLastName():void
    	{
    		var text:YoTextInput = lastNameText as YoTextInput;
    		
    		if(text != null)
    		{
    			text.text = lastName;
    		}
    	}
    	
    	//----------------------------------
    	//  email
    	//----------------------------------
    	
    	/**
    	 * @override
    	 * Create email component. 
    	 */    	
    	protected override function createEmailText():void
    	{
    		if(emailText == null)
    		{
    			var box:HBox = new HBox();
    			box.percentWidth = 100;
    			
    			var label:Text = new Text();
    			label.text = "Email";
    			label.styleName = "YoEditableProfilePanelEmailLabel";
    			label.width = 70;
    			
    			emailText = new YoTextInput();
    			emailText.styleName = "YoEditableProfilePanelEmail";
    			emailText.percentWidth = 100;
    			
    			emailText.addEventListener(
    				Event.CHANGE,
    				function(event:Event):void
    				{
    					var text:YoTextInput = emailText as YoTextInput;
    					
    					if(text != null)
    					{
    						newEmail = text.text;
    					}
    				});
    			
    			box.addChild(label);
    			box.addChild(emailText);
    			
    			content.addChild(box);
    		}
    	}
    	
    	/**
    	 * @override
    	 * Updates email component with new value. 
    	 */    	
    	protected override function updateEmail():void
    	{
    		var text:YoTextInput = emailText as YoTextInput;
    		
    		if(text != null)
    		{
    			text.text = email;
    		}
    	}
    	
    	//----------------------------------
    	//  twitter panel
    	//----------------------------------
    	
    	/**
    	 * @override 
    	 * Create twitterPanel component.
    	 */    	
    	protected override function createTwitterPanel():void
    	{
    		if(twitterPanel == null)
    		{
    			var panel:YoEditableTwitterPanel = new YoEditableTwitterPanel();
    			panel.label = "Twitter";
    			panel.percentWidth = 100;
    			panel.state = YoPanelState.Colapsed;
    			
    			panel.addEventListener(
    				"LoginChanged",
    				function(event:Event):void
    				{
    					newTwitterLogin = panel.typedLogin;
    				});
    			
    			panel.addEventListener(
    				"SecretChanged",
    				function(event:Event):void
    				{
    					newTwitterSecret = panel.typedSecret;
    				});
    			
    			panel.addEventListener(
    				"UpdateOnAddGomeeChanged",
    				function(event:Event):void
    				{
    					newTwitterUpdateOnAddGomee = panel.typedUpdateOnAddGomee;
    				});
    			
    			panel.addEventListener(
    				"UpdateOnSaveGomeeChanged",
    				function(event:Event):void
    				{
    					newTwitterUpdateOnSaveGomee = panel.typedUpdateOnSaveGomee;
    				});
    			
    			panel.addEventListener(
    				"UpdateOnDeleteGomeeChanged",
    				function(event:Event):void
    				{
    					newTwitterUpdateOnDeleteGomee = panel.typedUpdateOnDeleteGomee;
    				});
    			
    			twitterPanel = panel;
    			content.addChild(twitterPanel);
    		}
    	}
    	
    	/**
    	 * @override 
    	 * Updates twitterPanel component with new values.
    	 */    	
    	protected override function updateTwitter():void
    	{
    		super.updateTwitter();
    		
    		var panel:YoEditableTwitterPanel = twitterPanel as YoEditableTwitterPanel;
    		
    		if(panel != null)
    		{
    			panel.login = twitterLogin;
    			panel.secret = twitterSecret;
    			panel.updateOnAddGomee = twitterUpdateOnAddGomee;
    			panel.updateOnSaveGomee = twitterUpdateOnSaveGomee;
    			panel.updateOnDeleteGomee = twitterUpdateOnDeleteGomee;
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
    		super.createContent();
    		content.styleName = "YoEditableProfilePanelContent";
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
    		
    		// upate twiiter secret
    		if(_twitterSecretChanged)
    		{
    			if(twitterPanel != null)
    			{
    				updateTwitter();
    			}
    			
    			_twitterSecretChanged = false;
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