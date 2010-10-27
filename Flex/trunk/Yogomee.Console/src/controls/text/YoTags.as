package controls.text
{
	import mx.containers.HBox;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	public class YoTags extends UIComponent
	{
		/**
		 * Constructor. 
		 */		
		public function YoTags()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  tags
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for tags property. 
		 */		
		private var _tags:String;
		
		/**
		 * @private
		 * Flag to indicate when _tags changes. 
		 */		
		private var _tagsChanged:Boolean;
		
		/**
		 * Specifies comma separated tags list. 
		 */		
		public function get tags():String
		{
			return _tags;
		}
		
		/**
		 * Specifies comma separated tags list. 
		 */
		public function set tags(tags:String):void
		{
			if(_tags != tags)
			{
				_tags = tags;
				_tagsChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Storage for tagsBox property. 
		 */		
		private var _tagsBox:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _tagsBoxChanged. 
		 */		
		private var _tagsBoxChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to display tags. 
		 */		
		protected function get tagsBox():UIComponent
		{
			return _tagsBox;
		}
		
		/**
		 * @protected
		 * Specifies component to display tags. 
		 */
		protected function set tagsBox(tagsBox:UIComponent):void
		{
			if(_tagsBox != tagsBox)
			{
				_tagsBox = tagsBox;
				_tagsBoxChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates tagsBox component.
		 */		
		protected function createTagsBox():void
		{
			if(tagsBox == null)
			{
				tagsBox = new HBox();
				tagsBox.setStyle("horizontalGap", 0);
				addChild(tagsBox);
			}
		}
		
		/**
		 * @protected 
		 * Updates tagsBox component with new values.
		 */		
		protected function updateTags():void
		{
			var box:HBox = tagsBox as HBox;
			
			if(box != null)
			{
				box.removeAllChildren();
				
				if(tags != null)
				{
					var tagsStrings:Array = StringUtil.trimArrayElements(tags, ",").split(",");
				
					for(var i:int = 0; i < tagsStrings.length; i++)
					{
						var tagBox:HBox = new HBox();
						tagBox.setStyle("horizontalGap", 0);
						var tagText:Text = new Text();
						tagText.setStyle("color", 0x333333);
						
						tagText.text = tagsStrings[i];
					
						tagBox.addChild(tagText);
					
						if(i < tagsStrings.length - 1)
						{
							tagText.text = tagText.text + ",";
						}
					
						box.addChild(tagBox);
					}
				}	
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Overriden protected methods
    	//
    	//--------------------------------------------------------------------------
		
		/**
    	 * @override
    	 * Create and add children.  
    	 */
		protected override function createChildren():void
		{
			super.createChildren();
			createTagsBox();
		}
		
		/**
    	 * @override
    	 * Sets the default component size. 
    	 */
		protected override function measure():void
		{
			super.measure();
			measuredWidth = tagsBox.measuredWidth;
			measuredHeight = tagsBox.measuredHeight;
		}
		
		/**
    	 * @override
    	 * Coordinates modifications to component properties. 
    	 */
		protected override function commitProperties():void
		{
			super.commitProperties();
    		
    		var needInvalidateSize:Boolean = false;
    		var needInvalidateDisplayList:Boolean = false;
    		
    		// update tags
    		if(_tagsChanged || _tagsBoxChanged)
    		{
    			if(tagsBox != null)
    			{
    				updateTags();
    			}
    			
    			_tagsChanged = false;
    			_tagsBoxChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// ---------------------
    		// Validate
    		// ---------------------
    		
    		// validate size if need
    		if(needInvalidateSize)
    		{
    			invalidateSize();
    		}
    		
    		// validate display list if need
    		if(needInvalidateDisplayList)
    		{
    			invalidateDisplayList();
    		}
		}
		
		/**
    	 * @override
    	 * Draw component. 
    	 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			tagsBox.move(0, 0);
			tagsBox.setActualSize(unscaledWidth, unscaledHeight);
		}
	}
}