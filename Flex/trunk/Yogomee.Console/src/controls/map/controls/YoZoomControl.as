package controls.map.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Image;

	public class YoZoomControl extends HBox
	{
		public function YoZoomControl()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			var imageIn:Image = new Image();
			imageIn.source = "resources/zoom-in.png";
			imageIn.mouseChildren = false;
			imageIn.useHandCursor = true;
			imageIn.buttonMode = true;
			
			imageIn.addEventListener(
				MouseEvent.CLICK,
				function(event:MouseEvent):void
				{
					dispatchEvent(new Event("zoomInClicked"));
				});
			
			addChild(imageIn);
			 
			var imageOut:Image = new Image();
			imageOut.source = "resources/zoom-out.png";
			imageOut.mouseChildren = false;
			imageOut.useHandCursor = true;
			imageOut.buttonMode = true;
			
			imageOut.addEventListener(
				MouseEvent.CLICK,
				function(event:MouseEvent):void
				{
					dispatchEvent(new Event("zoomOutClicked"));
				});
			
			addChild(imageOut); 
		}
		
	}
}