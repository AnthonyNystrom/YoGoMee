package controls.map.marker
{
	import mx.core.UIComponent;
	
	/**
	 * Represents marker substrate. 
	 */	
	public class YoMarkerSubstrate extends UIComponent
	{
		/**
		 * Constructor. 
		 */		
		public function YoMarkerSubstrate()
		{
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------

    	//----------------------------------
    	//  radius
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for radius property. 
    	 */    	
    	private var _radius:Number;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _radius property changes. See <code>commitProperties</code>. 
    	 */    	
    	private var _radiusChanged:Boolean;
    	
    	/**
    	 * Specifies substrate radius. 
    	 */    	
    	public function get radius():Number
    	{
    		return _radius;
    	}
    	
    	/**
    	 * Specifies substrate radius. 
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
    	//  tailHeight
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for tailHeight property. 
    	 */    	
    	private var _tailHeight:Number;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _tailHeight property changed.
    	 * See <code>commitProperties</code>. 
    	 */    	
    	private var _tailHeightChanged:Boolean;
    	
    	/**
    	 * Specifies tail height. 
    	 */    	
    	public function get tailHeight():Number
    	{
    		return _tailHeight;
    	}
    	
    	/**
    	 * Specifies tail height. 
    	 */
    	public function set tailHeight(tailHeight:Number):void
    	{
    		if(_tailHeight != tailHeight)
    		{
    			_tailHeight = tailHeight;
    			_tailHeightChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  tailWidth
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for tailWidth property. 
    	 */    	
    	private var _tailWidth:Number;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _tailWidth property changes. See <code>commitProperies</code>.  
    	 */    	
    	private var _tailWidthChanged:Boolean;
    	
    	/**
    	 * Spicifies tail width. 
    	 */    	
    	public function get tailWidth():Number
    	{
    		return _tailWidth;
    	}
    	
    	/**
    	 * Spicifies tail width. 
    	 */
    	public function set tailWidth(tailWidth:Number):void
    	{
    		if(_tailWidth != tailWidth)
    		{
    			_tailWidth = tailWidth;
    			_tailWidthChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  tailPos
    	//----------------------------------
    	
    	/**
    	 * Storage for tailPos property. 
    	 */    	
    	private var _tailPos:Number;
    	
    	/**
    	 * Flag to indicate when _tailPos property changes. See <code>commitProperties</code>. 
    	 */    	
    	private var _tailPosChanged:Boolean;
    	
    	/**
    	 * Specifies tail position. 
    	 */    	
    	public function get tailPos():Number
    	{
    		return _tailPos;
    	}
    	
    	/**
    	 * Specifies tail position. 
    	 */
    	public function set tailPos(tailPos:Number):void
    	{
    		if(_tailPos != tailPos)
    		{
    			_tailPos = tailPos;
    			_tailPosChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * Specifies tail x coordinate. 
    	 */    	
    	public function get tailX():Number
    	{
    		var r:Number = radius;
			var tp:Number = tailPos;
			
			var w:Number = width;
			
			if(w == 0)
			{
				w = measuredWidth;
			}
			
			return w*tp + r*(1.0-2.0*tp);
    	}
    	
    	/**
    	 * Specifies tail y coordinate.
    	 */    	
    	public function get tailY():Number
    	{
    		if(height == 0)
    		{
    			return measuredHeight;
    		}
    		
    		return height;
    	}
    	
    	//----------------------------------
    	//  borderTickness
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for borderTickness property. 
    	 */    	
    	private var _borderTickness:Number;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _borderTickness property chages.
    	 * See <code>commitProperties</code> 
    	 */    	
    	private var _borderTicknessChanged:Boolean;
    	
    	/**
    	 * Specifies border tickness. 
    	 */    	
    	public function get borderTickness():Number
    	{
    		return _borderTickness;
    	}
    	
    	/**
    	 * Specifies border tickness. 
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
    	//  borderColor
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for borderColor property. 
    	 */    	
    	private var _borderColor:uint;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _borderColor property changes.
    	 * See <code>commitProperties</code>. 
    	 */    	
    	private var _borderColorChanged:Boolean;
    	
    	/**
    	 * Specifies border color. 
    	 */    	
    	public function get borderColor():uint
    	{
    		return _borderColor;
    	}
    	
    	/**
    	 * Specifies border color. 
    	 */    	
    	public function set borderColor(borderColor:uint):void
    	{
    		if(_borderColor != borderColor)
    		{
    			_borderColor = borderColor;
    			_borderColorChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//----------------------------------
    	//  fillColor
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for fillColor property. 
    	 */    	
    	private var _fillColor:uint;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _fillColor property chages.
    	 * See <code>commitProperties</code>. 
    	 */    	
    	private var _fillColorChanged:Boolean;
    	
    	/**
    	 * Specifies fill color. 
    	 */    	
    	public function get fillColor():uint
    	{
    		return _fillColor;
    	}
    	
    	/**
    	 * Specifies fill color. 
    	 */    	
    	public function set fillColor(fillColor:uint):void
    	{
    		if(_fillColor != fillColor)
    		{
    			_fillColor = fillColor;
    			_fillColorChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Override protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	/**
    	 * Coordinates modifications to component properties. 
    	 */
    	protected override function commitProperties():void
    	{
    		super.commitProperties();
    		
    		var needInvalidateSize:Boolean = false;
    		var needInvalidateDisplayList:Boolean = false;
    		
    		// update radius
    		if(_radiusChanged)
    		{
    			_radiusChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update tail height
    		if(_tailHeightChanged)
    		{
    			_tailHeightChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update tail width
    		if(_tailWidthChanged)
    		{
    			_tailWidthChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		//update tail position
    		if(_tailPosChanged)
    		{
    			_tailPosChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update border tickness
    		if(_borderTicknessChanged)
    		{
    			_borderTicknessChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update border color
    		if(_borderColorChanged)
    		{
    			_borderColorChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update fill color
    		if(_fillColorChanged)
    		{
    			_fillColorChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
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
			var th:Number = tailHeight;
			
			measuredWidth = 2*r;
			measuredHeight = 2*r + th;
    	}
    	
    	/**
    	 * Draws substrate. 
    	 */    	
    	protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    	{
    		super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var r:Number = radius;
			var tw:Number = tailWidth;
			var th:Number = tailHeight;
			var tp:Number = tailPos;
			var bt:Number = borderTickness;
			
			var w:Number = unscaledWidth;
			var h:Number = unscaledHeight - th;
			
			var x:Number = 0;
			var y:Number = 0;
			
			var d:Number = r*2;
			
			var tx:Number = tailX;
			var ty:Number = tailY;
			
			graphics.clear();
			graphics.beginFill(borderColor);
			graphics.drawRoundRect(x,y,w,h,d,d);
			graphics.moveTo(tx, ty);
			graphics.lineTo(tx - tw/2, ty - th);
			graphics.lineTo(tx + tw/2, ty - th);
			graphics.lineTo(tx, ty);
			graphics.endFill();
			
			graphics.beginFill(fillColor);
			graphics.drawRoundRect(x+bt,y+bt,w-2*bt,h-2*bt,d,d);
			graphics.moveTo(tx, ty-2*bt);
			graphics.lineTo(tx - tw/2 + bt, ty - th - bt);
			graphics.lineTo(tx + tw/2 - bt, ty - th - bt);
			graphics.lineTo(tx, ty-2*bt);
			graphics.endFill();
    	}
	}
}