package controls.map.controls
{
	import controls.map.marker.YoGomeeMarker;
	
	public class YoNewGomeeMarkerControl extends YoNewMarkerControl
	{
		/**
		 * Constructor. 
		 */		
		public function YoNewGomeeMarkerControl()
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
    			var m:YoGomeeMarker = new YoGomeeMarker();
    			
    			m.caption = "New Gomee";
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