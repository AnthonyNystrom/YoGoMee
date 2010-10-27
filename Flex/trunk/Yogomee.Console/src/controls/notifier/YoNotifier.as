package controls.notifier
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.core.UIComponent;

	public class YoNotifier extends UIComponent
	{
		/**
		 * Constructor. 
		 */		
		public function YoNotifier()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Proerties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  notifications
    	//----------------------------------
		
		private var _notifications:ArrayCollection;
		
		protected function get notifications():ArrayCollection
		{
			if(_notifications == null)
			{
				_notifications = new ArrayCollection();
			}
			
			return _notifications;
		}
		
		private var _cursor:IViewCursor;
		
		protected function get cursor():IViewCursor
		{
			if(_cursor == null || _cursor.afterLast)
			{
				if(_cursor != null)
				{
					_cursor = null;
				}
				
				_cursor = notifications.createCursor();
			}
			
			return _cursor;
		}
		
		//----------------------------------
    	//  label
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for label property. 
    	 */    	
    	private var _label:String;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _label changes. 
    	 */    	
    	private var _labelChanged:Boolean;
    	
    	/**
    	 * @public
    	 * Specifies notifier label. 
    	 */    	
    	public function get label():String
    	{
    		return _label;
    	}
    	
    	/**
    	 * @public
    	 * Specifies notifier label. 
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
    	//  radius
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for radius property. 
    	 */    	
    	private var _radius:Number = 6;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _radius changes. 
    	 */    	
    	private var _radiusChanged:Boolean;
    	
    	/**
    	 * Specifies notifier radius. 
    	 */    	
    	public function get radius():Number
    	{
    		return _radius;
    	}
    	
    	/**
    	 * Specifies notifier radius. 
    	 */
    	public function set radius(radius:Number):void
    	{
    		if(_radius != radius)
    		{
    			_radius = radius;
    			_radiusChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  borderTickness
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for borderTickness property. 
    	 */    	
    	private var _borderTickness:Number = 3;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _borerTickness changes. 
    	 */    	
    	private var _borderTicknessChanged:Boolean;
    	
    	/**
    	 * Specifies border trickness. 
    	 */    	
    	public function get borderTickness():Number
    	{
    		return _borderTickness;
    	}
    	
    	/**
    	 * Specifies border trickness. 
    	 */
    	public function set borderTickness(borderTickness:Number):void
    	{
    		if(_borderTickness != borderTickness)
    		{
    			_borderTickness = borderTickness;
    			_borderTicknessChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  fill color
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for fillColor property.
    	 */    	
    	private var _fillColor:Number = 0xcc0001;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _fillColor changes. 
    	 */    	
    	private var _fillColorChanged:Boolean;
    	
    	/**
    	 * Specifies fill color. 
    	 */    	
    	public function get fillColor():Number
    	{
    		return _fillColor;
    	}
    	
    	/**
    	 * Specifies fill color. 
    	 */
    	public function set fillColor(fillColor:Number):void
    	{
    		if(_fillColor != fillColor)
    		{
    			_fillColor = fillColor;
    			_fillColorChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  border color
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for borderColor property 
    	 */    	
    	private var _borderColor:Number = 0xffffff;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _borderColor changes. 
    	 */    	
    	private var _borderColorChanged:Boolean;
    	
    	/**
    	 * Specifies border color. 
    	 */    	
    	public function get borderColor():Number
    	{
    		return _borderColor;
    	}
    	
    	/**
    	 * Specifies border color. 
    	 */
    	public function set borderColor(borderColor:Number):void
    	{
    		if(_borderColor != borderColor)
    		{
    			_borderColor = borderColor;
    			_borderColorChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  label
    	//----------------------------------
    	
    	private var _labelText:UIComponent;
    	
    	private var _labelTextChanged:Boolean;
    	
    	protected function get labelText():UIComponent
    	{
    		return _labelText;
    	}
    	
    	protected function set labelText(labelText:UIComponent):void
    	{
    		if(_labelText != labelText)
    		{
    			_labelText = labelText;
    			_labelTextChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	protected function createLabelText():void
    	{
    		if(_labelText == null)
    		{
    			_box = new VBox();
    			
    			_box.setStyle("paddingTop", 0);
    			_box.setStyle("paddingLeft", 1);
    			_box.setStyle("paddingRignt", 0);
    			_box.setStyle("paddingBottom", 0);
    			_box.setStyle("verticalAlign", "middle");
    			_box.setStyle("horizontalAlign", "center");
    			
    			_labelText = new Text();
    			_labelText.styleName = "NotifierLabel";
    			_box.addChild(_labelText);
    			
    			_labelText.mouseChildren = false;
    			_labelText.useHandCursor = true;
    			_labelText.buttonMode = true;
    			
    			_labelText.addEventListener(
    				MouseEvent.CLICK,
    				function(event:MouseEvent):void
    				{
    					var e:YoNotifierEvent = new YoNotifierEvent(YoNotifierEvent.NOTIFIER_CLICKED, getNextObject());
    					dispatchEvent(e);
    				});
    			
    			addChild(_box);
    		}
    	}
    	
    	protected function updateLabel():void
    	{
    		var text:Text = labelText as Text;
    		
    		if(text != null)
    		{
    			text.text = label;
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Public methods
    	//
    	//--------------------------------------------------------------------------
    	
    	public function addNotification(n:Object):void
    	{
    		notifications.addItem(n);
    	}
    	
    	public function removeNotification(n:Object):void
    	{
    		var i:int = notifications.getItemIndex(n);
    		
    		if(i != -1)
    		{
    			notifications.removeItemAt(i);
    		}
    	}
    	
    	public function clearNotifications():void
    	{
    		notifications.removeAll();
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Private methods
    	//
    	//--------------------------------------------------------------------------
    	
    	private function getNextObject():Object
    	{
    		var o:Object = cursor.current;
    		cursor.moveNext();
    		return o;
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Overriden protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	private var _box:VBox;
    	
    	/**
    	 * @override
    	 * Create and add children.  
    	 */
    	protected override function createChildren():void
    	{
    		super.createChildren();
    		
    		createLabelText();
    	}
    	
    	/**
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
    			updateLabel();
    			
    			_labelChanged = false;
    			_labelTextChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update radius
    		if(_radiusChanged)
    		{
    			_radiusChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update border tickness
    		if(_borderTicknessChanged)
    		{
    			_borderTicknessChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update fill color
    		if(_fillColorChanged)
    		{
    			_fillColorChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update border color
    		if(_borderColorChanged)
    		{
    			_borderColorChanged = false;
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
    		
    		// validate display list if need.
    		if(needInvalidateDisplayList)
    		{
    			invalidateDisplayList();
    		}
    	}
    	
    	/**
    	 * Sets the default component size. 
    	 */    	
    	protected override function measure():void
    	{
    		super.measure();
    		
    		var r:Number = radius;
			
			measuredWidth = 2*r;
			measuredHeight = 2*r;
    	}
    	
    	/**
    	 * Draws notifier. 
    	 */    	
    	protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    	{
    		super.updateDisplayList(unscaledWidth, unscaledHeight);
    		
    		if(labelText != null)
    		{
    			//labelText.move(radius - labelText.measuredWidth/2, radius - labelText.measuredHeight/2);
    			//labelText.setActualSize(labelText.measuredWidth, labelText.measuredHeight);
    			
    			_box.move(0, 0);
    			_box.setActualSize(unscaledWidth, unscaledHeight);
    		}
    		
    		graphics.clear();
    		
    		graphics.beginFill(0x666666);
    		graphics.drawCircle(unscaledWidth/2, unscaledHeight/2, radius);
    		graphics.endFill();
    		
    		graphics.beginFill(borderColor);
    		graphics.drawCircle(unscaledWidth/2, unscaledHeight/2, radius-1);
    		graphics.endFill();
    		
    		graphics.beginFill(fillColor);
    		graphics.drawCircle(unscaledWidth/2, unscaledHeight/2, radius - borderTickness);
    		graphics.endFill();
    	}
	}
}