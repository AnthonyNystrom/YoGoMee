package domainModel.entities
{
	import domainModel.values.GomeeSource;
	import domainModel.values.GomeeType;
	
	public class Gomee
	{
		public function Gomee()
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
		
		private var _caption:String;
		
		public function get caption():String
		{
			return _caption;
		}
		
		public function set caption(caption:String):void
		{
			_caption = caption;
		}
		
		private var _address:String;
		
		public function get address():String
		{
			return _address;
		}
		
		public function set address(address:String):void
		{
			_address = address;
		}
		
		private var _description:String;
		
		public function get description():String
		{
			return _description;
		}
		
		public function set description(description:String):void
		{
			_description = description;
		}
		
		private var _lat:Number;
		
		public function get lat():Number
		{
			return _lat;
		}
		
		public function set lat(lat:Number):void
		{
			_lat = lat;
		}
		
		private var _lng:Number;
		
		public function get lng():Number
		{
			return _lng;
		}
		
		public function set lng(lng:Number):void
		{
			_lng = lng;
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
		
		private var _isPublic:Boolean;
		
		public function get common():Boolean
		{
			return _isPublic;
		}
		
		public function set common(isPublic:Boolean):void
		{
			_isPublic = isPublic;
		}
		
		private var _tags:Array = [];
		
		public function get tags():Array
		{
			return _tags;
		}
		
		public function set tags(tags:Array):void
		{
			_tags = tags;
		}
		
		public function toString():String
		{
			return "gomee{id: " + id + ", owner: " + owner + "}";
		}
	}
}