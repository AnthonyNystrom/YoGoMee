package controls.map
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.MapType;
	
	import controls.map.controllers.FriendsGomeeMarkersController;
	import controls.map.controllers.FriendsProfileMarkersController;
	import controls.map.controllers.MineGomeeMarkersController;
	import controls.map.controllers.MineProfileMarkersController;
	import controls.map.controllers.SearchMarkersController;
	import controls.map.controllers.TheirsGomeeMarkersController;
	import controls.map.controllers.TheirsProfileMarkersController;
	import controls.map.controls.YoInvitesFilterControl;
	import controls.map.controls.YoMapTypeControl;
	import controls.map.controls.YoMarkersFilterControl;
	import controls.map.controls.YoNewGomeeMarkerControl;
	import controls.map.controls.YoNewHomeMarkerControl;
	import controls.map.controls.YoTagFilterControl;
	import controls.map.controls.YoZoomControl;
	import controls.map.events.YoMapEvent;
	import controls.map.marker.YoGomeeMarker;
	import controls.map.marker.YoHomeMarker;
	import controls.map.marker.YoMarker;
	import controls.panel.YoPanelState;
	
	import domainModel.IUnitOfWork;
	import domainModel.UnitOfWork;
	import domainModel.entities.Gomee;
	import domainModel.entities.User;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.DynamicEvent;
	import mx.managers.DragManager;
	import mx.utils.StringUtil;

	public class YoMap extends UIComponent
	{
		/**
		 * Constructor. 
		 */		
		public function YoMap()
		{
			super();
			var l:YoMarkersLayer;
			addEventListener(
				DragEvent.DRAG_ENTER,
				function(event:DragEvent):void
				{
					if(event.dragInitiator is YoMarker)
					{
						DragManager.acceptDragDrop(event.currentTarget as UIComponent);
					}
				});
				
			addEventListener(
				DragEvent.DRAG_DROP,
				function(event:DragEvent):void
				{
					if(uow != null)
					{
						var p:Point = new Point(event.localX, event.localY);
						var latlng:LatLng = fromViewportToLatLng(p);
						var gomee:Gomee = new Gomee();
						
						var data:Object = new Object();
						data.gomee = gomee;
						
						if(event.dragInitiator is YoGomeeMarker)
						{
							var initiator:YoGomeeMarker = event.dragInitiator as YoGomeeMarker;
							
							if(initiator.data is YoGomeeMarker)
							{
								initiator.latLng = latlng;
								_mineGomeeMarkersController.dropMarker(initiator);
							}
							else
							{
								gomee.lat = latlng.lat();
								gomee.lng = latlng.lng();
								gomee.caption = initiator.caption;
								gomee.address = initiator.address;
								gomee.description = initiator.description;
								gomee.common = initiator.common;
								gomee.tags = StringUtil.trimArrayElements(initiator.tags, ",").split(",");
								gomee.type = 1;
							
								_mineGomeeMarkersController.addMarker(data);
							}
						}
						
						if(event.dragInitiator is YoHomeMarker)
						{
							var home:YoHomeMarker = event.dragInitiator as YoHomeMarker;
							
							if(home.data is YoHomeMarker)
							{
								home.latLng = latlng;
								_mineHomeMarkersController.dropMarker(home);
							}
							else
							{
								gomee.lat = latlng.lat();
								gomee.lng = latlng.lng();
								gomee.caption = home.caption;
								gomee.address = home.address;
								gomee.description = home.description;
								gomee.common = home.common;
								gomee.tags = StringUtil.trimArrayElements(home.tags, ",").split(",");
								gomee.type = 0;
							
								_mineHomeMarkersController.addMarker(data);
							}
						}
					}
				});
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	// key
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for key property. 
		 */		
		private var _key:String;
		
		/**
		 * @private
		 * Flag to indicate when _key changed. 
		 */		
		private var _keyChanged:Boolean;
		
		/**
		 * Specifies map key. 
		 */		
		public function get key():String
		{
			return _key;
		}
		
		/**
		 * Specifies map key. 
		 */
		public function set key(key:String):void
		{
			if(_key != key)
			{
				_key = key;
				_keyChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	// gomee id
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for gomeeId property. 
		 */		
		private var _gomeeId:String;
		
		/**
		 * @private
		 * Flag to indicate when _gomeeId changes. 
		 */		
		private var _gomeeIdChanged:Boolean;
		
		/**
		 * Specifies gomee to display on startup. 
		 */		
		public function get gomeeId():String
		{
			return _gomeeId;
		}
		
		/**
		 * Specifies gomee to display on startup. 
		 */
		public function set gomeeId(gomeeId:String):void
		{
			if(_gomeeId != gomeeId)
			{
				_gomeeId = gomeeId;
				_gomeeIdChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	// search query
    	//----------------------------------
		
		private var _searchQuery:String;
		
		private var _searchQueryChanged:Boolean;
		
		public function get searchQuery():String
		{
			return _searchQuery;
		}
		
		public function set searchQuery(searchQuery:String):void
		{
			if(_searchQuery != searchQuery)
			{
				_searchQuery = searchQuery;
				_searchQueryChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	// unit of work
    	//----------------------------------
    	
		/**
		 * @private
		 * Storage for uow property. 
		 */    	
		private var _uow:IUnitOfWork;
		
		/**
		 * @private
		 * Flag to indicate when _uow changes. 
		 */		
		private var _uowChanged:Boolean;
		
		/**
		 * Specifies uonit of work. 
		 */		
		public function get uow():IUnitOfWork
		{
			return _uow;
		}
		
		/**
		 * Specifies uonit of work. 
		 */
		public function set uow(uow:IUnitOfWork):void
		{
			if(_uow != uow)
			{
				_uow = uow;
				_uowChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Children
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	// controls box
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for controlsBox component. 
		 */		
		private var _controlsBox:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _controlsBox changes. 
		 */		
		private var _controlsBoxChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component that displays controls. 
		 */		
		protected function get controlsBox():UIComponent
		{
			return _controlsBox;
		}
		
		/**
		 * @protected
		 * Specifies component that displays controls. 
		 */
		protected function set controlsBox(controlsBox:UIComponent):void
		{
			if(_controlsBox != controlsBox)
			{
				_controlsBox = controlsBox;
				_controlsBoxChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates controlsBox component.
		 */		
		protected function createControlsBox():void
		{
			if(_controlsBox == null)
			{
				_controlsBox = new HBox();
				addChild(_controlsBox);
			}
		}
		
		//----------------------------------
    	// zoom control
    	//----------------------------------
		
		private var _zoomControl:UIComponent;
		
		private var _zoomControlChanged:Boolean;
		
		protected function get zoomControl():UIComponent
		{
			return _zoomControl;
		}
		
		protected function set zoomControl(zoomControl:UIComponent):void
		{
			if(_zoomControl != zoomControl)
			{
				_zoomControl = zoomControl;
				_zoomControlChanged = true;
				invalidateProperties();
			}
		}
		
		protected function createZoomControl():void
		{
			if(_zoomControl == null)
			{
				_zoomControl = new YoZoomControl();
				_zoomControl.height = 52;
				
				_zoomControl.addEventListener(
					"zoomInClicked",
					function(event:Event):void
					{
						var lvl:Number = getZoom();
						if(lvl < 19)
						{
							setZoom(lvl + 1);
						}
					});
				
				_zoomControl.addEventListener(
					"zoomOutClicked",
					function(event:Event):void
					{
						var lvl:Number = getZoom();
						if(lvl > 3)
						{
							setZoom(lvl - 1);
						}
					});
					
				_controlsBox.addChild(_zoomControl);
			}
		}
		
		//----------------------------------
    	// new gomee control
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for newGomeeControl component. 
		 */		
		private var _newGomeeControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _newGomeeControl changes. 
		 */		
		private var _newGomeeControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component that allow to create new gomees. 
		 */		
		protected function get newGomeeControl():UIComponent
		{
			return _newGomeeControl;
		}
		
		/**
		 * @protected
		 * Specifies component that allow to create new gomees. 
		 */
		protected function set newGomeeControl(newGomeeControl:UIComponent):void
		{
			if(_newGomeeControl != newGomeeControl)
			{
				_newGomeeControl = newGomeeControl;
				_newGomeeControlChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates newGomeeControl component.
		 */		
		protected function createNewGomeeControl():void
		{
			if(_newGomeeControl == null)
			{
				_newGomeeControl = new YoNewGomeeMarkerControl();
				controlsBox.addChild(_newGomeeControl);
			}
		}
		
		//----------------------------------
    	// new home control
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for newHomeControl component. 
		 */		
		private var _newHomeControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _newHomeControl changes. 
		 */		
		private var _newHomeControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies control that allow to greate new home markers. 
		 */		
		protected function get newHomeControl():UIComponent
		{
			return _newHomeControl;
		}
		
		/**
		 * @protected
		 * Specifies control that allow to greate new home markers. 
		 */
		protected function set newHomeControl(newHomeControl:UIComponent):void
		{
			if(_newHomeControl != newHomeControl)
			{
				_newHomeControl = newHomeControl;
				_newHomeControlChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates newHomeControl component.
		 */		
		protected function createNewHomeControl():void
		{
			if(_newHomeControl == null)
			{
				_newHomeControl = new YoNewHomeMarkerControl();
				controlsBox.addChild(_newHomeControl);
			}
		}
		
		//----------------------------------
    	// filters box
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for filtersBox component. 
		 */		
		private var _filtersBox:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _filtersBox changes. 
		 */		
		private var _filtersBoxChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to diaplay filters. 
		 */
		protected function get filtersBox():UIComponent
		{
			return _filtersBox;
		}
		
		/**
		 * @protected
		 * Specifies component to diaplay filters. 
		 */		
		protected function set filtersBox(filtersBox:UIComponent):void
		{
			if(_filtersBox != filtersBox)
			{
				_filtersBox = filtersBox;
				_filtersBoxChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates filtersBox coponent.
		 */		
		protected function createFiltersBox():void
		{
			if(_filtersBox == null)
			{
				_filtersBox = new HBox();
				_filtersBox.styleName = "MapFiltersBox";
				addChild(_filtersBox);
			}
		}
		
		//----------------------------------
    	// mine filter
    	//----------------------------------
		
		/**
		 * @provate
		 * Storage for mineFilter property. 
		 */		
		private var _mineFilter:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _mineFilter changes. 
		 */		
		private var _mineFilterChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies filter for mine markers. 
		 */
		protected function get mineFilter():UIComponent
		{
			return _mineFilter;
		}
		
		/**
		 * @protected
		 * Specifies filter for mine markers. 
		 */		
		protected function set mineFilter(mineFilter:UIComponent):void
		{
			if(_mineFilter != mineFilter)
			{
				_mineFilter = mineFilter;
				_mineFilterChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protecetd
		 * Creates mineFilter component.
		 */		
		protected function createMineFilter():void
		{
			if(_mineFilter == null)
			{
				var filter:YoMarkersFilterControl = new YoMarkersFilterControl();
				filter.label = "mine";
				filter.headerVisible = true;
				filter.collapsable = true;
				filter.state = YoPanelState.Colapsed;
				filter.homesVisible = true;
				filter.gomeesVisible = true;
				filter.headerStyleName = "YoMineFilterHeader";
				
				_mineFilter = filter;
				filtersBox.addChild(_mineFilter);
			}
		}
		
		//----------------------------------
    	// friends filter
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for friendsFilter component. 
		 */		
		private var _friendsFilter:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _friendsFilter changes. 
		 */		
		private var _friendsFilterChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to filter friends markers. 
		 */
		protected function get friendsFilter():UIComponent
		{
			return _friendsFilter;
		}
		
		/**
		 * @protected
		 * Specifies component to filter friends markers. 
		 */		
		protected function set friendsFilter(friendsFilter:UIComponent):void
		{
			if(_friendsFilter != friendsFilter)
			{
				_friendsFilter = friendsFilter;
				_friendsFilterChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates friendsFilter component. 
		 */		
		protected function createFriendsFilter():void
		{
			if(_friendsFilter == null)
			{
				var filter:YoMarkersFilterControl = new YoMarkersFilterControl();
				filter.label = "friends";
				filter.headerVisible = true;
				filter.collapsable = true;
				filter.state = YoPanelState.Colapsed;
				filter.gomeesVisible = true;
				filter.homesVisible = true;
				filter.headerStyleName = "YoFriendsFilterHeader";
				
				_friendsFilter = filter;
				filtersBox.addChild(_friendsFilter);
			}
		}
		
		//----------------------------------
    	// theirs filter
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for theirsFilter component. 
		 */		
		private var _theirsFilter:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _theirsFilter changes. 
		 */		
		private var _theirsFilterChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to filter theirs markers. 
		 */
		protected function get theirsFilter():UIComponent
		{
			return _theirsFilter;
		}
		
		/**
		 * @protected
		 * Specifies component to filter theirs markers. 
		 */		
		protected function set theirsFilter(theirsFilter:UIComponent):void
		{
			if(_theirsFilter != theirsFilter)
			{
				_theirsFilter = theirsFilter;
				_theirsFilterChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * CReate theirsFilter component.
		 */		
		protected function createTheirsFilter():void
		{
			if(_theirsFilter == null)
			{
				var filter:YoMarkersFilterControl = new YoMarkersFilterControl();
				filter.label = "theirs";
				filter.headerVisible = true;
				filter.collapsable = true;
				filter.state = YoPanelState.Colapsed;
				filter.gomeesVisible = true;
				filter.homesVisible = true;
				filter.headerStyleName = "YoTheirsFilterHeader";
				
				_theirsFilter = filter;
				filtersBox.addChild(_theirsFilter);
			}
		}
		
		//----------------------------------
    	// invites filter
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for invitesFilter property. 
		 */		
		private var _invitesFilter:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _invitesFilter changes. 
		 */		
		private var _invitesFilterChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies filter for invites. 
		 */
		protected function get invitesFilter():UIComponent
		{
			return _invitesFilter;
		}
		
		/**
		 * @protected
		 * Specifies filter for invites. 
		 */		
		protected function set invitesFilter(invitesFilter:UIComponent):void
		{
			if(_invitesFilter != invitesFilter)
			{
				_invitesFilter = invitesFilter;
				_invitesFilterChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protecetd
		 * Creates invitesFilter component.
		 */		
		protected function createInvitesFilter():void
		{
			if(_invitesFilter == null)
			{
				var filter:YoInvitesFilterControl = new YoInvitesFilterControl();
				filter.label = "invites";
				filter.headerVisible = true;
				filter.collapsable = true;
				filter.state = YoPanelState.Colapsed;
				filter.friendsVisible = true;
				filter.eventsVisible = true;
				
				_invitesFilter = filter;
				filtersBox.addChild(_invitesFilter);
			}
		}
		
		//----------------------------------
    	// tag filter
    	//----------------------------------
		
		private var _tagFilter:UIComponent;
		
		private var _tagFilterChanged:Boolean;
		
		protected function get tagFilter():UIComponent
		{
			return _tagFilter;
		}
		
		protected function set tagFilter(tagFilter:UIComponent):void
		{
			if(_tagFilter != tagFilter)
			{
				_tagFilter = tagFilter;
				_tagFilterChanged = true;
				invalidateProperties(); 
			}
		}
		
		protected function createTagFilter():void
		{
			if(_tagFilter == null)
			{
				var filter:YoTagFilterControl = new YoTagFilterControl();
				filter.label = "tags";
				filter.headerVisible = true;
				filter.collapsable = true;
				filter.state = YoPanelState.Colapsed;
				filter.tagsEnabled = false;
				
				_tagFilter = filter;
				filtersBox.addChild(_tagFilter);
			}
		}
		
		//----------------------------------
    	// map controls box
    	//----------------------------------
		
		/**
		 * @private
		 * Storage from mapControlsBox component. 
		 */		
		private var _mapControlsBox:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _mapControlsBox changed 
		 */		
		private var _mapControlsBoxChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to display map controls. 
		 */		
		protected function get mapControlsBox():UIComponent
		{
			return _mapControlsBox;
		}
		
		/**
		 * @protected
		 * Specifies component to display map controls. 
		 */
		protected function set mapControlsBox(mapBox:UIComponent):void
		{
			if(_mapControlsBox != mapBox)
			{
				_mapControlsBox = mapBox;
				_mapControlsBoxChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates mapControlsBox component. 
		 */		
		protected function createMapControlsBox():void
		{
			if(_mapControlsBox == null)
			{
				_mapControlsBox = new HBox();
				_mapControlsBox.styleName = "MapControlsBox";
				addChild(_mapControlsBox);
			}
		}
		
		//----------------------------------
    	// map type control
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for mapTypeControl component 
		 */		
		private var _mapTypeControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _mapTypeControl changes 
		 */		
		private var _mapTypeControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies control to changed map type. 
		 */		
		protected function get mapTypeControl():UIComponent
		{
			return _mapTypeControl;
		}
		
		/**
		 * @protected
		 * Specifies control to changed map type. 
		 */
		protected function set mapTypeControl(mapTypeControl:UIComponent):void
		{
			if(_mapTypeControl != mapTypeControl)
			{
				_mapTypeControl = mapTypeControl;
				_mapTypeControlChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected
		 * Creates mapTypeControl component. 
		 */		
		protected function createMapTypeControl():void
		{
			if(_mapTypeControl == null)
			{
				var control:YoMapTypeControl = new YoMapTypeControl();
				control.label = "map type";
				control.headerVisible = true;
				control.collapsable = true;
				control.state = YoPanelState.Colapsed;
				
				control.addEventListener(
					Event.CHANGE,
					function(event:Event):void
					{
						var m:YoMapLayer = _mapLayer as YoMapLayer;
						
						if(m != null)
						{
							m.setMapType(control.type);
						}
					});
				
				_mapTypeControl = control;
				_mapControlsBox.addChild(_mapTypeControl);
				
				control.type = MapType.PHYSICAL_MAP_TYPE;
				
				var m:YoMapLayer = _mapLayer as YoMapLayer;
						
				if(m != null)
				{
					m.setMapType(control.type);
				}
			}
		}
		
		//----------------------------------
    	// map expand control
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for mapExpandControl component.  
		 */		
		private var _mapExpandControl:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _mapExpandControl changes. 
		 */		
		private var _mapExpandControlChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component that epxands map. 
		 */
		protected function get mapExpandControl():UIComponent
		{
			return _mapExpandControl;
		}
		
		/**
		 * @protected
		 * Specifies component that epxands map. 
		 */		
		protected function set mapExpandControl(mapExpandControl:UIComponent):void
		{
			if(_mapExpandControl != mapExpandControl)
			{
				_mapExpandControl = mapExpandControl;
				_mapExpandControlChanged = true;
				invalidateProperties();
			}
		}
		
		private var _expanded:Boolean = false;
		
		/**
		 * @protected 
		 * Creates map expand control component.
		 */		
		protected function createMapExpandControl():void
		{
			if(_mapExpandControl == null)
			{
				_mapExpandControl = new VBox();
				_mapExpandControl.styleName = "MapExpandControl";
				
				var img:Image = new Image();
				img.width = 16;
				img.height = 16;
				img.source = "resources/expand.png";
				img.buttonMode = true;
				img.useHandCursor = true;
				img.mouseChildren = false;
				
				img.addEventListener(
					MouseEvent.CLICK,
					function(event:MouseEvent):void
					{
						if(!_expanded)
						{
							img.source = "resources/collapse.png";
							_expanded = true;
						}
						else
						{
							img.source = "resources/expand.png";
							_expanded = false;
						}
						dispatchEvent(new Event("expandClicked"));
					});
				
				_mapExpandControl.addChild(img);
				
				_mapControlsBox.addChild(_mapExpandControl);
			}
		}
		
		//----------------------------------
    	// map layer
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for mapLayer component. 
		 */		
		private var _mapLayer:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _mapLayer changes. 
		 */		
		private var _mapLayerChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to display google map. 
		 */		
		protected function get mapLayer():UIComponent
		{
			return _mapLayer;
		}
		
		/**
		 * @protected
		 * Specifies component to display google map. 
		 */
		protected function set mapLayer(mapLayer:UIComponent):void
		{
			if(_mapLayer != mapLayer)
			{
				_mapLayer = mapLayer;
				_mapLayerChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates mapLayer component.
		 */		
		protected function createMapLayer():void
		{
			if(_mapLayer == null)
			{
				_mapLayer = new YoMapLayer();
				
				_mapLayer.addEventListener(YoMapEvent.MapReady, mapLayerReadyHandler);
				_mapLayer.addEventListener(YoMapEvent.ViewChangeEnd, mapLayerViewChangeEndHandler);
				_mapLayer.addEventListener(YoMapEvent.ViewChangeStep, mapLayerViewChangeStepHandler);
				
				addChild(_mapLayer);
			}
		}
		
		/**
		 * @protected
		 * Updates mapLayre component with new values. 
		 */		
		protected function updateMapLayer():void
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				layer.key = key;
			}
		}
		
		//----------------------------------
    	// marker layer
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for markerLayer component. 
		 */		
		private var _markerLayer:UIComponent;
		
		/**
		 * @private
		 * Flag to indicate when _markerLayer changes. 
		 */		
		private var _markerLayerChanged:Boolean;
		
		/**
		 * @protected
		 * Specifies component to display markers.  
		 */		
		protected function get markerLayer():UIComponent
		{
			return _markerLayer;
		}
		
		/**
		 * @protected
		 * Specifies component to display markers.  
		 */
		protected function set markerLayer(markerLayer:UIComponent):void
		{
			if(_markerLayer != markerLayer)
			{
				_markerLayer = markerLayer;
				_markerLayerChanged = true;
				invalidateProperties();
			}
		}
		
		/**
		 * @protected 
		 * Creates markerLayer component.
		 */		
		protected function createMarkerLayer():void
		{
			if(_markerLayer == null)
			{
				var layer:YoMarkerLayer = new YoMarkerLayer();
				layer.map = this;
				
				_markerLayer = layer;
				addChild(_markerLayer);
			}
		}
		
		/**
		 * @override
		 * Updates markerLayer component with new values. 
		 */		
		protected function updateMarkerLayer():void
		{
			var layer:YoMarkerLayer = markerLayer as YoMarkerLayer;
			
			if(layer != null)
			{
				layer.uow = uow;
				layer.gomeeId = gomeeId;
				layer.searchQuery = searchQuery;
			}
		}
		
		//----------------------------------
    	// markers layer
    	//----------------------------------
		
		private var _markersLayer:YoMarkersLayer;
		
		protected function get markersLayer():YoMarkersLayer
		{
			return _markersLayer;
		}
		
		protected function createMarkersLayer():void
		{
			if(_markersLayer == null)
			{
			 	_markersLayer = new YoMarkersLayer();
			 	_markersLayer.map = this;
			 	addChild(_markersLayer);
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Controllers
    	//
    	//--------------------------------------------------------------------------
		
		private var _mineGomeeMarkersController:MineGomeeMarkersController;
		private var _mineHomeMarkersController:MineProfileMarkersController;
		
		private var _theirsGomeeMarkersController:TheirsGomeeMarkersController;
		private var _theirsHomeMarkersController:TheirsProfileMarkersController;
		
		private var _friendsHomeMarkersController:FriendsProfileMarkersController;
		private var _friendsGomeeMarkersController:FriendsGomeeMarkersController;
		
		private var _searchMarkersController:SearchMarkersController;
		
		protected function createControllers():void
		{
			_mineGomeeMarkersController = new MineGomeeMarkersController(_markersLayer, mineFilter, invitesFilter, tagFilter);
			_mineHomeMarkersController = new MineProfileMarkersController(_markersLayer, mineFilter, invitesFilter, tagFilter);
			
			_theirsGomeeMarkersController = new TheirsGomeeMarkersController(_markersLayer, theirsFilter, invitesFilter, tagFilter);
			_theirsHomeMarkersController = new TheirsProfileMarkersController(this, _markersLayer, theirsFilter, invitesFilter, tagFilter);
			
			_friendsHomeMarkersController = new FriendsProfileMarkersController(_markersLayer, friendsFilter, invitesFilter, tagFilter);
			_friendsGomeeMarkersController = new FriendsGomeeMarkersController(_markersLayer, friendsFilter, invitesFilter, tagFilter);
			
			_searchMarkersController = new SearchMarkersController(_markersLayer);
			
			_theirsHomeMarkersController.addEventListener(
				"friendInviteAccepted",
				function(event:DynamicEvent):void
				{
					var user:User = event.invite.creator as User;
					_theirsGomeeMarkersController.removeUsersMarkers(user);
					
					var b:LatLngBounds = getLatLngBounds();
					_friendsGomeeMarkersController.updateMarkers(b);
					_friendsHomeMarkersController.updateMarkers(b);
				});
				
			_searchMarkersController.addEventListener(
				"markerAdded",
				function(event:Event):void
				{
					searchQuery = "";
					
					_mineGomeeMarkersController.updateMarkers(getLatLngBounds());
				});
		}
		
		protected function updateControllers():void
		{
			if(_uowChanged)
			{
				_mineGomeeMarkersController.uow = uow as UnitOfWork;
    			_mineHomeMarkersController.uow = uow as UnitOfWork;
    		
    			_theirsGomeeMarkersController.uow = uow as UnitOfWork;
    			_theirsHomeMarkersController.uow = uow as UnitOfWork;	
    			
    			_friendsHomeMarkersController.uow = uow as UnitOfWork;
    			_friendsGomeeMarkersController.uow = uow as UnitOfWork;
    			
    			_searchMarkersController.uow = uow as UnitOfWork;
   			}
   			
   			if(_searchQueryChanged)
   			{
   				_searchMarkersController.query = _searchQuery;
   				
   				if(_searchQuery != null && _searchQuery != "")
   				{
   					_mineGomeeMarkersController.markersVisible = false;
   					_mineHomeMarkersController.markersVisible = false;
   					_theirsGomeeMarkersController.markersVisible = false;
   					_theirsHomeMarkersController.markersVisible = false;
   					_friendsHomeMarkersController.markersVisible = false;
   					_friendsGomeeMarkersController.markersVisible = false;
   					
   					_searchMarkersController.markersVisible = true;
   				}
   				else
   				{
   					_mineGomeeMarkersController.markersVisible = true;
   					_mineHomeMarkersController.markersVisible = true;
   					_theirsGomeeMarkersController.markersVisible = true;
   					_theirsHomeMarkersController.markersVisible = true;
   					_friendsHomeMarkersController.markersVisible = true;
   					_friendsGomeeMarkersController.markersVisible = true;
   					
   					_searchMarkersController.markersVisible = false;
   				}
   			}
   			
    		if(_mapReady)
    		{
    			var b:LatLngBounds = getLatLngBounds();
    			
    			if(_searchQuery == null)
    			{
    				_mineGomeeMarkersController.updateMarkers(b);
    				_mineHomeMarkersController.updateMarkers(b);
    			
    				_theirsGomeeMarkersController.updateMarkers(b);
    				_theirsHomeMarkersController.updateMarkers(b);
    				
    				_friendsHomeMarkersController.updateMarkers(b);
    				_friendsGomeeMarkersController.updateMarkers(b);
    			}
    			else
    			{
    				_searchMarkersController.updateMarkers(b);
    			}
    		}
		}
		
		protected function updateFilters():void
		{
			if(_uowChanged)
    		{
    			if(uow == null)
    			{
    				filtersBox.visible = false;
    			}
    			else
    			{
    				filtersBox.visible = true;
    				
    				if(uow.service.login == "guest")
    				{
    					newGomeeControl.visible = false;
    					newHomeControl.visible = false;
    					
    					filtersBox.removeChild(mineFilter);
    					filtersBox.removeChild(friendsFilter);
    					filtersBox.removeChild(invitesFilter);
    					(theirsFilter as YoMarkersFilterControl).label = "public";
    				}
    				else
    				{
    					newGomeeControl.visible = true;
    					newHomeControl.visible = true;
    				
    					filtersBox.addChildAt(mineFilter, 0);
    					filtersBox.addChildAt(friendsFilter, 1);
    					filtersBox.addChildAt(invitesFilter, 3);
    					(theirsFilter as YoMarkersFilterControl).label = "theirs";
    				}
    			}
    		}
    		
    		if(_searchQueryChanged)
    		{
    			if(_searchQuery != null && _searchQuery != "")
    			{
    				_filtersBox.visible = false;
    			}
    			else
    			{
    				_filtersBox.visible = true;
    			}
    		}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Public methods
    	//
    	//--------------------------------------------------------------------------
		
		public function panBy(point:Point):void
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				layer.panBy(point);
			}
		}
				
		public function fromLatLngToViewport(latlng:LatLng):Point
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				return layer.fromLatLngToViewport(latlng);
			}
			else
			{
				return null;
			}
		}
		
		public function fromViewportToLatLng(point:Point):LatLng
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				return layer.fromViewportToLatLng(point);
			}
			else
			{
				return null;
			}
		}
		
		public function getLatLngBounds():LatLngBounds
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				return layer.getLatLngBounds();
			}
			else
			{
				return null;
			}
		}
		
		public function setCenter(latLng:LatLng, l:Number):void
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				layer.setCenter(latLng, l);
			}
		}
		
		public function getZoom():Number
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				return layer.getZoom();
			}
			
			return 0;
		}
		
		public function setZoom(zoom:Number):void
		{
			var layer:YoMapLayer = mapLayer as YoMapLayer;
			
			if(layer != null)
			{
				layer.setZoom(zoom);
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Overridden methods
    	//
    	//--------------------------------------------------------------------------
		
		/**
    	 * @override
    	 * Create and add children. 
    	 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			createMapLayer();
			createMarkersLayer();
			
			createControlsBox();
			createZoomControl();
			createNewGomeeControl();
			createNewHomeControl();
			
			createFiltersBox();
			createMineFilter();
			createFriendsFilter();
			createTheirsFilter();
			createInvitesFilter();
			//createTagFilter();
			
			createControllers();
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
    		
    		// update map key
    		if(_keyChanged || _mapLayerChanged)
    		{
    			if(mapLayer != null)
    			{
    				updateMapLayer();
    			}
    			
    			_keyChanged = false;
    			_mapLayerChanged = false;
    			
    			needInvalidateSize = true;
    			needInvalidateDisplayList = true;
    		}
    		
    		if(_uowChanged || _markerLayerChanged || _gomeeIdChanged || _searchQueryChanged)
    		{
    			updateFilters();
    			updateControllers();
    			
    			_uowChanged = false;
    			_markerLayerChanged = false;
    			_searchQueryChanged = false;
    			_gomeeIdChanged = false;
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
    	 * Draw map. 
    	 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(_mapLayer != null)
			{
				_mapLayer.move(0,0);
				_mapLayer.setActualSize(unscaledWidth, unscaledHeight);
			}
			
			if(_markerLayer != null)
			{
				_markerLayer.move(0,0);
				_markerLayer.setActualSize(unscaledWidth, unscaledHeight);
			}
			
			if(_markersLayer != null)
			{
				_markersLayer.move(0, 0);
				_markersLayer.setActualSize(unscaledWidth, unscaledHeight);
			}
			
			if(_controlsBox != null)
			{
				_controlsBox.move(10,10);
				_controlsBox.setActualSize(_controlsBox.measuredWidth, _controlsBox.measuredHeight);
			}
			
			if(_filtersBox != null)
			{
				_filtersBox.move(unscaledWidth/2 - _filtersBox.measuredWidth/2, 10);
				_filtersBox.setActualSize(_filtersBox.measuredWidth, _filtersBox.measuredHeight);
			}
			
			if(_mapControlsBox != null)
			{
				_mapControlsBox.move(unscaledWidth - _mapControlsBox.measuredWidth - 10, 10);
				_mapControlsBox.setActualSize(_mapControlsBox.measuredWidth, _mapControlsBox.measuredHeight);
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Private methods
    	//
    	//--------------------------------------------------------------------------
		
		private var _mapReady:Boolean;
		
		private function mapLayerReadyHandler(event:YoMapEvent):void
		{
			_mapReady = true;
			
			createMapControlsBox();
			createMapTypeControl();
			createMapExpandControl();
			
			dispatchEvent(new YoMapEvent(YoMapEvent.MapReady));	
		}
		
		private function mapLayerViewChangeStepHandler(event:YoMapEvent):void
		{
			dispatchEvent(new YoMapEvent(YoMapEvent.ViewChangeStep));
		}
		
		private var _noUpdate:Boolean;
		
		public function noUpdate(b:Boolean):void
		{
			_noUpdate = b;
		}
		
		private function mapLayerViewChangeEndHandler(event:YoMapEvent):void
		{
			dispatchEvent(new YoMapEvent(YoMapEvent.ViewChangeEnd));
			
			if(!_noUpdate)
			{
				var b:LatLngBounds = getLatLngBounds();
				
				if(_searchQuery == null || _searchQuery == "")
				{
					_mineGomeeMarkersController.updateMarkers(b);
					_mineHomeMarkersController.updateMarkers(b);
				
					_theirsGomeeMarkersController.updateMarkers(b);
					_theirsHomeMarkersController.updateMarkers(b);
					
					_friendsHomeMarkersController.updateMarkers(b);
					_friendsGomeeMarkersController.updateMarkers(b);
				}
				else
				{
					_searchMarkersController.updateMarkers(b);
				}
			}
		}
	}
}