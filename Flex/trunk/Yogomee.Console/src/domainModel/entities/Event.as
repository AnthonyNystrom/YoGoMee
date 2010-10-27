package domainModel.entities
{
	public class Event
	{
		public static const TEXT_EVENT:int = 1;
		public static const URL_EVENT:int = 2;
		public static const IMAGE_EVENT:int = 3;
		public static const SMS_EVENT:int = 4;
		public static const EMAIL_EVENT:int = 5;
		
		public function Event()
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
		
		private var _gomee:Gomee;
		
		public function get gomee():Gomee
		{
			return _gomee;
		}
		
		public function set gomee(gomee:Gomee):void
		{
			_gomee = gomee;
		}
		
		private var _radius:Number;
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(radius:Number):void
		{
			_radius = radius;
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
		
		private var _data:String;
		
		public function get data():String
		{
			return _data;
		}
		
		public function set data(data:String):void
		{
			_data = data;
		}
	}
}