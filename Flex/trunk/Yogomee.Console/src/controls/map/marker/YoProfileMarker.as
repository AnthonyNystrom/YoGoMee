package controls.map.marker
{
	import controls.panel.YoEditableProfilePanel;
	import controls.panel.YoPanelState;
	import controls.panel.YoProfilePanel;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	/**
	 * Marker that can display profile information. 
	 */	
	public class YoProfileMarker extends YoLocationMarker
	{
		/**
		 * Constructor. 
		 */		
		public function YoProfileMarker()
		{
			super();
			
			_profileVisible = true;
			_editableProfileVisible = true;
			_twitterVisible = true;
			_editableTwitterVisible = true;
			
			_profileState = YoPanelState.Expanded;
			_editableProfileState = YoPanelState.Expanded;
			
			_twitterState = YoPanelState.Colapsed;
			_editableTwitterState = YoPanelState.Colapsed;
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
		 * Specifies profile login. 
		 */		
		public function get login():String
		{
			return _login;
		}
		
		/**
		 * Specifies profile login. 
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
    	//  first name
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for firstName property. 
		 */		
		private var _firstName:String;
		
		/**
		 * @private
		 * Flag to indicate when _firstName _changes. 
		 */		
		private var _firstNameChanged:Boolean;
		
		/**
		 * Specifies profile first name. 
		 */		
		public function get firstName():String
		{
			return _firstName;
		}
		
		/**
		 * Specifies profile first name. 
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
    	//  last name
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
		 * Specifies profile last name. 
		 */		
		public function get lastName():String
		{
			return _lastName;
		}
		
		/**
		 * Specifies profile last name. 
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
		 * Storage for _email property. 
		 */		
		private var _email:String;
		
		/**
		 * @private
		 * Flag to indicate when _email changes. 
		 */		
		private var _emailChanged:Boolean;
		
		/**
		 * Specifies profile email. 
		 */		
		public function get email():String
		{
			return _email;
		}
		
		/**
		 * Specifies profile email. 
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
    	//  twitter login
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for twitterLogin property. 
		 */		
		private var _twitterLogin:String;
		
		/**
		 * @private
		 * Flag to indicate when _twitterLogin changes. 
		 */		
		private var _twitterLoginChanged:Boolean;
		
		/**
		 * Specififes twitter login. 
		 */		
		public function get twitterLogin():String
		{
			return _twitterLogin;
		}
		
		/**
		 * Specififes twitter login. 
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
    	//  twitter secret
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for twitterSecret property. 
		 */		
		private var _twitterSecret:String;
		
		/**
		 * @private
		 * Flag to indicate whne _twitterSecret changes. 
		 */		
		private var _twitterSecretChanged:Boolean;
		
		/**
		 * Specifies twitter secret. 
		 */		
		public function get twitterSecret():String
		{
			return _twitterSecret;
		}
		
		/**
		 * Specifies twitter secret. 
		 */
		public function set twitterSecret(twitterSecret:String):void
		{
			if(_twitterSecret != twitterSecret)
			{
				_twitterSecret = twitterSecret;
				_twitterSecretChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  twitterUpdateOnAddGomee
    	//----------------------------------
		
		/**
		 * @priavte
		 * Storage for twitterUpdateOnAddGomee property. 
		 */		
		private var _twitterUpdateOnAddGomee:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _twitterUpdateOnAddGomee changes. 
		 */		
		private var _twitterUpdateOnAddGomeeChanged:Boolean;
		
		/**
		 * If true - twitter status will be updated when gomee added. 
		 */		
		public function get twitterUpdateOnAddGomee():Boolean
		{
			return _twitterUpdateOnAddGomee;
		}
		
		/**
		 * If true - twitter status will be updated when gomee added. 
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
		 * If true - twitter status will be updated when gomee saved. 
		 */		
		public function get twitterUpdateOnSaveGomee():Boolean
		{
			return _twitterUpdateOnSaveGomee;
		}
		
		/**
		 * If true - twitter status will be updated when gomee saved. 
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
		 * Flag to indicate when _twitterUpdateOnDeleteGomee changes. 
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
		
		//----------------------------------
    	//  profileState
    	//----------------------------------
		
		private var _profileState:YoPanelState;
		
		private var _profileStateChanged:Boolean;
		
		public function get profileState():YoPanelState
		{
			return _profileState;
		}
		
		public function set profileState(profileState:YoPanelState):void
		{
			if(_profileState != profileState)
			{
				_profileState = profileState;
				_profileStateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  profileVisible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for profileVisible peoperty. 
		 */		
		private var _profileVisible:Boolean = true;
		
		/**
		 * @private
		 * Flag to indicate when _profileVisible changes. 
		 */		
		private var _profileVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of profile panel. 
		 */		
		public function get profileVisible():Boolean
		{
			return _profileVisible;
		}
		
		/**
		 * Specifies visibility of profile panel. 
		 */
		public function set profileVisible(profileVisible:Boolean):void
		{
			if(_profileVisible != profileVisible)
			{
				_profileVisible = profileVisible;
				_profileVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  editableProfileState
    	//----------------------------------
		
		private var _editableProfileState:YoPanelState;
		
		private var _editableProfileStateChanged:Boolean;
		
		public function get editableProfileState():YoPanelState
		{
			return _editableProfileState;
		}
		
		public function set editableProfileState(editableProfileState:YoPanelState):void
		{
			if(_editableProfileState != editableProfileState)
			{
				_editableProfileState = editableProfileState;
				_editableProfileStateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  editableProfileVisible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for ediatbleProfileVisible property. 
		 */		
		private var _editableProfileVisible:Boolean = true;
		
		/**
		 * @private
		 * Flag to indicate when _editableProfileVisible changes. 
		 */		
		private var _editableProfileVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of profile panel in edit state. 
		 */		
		public function get editableProfileVisible():Boolean
		{
			return _editableProfileVisible;
		}
		
		/**
		 * Specifies visibility of profile panel in edit state. 
		 */
		public function set editableProfileVisible(editableProfileVisible:Boolean):void
		{
			if(_editableProfileVisible != editableProfileVisible)
			{
				_editableProfileVisible = editableProfileVisible;
				_editableProfileVisibleChanged  = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  twitterState
    	//----------------------------------
		
		private var _twitterState:YoPanelState;
		
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
    	//  editableTwitterState
    	//----------------------------------
		
		private var _editableTwitterState:YoPanelState;
		
		private var _editableTwitterStateChanged:Boolean;
		
		public function get editableTwitterState():YoPanelState
		{
			return _editableTwitterState;
		}
		
		public function set editableTwitterState(editableTwitterState:YoPanelState):void
		{
			if(_editableTwitterState != editableTwitterState)
			{
				_editableTwitterState = editableTwitterState;
				_editableTwitterStateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  editableTwitterVisible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for ediatbleTwitterVisible property. 
		 */		
		private var _editableTwitterVisible:Boolean = true;
		
		/**
		 * @private
		 * Flag to indicate whne _editableTwitterVisible changes. 
		 */		
		private var _editableTwitterVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of twitter panel in edit state. 
		 */		
		public function get editableTwitterVisible():Boolean
		{
			return _editableTwitterVisible;
		}
		
		/**
		 * Specifies visibility of twitter panel in edit state. 
		 */
		public function set editableTwitterVisible(editableTwitterVisible:Boolean):void
		{
			if(_editableTwitterVisible != editableTwitterVisible)
			{
				_editableTwitterVisible = editableTwitterVisible;
				_editableTwitterVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  profilePanel
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for profile panel component. 
		 */		
		private var _profilePanel:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _profilePanel changes. 
		 */		
		private var _profilePanelChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to display profile information. 
		 */		
		protected function get profilePanel():UIComponent
		{
			return _profilePanel;
		}
		
		/**
		 * @protected
		 * Specifies component to display profile information. 
		 */
		protected function set profilePanel(profilePanel:UIComponent):void
		{
			if(_profilePanel != profilePanel)
			{
				_profilePanel = profilePanel
				_profilePanelChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates profile panel component. 
		 */		
		protected function createProfilePanel():void
		{
			if(_profilePanel == null)
			{
				var profilePanel:YoProfilePanel = new YoProfilePanel();
				profilePanel.percentWidth = 100;
				
				profilePanel.addEventListener(
					"inviteClicked",
					function(event:Event):void
					{
						dispatchEvent(new Event("inviteClicked"));
					});
				
				profilePanel.addEventListener(
					"acceptInviteClicked",
					function(event:Event):void
					{
						dispatchEvent(new Event("acceptInviteClicked"));
					});
				
				profilePanel.addEventListener(
					"rejectInviteClicked",
					function(event:Event):void
					{
						dispatchEvent(new Event("rejectInviteClicked"));
					});
				
				_profilePanel = profilePanel;
				contentFrame.addChild(_profilePanel);
			}
		}
		
		/**
		 * @protected 
		 * Updates profile panel with new values.
		 */		
		protected function updateProfile():void
		{
			var panel:YoProfilePanel = _profilePanel as YoProfilePanel;
			
			if(panel != null)
			{
				panel.login = login;
				panel.firstName = firstName;
				panel.lastName = lastName;
				panel.email = email;
				panel.sendInviteVisible = sendInviteVisible;
				panel.acceptInviteVisible = acceptInviteVisible;
				panel.rejectInviteVisible = rejectInviteVisible;
				panel.twitterVisible = twitterVisible;
				panel.twitterLogin = twitterLogin;
				panel.twitterUpdateOnAddGomee = twitterUpdateOnAddGomee;
				panel.twitterUpdateOnSaveGomee = twitterUpdateOnSaveGomee;
				panel.twitterUpdateOnDeleteGomee = twitterUpdateOnDeleteGomee;
				panel.state = profileState;
				panel.twitterState = twitterState;
			}
		}
		
		//----------------------------------
    	//  editableProfilePanel
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for editableProfilePanel component. 
		 */		
		private var _editableProfilePanel:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _editableProfilePanel changes. 
		 */		
		private var _editableProfilePanelChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies to dosplay profile indirmation in edit state. 
		 */		
		protected function get editableProfilePanel():UIComponent
		{
			return _editableProfilePanel;
		}
		
		/**
		 * @protected
		 * Specifies to dosplay profile indirmation in edit state. 
		 */
		protected function set editableProfilePanel(editapleProfilePanel:UIComponent):void
		{
			if(_editableProfilePanel != editableProfilePanel)
			{
				_editableProfilePanel = editableProfilePanel;
				_editableProfilePanelChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Create editable profile panel component.
		 */		
		protected function createEditableProfilePanel():void
		{
			if(_editableProfilePanel == null)
			{
				var panel:YoEditableProfilePanel = new YoEditableProfilePanel();
				
				panel.addEventListener(
					"FirstNameChanged",
					function(event:Event):void
					{
						firstName = panel.typedFirstName;
					});
					
				panel.addEventListener(
					"LastNameChanged",
					function(event:Event):void
					{
						lastName = panel.typedLastName;
					});
					
				panel.addEventListener(
					"EmailChanged",
					function(event:Event):void
					{
						email = panel.typedEmail;
					});
					
				panel.addEventListener(
					"TwitterLoginChanged",
					function(event:Event):void
					{
						twitterLogin = panel.typedTwitterLogin;
					});
					
				panel.addEventListener(
					"TwitterSecretChanged",
					function(event:Event):void
					{
						twitterSecret = panel.typedTwitterSecret;
					});
					
				panel.addEventListener(
					"TwitterUpdateOnAddGomeeChanged",
					function(event:Event):void
					{
						twitterUpdateOnAddGomee = panel.typedTwitterUpdateOnAddGomee;
					});
					
				panel.addEventListener(
					"TwitterUpdateOnSaveGomeeChanged",
					function(event:Event):void
					{
						twitterUpdateOnSaveGomee = panel.typedTwitterUpdateOnSaveGomee;
					});
					
				panel.addEventListener(
					"TwitterUpdateOnDeleteGomeeChanged",
					function(event:Event):void
					{
						twitterUpdateOnDeleteGomee = panel.typedTwitterUpdateOnDeleteGomee;
					});
				
				_editableProfilePanel = panel;
				_editableProfilePanel.percentWidth = 100;
				editFrame.addChild(_editableProfilePanel);
			} 
		}
		
		/**
		 * @protected
		 * Update editable profile panel with new values. 
		 */		
		protected function updateEditableProfile():void
		{
			var panel:YoEditableProfilePanel = editableProfilePanel as YoEditableProfilePanel;
			
			if(panel != null)
			{
				panel.login = login;
				panel.firstName = firstName;
				panel.lastName = lastName;
				panel.email = email;
				panel.twitterVisible = editableTwitterVisible;
				panel.twitterLogin = twitterLogin;
				panel.twitterSecret = twitterSecret;
				panel.twitterUpdateOnAddGomee = twitterUpdateOnAddGomee;
				panel.twitterUpdateOnSaveGomee = twitterUpdateOnSaveGomee;
				panel.twitterUpdateOnDeleteGomee = twitterUpdateOnDeleteGomee;
				panel.state = editableProfileState;
				panel.twitterState = editableTwitterState;
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
    		createProfilePanel();
    		createEditableProfilePanel();
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
    		
    		// update profile
    		if(
    			_profilePanelChanged ||
    			_editableProfilePanelChanged ||
    			_loginChanged ||
    			_firstNameChanged ||
    			_lastNameChanged ||
    			_emailChanged ||
    			_sendInviteVisibleChanged ||
    			_acceptInviteVisibleChanged ||
    			_rejectInviteVisibleChanged ||
    			_twitterLoginChanged ||
    			_twitterSecretChanged ||
    			_twitterUpdateOnAddGomeeChanged ||
    			_twitterUpdateOnSaveGomeeChanged ||
    			_twitterUpdateOnDeleteGomeeChanged ||
    			_profileVisibleChanged ||
    			_editableProfileVisibleChanged ||
    			_twitterVisibleChanged || 
    			_editableTwitterVisibleChanged ||
    			_profileStateChanged ||
    			_editableProfileStateChanged ||
    			_twitterStateChanged ||
    			_editableTwitterStateChanged)
    		{
    			if(profilePanel != null)
    			{
    				updateProfile();
    			}
    			
    			if(profilePanel != null && contentFrame != null)
    			{
    				if(profileVisible)
    				{
    					if(!contentFrame.contains(profilePanel))
    					{
    						contentFrame.addChild(profilePanel);
    					}
    				}
    				else
    				{
    					if(contentFrame.contains(profilePanel))
    					{
    						contentFrame.removeChild(profilePanel);
    					}
    				}
    			}
    			
    			if(editableProfilePanel != null)
    			{
    				updateEditableProfile();
    			}
    			
    			if(editableProfilePanel != null && editFrame != null)
    			{
    				if(editableProfileVisible)
    				{
    					if(!editFrame.contains(editableProfilePanel))
    					{
    						editFrame.addChild(editableProfilePanel);
    					}
    				}
    				else
    				{
    					if(editFrame.contains(editableProfilePanel))
    					{
    						editFrame.removeChild(editableProfilePanel);
    					}
    				}
    			}
    			
    			_profilePanelChanged = false;
    			_loginChanged = false;
    			_firstNameChanged = false;
    			_lastNameChanged = false;
    			_emailChanged = false;
    			_sendInviteVisibleChanged = false;
    			_acceptInviteVisibleChanged = false;
    			_rejectInviteVisibleChanged = false;
    			_twitterLoginChanged = false;
    			_twitterSecretChanged = false;
    			_twitterUpdateOnAddGomeeChanged = false;
    			_twitterUpdateOnSaveGomeeChanged = false;
    			_twitterUpdateOnDeleteGomeeChanged = false;
    			_profileVisibleChanged = false;
    			_editableProfileVisibleChanged = false;
    			_twitterVisibleChanged = false;
    			_editableTwitterVisibleChanged = false;
    			_profileStateChanged = false;
    			_editableProfileStateChanged = false;
    			_twitterStateChanged = false;
    			_editableTwitterStateChanged = false;
    			
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