package controls.panel
{
	import controls.notifier.YoNotifierComponent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	
	/**
	 * Represents expandable panel. 
	 */	
	public class YoPanel extends YoNotifierComponent
	{
		/**
		 * Constructor 
		 */		
		public function YoPanel()
		{
			state = YoPanelState.Expanded;
			headerVisible = true;
			collapsable = true;
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  label
    	//----------------------------------
    	
		/**
		 * @private
		 * Storage for label property 
		 */    	
		private var _label:String;
		
		/**
		 * @private
		 * Flag to indicate when _label changes. 
		 */		
		private var _labelChanged:Boolean;
		
		/**
		 * Specifies panel label property. 
		 */		
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * Specifies panel label property.
		 */		
		public function set label(label:String):void
		{
			if(_label != label)
			{
				_label = label;
				_labelChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  state
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for state property. 
		 */		
		private var _state:YoPanelState;
		
		/**
		 * @private
		 * Flag to indicate when _state changes. 
		 */		
		private var _stateChanged:Boolean;
		
		/**
		 * Specifies panel state: expanded or colapsed. 
		 */		
		public function get state():YoPanelState
		{
			return _state;
		}
		
		/**
		 * Specifies panel state: expanded or colapsed. 
		 */
		public function set state(state:YoPanelState):void
		{
			if(_state != state)
			{
				_state = state;
				_stateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  headerVisible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for headerVisible property. 
		 */		
		private var _headerVisible:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _headerVisible changes. 
		 */		
		private var _headerVisibleChanged:Boolean;
		
		/**
		 * Specifies header visibility. 
		 */		
		public function get headerVisible():Boolean
		{
			return _headerVisible;
		}
		
		/**
		 * Specifies header visibility. 
		 */
		public function set headerVisible(headerVisible:Boolean):void
		{
			if(_headerVisible != headerVisible)
			{
				_headerVisible = headerVisible;
				_headerVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  headerStyleName
    	//----------------------------------
		
		private var _headerStyleName:String = "YoPanelHeader";
		
		private var _headerStyleNameChanged:Boolean;
		
		public function get headerStyleName():String
		{	
			return _headerStyleName;
		}
		
		public function set headerStyleName(headerStyleName:String):void
		{
			if(_headerStyleName != headerStyleName)
			{
				_headerStyleName = headerStyleName;
				_headerStyleNameChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  headerPlacement
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for headerPlacement property 
		 */		
		private var _headerPlacement:int;
		
		/**
		 * @private
		 * Flag to indicate when _headerPalcement changes 
		 */		
		private var _headerPlacementChanged:Boolean;
		
		/**
		 * Specifies panel's header placememnt.  
		 */		
		public function get headerPlacement():int
		{
			return _headerPlacement;
		}
		
		/**
		 * Specifies panel's header placememnt.  
		 */
		public function set headerPlacement(headerPlacement:int):void
		{
			if(_headerPlacement != headerPlacement)
			{
				_headerPlacement = headerPlacement;
				_headerPlacementChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  callapsable
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for collapsable property. 
		 */		
		private var _collapsable:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _callapsable changes. 
		 */		
		private var _collapsableChanged:Boolean;
		
		/**
		 * Specifies ability of panel to collapse. 
		 */		
		public function get collapsable():Boolean
		{
			return _collapsable;
		}
		
		/**
		 * Specifies ability of panel to collapse. 
		 */
		public function set collapsable(collapsable:Boolean):void
		{
			if(_collapsable != collapsable)
			{
				_collapsable = collapsable;
				_collapsableChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  measuredExpandedWidth
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredExpandedWidth property.
		 */		
		private var _measuredExpandedWidth:Number;
		
		/**
		 * Specifies default width in expanded state. 
		 */		
		public function get measuredExpandedWidth():Number
		{
			return _measuredExpandedWidth;
		}
		
		/**
		 * Specifies default width in expanded state. 
		 */
		public function set measuredExpandedWidth(measuredExpandedWidth:Number):void
		{
			if(_measuredExpandedWidth != measuredExpandedWidth)
			{
				_measuredExpandedWidth = measuredExpandedWidth;
			}
		}
		
		//----------------------------------
    	//  measuredExpandedHeight
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredExpandedHeight property.
		 */		
		private var _measuredExpandedHeight:Number;
		
		/**
		 * Specifies default height in expanded state. 
		 */		
		public function get measuredExpandedHeight():Number
		{
			return _measuredExpandedHeight;
		}
		
		/**
		 * Specifies default height in expanded state. 
		 */
		public function set measuredExpandedHeight(measuredExpandedHeight:Number):void
		{
			if(_measuredExpandedHeight != measuredExpandedHeight)
			{
				_measuredExpandedHeight = measuredExpandedHeight;
			}
		}
		
		//----------------------------------
    	//  measuredCollapsedWidth
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredCollapsedWidth property.
		 */		
		private var _measuredCollapsedWidth:Number;
		
		/**
		 * Specifies default width in caollapsed state. 
		 */		
		public function get measuredCollapsedWidth():Number
		{
			return _measuredCollapsedWidth;
		}
		
		/**
		 * Specifies default width in collapsed state. 
		 */
		public function set measuredCollapsedWidth(measuredCollapsedWidth:Number):void
		{
			if(_measuredCollapsedWidth != measuredCollapsedWidth)
			{
				_measuredCollapsedWidth = measuredCollapsedWidth;
			}
		}
		
		//----------------------------------
    	//  measuredCollapsedHeight
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredColapsedHeight property.
		 */		
		private var _measuredCollapsedHeight:Number;
		
		/**
		 * Specifies default height in colapsed state. 
		 */		
		public function get measuredCollapsedHeight():Number
		{
			return _measuredCollapsedHeight;
		}
		
		/**
		 * Specifies default height in colapsed state. 
		 */
		public function set measuredCollapsedHeight(measuredCollapsedHeight:Number):void
		{
			if(_measuredCollapsedHeight != measuredCollapsedHeight)
			{
				_measuredCollapsedHeight = measuredCollapsedHeight;
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  substrate
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for substrate child. 
		 */		
		private var _substrate:YoPanelSubstrate;
		
		/**
		 * @private
		 * Flag to indicate when _substarte changes. 
		 */		
		private var _substrateChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies panel substrate. 
		 */		
		protected function get substrate():YoPanelSubstrate
		{
			return _substrate;
		}
		
		/**
		 * @protected
		 * Specifies panel substrate. 
		 */
		protected function set substrate(substrate:YoPanelSubstrate):void
		{
			if(_substrate != substrate)
			{
				_substrate = substrate;
				_substrateChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Specifies panel substrate. 
		 */
		protected function createSubstrate():void
		{
			if(_substrate == null)
			{
				_substrate = new YoPanelSubstrate();
				addChild(_substrate);
			}
		}
		
		//----------------------------------
    	//  header
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for header child.
		 */		
		private var _header:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _header changes.
		 */		
		private var _headerChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies panel header. 
		 */		
		protected function get header():UIComponent
		{
			return _header;
		}
		
		/**
		 * @protected
		 * Specifies panel header. 
		 */
		protected function set header(header:UIComponent):void
		{
			if(_header != header)
			{
				_header = header;
				_headerChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates and adds header component. 
		 */		
		protected function createHeader():void
		{
			if(_header == null)
			{
				_header = new HBox();
				_header.styleName = headerStyleName;
				addChild(_header);
			}
		}
		
		//----------------------------------
    	//  state control
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for state control child. 
		 */		
		private var _stateControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _stateControl changes.
		 */		
		private var _stateControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies state control component. 
		 */		
		protected function get stateControl():UIComponent
		{
			return _stateControl;
		}
		
		/**
		 * @protected
		 * Specifies state control component. 
		 */
		protected function set stateControl(stateControl:UIComponent):void
		{
			if(_stateControl != stateControl)
			{
				_stateControl = stateControl;
				_stateControlChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates and adds state control component.
		 */		
		protected function createStateControl():void
		{
			if(_stateControl == null)
			{
				var stateControl:Image = new Image();
				stateControl.source = "resources/collapse_11x11.png";
				stateControl.scaleContent = false;
				stateControl.buttonMode = true;
				stateControl.useHandCursor = true;
				stateControl.mouseChildren = false;
				_stateControl = stateControl;
				
				if(header != null)
				{
					header.addChild(_stateControl);
				}
				
				_stateControl.addEventListener(
					MouseEvent.CLICK,
					function(event:MouseEvent):void
					{
						if(state == YoPanelState.Expanded)
						{
							state = YoPanelState.Colapsed;
						}
						else if(state == YoPanelState.Colapsed)
						{
							state = YoPanelState.Expanded;
						}
					});
			}
		}
		
		//----------------------------------
    	//  label
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for labelText child. 
		 */		
		private var _labelText:Text;
		
		/**
		 * @private
		 * Flag to indicate when _labelText changes. 
		 */		
		private var _labelTextChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies label component. 
		 */		
		protected function get labelText():Text
		{
			return _labelText;
		}
		
		/**
		 * @protected
		 * Specifies label component. 
		 */		
		protected function set labelText(labelText:Text):void
		{
			if(_labelText != labelText)
			{
				_labelText = labelText;
				_labelTextChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates and adds label text component.
		 */		
		protected function createLabelText():void
		{
			if(_labelText == null)
			{
				_labelText = new Text();
				_labelText.styleName = "YoPanelLabel";
				header.addChild(_labelText);
			}
		}
		
		//----------------------------------
    	//  content
    	//----------------------------------
		
		/**
		 * Storage for content child. 
		 */		
		private var _content:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _content changes. 
		 */		
		private var _contentChanged:Boolean;
		
		/**
		 * Specifies panel content. 
		 */		
		public function get content():UIComponent
		{
			return _content;
		}
		
		/**
		 * Specifies panel content. 
		 */
		public function set content(content:UIComponent):void
		{
			if(_content != content)
			{
				if(_content != null)
				{
					removeChild(_content);
				}
				
				_content = content;
				
				if(_content != null)
				{
					addChild(_content);
				}
				
				_contentChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates and adds content component. 
		 */		
		protected function createContent():void {}
		
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
			
			createSubstrate();
			createHeader();
			createStateControl();
			createLabelText();
			
			createContent();
			
			setChildIndex(notifier, numChildren - 1);
			notifierRadius = 12;
			notifierBorderTickness = 3;
			notifierBorderColor = 0xffffff;
			notifierFillColor = 0xcc0001;
			notifierVisible = false;
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
    		
    		// update label
    		if(_labelChanged || _labelTextChanged)
    		{
    			if(labelText != null)
    			{
    				labelText.text = label;
    			}
    			
    			_labelChanged = false;
    			_labelTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update header
    		if(_headerChanged || _headerVisibleChanged || _headerStyleNameChanged)
    		{
    			if(header != null)
    			{
    				header.visible = headerVisible;
    				header.styleName = headerStyleName;
    			}
    			
    			_headerChanged = false;
    			_headerVisibleChanged = false;
    			_headerStyleNameChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update collapsable
    		if(_collapsableChanged || _stateControlChanged)
    		{
    			if(stateControl != null)
    			{
    				stateControl.visible = collapsable;
    			}
    			
    			_collapsableChanged = false;
    			_stateControlChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update state
    		if(_stateChanged)
    		{
    			var resize:Resize = new Resize(substrate);
				if(state == YoPanelState.Expanded)
				{
					resize.widthTo = measuredExpandedWidth;
					resize.heightTo = measuredExpandedHeight;
				}
				else if(state == YoPanelState.Colapsed)
				{
					resize.widthTo = measuredCollapsedWidth;
					resize.heightTo = measuredCollapsedHeight;				
				}
				
				resize.addEventListener(
					EffectEvent.EFFECT_END,
					function(event:EffectEvent):void
					{
						_stateChanged = false;
    					invalidateSize();
    					invalidateDisplayList();
					});
				
				resize.play();
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
    	 * Sets the default component size. 
    	 */
		protected override function measure():void
		{
			super.measure();
			
			measureExpandedState();
			measureCollapsedState();
			
			if(_stateChanged)
			{
				measuredWidth = substrate.width;
				measuredHeight = substrate.height;
			}
			else if(state == YoPanelState.Expanded)
			{
				measuredWidth = measuredExpandedWidth;
				measuredHeight = measuredExpandedHeight;
			}
			else if(state == YoPanelState.Colapsed)
			{
				measuredWidth = measuredCollapsedWidth;
				measuredHeight = measuredCollapsedHeight;
			}
		}
		
		/**
    	 * @override
    	 * Draw panel. 
    	 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			substrate.move(0, 0);
			substrate.setActualSize(unscaledWidth, unscaledHeight);
			
			var y:Number = 0;
			
			if(header != null && headerVisible)
			{
				header.move(0, 0);
				header.setActualSize(unscaledWidth, header.measuredHeight);
				y += header.measuredHeight;
			}
			
			if(content != null)
			{
				if(state == YoPanelState.Expanded && !_stateChanged)
				{
					content.move(0, y);
					content.setActualSize(unscaledWidth, unscaledHeight - y);
					content.visible = true;
				}
				else
				{
					content.visible = false;
				}
			}
			
			notifier.move(unscaledWidth - notifier.measuredWidth + 4, -18);
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Protected methods
    	//
    	//--------------------------------------------------------------------------
		
		/**
		 * Set default size in expanded state. 
		 */		
		protected function measureExpandedState():void
		{
			measuredExpandedWidth = 0;
			measuredExpandedHeight = 0;
			
			if(header != null && headerVisible)
			{
				measuredExpandedWidth = header.measuredWidth;
				measuredExpandedHeight += header.measuredHeight;
			}
			
			if(content != null)
			{
				measuredExpandedWidth = Math.max(measuredExpandedWidth, content.measuredWidth);
				measuredExpandedHeight += content.measuredHeight;
			}
		}
		
		/**
		 * Set default size in collapse state. 
		 */		
		protected function measureCollapsedState():void
		{
			measuredCollapsedWidth = 0;
			measuredCollapsedHeight = 0;
			
			if(header != null && headerVisible)
			{
				measuredCollapsedWidth = header.measuredWidth;
				measuredCollapsedHeight = header.measuredHeight;
			}
		}
	}
}