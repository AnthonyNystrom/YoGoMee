package controls.text
{
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.TextInput;
	import mx.events.ResizeEvent;

	public class YoTextInput extends TextInput
	{
		public function YoTextInput()
		{
			super();
			addEventListener(Event.CHANGE, changeHandler);
			addEventListener(ResizeEvent.RESIZE, resizeHandler);
		}
		
		protected override function measure():void
		{
			super.measure();
			measuredWidth += 30;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected override function childrenCreated():void
		{
			textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function changeHandler(event:Event):void
		{
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function resizeHandler(event:ResizeEvent):void
		{
			if(measuredWidth <= width)
			{
				textField.autoSize = TextFieldAutoSize.LEFT;
			}
			else
			{
				textField.autoSize = TextFieldAutoSize.NONE;
			}
		}
	}
}