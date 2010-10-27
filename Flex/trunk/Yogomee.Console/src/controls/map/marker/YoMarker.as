package controls.map.marker
{
	import com.google.maps.LatLng;
	
	import controls.map.marker.events.YoMarkerEvent;
	import controls.notifier.YoNotifierComponent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	import mx.events.ResizeEvent;
	import mx.events.TweenEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	/**
	 * Base class for all markers.
	*/
	public class YoMarker extends YoNotifierComponent
	{
		/**
		 * Constructor 
		 */		
		public function YoMarker()
		{
			_state = YoMarkerState.Icon;
			_editable = true;
			_deletable = true;
			
			addEventListener(
				ResizeEvent.RESIZE,
				function(event:ResizeEvent):void
				{
					//dispatchEvent(new YoMarkerEvent(YoMarkerEvent.ResizePan));
				});
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------

		public var data:Object;
		
    	//----------------------------------
    	//  latLng
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for latLng property. 
		 */		
		private var _latLng:LatLng;
		
		/**
		 * @private
		 * Flag to indicate when _latLng property changes. See <code>commitProperties</code>
		 * implementation. 
		 */		
		private var _latLngChanged:Boolean;
		
		/**
		 * Specifies marker position on the map. 
		 */		
		public function get latLng():LatLng
		{
			return _latLng;
		}
		
		/**
		 * Specifies marker position on the map. 
		 */
		public function set latLng(latLng:LatLng):void
		{
			if(_latLng != latLng)
			{
				_latLng = latLng;
				_latLngChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  tailX
    	//----------------------------------
		
		/**
    	 * Specifies tail x coordinate. 
    	 */
		public function get tailX():Number
		{
			return substrate.tailX;
		}
		
		/**
    	 * Specifies tail y coordinate. 
    	 */
		public function get tailY():Number
		{
			return substrate.tailY;
		}
		
		//----------------------------------
    	//  state
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for state property.
		 */		
		private var _state:YoMarkerState;
		
		/**
		 * @private
		 * Storage for previous state value. 
		 */		
		private var _oldState:YoMarkerState;
		
		/**
		 * @private
		 * Flag to indicate when _state property changes. See <code>commitProperties</code>. 
		 */		
		private var _stateChanged:Boolean;
		
		/**
		 * Specifies marker state: icon, content or edit. 
		 */		
		public function get state():YoMarkerState
		{
			return _state;
		}
		
		/**
		 * Specifies marker state: icon, content or edit. 
		 */
		public function set state(state:YoMarkerState):void
		{
			if(_state != state)
			{
				if(_state == YoMarkerState.Edit)
				{
					dispatchEvent(new YoMarkerEvent(YoMarkerEvent.ContentChanged));
				}
				
				_oldState = _state;
				_state = state;
				_stateChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  editable
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for editable property. 
		 */		
		private var _editable:Boolean; 
		
		/**
		 * @private
		 * Flag to indicate when _editable chnages. 
		 */		
		private var _editableChanged:Boolean;
		
		/**
		 * Specifies ability to become in edit state 
		 */		
		public function get editable():Boolean
		{
			return _editable;
		}
		
		/**
		 * Specifies ability to become in edit state 
		 */
		public function set editable(editable:Boolean):void
		{
			if(_editable != editable)
			{
				_editable = editable;
				_editableChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  deletable
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for deletable property. 
		 */		
		private var _deletable:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _deletable changes. 
		 */		
		private var _deletableChanged:Boolean;
		
		/**
		 * Specifies ability to delete marker. 
		 */		
		public function get deletable():Boolean
		{
			return _deletable;
		}
		
		/**
		 * Specifies ability to delete marker. 
		 */
		public function set deletable(deletable:Boolean):void
		{
			if(_deletable != deletable)
			{
				_deletable = deletable;
				_deletableChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  measuredIconWidth
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredIconWidth property. 
		 */		
		private var _measuredIconWidth:Number;
		
		/**
		 * Specifies default width in icon state. 
		 */		
		public function get measuredIconWidth():Number
		{
			return _measuredIconWidth;
		}
		
		/**
		 * Specifies default width in icon state. 
		 */
		public function set measuredIconWidth(measuredIconWidth:Number):void
		{
			if(_measuredIconWidth != measuredIconWidth)
			{
				_measuredIconWidth = measuredIconWidth;
			}
		}
		
		//----------------------------------
    	//  measuredIconHeight
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredIconHeight property. 
		 */		
		private var _measuredIconHeight:Number;
		
		/**
		 * Specifies default height in icon state. 
		 */		
		public function get measuredIconHeight():Number
		{
			return _measuredIconHeight;
		}
		
		/**
		 * Specifies default height in icon state. 
		 */
		public function set measuredIconHeight(measuredIconHeight:Number):void
		{
			if(_measuredIconHeight != measuredIconHeight)
			{
				_measuredIconHeight = measuredIconHeight;
			}
		}
		
		//----------------------------------
    	//  measuredContentWidth
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredContentWidth property. 
		 */		
		private var _measuredContentWidth:Number;
		
		/**
		 * Specifies default width in content state. 
		 */		
		public function get measuredContentWidth():Number
		{
			return _measuredContentWidth;
		}
		
		/**
		 * Specifies default width in content state. 
		 */
		public function set measuredContentWidth(measuredContentWidth:Number):void
		{
			if(_measuredContentWidth != measuredContentWidth)
			{
				_measuredContentWidth = measuredContentWidth;
			}
		}
		
		//----------------------------------
    	//  measuredContentHeight
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredContentHeight property. 
		 */		
		private var _measuredContentHeight:Number;
		
		/**
		 * Specifies default height in content state. 
		 */		
		public function get measuredContentHeight():Number
		{
			return _measuredContentHeight;
		}
		
		/**
		 * Specifies default height in content state. 
		 */
		public function set measuredContentHeight(measuredContentHeight:Number):void
		{
			if(_measuredContentHeight != measuredContentHeight)
			{
				_measuredContentHeight = measuredContentHeight;
			}
		}
		
		//----------------------------------
    	//  measuredEditWidth
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredEditWidth property. 
		 */		
		private var _measuredEditWidth:Number;
		
		/**
		 * Specifies default width in edit state. 
		 */		
		public function get measuredEditWidth():Number
		{
			return _measuredEditWidth;
		}
		
		/**
		 * Specifies default width in edit state. 
		 */
		public function set measuredEditWidth(measuredEditWidth:Number):void
		{
			if(_measuredEditWidth != measuredEditWidth)
			{
				_measuredEditWidth = measuredEditWidth;
			}
		}
		
		//----------------------------------
    	//  measuredEditHeight
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for measuredEditHeight property. 
		 */		
		private var _measuredEditHeight:Number;
		
		/**
		 * Specifies default height in edit state. 
		 */		
		public function get measuredEditHeight():Number
		{
			return _measuredEditHeight;
		}
		
		/**
		 * Specifies default height in edit state. 
		 */
		public function set measuredEditHeight(measuredEditHeight:Number):void
		{
			if(_measuredEditHeight != measuredEditHeight)
			{
				_measuredEditHeight = measuredEditHeight;
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Styles
    	//
    	//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Flag to indicate that default style create. 
		 */		
		private static var _defaultStyleCreated:Boolean = createDefaultStyle();
		
		/**
		 * @private
		 * Creates default styles for markers.
		 */		
		private static function createDefaultStyle():Boolean
		{
			// try to get already declared styles
			var styles:CSSStyleDeclaration = StyleManager.getStyleDeclaration("YoMarker");
			
			// create new declaration if not declared previously
			if(!styles)
			{
				styles = new CSSStyleDeclaration();
			}
			
			// set default values
			styles.defaultFactory = function():void
			{
				this.radius = 16;
				this.tailWidth = 8;
				this.tailHeight = 8;
				this.tailPos = 0.25;
				this.borderTickness = 1;
				this.borderColor = 0x666666;
				this.fillColor = 0xffffff;
				this.gap = 2.5;
				this.iconColor = 0xcc0001;
				this.paddingLeft = 5;
				this.paddingRight = 5;
				this.paddingTop = 5;
				this.paddingBottom = 5;
				this.horizontalGap = 5;
			}
			
			StyleManager.setStyleDeclaration("YoMarker", styles, true);
			
			return true;
		}
		
		/**
		 * @override
		 * Detects changes to style properties. 
		 */		
		public override function styleChanged(styleProp:String):void
		{
			// update all styles
			if(styleProp == null)
			{
				_radiusChanged = true;
				_tailWidthChanged = true;
				_tailHeightChanged = true;
				_tailPosChanged = true;
				_borderTicknessChanged = true;
				_borderColorChanged = true;
				_fillColorChanged = true;
				_gapChanged = true;
				_iconColorChanged = true;
				invalidateProperties();
				return;
			}
			
			// update radius
			if(styleProp == "radius")
			{
				_radiusChanged = true;
				invalidateProperties();
				return;	
			}
			
			// update tail width
			if(styleProp == "tailWidth")
			{
				_tailWidthChanged = true;
				invalidateProperties();
				return;
			}
			
			// update tail height
			if(styleProp == "tailHeight")
			{
				_tailHeightChanged = true;
				invalidateProperties();
				return;
			}
			
			// update tail position
			if(styleProp == "tailPos")
			{
				_tailPosChanged = true;
				invalidateProperties();
				return;
			}
			
			// update border tickness
			if(styleProp == "borderTickness")
			{
				_borderTicknessChanged = true;
				invalidateProperties();
				return;
			}
			
			// update border color
			if(styleProp == "borderColor")
			{
				_borderColorChanged = true;
				invalidateProperties();
				return;
			}
			
			// update fill color
			if(styleProp == "fillColor")
			{
				_fillColorChanged = true;
				invalidateProperties();
				return;
			}
			
			// update gap
			if(styleProp == "gap")
			{
				_gapChanged = true;
				invalidateProperties();
				return;
			}
			
			// update icon color
			if(styleProp == "iconColor")
			{
				_iconColorChanged = true;
				invalidateProperties();
				return;
			}
		}
		
		//----------------------------------
    	//  radius
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when radius style changes. 
		 */		
		private var _radiusChanged:Boolean;
		
		/**
		 * Specifies marker radius.
		 * @default 16 
		 */		
		public function get radius():Number
		{
			return getStyle("radius");
		}
		
		/**
		 * Specifies marker radius.
		 * @default 16 
		 */
		public function set radius(radius:Number):void
		{
			setStyle("radius", radius);
		}
		
		//----------------------------------
    	//  tailWidth
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when tail width style changes. 
		 */		
		private var _tailWidthChanged:Boolean;
		
		/**
		 * Specifies marker tail width.
		 * @default 8 
		 */		
		public function get tailWidth():Number
		{
			return getStyle("tailWidth");
		}
		
		/**
		 * Specifies marker tail width.
		 * @default 8 
		 */
		public function set tailWidth(tailWidth:Number):void
		{
			setStyle("tailWidth", tailWidth);
		}
		
		//----------------------------------
    	//  tailHeight
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when tail height style changes. 
		 */		
		private var _tailHeightChanged:Boolean;
		
		/**
		 * Specifies marker tail height.
		 * @default 8 
		 */		
		public function get tailHeight():Number
		{
			return getStyle("tailHeight");
		}
		
		/**
		 * Specifies marker tail height.
		 * @default 8 
		 */
		public function set tailHeight(tailHeight:Number):void
		{
			setStyle("tailHeight", tailHeight);
		}
		
		//----------------------------------
    	//  tailPos
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when tail position style changes. 
		 */		
		private var _tailPosChanged:Boolean;
		
		/**
		 * Specifies marker tail position.
		 * @default 0.25 
		 */		
		public function get tailPos():Number
		{
			return getStyle("tailPos");
		}
		
		/**
		 * Specifies marker tail position.
		 * @default 0.25 
		 */
		public function set tailPos(tailPos:Number):void
		{
			setStyle("tailPos", tailPos);
		}
		
		//----------------------------------
    	//  borderTickness
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when border tickness style changes. 
		 */		
		private var _borderTicknessChanged:Boolean;
		
		/**
		 * Specifies marker border tickness style.
		 * @default 1
		 */		
		public function get borderTickness():Number
		{
			return getStyle("borderTickness");
		}
		
		/**
		 * Specifies marker border tickness style.
		 * @default 1
		 */
		public function set borderTickness(borderTickness:Number):void
		{
			setStyle("borderTickness", borderTickness);
		}
		
		//----------------------------------
    	//  borderColor
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when border color style  changes. 
		 */		
		private var _borderColorChanged:Boolean;
		
		/**
		 * Specifies marker border color.
		 * @default 0x666666 
		 */		
		public function get borderColor():uint
		{
			return getStyle("borderColor");
		}
		
		/**
		 * Specifies marker border color.
		 * @default 0x666666 
		 */
		public function set borderColor(borderColor:uint):void
		{
			setStyle("borderColor", borderColor);
		}
		
		//----------------------------------
    	//  fillColor
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when fill color style changes. 
		 */		
		private var _fillColorChanged:Boolean;
		
		/**
		 * Specifies marker fill color.
		 * @default 0xffffff 
		 */		
		public function get fillColor():uint
		{
			return getStyle("fillColor");
		}
		
		/**
		 * Specifies marker fill color.
		 * @default 0xffffff 
		 */
		public function set fillColor(fillColor:uint):void
		{
			setStyle("fillColor", fillColor);
		}
		
		//----------------------------------
    	//  gap
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when gap style changes. 
		 */		
		private var _gapChanged:Boolean;
		
		/**
		 * Specifies gap between border and icon.
		 * @default 2.5 
		 */		
		public function get gap():Number
		{
			return getStyle("gap");
		}
		
		/**
		 * Specifies gap between border and icon.
		 * @default 2.5 
		 */
		public function set gap(gap:Number):void
		{
			setStyle("gap", gap);
		}
		
		//----------------------------------
    	//  iconColor
    	//----------------------------------
		
		/**
		 * @private
		 * Flag to indicate when icon fill color style changed. 
		 */		
		private var _iconColorChanged:Boolean;
		
		/**
		 * Specifies icon fill color.
		 * @default 0xcc0001
		 */		
		public function get iconColor():uint
		{
			return getStyle("iconColor");
		}
		
		/**
		 * Specifies icon fill color.
		 * @default 0xcc0001 
		 */		
		public function set iconColor(iconColor:uint):void
		{
			setStyle("iconColor", iconColor);
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
    	 * Storage for substrate. 
    	 */    	
    	private var _substrate:YoMarkerSubstrate;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _substarte property changes. 
    	 */    	
    	private var _substrateChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifise marker substrate. 
    	 */    	
    	protected function get substrate():YoMarkerSubstrate
    	{
    		return _substrate;
    	}
    	
    	/**
    	 * @protected
    	 * Specifise marker substrate. 
    	 */
    	protected function set substrate(substrate:YoMarkerSubstrate):void
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
    	 * Creates substrate and add it as child. 
    	 */    	
    	protected function createSubstrate():void
    	{
    		if(_substrate == null)
    		{
    			_substrate = new YoMarkerSubstrate();
    			addChild(_substrate);
    		}
    	}
		
		//----------------------------------
    	//  icon
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for icon.
		 */		
		private var _icon:YoMarkerIcon;
		
		/**
		 * @private
		 * Flag to indicate when _icon chenges. 
		 */		
		private var _iconChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies marker icon. 
		 */		
		protected function get icon():YoMarkerIcon
		{
			return _icon;
		}
		
		/**
		 * @protected
		 * Specifies marker icon. 
		 */		
		protected function set icon(icon:YoMarkerIcon):void
		{
			if(_icon != icon)
			{
				_icon = icon;
				_iconChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates icon and add it as child. 
		 */		
		protected function createIcon():void
		{
			if(_icon == null)
			{
				_icon = new YoMarkerIcon();
				addChild(_icon);
				
				_icon.addEventListener(
					MouseEvent.CLICK,
					function(event:MouseEvent):void
					{
						if(state == YoMarkerState.Icon)
						{
							state = YoMarkerState.Content;
						}
					});
			}
		}
		
		//----------------------------------
    	//  header
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for header. 
		 */		
		private var _header:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _header changes.
		 */		
		private var _headerChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies header that contains controls. 
		 */		
		protected function get header():UIComponent
		{
			return _header;
		}
		
		/**
		 * @protected
		 * Specifies header that contains controls. 
		 */
		protected function set header(header:UIComponent):void
		{
			if(_header != header)
			{
				_header = header;
				_headerChanged = true;
				invalidateProperties()
			}
		}
		
		/**
		 * @protected
		 * Creates header with controls. 
		 */		
		protected function createHeader():void
		{
			if(_header == null)
			{
				_header = new HBox();
				_header.setStyle("horizontalAlign", "right");
				_header.setStyle("horizontalGap", 3);
				_header.setStyle("paddingRight", 10);
				_header.setStyle("paddingTop", 5);
				addChild(_header);
			}
			
			createEditControl();
			createRemoveControl();
			createCollapseControl();
		}
		
		//----------------------------------
    	//  collapseControl
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for collapse control. 
		 */		
		private var _collapseControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _collapseControl changes. 
		 */		
		private var _collapseControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies collapse control. 
		 */		
		protected function get collapseControl():UIComponent
		{
			return _collapseControl;
		}
		
		/**
		 * @protected
		 * Specifies collapse control. 
		 */
		protected function set collapseControl(collapseControl:UIComponent):void
		{
			if(_collapseControl != collapseControl)
			{
				_collapseControl = collapseControl;
				_collapseControlChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates collapse control 
		 */		
		protected function createCollapseControl():void
		{
			if(_collapseControl == null)
			{
				if(header != null)
				{
					var collapseControl:Image = new Image();
					collapseControl.source = "resources/collapse_11x11.png";
					collapseControl.scaleContent = false;
					collapseControl.buttonMode = true;
					collapseControl.useHandCursor = true;
					collapseControl.mouseChildren = false;
					
					_collapseControl = collapseControl;
					header.addChild(_collapseControl);
					
					_collapseControl.addEventListener(
						MouseEvent.CLICK,
						function(event:MouseEvent):void
						{
							if(state == YoMarkerState.Content)
							{
								state = YoMarkerState.Icon;
							}
							else if (state == YoMarkerState.Edit)
							{
								state = YoMarkerState.Content;
							}
						});
				}
			}
		}
		
		//----------------------------------
    	//  editControl
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for edit control. 
		 */		
		private var _editControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _editControl changes. 
		 */		
		private var _editControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies edit control. 
		 */		
		protected function get editControl():UIComponent
		{
			return _editControl;
		}
		
		/**
		 * @protected
		 * Specifies edit control. 
		 */		
		protected function set editControl(editControl:UIComponent):void
		{
			if(_editControl != editControl)
			{
				_editControl = editControl;
				_editControlChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates edit control. 
		 */		
		protected function createEditControl():void
		{
			if(_editControl == null)
			{
				if(header != null)
				{
					var editControl:Image = new Image();
					editControl.source = "resources/pencil_11x11.png";
					editControl.scaleContent = false;
					editControl.buttonMode = true;
					editControl.useHandCursor = true;
					editControl.mouseChildren = false;
					
					_editControl = editControl;
					header.addChild(_editControl);
					
					_editControl.addEventListener(
						MouseEvent.CLICK,
						function(event:MouseEvent):void
						{
							if(state == YoMarkerState.Content)
							{
								state = YoMarkerState.Edit;
							}
						});
				}
			}
		}
		
		//----------------------------------
    	//  removeControl
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for remove control. 
		 */		
		private var _removeControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _removeControl changes. 
		 */		
		private var _removeControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies remove control. 
		 */		
		protected function get removeControl():UIComponent
		{
			return _removeControl;
		}
		
		/**
		 * @protected
		 * Specifies remove control. 
		 */		
		protected function set removeControl(removeControl:UIComponent):void
		{
			if(_removeControl != removeControl)
			{
				_removeControl = removeControl;
				_removeControlChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Create remove control. 
		 */		
		protected function createRemoveControl():void
		{
			if(_removeControl == null)
			{
				if(header != null)
				{
					var removeControl:Image = new Image();
					removeControl.source = "resources/trash_11x11.png";
					removeControl.scaleContent = false;
					removeControl.buttonMode = true;
					removeControl.useHandCursor = true;
					removeControl.mouseChildren = false;
					
					removeControl.addEventListener(
						MouseEvent.CLICK,
						function(event:MouseEvent):void
						{
							dispatchEvent(new YoMarkerEvent(YoMarkerEvent.RemoveClick));
						});
					
					_removeControl = removeControl;
					header.addChild(_removeControl);
				}
			}
		}
		
		//----------------------------------
    	//  contentFrame
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for contentFrame child. 
		 */		
		private var _contentFrame:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _contentFrame changes. 
		 */		
		private var _contentFrameChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component that whill be displayed in content state. 
		 */		
		protected function get contentFrame():UIComponent
		{
			return _contentFrame;
		}
		
		/**
		 * @protected
		 * Specifies component that whill be displayed in content state. 
		 */
		protected function set contentFrame(contentFrame:UIComponent):void
		{
			if(_contentFrame != contentFrame)
			{
				_contentFrame = contentFrame;
				_contentFrameChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates frame to display in content state.
		 * Must be implemented in subclasses.
		 */		
		protected function createContentFrame():void {}
		
		//----------------------------------
    	//  editFrame
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for editFrame child. 
		 */		
		private var _editFrame:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _editFrame changes. 
		 */		
		private var _editFrameChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component that whill be displayed in edit state. 
		 */		
		protected function get editFrame():UIComponent
		{
			return _editFrame;
		}
		
		/**
		 * @protected
		 * Specifies component that whill be displayed in edit state. 
		 */
		protected function set editFrame(editFrame:UIComponent):void
		{
			if(_editFrame != editFrame)
			{
				_editFrame = editFrame;
				_editFrameChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates frame to display in edit state.
		 * Must be implemented in subclasses.
		 */
		protected function createEditFrame():void {}
		
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
    		
    		createSubstrate();
    		createIcon();
    		createHeader();
    		createContentFrame();
    		createEditFrame();
    		
    		setChildIndex(notifier, numChildren - 1);
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
    		
    		// ---------------------
    		// Properties
    		// ---------------------
    		
    		// update latLng
    		if(_latLngChanged)
    		{
    			_latLngChanged = false;
    			needInvalidateSize = true; 
    			needInvalidateDisplayList = true;
    		}
    		
    		// update state
    		if(_stateChanged)
    		{
    			header.visible = false;
				contentFrame.visible = false;
				editFrame.visible = false;
					
    			var resize:Resize = new Resize(substrate);
				//resize.duration = 2000;
				if(state == YoMarkerState.Icon)
				{
					resize.widthTo = measuredIconWidth;
					resize.heightTo = measuredIconHeight;
				}
				else if(state == YoMarkerState.Content)
				{
					resize.widthTo = measuredContentWidth;
					resize.heightTo = measuredContentHeight;				
				}
				else if(state == YoMarkerState.Edit)
				{
					resize.widthTo = measuredEditWidth;
					resize.heightTo = measuredEditHeight;
					
					editControl.visible = false;
				}
			
				resize.addEventListener(
					TweenEvent.TWEEN_UPDATE,
					function(event:TweenEvent):void
					{
						//dispatchEvent(new YoMarkerEvent(YoMarkerEvent.ResizePan));
					});
					
				resize.addEventListener(
					EffectEvent.EFFECT_END,
					function(event:EffectEvent):void
					{
						_stateChanged = false;
						
						if(state == YoMarkerState.Content)
						{
							header.visible = true;
							contentFrame.visible = true;
							editControl.visible = editable;
						}
						else if(state == YoMarkerState.Edit)
						{
							header.visible = true;
							editFrame.visible = true;
						}
						
						dispatchEvent(new YoMarkerEvent(YoMarkerEvent.ResizePan));
						
    					invalidateSize();
    					invalidateDisplayList();
					});
				
				resize.play();
    		}
    		
    		// update editable
    		if(_editableChanged)
    		{
    			if(editable)
    			{
    				if(!header.contains(editControl))
    				{
    					header.addChild(editControl);
    				}
    			}
    			else
    			{
    				if(header.contains(editFrame))
    				{
    					header.removeChild(editControl);
    				}
    			}
    			
    			_editableChanged = false;
				needInvalidateSize = true;
				needInvalidateDisplayList = true;
    		}
    		
    		// update deletable
    		if(_deletableChanged)
    		{
    			if(deletable)
    			{
    				if(!header.contains(removeControl))
    				{
    					header.addChild(removeControl);
    				}
    			}
    			else
    			{
    				if(header.contains(removeControl))
    				{
    					header.removeChild(removeControl);
    				}
    			}
    			
    			_deletableChanged = false;
    			needInvalidateSize = true;
				needInvalidateDisplayList = true;
    		}
    		
    		// ---------------------
    		// Styles
    		// ---------------------
    		
    		// update radius
    		if(_radiusChanged)
    		{
    			if(_substrate != null)
    			{
    				_substrate.radius = radius;
    			}
    			
    			if(_icon != null)
    			{
    				_icon.radius = radius;
    			}
    			
    			_radiusChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update tail width
    		if(_tailWidthChanged)
    		{
    			if(_substrate != null)
    			{
    				_substrate.tailWidth = tailWidth;
    			}
    			
    			_tailWidthChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update tail height
    		if(_tailHeightChanged)
    		{
    			if(_substrate)
    			{
    				_substrate.tailHeight = tailHeight;
    			}
    			
    			_tailHeightChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update tail position
    		if(_tailPosChanged)
    		{
    			if(_substrate)
    			{
    				_substrate.tailPos = tailPos;
    			}
    			
    			_tailPosChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update border tickness
    		if(_borderTicknessChanged)
    		{
    			if(_substrate != null)
    			{
    				_substrate.borderTickness = borderTickness;
    			}
    			
    			_borderTicknessChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update border color
    		if(_borderColorChanged)
    		{
    			if(_substrate)
    			{
    				_substrate.borderColor = borderColor;
    			}
    			
    			_borderColorChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update fill color
    		if(_fillColorChanged)
    		{
    			if(_substrate)
    			{
    				_substrate.fillColor = fillColor;
    			}
    			
    			_fillColorChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update gap
    		if(_gapChanged)
    		{
    			if(_icon != null)
    			{
    				_icon.gap = gap;
    			}
    			
    			_gapChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update icon color
    		if(_iconColorChanged)
    		{
    			if(_icon != null)
    			{
    				_icon.fillColor = iconColor;
    			}
    			
    			_iconChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// ---------------------
    		// Children
    		// ---------------------
    		
    		// update substrate
    		if(_substrateChanged)
    		{
    			if(_substrate != null)
    			{
    				_substrate.radius = radius;
    				_substrate.tailWidth = tailWidth;
    				_substrate.tailHeight = tailHeight;
    				_substrate.tailPos = tailPos;
    				_substrate.borderTickness = borderTickness;
    				_substrate.borderColor = borderColor;
    				_substrate.fillColor = fillColor;
    			}
    			
    			_substrateChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update icon
    		if(_iconChanged)
    		{
    			if(_icon != null)
    			{
    				_icon.radius = radius;
    				_icon.gap = gap;
    			}
    			
    			_iconChanged = false;
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
    	 * Sets the default component size. 
    	 */
    	protected override function measure():void
    	{
    		super.measure();
    		
    		measureIconState();
    		measureContentState();
    		measureEditState();
    		
    		if(_stateChanged)
			{
				measuredWidth = substrate.width;
				measuredHeight = substrate.height;
			}
			else if(state == YoMarkerState.Icon)
			{
				measuredWidth = measuredIconWidth;
				measuredHeight = measuredIconHeight;
			}
			else if(state == YoMarkerState.Content)
			{
				measuredWidth = measuredContentWidth;
				measuredHeight = measuredContentHeight;
			}
			else if(state == YoMarkerState.Edit)
			{
				measuredWidth = measuredEditWidth;
				measuredHeight = measuredEditHeight;
			}
    	}
    	
    	/**
    	 * @override
    	 * Draw marker. 
    	 */    	
    	protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    	{
    		super.updateDisplayList(unscaledWidth, unscaledHeight);
    		
    		substrate.move(0, 0);
    		substrate.setActualSize(unscaledWidth, unscaledHeight);
    		
    		var x:Number = 0;
    		var y:Number = 0;
    		
    		if(icon != null)
    		{
    			icon.move(0, 0);
    			icon.setActualSize(icon.measuredWidth, icon.measuredHeight);
    			x = icon.measuredWidth;
    			
    			notifier.move(icon.measuredWidth - notifier.measuredWidth, -2);
    		}
    		
    		if(header != null)
    		{
    			if(state != YoMarkerState.Icon && !_stateChanged)
    			{
    				header.move(x, 0);
    				header.setActualSize(unscaledWidth - x, header.measuredHeight);
    				y = header.measuredHeight;
    			}
    		}
    		
    		if(contentFrame != null)
    		{
    			if(state == YoMarkerState.Content && !_stateChanged)
    			{
    				contentFrame.move(x, y);
    				contentFrame.setActualSize(unscaledWidth - x, unscaledHeight - y);
    			}
    		}
    		
    		if(editFrame != null)
    		{
    			if(state == YoMarkerState.Edit && !_stateChanged)
    			{
    				editFrame.move(x, y);
    				editFrame.setActualSize(unscaledWidth - x, unscaledHeight - y);
    			}
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	/**
    	 * @protected
    	 * Sets default component size in icon state. 
    	 */    	
    	protected function measureIconState():void
    	{
    		measuredIconWidth = substrate.measuredWidth;
    		measuredIconHeight = substrate.measuredHeight;
    	}
    	
    	/**
    	 * @protected
    	 * Sets deafault component size in content state. 
    	 */    	
    	protected function measureContentState():void
    	{
    		var iconWidth:Number = 0;
    		var iconHeight:Number = 0;
    		var headerWidth:Number = 0;
    		var headerHeight:Number = 0;
    		var contentWidth:Number = 0;
    		var contentHeight:Number = 0;
    		
    		if(icon != null)
    		{
    			iconWidth = substrate.measuredWidth;
    			iconHeight = substrate.measuredHeight;
    		}
    		
    		if(header != null)
    		{
    			headerWidth = header.measuredWidth;
    			headerHeight = header.measuredHeight;
    		}
    		
    		if(contentFrame != null)
    		{
    			contentWidth = contentFrame.measuredWidth;
    			contentHeight = contentFrame.measuredHeight;
    		}
    		
    		measuredContentWidth = iconWidth + Math.max(headerWidth, contentWidth);
    		measuredContentHeight = Math.max(iconHeight, headerHeight + contentHeight);
    	}
    	
    	/**
    	 * @protected
    	 * Sets deafult component seize in edit state. 
    	 */    	
    	protected function measureEditState():void
    	{
    		var iconWidth:Number = 0;
    		var iconHeight:Number = 0;
    		var headerWidth:Number = 0;
    		var headerHeight:Number = 0;
    		var editWidth:Number = 0;
    		var editHeight:Number = 0;
    		
    		if(icon != null)
    		{
    			iconWidth = icon.measuredWidth;
    			iconHeight = icon.measuredHeight;
    		}
    		
    		if(header != null)
    		{
    			headerWidth = header.measuredWidth;
    			headerHeight = header.measuredHeight;
    		}
    		
    		if(editFrame != null)
    		{
    			editWidth = editFrame.measuredWidth;
    			editHeight = editFrame.measuredHeight;
    		}
    		
    		measuredEditWidth = iconWidth + Math.max(headerWidth, editWidth);
    		measuredEditHeight = Math.max(iconHeight, headerHeight + editHeight);
    	}
	}
}