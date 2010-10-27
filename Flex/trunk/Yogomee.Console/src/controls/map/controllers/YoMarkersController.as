package controls.map.controllers
{
	import controls.map.marker.YoMarker;
	
	import defer.Deferred;
	
	import domainModel.UnitOfWork;
	
	import mx.core.UIComponent;

	public class YoMarkersController extends MarkersController
	{
		/**
		 * Constructor 
		 */		
		public function YoMarkersController(layer:UIComponent)
		{
			super(layer);
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  uow
    	//----------------------------------
		
		private var _uow:UnitOfWork;
		
		public function get uow():UnitOfWork
		{
			return _uow;
		}
		
		public function set uow(uow:UnitOfWork):void
		{
			if(_uow != uow)
			{
				_uow = uow;
				
				clearMarkers();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Protected properties
    	//
    	//--------------------------------------------------------------------------
    	
    	//----------------------------------
    	//  markers
    	//----------------------------------
    	
    	private var _markers:Object = new Object();
    	
    	protected function get markers():Object
    	{
    		return _markers;
    	}
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Public methods
    	//
    	//--------------------------------------------------------------------------
    	
    	//--------------------------------------------------------------------------
    	//
    	//  Protected methods
    	//
    	//--------------------------------------------------------------------------
    	
    	protected function clearMarkers():void
    	{
    		for(var marker:String in markers)
			{
				layer.removeChild(markers[marker]);
				markers[marker] = null;
				delete markers[marker];
			}
			
			_markers = new Object();
    	}
    	
    	protected function _addMarker(object:Object):Deferred
    	{
    		if(checkMarker(object))
    		{
    			return Deferred.succeed(true);
    		}
    		
    		var id:Object = getId(object);
    		var marker:YoMarker = createMarker();
    		updateMarker(marker, object);
    		markers[id] = marker;
    		layer.addChild(marker);
    			
    		return Deferred.succeed(true);
    	}
    	
    	protected function getId(object:Object):Object
    	{
    		return object;
    	}
    	
    	protected function checkMarker(object:Object):Boolean
    	{
    		var id:Object = getId(object);
    		
    		var marker:YoMarker = markers[id] as YoMarker;
    		
    		if(marker != null)
    		{
    			updateMarker(marker, object);
    			return true;
    		}
    		
    		return false;
    	}
    	
    	protected function updateMarker(marker:YoMarker, object:Object):void
    	{
    	}
    	
    	protected function createMarker():YoMarker
    	{
    		return new YoMarker();
    	}
	}
}