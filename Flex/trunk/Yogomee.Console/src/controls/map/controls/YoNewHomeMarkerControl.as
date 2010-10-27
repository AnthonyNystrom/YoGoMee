package controls.map.controls
{
	import controls.map.marker.YoHomeMarker;
	
	public class YoNewHomeMarkerControl extends YoNewMarkerControl
	{
		/**
		 * Constructor. 
		 */		
		public function YoNewHomeMarkerControl()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  marker
    	//----------------------------------
    	
    	/**
    	 * @override
    	 * Creates marker component. 
    	 */    	
    	protected override function createMarker():void
    	{
    		if(marker == null)
    		{
    			var m:YoHomeMarker = new YoHomeMarker();
    			m.caption = "New Home";
    			m.address = "Input address here";
    			m.description = "Input description here";
    			m.common = true;
    			m.tags = "";
    			
    			m.profileVisible = false;
    			m.editableProfileVisible = false;
    			m.deletable = false;
    			
    			marker = m;
    			addChild(marker);
    		}
    	}
	}
}