package controls.notifier
{
	import flash.events.Event;
	
	public class YoNotifierEvent extends Event
	{
		public static const NOTIFIER_CLICKED:String = "notifierClicked";
		
		public function YoNotifierEvent(type:String, object:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_object = object;
		}
		
		private var _object:Object;
		
		public function get object():Object
		{
			return _object;
		}
		
	}
}