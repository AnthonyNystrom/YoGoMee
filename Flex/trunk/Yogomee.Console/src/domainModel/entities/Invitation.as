package domainModel.entities
{
	public class Invitation
	{
		public static const EVENT_INVITATION:int = 0;
		public static const FRIEND_INVITATION:int = 1;
		
		public static const ACCEPTED_INVITATION:int = 0;
		public static const REJECTED_INVITATION:int = 1;
		public static const WAITING_INVITATION:int = 2;
		
		public function Invitation()
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
		
		private var _owner:User;
		
		public function get owner():User
		{
			return _owner;
		}
		
		public function set owner(owner:User):void
		{
			_owner = owner;
		}
		
		private var _creator:User;
		
		public function get creator():User
		{
			return _creator;
		}
		
		public function set creator(creator:User):void
		{
			_creator = creator;
		}
		
		private var _event:Event;
		
		public function get event():Event
		{
			return _event;
		}
		
		public function set event(event:Event):void
		{
			_event = event;
		}
		
		private var _type:int;
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(type:int):void
		{
			_type = type;
		}
		
		private var _status:int;
		
		public function get status():int
		{
			return _status;
		}
		
		public function set status(status:int):void
		{
			_status = status;
		}
	}
}