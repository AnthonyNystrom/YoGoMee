package controls.map.marker
{
	import flash.geom.Matrix;
	
	import mx.controls.Image;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	
	/**
	 * Represents marker icon. 
	 */	
	public class YoMarkerIcon extends UIComponent
	{
		/**
		 * Constructor 
		 */		
		public function YoMarkerIcon()
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
    	//  gap
    	//----------------------------------
    	
    	/**
    	 * Storage for gap property. 
    	 */    	
    	private var _gap:Number;
    	
    	/**
    	 * Flag to indicate when _gap changes.
    	 */    	
    	private var _gapChanged:Boolean;
    	
    	/**
    	 * Specifies gap between border and icon. 
    	 */    	
    	public function get gap():Number
    	{
    		return _gap;
    	}
    	
    	/**
    	 * Specifies gap between border and icon. 
    	 */
    	public function set gap(gap:Number):void
    	{
    		if(_gap != gap)
    		{
    			_gap = gap;
    			_gapChanged = true;
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
    	
    	//----------------------------------
    	//  source
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for source property. 
    	 */    	
    	private var _source:Object;
    	
    	/**
    	 * Flag to indicate when _source chaages. 
    	 */    	
    	private var _sourceChanged:Boolean;
    	
    	/**
    	 * Specifies icon image source. 
    	 */    	
    	public function get source():Object
    	{
    		return _source;
    	}
    	
    	/**
    	 * Specifies icon image source. 
    	 */
    	public function set source(source:Object):void
    	{
    		if(_source != source)
    		{
    			_source = source;
    			_sourceChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  image
    	//----------------------------------
    	
    	/**
    	 * @private
    	 * Storage for image child. 
    	 */    	
    	private var _image:Image;
    	
    	/**
    	 * @private
    	 * Flag to indicate when _image changes. 
    	 */    	
    	private var _imageChanged:Boolean;
    	
    	/**
    	 * @protected
    	 * Specifies image child. 
    	 */    	
    	protected function get image():Image
    	{
    		return _image;
    	}
    	
    	/**
    	 * @protected
    	 * Specifies image child. 
    	 */    	
    	protected function set image(image:Image):void
    	{
    		if(_image != image)
    		{
    			_image = image;
    			_imageChanged = true;
    			invalidateProperties();
    		}
    	}
    	
    	/**
    	 * @protected 
    	 * Creates and add image.
    	 */    	
    	protected function createImage():void
    	{
    		if(_image == null)
    		{
    			_image = new Image();
    			addChild(_image);
    		}
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
    		
    		createImage();
    	}
    	
    	/**
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
    		
    		// update radius
    		if(_radiusChanged)
    		{
    			_radiusChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update gap
    		if(_gapChanged)
    		{
    			_gapChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update fill color
    		if(_fillColorChanged)
    		{
    			_fillColorChanged = false;
    			needInvalidateDisplayList = true;
    		}
    		
    		// update source
    		if(_sourceChanged)
    		{
    			if(image != null)
    			{
    				image.source = source;
    			}
    			
    			_sourceChanged = false;
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		// ---------------------
    		// Children
    		// ---------------------
    		
    		// update image
    		if(_imageChanged)
    		{
    			_imageChanged = false;
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
    	 * Draws icon. 
    	 */    	
    	protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    	{
    		super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var r:Number = radius;
			
			graphics.clear();
			
			graphics.beginFill(fillColor);
			graphics.drawCircle(r, r, r - gap);
			graphics.endFill();
			
			image.move(r - 12, r - 12);
			image.setActualSize(24, 24);
	   	}
	}
}