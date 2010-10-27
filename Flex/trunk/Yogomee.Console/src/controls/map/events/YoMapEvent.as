package controls.map.events
{
	import flash.events.Event;

	public class YoMapEvent extends Event
	{
		public static const ViewChangeStep:String = "YoMapEvent_ViewChangeStep";
		public static const ViewChangeEnd:String = "YoMapEvent_ViewChangedEnd";
		public static const MapReady:String = "YoMapEvent_MapReady";
		public static const HomeAdded:String = "YoMapEvent_HomeAdded";
		public static const HomeRemoved:String = "YoMapEvent_HomeRemoved";
		
		public function YoMapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}