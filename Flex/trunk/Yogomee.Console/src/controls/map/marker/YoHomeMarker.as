package controls.map.marker
{
	import controls.panel.YoEditableLocationPanel;
	import controls.panel.YoEditableProfilePanel;
	import controls.panel.YoLocationPanel;
	import controls.panel.YoPanelState;
	import controls.panel.YoProfilePanel;
	
	/**
	 * Marker that can display user`s home. 
	 */	
	public class YoHomeMarker extends YoProfileMarker
	{
		[Embed(source="resources/user_marker.png")]
		private static var iconImage:Class;
		
		/**
		 * Constructor. 
		 */		
		public function YoHomeMarker()
		{
			super();
			twitterVisible = false;
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
    			lPanel.headerVisible = true;
    			lPanel.label = "Location";
    			lPanel.collapsable = true;
    			lPanel.state = YoPanelState.Colapsed;
    		}
    		
    		var elPanel:YoEditableLocationPanel = editableLocationPanel as YoEditableLocationPanel;
    		
    		if(elPanel != null)
    		{
    			elPanel.headerVisible = true;
    			elPanel.label = "Location";
    			elPanel.collapsable = true;
    			elPanel.state = YoPanelState.Colapsed;
    		}
    		
    		var pPanel:YoProfilePanel = profilePanel as YoProfilePanel;
    		
    		if(pPanel != null)
    		{
    			pPanel.headerVisible = false;
    		//	pPanel.state = YoPanelState.Expanded;
    		}
    		
    		var epPanel:YoEditableProfilePanel = editableProfilePanel as YoEditableProfilePanel;
    		
    		if(epPanel != null)
    		{
    			epPanel.headerVisible = false;
    		//	epPanel.state = YoPanelState.Expanded;
    		}
    		
    		contentFrame.setChildIndex(profilePanel, 0);
    		contentFrame.setChildIndex(locationPanel, 1);
    		
    		editFrame.setChildIndex(editableProfilePanel, 0);
    		editFrame.setChildIndex(editableLocationPanel, 1);
    		
    		icon.source = iconImage;
    	}
	}
}