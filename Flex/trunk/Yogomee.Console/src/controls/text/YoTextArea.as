package controls.text
{
	import flash.events.Event;
	import flash.text.TextLineMetrics;
	
	import mx.controls.TextArea;
	import mx.core.ScrollPolicy;
	import mx.events.ResizeEvent;

	public class YoTextArea extends TextArea
	{
		public function YoTextArea()
		{
			super();
			addEventListener(Event.CHANGE, changeHandler);
			addEventListener(ResizeEvent.RESIZE, resizeHandler);
		}
		
		protected override function measure():void
		{
			super.measure();
			
			if(textField != null)
			{
				var h:Number = 10;
				var w:Number = 0;
				
				textField.validateNow();
				
				for(var i:int = 0; i < textField.numLines; i++)
				{
					var m:TextLineMetrics = textField.getLineMetrics(i);
					h += m.height;
					w = Math.max(w, m.width + 30);
				}
				
				measuredWidth = Math.max(w, measuredWidth);
				measuredHeight = Math.max(h, measuredHeight);
			}
		}
		
		private function changeHandler(event:Event):void
		{
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function resizeHandler(event:ResizeEvent):void
		{
			if(measuredWidth > width)
			{
				horizontalScrollPolicy = ScrollPolicy.ON;
			}
			else
			{
				textField.scrollH = 0;
				horizontalScrollPolicy = ScrollPolicy.OFF;
			}

			if(measuredHeight > height)
			{
				verticalScrollPolicy = ScrollPolicy.ON;
			} 
			else
			{
				textField.scrollH = 0;
				verticalScrollPolicy = ScrollPolicy.OFF;
			}
		}
	}
}