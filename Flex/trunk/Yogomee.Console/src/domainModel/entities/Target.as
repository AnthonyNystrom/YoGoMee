package domainModel.entities
{
	public class Target
	{
		public function Target()
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
		
		private var _event:Event;
		
		public function get event():Event
		{
			return _event;
		}
		
		public function set event(event:Event):void
		{
			_event = event;
		}
	}
}