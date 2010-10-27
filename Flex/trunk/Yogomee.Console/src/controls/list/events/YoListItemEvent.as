package controls.list.events
{
	import flash.events.Event;
	
	public class YoListItemEvent extends Event
	{
		public static const EditClick:String = "YoListItemEvent_EditClick";
		public static const ItemClick:String = "YoListItemEvent_ItemClick";
		public static const RemoveClick:String = "YoListItemEvent_RemoveClick";
		
		public function YoListItemEvent(type:String)
		{
			super(type);
		}

	}
}