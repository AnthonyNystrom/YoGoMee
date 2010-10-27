package domainModel.entities
{
	public class Profile
	{
		public function Profile()
		{
		}
		
		private var _id:String;
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(id:String):void
		{
			_id = id;
		}
		
		private var _user:User;
		
		public function get user():User
		{
			return _user;
		}
		
		public function set user(user:User):void
		{
			_user = user;
		}
		
		private var _firstName:String;
		
		public function get firstName():String
		{
			return _firstName;
		}
		
		public function set firstName(firstName:String):void
		{
			_firstName = firstName;
		}
		
		private var _lastName:String;
		
		public function get lastName():String
		{
			return _lastName;
		}
		
		public function set lastName(lastName:String):void
		{
			_lastName = lastName;
		}
		
		private var _email:String;
		
		public function get email():String
		{
			return _email;
		}
		
		public function set email(email:String):void
		{
			_email = email;
		}
		
		private var _twitterLogin:String;
		
		public function get twitterLogin():String
		{
			return _twitterLogin;
		}
		
		public function set twitterLogin(twitterLogin:String):void
		{
			_twitterLogin = twitterLogin;
		}
		
		private var _twitterSecret:String;
		
		public function get twitterSecret():String
		{
			return _twitterSecret;
		}
		
		public function set twitterSecret(twitterSecret:String):void
		{
			_twitterSecret = twitterSecret;
		}
		
		private var _twitterUpdateOnAddGomee:Boolean;
		
		public function get twitterUpdateOnAddGomee():Boolean
		{
			return _twitterUpdateOnAddGomee;
		}
		
		public function set twitterUpdateOnAddGomee(twitterUpdateOnAddGomee:Boolean):void
		{
			_twitterUpdateOnAddGomee = twitterUpdateOnAddGomee;
		}
		
		private var _twitterUpdateOnSaveGomee:Boolean;
		
		public function get twitterUpdateOnSaveGomee():Boolean
		{
			return _twitterUpdateOnSaveGomee;
		}
		
		public function set twitterUpdateOnSaveGomee(twitterUpdateOnSaveGomee:Boolean):void
		{
			_twitterUpdateOnSaveGomee = twitterUpdateOnSaveGomee;
		}
		
		private var _twitterUpdateOnDeleteGomee:Boolean;
		
		public function get twitterUpdateOnDeleteGomee():Boolean
		{
			return _twitterUpdateOnDeleteGomee;
		}
		
		public function set twitterUpdateOnDeleteGomee(twitterUpdateOnDeleteGomee:Boolean):void
		{
			_twitterUpdateOnDeleteGomee = twitterUpdateOnDeleteGomee;
		}
		
		private var _gomees:Array;
		
		public function getGomees():Array
		{
			return _gomees;
		}
		
		public function setGomees(gomees:Array):void
		{
			_gomees = gomees;
		}
		
		public function toString():String
		{
			return "profile{id: " + id + ", " + user + ", firstName: " + firstName + ", lastName: " + lastName + ", email:" + email + " }";
		}
	}
}