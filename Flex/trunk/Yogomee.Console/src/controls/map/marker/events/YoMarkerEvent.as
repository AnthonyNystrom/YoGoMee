package controls.map.marker.events
{
	import flash.events.Event;
	
	public class YoMarkerEvent extends Event
	{
		public static const RemoveClick:String = "YoMarkerEvent_RemoveClick";
		public static const EditClick:String = "YoMarkerEvent_EditClick";
		public static const SaveClick:String = "YoMarkerEvent_SaveClick";
		public static const CollapseClick:String = "YoMarkerEvent_CollapseClick";
		public static const ResizePan:String = "YoMarkerEvent_ResizePan";
		public static const ContentChanged:String = "YoMarkerEvent_ContentChanged"
		
		public function YoMarkerEvent(type:String)
		{
			super(type);
		}
	}
}