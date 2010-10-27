package defer
{
	public class Failure
	{
		public function Failure(value:*)
		{
			this._value = value;
		}
		
		private var _value:*;
		
		public function get value():*
		{
			return this._value;
		}
	}
}
