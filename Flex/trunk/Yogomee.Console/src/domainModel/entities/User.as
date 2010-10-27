package domainModel.entities
{
	public class User
	{
		public function User()
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
		
		private var _login:String;
		
		public function get login():String
		{
			return _login;
		}
		
		public function set login(login:String):void
		{
			_login = login;
		}
		
		private var _secret:String;
		
		public function get secret():String
		{
			return _secret;
		}
		
		public function set secret(secret:String):void
		{
			_secret = secret;
		}
		
		public function toString():String
		{
			return "user{id: " + id +", login: " + login + "}";
		} 		
	}
}