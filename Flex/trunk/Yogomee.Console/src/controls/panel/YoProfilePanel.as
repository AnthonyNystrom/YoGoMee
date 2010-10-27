package controls.panel
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.core.UIComponent;
	
	/**
	 * Represents panel with profile information. 
	 */	
	public class YoProfilePanel extends YoPanel
	{
		/**
		 * Constructor. 
		 */		
		public function YoProfilePanel()
		{
			super();
			_twitterVisible = true;
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
    	 * Specifies login property. 
    	 */    	
    	public function get login():String
    	{
    		return _login;
    	}
    	
    	/**
    	 * Specifies login property. 
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
    	//  firstName
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for firstName property.  
    	 */    	
    	private var _firstName:String;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _firstNameChanges. 
    	 */    	
    	private var _firstNameChanged:Boolean;
    	
    	/**
    	 * Specifies frist name. 
    	 */    	
    	public function get firstName():String
    	{
    		return _firstName;
    	}
    	
    	/**
    	 * Specifies frist name. 
    	 */
    	public function set firstName(firstName:String):void
    	{
    		if(_firstName != firstName)
    		{
    			_firstName = firstName;
    			_firstNameChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  lastName
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for lastName property. 
    	 */    	
    	private var _lastName:String;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _lastName changes. 
    	 */    	
    	private var _lastNameChanged:Boolean;
    	
    	/**
    	 * Specifies last name. 
    	 */    	
    	public function get lastName():String
    	{
    		return _lastName;
    	}
    	
    	/**
    	 * Specifies last name. 
    	 */
    	public function set lastName(lastName:String):void
    	{
    		if(_lastName != lastName)
    		{
    			_lastName = lastName;
    			_lastNameChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  email
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for email property. 
    	 */    	
    	private var _email:String;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _email changes. 
    	 */    	
    	private var _emailChanged:Boolean;
    	
    	/**
    	 * Specifies email. 
    	 */    	
    	public function get email():String
    	{
    		return _email;
    	}
    	
    	/**
    	 * Specifies email. 
    	 */
    	public function set email(email:String):void
    	{
    		if(_email != email)
    		{
    			_email = email;
    			_emailChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  send invite visible
    	//----------------------------------
    	
    	private var _sendInviteVisible:Boolean;
    	
    	private var _sendInviteVisibleChanged:Boolean;
    	
    	public function get sendInviteVisible():Boolean
    	{
    		return _sendInviteVisible;
    	}
    	
    	public function set sendInviteVisible(inviteVisible:Boolean):void
    	{
    		if(_sendInviteVisible != inviteVisible)
    		{
    			_sendInviteVisible = inviteVisible;
    			_sendInviteVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  accept invite visible
    	//----------------------------------
    	
    	private var _acceptInviteVisible:Boolean;
    	
    	private var _acceptInviteVisibleChanged:Boolean;
    	
    	public function get acceptInviteVisible():Boolean
    	{
    		return _acceptInviteVisible;
    	} 
    	
    	public function set acceptInviteVisible(acceptInviteVisible:Boolean):void
    	{
    		if(_acceptInviteVisible != acceptInviteVisible)
    		{
    			_acceptInviteVisible = acceptInviteVisible;
    			_acceptInviteVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  reject invite visible
    	//----------------------------------
    	
    	private var _rejectInviteVisible:Boolean;
    	
    	private var _rejectInviteVisibleChanged:Boolean;
    	
    	public function get rejectInviteVisible():Boolean
    	{
    		return _rejectInviteVisible;
    	}
    	
    	public function set rejectInviteVisible(rejectInviteVisible:Boolean):void
    	{
    		if(_rejectInviteVisible != rejectInviteVisible)
    		{
    			_rejectInviteVisible = rejectInviteVisible;
    			_rejectInviteVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  twitterState
    	//----------------------------------
    	
    	private var _twitterState:YoPanelState = YoPanelState.Colapsed;
    	
    	private var _twitterStateChanged:Boolean;
    	
    	public function get twitterState():YoPanelState
    	{
    		return _twitterState;
    	}
    	
    	public function set twitterState(twitterState:YoPanelState):void
    	{
    		if(_twitterState != twitterState)
    		{
    			_twitterState = twitterState;
    			_twitterStateChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  twitterVisible
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for twitterVisible property. 
    	 */    	
    	private var _twitterVisible:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _twitterVisible changes. 
    	 */    	
    	private var _twitterVisibleChanged:Boolean;
    	
    	/**
    	 * Specifies visibility of twitter panel. 
    	 */    	
    	public function get twitterVisible():Boolean
    	{
    		return _twitterVisible;
    	}
    	
    	/**
    	 * Specifies visibility of twitter panel. 
    	 */
    	public function set twitterVisible(twitterVisible:Boolean):void
    	{
    		if(_twitterVisible != twitterVisible)
    		{
    			_twitterVisible = twitterVisible;
    			_twitterVisibleChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  twitterLogin
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for twitter login property. 
    	 */    	
    	private var _twitterLogin:String;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _twitterLogin changes. 
    	 */    	
    	private var _twitterLoginChanged:Boolean;
    	
    	/**
    	 * Specifies twitter login. 
    	 */    	
    	public function get twitterLogin():String
    	{
    		return _twitterLogin;
    	}
    	
    	/**
    	 * Specifies twitter login. 
    	 */
    	public function set twitterLogin(twitterLogin:String):void
    	{
    		if(_twitterLogin != twitterLogin)
    		{
    			_twitterLogin = twitterLogin;
    			_twitterLoginChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  twitterUpdateOnAddGomee
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for twiiterUpdateOnAddGomee property. 
    	 */    	
    	private var _twitterUpdateOnAddGomee:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _twitterUpdateOnAddGomee changes. 
    	 */    	
    	private var _twitterUpdateOnAddGomeeChanged:Boolean;
    	
    	/**
    	 * If true - twiiter status will be updated when gomee added. 
    	 */    	
    	public function get twitterUpdateOnAddGomee():Boolean
    	{
    		return _twitterUpdateOnAddGomee;
    	}
    	
    	/**
    	 * If true - twiiter status will be updated when gomee added. 
    	 */
    	public function set twitterUpdateOnAddGomee(twitterUpdateOnAddGomee:Boolean):void
    	{
    		if(_twitterUpdateOnAddGomee != twitterUpdateOnAddGomee)
    		{
    			_twitterUpdateOnAddGomee = twitterUpdateOnAddGomee;
    			_twitterUpdateOnAddGomeeChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  twitterUpdateOnSaveGomee
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for twitterUpdateOnSaveGomee property. 
    	 */    	
    	private var _twitterUpdateOnSaveGomee:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _twitterUpdateOnSaveGomee changes. 
    	 */    	
    	private var _twitterUpdateOnSaveGomeeChanged:Boolean;
    	
    	/**
    	 * If true - twitter status will be updated when  gomee saved. 
    	 */
    	public function get twitterUpdateOnSaveGomee():Boolean
    	{
    		return _twitterUpdateOnSaveGomee;
    	}
    	
    	/**
    	 * If true - twitter status will be updated when  gomee saved. 
    	 */    	
    	public function set twitterUpdateOnSaveGomee(twitterUpdateOnSaveGomee:Boolean):void
    	{
    		if(_twitterUpdateOnSaveGomee != twitterUpdateOnSaveGomee)
    		{
    			_twitterUpdateOnSaveGomee = twitterUpdateOnSaveGomee;
    			_twitterUpdateOnSaveGomeeChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  twitterUpdateOnDeleteGomee
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for twitterUpdateOnDeleteGomee property. 
    	 */    	
    	private var _twitterUpdateOnDeleteGomee:Boolean;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _twitterUpdateOnDEleteGomee changes. 
    	 */    	
    	private var _twitterUpdateOnDeleteGomeeChanged:Boolean;
    	
    	/**
    	 * If true - twitter status will be updated when gomee deleted. 
    	 */
    	public function get twitterUpdateOnDeleteGomee():Boolean
    	{
    		return _twitterUpdateOnDeleteGomee;
    	}
    	
    	/**
    	 * If true - twitter status will be updated when gomee deleted. 
    	 */    	
    	public function set twitterUpdateOnDeleteGomee(twitterUpdateOnDeleteGomee:Boolean):void
    	{
    		if(_twitterUpdateOnDeleteGomee != twitterUpdateOnDeleteGomee)
    		{
    			_twitterUpdateOnDeleteGomee = twitterUpdateOnDeleteGomee;
    			_twitterUpdateOnDeleteGomeeChanged = true;
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
    	 * Storage for login child. 
    	 */    	
    	private var _loginText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _loginText changes. 
    	 */    	
    	private var _loginTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component that display login. 
    	 */    	
    	protected function get loginText():UIComponent
    	{
    		return _loginText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component that display login. 
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
    	 * Creates login text component. 
    	 */    	
    	protected function createLoginText():void
    	{
    		if(_loginText == null)
    		{
    			_loginText = new Text();
    			_loginText.styleName = "YoProfilePanelLogin";
    			content.addChild(_loginText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Update login component with new value.
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
    	//  name
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for nameContainer child. 
    	 */    	
    	private var _nameContainer:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _nameContainer changes. 
    	 */    	
    	private var _nameContainerChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies componenet that stores first and last names. 
    	 */    	
    	protected function get nameContainer():UIComponent
    	{
    		return _nameContainer;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies componenet that stores first and last names. 
    	 */
    	protected function set nameContainer(nameContainer:UIComponent):void
    	{
    		if(_nameContainer != nameContainer)
    		{
    			_nameContainer = nameContainer;
    			_nameContainerChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates name container component. 
    	 */    	
    	protected function createNameConatiner():void
    	{
    		if(_nameContainer == null)
    		{
    			_nameContainer = new HBox();
    			_nameContainer.styleName = "YoProfilePanelName";
    			content.addChild(_nameContainer);
    		}
    	}
    	
    	//----------------------------------
    	//  firstName
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for first name component. 
    	 */    	
    	private var _firstNameText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _firstNameText changes. 
    	 */    	
    	private var _firstNameTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component that displays first name. 
    	 */    	
    	protected function get firstNameText():UIComponent
    	{
    		return _firstNameText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component that displays first name. 
    	 */
    	protected function set firstNameText(firstNameText:UIComponent):void
    	{
    		if(_firstNameText != firstNameText)
    		{
    			_firstNameText = firstNameText;
    			_firstNameTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates first name component. 
    	 */    	
    	protected function createFirstNameText():void
    	{
    		if(_firstNameText == null)
    		{
    			_firstNameText = new Text();
    			_firstNameText.styleName = "YoProfilePanelFirstName";
    			nameContainer.addChild(_firstNameText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Update first name component with new value.
    	 */    	
    	protected function updateFirstName():void
    	{
    		var text:Text = firstNameText as Text;
    		
    		if(text != null)
    		{
    			text.text = firstName;
    		}
    	}
    	
    	//----------------------------------
    	//  lastName
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for last name component. 
    	 */    	
    	private var _lastNameText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _lastNameText changes. 
    	 */    	
    	private var _lastNameTextChanged:Boolean;
    	
    	/**
    	 * @private
    	 * Specifies component that displays last name. 
    	 */    	
    	protected function get lastNameText():UIComponent
    	{
    		return _lastNameText;
    	}
    	
    	/**
    	 * @private
    	 * Specifies component that displays last name. 
    	 */
    	protected function set lastNameText(lastNameText:UIComponent):void
    	{
    		if(_lastNameText != lastNameText)
    		{
    			_lastNameText = lastNameText;
    			_lastNameTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates last name component. 
    	 */    	
    	protected function createLastNameText():void
    	{
    		if(_lastNameText == null)
    		{
    			_lastNameText = new Text();
    			_lastNameText.styleName = "YoProfilePanelLastName";
    			nameContainer.addChild(_lastNameText);
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Updates last name component with new value. 
    	 */    	
    	protected function updateLastName():void
    	{
    		var text:Text = lastNameText as Text;
    		
    		if(text != null)
    		{
    			text.text = lastName;
    		}
    	}
    	
    	//----------------------------------
    	//  email
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for email component. 
    	 */    	
    	private var _emailText:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _emailText changes. 
    	 */    	
    	private var _emailTextChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies componenet to display email address. 
    	 */    	
    	protected function get emailText():UIComponent
    	{
    		return _emailText;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies componenet to display email address. 
    	 */
    	protected function set emailText(emailText:UIComponent):void
    	{
    		if(_emailText != emailText)
    		{
    			_emailText = emailText;
    			_emailTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates email componenet. 
    	 */    	
    	protected function createEmailText():void
    	{
    		if(_emailText == null)
    		{
    			_emailText = new Text();
    			_emailText.styleName = "YoProfilePanelEmail";
    			content.addChild(_emailText);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates email component with new value. 
    	 */    	
    	protected function updateEmail():void
    	{
    		var text:Text = emailText as Text;
    		
    		if(text != null)
    		{
    			text.text = email;
    		}
    	}
    	
    	//----------------------------------
    	//  send invite
    	//----------------------------------
    	
    	private var _sendInviteText:UIComponent;
    	
    	private var _sendInviteTextChanged:Boolean;
    	
    	protected function get sendInviteText():UIComponent
    	{
    		return _sendInviteText;
    	}
    	
    	protected function set sendInviteText(inviteText:UIComponent):void
    	{
    		if(_sendInviteText != inviteText)
    		{
    			_sendInviteText = inviteText;
    			_sendInviteTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createSendInviteText():void
    	{
    		if(_sendInviteText == null)
    		{
    			var text:Text = new Text();
    			text.text = "Add to friends";
    			text.styleName = "YoProfilePanelInvite";
    			text.buttonMode = true;
    			text.useHandCursor = true;
    			text.mouseChildren = false;
    			
    			text.addEventListener(
    				MouseEvent.CLICK,
    				function(event:MouseEvent):void
    				{
    					dispatchEvent(new Event("inviteClicked"));
    				});
    			
    			_sendInviteText = text;
    			if(sendInviteVisible)
    			{
    				content.addChildAt(_sendInviteText, 3);
    			}
    		}
    	}
    	
    	//----------------------------------
    	//  accept invite
    	//----------------------------------
    	
    	private var _acceptInviteText:UIComponent;
    	
    	private var _acceptInviteTextChanged:Boolean;
    	
    	protected function get acceptInviteText():UIComponent
    	{
    		return _acceptInviteText;
    	}
    	
    	protected function set acceptInviteText(acceptInviteText:UIComponent):void
    	{
    		if(_acceptInviteText != acceptInviteText)
    		{
    			_acceptInviteText = acceptInviteText;
    			_acceptInviteTextChanged  = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createAcceptInviteText():void
    	{
    		if(_acceptInviteText == null)
    		{
    			var text:Text = new Text();
    			text.text = "Accept invite";
    			text.styleName = "YoProfilePanelInvite";
    			text.buttonMode = true;
    			text.useHandCursor = true;
    			text.mouseChildren = false;
    			
    			text.addEventListener(
    				MouseEvent.CLICK,
    				function(event:MouseEvent):void
    				{
    					dispatchEvent(new Event("acceptInviteClicked"));
    				});
    			
    			_acceptInviteText = text;
    			if(acceptInviteVisible)
    			{
    				content.addChildAt(_acceptInviteText, 3);
    			}
    		}
    	}
    	
    	//----------------------------------
    	//  reject invite
    	//----------------------------------
    	
    	private var _rejectInviteText:UIComponent;
    	
    	private var _rejectInviteTextChanged:Boolean;
    	
    	protected function get rejectInviteText():UIComponent
    	{
    		return _rejectInviteText;
    	}
    	
    	protected function set rejectInviteText(rejectInviteText:UIComponent):void
    	{
    		if(_rejectInviteText != rejectInviteText)
    		{
    			_rejectInviteText = rejectInviteText;
    			_rejectInviteTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createRejectInviteTetx():void
    	{
    		if(_rejectInviteText == null)
    		{
    			var text:Text = new Text();
    			text.text = "Reject invite";
    			text.styleName = "YoProfilePanelInvite";
    			text.buttonMode = true;
    			text.useHandCursor = true;
    			text.mouseChildren = false;
    			
    			text.addEventListener(
    				MouseEvent.CLICK,
    				function(event:MouseEvent):void
    				{
    					dispatchEvent(new Event("rejectInviteClicked"));
    				});
    			
    			_rejectInviteText = text;
    			if(rejectInviteVisible)
    			{
    				content.addChildAt(_rejectInviteText, 3);
    			}
    		}
    	}
    	
    	//----------------------------------
    	//  twitter panel
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for twitterPanel component. 
    	 */    	
    	private var _twitterPanel:UIComponent;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _twitterPanel changes. 
    	 */    	
    	private var _twitterPanelChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies component to diplay twitter profile infirmation. 
    	 */    	
    	protected function get twitterPanel():UIComponent
    	{
    		return _twitterPanel;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies component to diplay twitter profile infirmation. 
    	 */
    	protected function set twitterPanel(twitterPanel:UIComponent):void
    	{
    		if(_twitterPanel != twitterPanel)
    		{
    			_twitterPanel = twitterPanel;
    			_twitterPanelChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected
    	 * Creates twitterPanel component. 
    	 */    	
    	protected function createTwitterPanel():void
    	{
    		if(_twitterPanel == null)
    		{
    			var panel:YoTwitterPanel = new YoTwitterPanel();
    			panel.label = "Twitter";
    			panel.percentWidth = 100;
    			panel.state = twitterState;
    			
    			_twitterPanel = panel;
    			content.addChild(_twitterPanel);
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Updates twitterPanel component with new values.
    	 */    	
    	protected function updateTwitter():void
    	{
    		var panel:YoTwitterPanel = twitterPanel as YoTwitterPanel;
    		
    		if(panel != null)
    		{
    			panel.login = twitterLogin;
    			panel.updateOnAddGomee = twitterUpdateOnAddGomee;
    			panel.updateOnSaveGomee = twitterUpdateOnSaveGomee;
    			panel.updateOnDeleteGomee = twitterUpdateOnDeleteGomee;
    			panel.state = twitterState;
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
    			content.styleName = "YoProfilePanelContent";
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
			
			createNameConatiner();
			createFirstNameText();
			createLastNameText();
			
			createEmailText();
			createSendInviteText();
			createRejectInviteTetx();
			createAcceptInviteText();
			createTwitterPanel();
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
    		
    		// update first name
    		if(_firstNameChanged || _firstNameTextChanged)
    		{
    			if(firstNameText != null)
    			{
    				updateFirstName();
    			}
    			
    			_firstNameChanged = false;
    			_firstNameTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update last name
    		if(_lastNameChanged || _lastNameTextChanged)
    		{
    			if(lastNameText != null)
    			{
    				updateLastName();
    			}
    			
    			_lastNameChanged = false;
    			_lastNameTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update email
    		if(_emailChanged || _emailTextChanged)
    		{
    			if(emailText != null)
    			{
    				updateEmail();
    			}
    			
    			_emailChanged = false;
    			_emailTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update send invite visibility
    		if(_sendInviteVisibleChanged)
    		{
    			if(content != null && sendInviteText != null)
    			{
    				if(sendInviteVisible)
    				{
    					if(!content.contains(sendInviteText))
    					{
    						content.addChildAt(sendInviteText, 3);
    					}
    				}
    				else
    				{
    					if(content.contains(sendInviteText))
    					{
    						content.removeChild(sendInviteText);
    					}
    				}
    			}
    		}
    		
    		// update reject invite visibility
    		if(_rejectInviteVisibleChanged)
    		{
    			if(content != null && rejectInviteText != null)
    			{
    				if(rejectInviteVisible)
    				{
    					if(!content.contains(rejectInviteText))
    					{
    						content.addChildAt(rejectInviteText, 3);
    					}
    				}
    				else
    				{
    					if(content.contains(rejectInviteText))
    					{
    						content.removeChild(rejectInviteText);
    					}
    				}
    			}
    		}
    		
    		// update accept invite visibility
    		if(_acceptInviteVisibleChanged)
    		{
    			if(content != null && acceptInviteText != null)
    			{
    				if(acceptInviteVisible)
    				{
    					if(!content.contains(acceptInviteText))
    					{
    						content.addChildAt(acceptInviteText, 3);
    					}
    				}
    				else
    				{
    					if(content.contains(acceptInviteText))
    					{
    						content.removeChild(acceptInviteText);
    					}
    				}
    			}
    		}
    		
    		// update twiiter visibility
    		if(_twitterVisibleChanged)
    		{
    			if(content != null && twitterPanel != null)
    			{
    				if(twitterVisible)
    				{
    					if(!content.contains(twitterPanel))
    					{
    						content.addChild(twitterPanel);
    					}
    				}
    				else
    				{
    					if(content.contains(twitterPanel))
    					{
    						content.removeChild(twitterPanel);
    					}
    				}
    			}
    		}
    		
    		// update twitter panel
    		if(
    			_twitterPanelChanged ||
    			_twitterLoginChanged ||
    			_twitterUpdateOnAddGomeeChanged ||
    			_twitterUpdateOnSaveGomeeChanged ||
    			_twitterUpdateOnDeleteGomeeChanged ||
    			_twitterStateChanged)
    		{
    			if(twitterPanel != null)
    			{
    				updateTwitter();
    			}
    			
    			_twitterPanelChanged = false;
    			_twitterLoginChanged = false;
    			_twitterUpdateOnAddGomeeChanged = false;
    			_twitterUpdateOnSaveGomeeChanged  = false;
    			_twitterUpdateOnDeleteGomeeChanged = false;
    			_twitterStateChanged = false;
    			
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