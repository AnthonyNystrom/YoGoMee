package domainModel.values
{
	public class GomeeType
	{
		private static var _intTypeMap:Object = new Object();
		
		public static const Text:GomeeType = new GomeeType(0);
		public static const Photo:GomeeType = new GomeeType(1);
		public static const Video:GomeeType = new GomeeType(2);
		
		public static function fromInt(value:int):GomeeType
		{
			return _intTypeMap[value];
		}
		
		public function GomeeType(value:int)
		{
			_value = value;
			_intTypeMap[value] = this;
		}
		
		private var _value:int;
		
		public function get value():int
		{
			return _value;
		}
	}
}