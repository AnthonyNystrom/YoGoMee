package controls.panel
{
	import mx.containers.Canvas;
	
	/**
	 * Represents marker substrate. 
	 */
	public class YoPanelSubstrate extends Canvas
	{
		/**
		 * Constructor. 
		 */		
		public function YoPanelSubstrate()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Override protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	/**
    	 * Draws substrate. 
    	 */    	
    	protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    	{
    		super.updateDisplayList(unscaledWidth, unscaledHeight);
    	}
	}
}