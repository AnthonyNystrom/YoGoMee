package controls.map.marker
{
	import controls.panel.YoEditableLocationPanel;
	import controls.panel.YoEditableProfilePanel;
	import controls.panel.YoLocationPanel;
	import controls.panel.YoPanelState;
	import controls.panel.YoProfilePanel;
	
	/**
	 * Marker that represents gomee on map. 
	 */	
	public class YoGomeeMarker extends YoProfileMarker
	{
		[Embed(source="resources/marker.png")]
		private static var iconImage:Class;
		
		/**
		 * Constructor. 
		 */		
		public function YoGomeeMarker()
		{
			super();
			profileVisible = false;
			editableProfileVisible = false;
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Override protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	/**
    	 * @override
    	 * Create and add children. 
    	 */    	
    	protected override function createChildren():void
    	{
    		super.createChildren();
    		
    		var lPanel:YoLocationPanel = locationPanel as YoLocationPanel;
    		
    		if(lPanel != null)
    		{
    			lPanel.headerVisible = false;
    			lPanel.state = YoPanelState.Expanded;
    		}
    		
    		var elPanel:YoEditableLocationPanel = editableLocationPanel as YoEditableLocationPanel;
    		
    		if(elPanel != null)
    		{
    			elPanel.headerVisible = false;
    			elPanel.state = YoPanelState.Expanded;
    		}
    		
    		var pPanel:YoProfilePanel = profilePanel as YoProfilePanel;
    		
    		if(pPanel != null)
    		{
    			pPanel.headerVisible = true;
    			pPanel.label = "Profile";
    			pPanel.collapsable = true;
    			pPanel.state = YoPanelState.Colapsed;
    		}
    		
    		var epPanel:YoEditableProfilePanel = editableProfilePanel as YoEditableProfilePanel;
    		
    		if(epPanel != null)
    		{
    			epPanel.headerVisible = true;
    			epPanel.label = "Profile";
    			epPanel.collapsable = true;
    			epPanel.state = YoPanelState.Colapsed;
    		}
    		
    		icon.source = iconImage;
    	}
	}
}