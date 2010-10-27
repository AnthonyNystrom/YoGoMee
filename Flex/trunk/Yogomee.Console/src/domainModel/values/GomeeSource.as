package domainModel.values
{
	public class GomeeSource
	{
		private static var _intSourceMap:Object = new Object();
		
		public static const Mine:GomeeSource = new GomeeSource(0);
		public static const Theirs:GomeeSource = new GomeeSource(1);
		public static const Google:GomeeSource = new GomeeSource(2);
		
		public static function fromInt(value:int):GomeeSource
		{
			return _intSourceMap[value];
		}
		
		public function GomeeSource(value:int)
		{
			_value = value;
			_intSourceMap[value] = this;
		}
		
		private var _value:int;
		
		public function get value():int
		{
			return _value;
		}
	}
}