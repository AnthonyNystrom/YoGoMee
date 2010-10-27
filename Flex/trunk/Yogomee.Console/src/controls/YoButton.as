package controls
{
	import mx.controls.Button;

	public class YoButton extends Button
	{
		[Inspectable(defaultValue = true)]
		private var _active:Boolean = true;
		
		public function set active(value:Boolean):void
		{
			_active = value;
			enabled = value;
			useHandCursor = value;
			selected = !value;
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function YoButton()
		{
			super();
		}
		
		public override function initialize():void
		{
			super.initialize();
			buttonMode = true;
			active = true;
		}
		
	}
}