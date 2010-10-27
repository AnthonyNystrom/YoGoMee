package controls.notifier
{
	import mx.core.UIComponent;
	
	/**
	 * Component with notifier 
	 */	
	public class YoNotifierComponent extends UIComponent
	{
		/**
		 * Constructor 
		 */		
		public function YoNotifierComponent()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  notifier label
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for notifierLabel property 
		 */		
		private var _notifierLabel:String;
		
		/**
		 * @private
		 * Flag to indicate when _notifierLabel changes 
		 */		
		private var _notifierLabelChanged:Boolean;
		
		/**
		 * Specifies notifier label 
		 */		
		public function get notifierLabel():String
		{
			return _notifierLabel;
		}
		
		/**
		 * Specifies notifier label 
		 */
		public function set notifierLabel(notifierLabel:String):void
		{
			if(_notifierLabel != notifierLabel)
			{
				_notifierLabel = notifierLabel;
				_notifierLabelChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  notifier radius
    	//----------------------------------
		
		private var _notifierRadius:Number = 6;
		
		private var _notifierRadiusChanged:Boolean;
		
		public function get notifierRadius():Number
		{
			return _notifierRadius;
		}
		
		public function set notifierRadius(notifierRadius:Number):void
		{
			if(_notifierRadius != notifierRadius)
			{
				_notifierRadius = notifierRadius;
				_notifierRadiusChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  notifier border tickness
    	//----------------------------------
		
		private var _notifierBorderTickness:Number = 3;
		
		private var _notifierBorderTicknessChanged:Boolean;
		
		public function get notifierBorderTickness():Number
		{
			return _notifierBorderTickness;
		}
		
		public function set notifierBorderTickness(notifierBorderTickness:Number):void
		{
			if(_notifierBorderTickness != notifierBorderTickness)
			{
				_notifierBorderTickness = notifierBorderTickness;
				_notifierBorderTicknessChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  notifier fill color
    	//----------------------------------
		
		private var _notifierFillColor:Number = 0xcc0001;
		
		private var _notifierFillColorChanged:Boolean;
		
		public function get notifierFillColor():Number
		{
			return _notifierFillColor;
		}
		
		public function set notifierFillColor(notifierFillColor:Number):void
		{
			if(_notifierFillColor != notifierFillColor)
			{
				_notifierFillColor = notifierFillColor;
				_notifierFillColorChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  notifier border color
    	//----------------------------------
		
		private var _notifierBorderColor:Number = 0xffffff;
		
		private var _notifierBorderColorChanged:Boolean;
		
		public function get notifierBorderColor():Number
		{
			return _notifierBorderColor;
		}
		
		public function set notifierBorderColor(notifierBorderColor:Number):void
		{
			if(_notifierBorderColor != notifierBorderColor)
			{
				_notifierBorderColor = notifierBorderColor;
				_notifierBorderColorChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	//  notifier visible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for notifierVisible property. 
		 */		
		private var _notifierVisible:Boolean = false;
		
		/**
		 * @private
		 * Flag to indicate when _notifierVisible changes. 
		 */		
		private var _notifierVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of notifier component. 
		 */		
		public function get notifierVisible():Boolean
		{
			return _notifierVisible;
		}
		
		/**
		 * Specifies visibility of notifier component. 
		 */
		public function set notifierVisible(notifierVisible:Boolean):void
		{
			if(_notifierVisible != notifierVisible)
			{
				_notifierVisible = notifierVisible;
				_notifierVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  notifier
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for notifier component. 
		 */		
		private var _notifier:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _notifier changes 
		 */		
		private var _notifierChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies notifier component. 
		 */		
		protected function get notifier():UIComponent
		{
			return _notifier;
		}
		
		/**
		 * @protected
		 * Specifies notifier component. 
		 */
		protected function set notifier(notifier:UIComponent):void
		{
			if(_notifier != notifier)
			{
				_notifier = notifier;
				_notifierChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates notifier component. 
		 */		
		protected function createNotifier():void
		{
			if(_notifier == null)
			{
				_notifier = new YoNotifier();
				_notifier.visible = false;
				
				_notifier.addEventListener(
					YoNotifierEvent.NOTIFIER_CLICKED,
					function(event:YoNotifierEvent):void
					{
						var e:YoNotifierEvent = new YoNotifierEvent(YoNotifierEvent.NOTIFIER_CLICKED, event.object);
						dispatchEvent(e);
					});
				
				addChild(_notifier);
			}
		}
		
		/**
		 * @protected
		 * Update notifier properties and visibility. 
		 */		
		protected function updateNotifier():void
		{
			var n:YoNotifier = notifier as YoNotifier;
			
			if(n != null)
			{
				n.label = notifierLabel;
				n.radius = notifierRadius;
				n.borderTickness = notifierBorderTickness;
				n.fillColor = notifierFillColor;
				n.borderColor = notifierBorderColor;
				n.visible = notifierVisible;
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Public methods
    	//
    	//--------------------------------------------------------------------------
		
		public function addNotification(o:Object):void
		{
			var n:YoNotifier = notifier as YoNotifier;
			
			if(n != null)
			{
				n.addNotification(o);
			}	
		}
		
		public function removeNotification(o:Object):void
		{
			var n:YoNotifier = notifier as YoNotifier;
			
			if(n != null)
			{
				n.removeNotification(o);
			}
		}
		
		public function clearNotifications():void
		{
			var n:YoNotifier = notifier as YoNotifier;
			
			if(n != null)
			{
				n.clearNotifications();
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
    		
    		createNotifier();
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
    		
    		// update notifier
    		if(
    			_notifierChanged ||
    			_notifierLabelChanged ||
    			_notifierRadiusChanged ||
    			_notifierBorderTicknessChanged ||
    			_notifierFillColorChanged ||
    			_notifierBorderColorChanged ||
    			_notifierVisibleChanged
    			)
    		{
    			updateNotifier();
    			
    			_notifierChanged = false;
    			_notifierLabelChanged = false;
    			_notifierRadiusChanged = false;
    			_notifierBorderTicknessChanged = false;
    			_notifierFillColorChanged = false;
    			_notifierBorderColorChanged = false;
    			_notifierVisibleChanged = false;
    			
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
    		
    		if(notifier != null)
    		{
    			notifier.move(unscaledWidth - notifier.measuredWidth, 0);
    			notifier.setActualSize(notifier.measuredWidth, notifier.measuredHeight);
    		}
    	}
	}
}