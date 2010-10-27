package controls.map
{
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	import controls.map.events.YoMapEvent;
	import controls.map.marker.YoGomeeMarker;
	import controls.map.marker.YoHomeMarker;
	import controls.map.marker.YoMarker;
	import controls.map.marker.events.YoMarkerEvent;
	import controls.text.YoTagsInput;
	
	import defer.Deferred;
	import defer.Failure;
	
	import domainModel.IUnitOfWork;
	import domainModel.entities.Gomee;
	import domainModel.entities.Profile;
	import domainModel.entities.User;
	import domainModel.utils.GoogleSearchService;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.managers.HistoryManager;
	import mx.managers.IHistoryManagerClient;
	import mx.utils.StringUtil;

	public class YoMarkerLayer extends Container implements IHistoryManagerClient
	{
		/**
		 * Constructor. 
		 */		
		public function YoMarkerLayer()
		{
			super();
			clipContent = true;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			mineMarkersVisible = true;
		}
		
		public function saveState():Object
		{
			var state:Object = {};
			var center:LatLng = map.getLatLngBounds().getCenter();
			
			state.lat = center.lat();
			state.lng = center.lng();
			state.z = map.getZoom();
			 
			return state;
		}
		
		private var _stateLoaded:Boolean;
		
		public function loadState(state:Object):void
		{
			if(state != null)
			{
				map.setCenter(new LatLng(state.lat, state.lng), state.z);
				_stateLoaded = true;
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Properties
    	//
    	//--------------------------------------------------------------------------
		
		//----------------------------------
    	//  map
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for map property. 
		 */		
		private var _map:YoMap;
		
		/**
		 * @private
		 * Flag to indicate when _map changes. 
		 */		
		private var _mapChanged:Boolean;
		
		/**
		 * Specifies map component. 
		 */		
		public function get map():YoMap
		{
			return _map;
		}
		
		/**
		 * Specifies map component. 
		 */
		public function set map(map:YoMap):void
		{
			if(_map != map)
			{
				_map = map;
				
				_map.addEventListener(YoMapEvent.MapReady, mapReadyHandler);
				_map.addEventListener(YoMapEvent.ViewChangeEnd, mapViewChangeEndHandler);
				_map.addEventListener(YoMapEvent.ViewChangeStep, mapViewChangeStepHandler);
				
				_mapChanged = true;
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
    	//  unit of work
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
		 * Specifies unit of work. 
		 */		
		public function get uow():IUnitOfWork
		{
			return _uow;
		}
		
		/**
		 * Specifies unit of work. 
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
		
		//----------------------------------
    	//  mapReady
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for mapReady property. 
		 */		
		private var _mapReady:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _mapReady changes. 
		 */		
		private var _mapReadyChanged:Boolean;
		
		/**
		 * @protected
		 * True, if map loded and initialized. 
		 */		
		protected function get mapReady():Boolean
		{
			return _mapReady;
		}
		
		/**
		 * @protected
		 * True, if map loded and initialized. 
		 */
		protected function set mapReady(mapReady:Boolean):void
		{
			if(_mapReady != mapReady)
			{
				_mapReady = mapReady;
				_mapReadyChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	// search query
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for searchQuery property .
		 */		
		private var _searchQuery:String;
		
		/**
		 * @private
		 * Flag to indicate when _searchQuery changes. 
		 */		
		private var _searchQueryChanged:Boolean;
		
		/**
		 * Specifies markers search query. 
		 */		
		public function get searchQuery():String
		{
			return _searchQuery;
		}
		
		/**
		 * Specifies markers search query. 
		 */
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
    	// search markers visible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for searchMarkersVisibleProperty. 
		 */		
		private var _searchMarkersVisible:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _searchMarkersVisible changes. 
		 */		
		private var _searchMarkersVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of search markers. 
		 */		
		public function get searchMarkersVisible():Boolean
		{
			return _searchMarkersVisible;
		}
		
		/**
		 * Specifies visibility of search markers. 
		 */
		public function set searchMarkersVisible(searchMarkersVisible:Boolean):void
		{
			if(_searchMarkersVisible != searchMarkersVisible)
			{
				_searchMarkersVisible = searchMarkersVisible;
				_searchMarkersVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	// mine markers visible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for mineMarkersVisible property. 
		 */		
		private var _mineMarkersVisible:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _mineMarkersVisible chanes.
		 */		
		private var _mineMarkersVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of mine markers. 
		 */		
		public function get mineMarkersVisible():Boolean
		{
			return _mineMarkersVisible;
		}
		
		/**
		 * Specifies visibility of mine markers. 
		 */
		public function set mineMarkersVisible(mineMarkersVisible:Boolean):void
		{
			if(_mineMarkersVisible != mineMarkersVisible)
			{
				_mineMarkersVisible = mineMarkersVisible;
				_mineMarkersVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
    	// users markers visible
    	//----------------------------------
		
		/**
		 * @private
		 * Storage for usersMarkersVisible property. 
		 */		
		private var _usersMarkersVisible:Boolean;
		
		/**
		 * @private
		 * Flag to indicate when _usersMarkersVisible chanes.
		 */		
		private var _usersMarkersVisibleChanged:Boolean;
		
		/**
		 * Specifies visibility of users markers. 
		 */		
		public function get usersMarkersVisible():Boolean
		{
			return _usersMarkersVisible;
		}
		
		/**
		 * Specifies visibility of users markers. 
		 */
		public function set usersMarkersVisible(usersMarkersVisible:Boolean):void
		{
			if(_usersMarkersVisible != usersMarkersVisible)
			{
				_usersMarkersVisible = usersMarkersVisible;
				_usersMarkersVisibleChanged = true;
				invalidateProperties();
			}
		}
		
		//--------------------------------------------------------------------------
    	//
    	//  Overridden protected methods
    	//
    	//--------------------------------------------------------------------------
		
		/**
		 * @override
		 * Draws markers. 
		 */		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(mapReady)
			{
				var i:int;
				for(i = 0; i < numChildren; i++)
				{
					var marker:YoMarker = getChildAt(i) as YoMarker;
				
					var point:Point = map.fromLatLngToViewport(marker.latLng);
					marker.setActualSize(
						Math.min(marker.measuredWidth, unscaledWidth - 80),
						Math.min(marker.measuredHeight, unscaledHeight - 50));
					marker.move(point.x - marker.tailX, point.y - marker.tailY);
				}
			}
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(_mapChanged)
			{
				updateMap();
				_mapChanged = false;
			}
			
			if(_uowChanged)
			{
				updateUow();
				_uowChanged = false;
			}
			
			if(_mapReadyChanged)
			{
				_mapReadyChanged = false;
				
				updateGomees();
				
				invalidateSize();
				invalidateDisplayList();
			}
			
			if(_searchQueryChanged)
			{
				_searchQueryChanged = false;
				
				updateGomees();
				
				invalidateSize();
				invalidateDisplayList();
			}
			
			if(_mineMarkersVisibleChanged || _usersMarkersVisibleChanged || _searchMarkersVisibleChanged)
			{
				var i:int;
				
				for(i = 0; i < _mineGomees.length; i++)
				{
					_mineGomeesMarkers[_mineGomees[i].id].visible = mineMarkersVisible;
				}
				
				for(i = 0; i < _theirsGomees.length; i++)
				{
					_theirsGomeesMarkers[_theirsGomees[i].id].visible = usersMarkersVisible;
				}
				
				
				for( i = 0; i < _searchGomees.length; i++)
				{
					_searchGomeesMarkers[_searchGomees[i].id].visible = searchMarkersVisible;
				}
				
				_mineMarkersVisibleChanged = false;
				_usersMarkersVisibleChanged = false;
				_searchMarkersVisibleChanged = false;
				
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private function updateMap():void
		{
			if(_map != null)
			{
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		private function updateUow():void
		{
			if(uow != null)
			{
				updateGomees();
			}
		}
		
		private var _gomees:Array;
		
		private function updateGomees():void
		{
			removeAllChildren();
			
			_mineGomees = new Array();
			_mineGomeesMarkers = new Object();
			
			_theirsGomees = new Array();
			_theirsGomeesMarkers = new Object();
			
			_searchGomees = new Array();
			_searchGomeesMarkers = new Object();
			
			_usersHomeMarkers = new Array();
			_mineHomeMarkers = new Array();
			
			if(uow != null && mapReady)
			{
				if(uow.service.login != "guest" && mineMarkersVisible)
				{
					fetchMe();
					fetchMineProfile();
					fetchMineGomees(map.getLatLngBounds());
				}
				else
				{
					if(gomeeId != null && gomeeId != "" && usersMarkersVisible)
					{
						fetchStartGomee();
					}
				}
				
				if(searchMarkersVisible)
				{
					fetchSearchGomees(map.getLatLngBounds());
				}	
			}
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if(child is YoMarker)
			{
				child.addEventListener(YoMarkerEvent.ResizePan, markerResizePanHandler);
				child.addEventListener(YoMarkerEvent.RemoveClick, markerRemoveClickHandler);
				child.addEventListener(YoMarkerEvent.ContentChanged, markerContentChangedHandler);
				child.addEventListener(MouseEvent.MOUSE_OVER, markerMouseOverHandler);
			}
			
			return super.addChild(child);
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		
		private function markerRemoveClickHandler(event:YoMarkerEvent):void
		{
			var marker:YoMarker = event.currentTarget as YoMarker;
			
			if(marker != null)
			{
				if(uow != null)
				{
					var gomee:Gomee = marker.data as Gomee;
					uow.gomeeRepository.removeGomee(gomee)
						.addCallback(
							function(result:Boolean):void
							{
								if(result)
								{
									removeChild(marker);
								}
							})
						.addErrback(
							function(fail:Failure):void
							{
								trace("gomee remove error:", fail.value);
							});
				}
			}
		}
		
		private function markerContentChangedHandler(event:YoMarkerEvent):void
		{
			var marker:YoGomeeMarker = event.currentTarget as YoGomeeMarker;
			
			if(marker != null)
			{
				if(uow != null)
				{
					var gomee:Gomee = marker.data as Gomee;
					gomee.caption = marker.caption;
					gomee.description = marker.description;
					gomee.address = marker.address;
					gomee.common = marker.common;
					gomee.tags = StringUtil.trimArrayElements(marker.tags, ",").split(",");
					
					if(gomee.type != 2)
					{
						uow.gomeeRepository.saveGomee(gomee)
							.addCallback(
								function(result:Gomee):void
								{
								})
							.addErrback(
								function(fail:Failure):void
								{
									trace("gomee save error:", fail.value);
								});
					}
					else
					{
						gomee.owner = _me;
						gomee.type = 1;
						
						uow.gomeeRepository.addGomee(gomee)
							.addCallback(
								function(result:Gomee):void
								{
									searchMarkersVisible = false;
									mineMarkersVisible = true;
									usersMarkersVisible = true;
									_searchQuery = null;
									updateGomees();
									fetchMineGomees(map.getLatLngBounds());
									invalidateSize();
									invalidateDisplayList();
								})
							.addErrback(
								function(fail:Failure):void
								{
									trace("gomee add error:", fail.value);
								});
					}
				}
			}
		}
		
		private function markerResizePanHandler(event:YoMarkerEvent):void
		{
			var marker:UIComponent = event.target as UIComponent;
			
			var rect:Rectangle = new Rectangle(marker.x, marker.y, marker.width, marker.height);
			var point:Point = new Point();
			
			if(rect.left < 70)
			{
				point.x += rect.left - 70;
			}
			
			if(rect.right > width - 10)
			{
				point.x += rect.right - width + 10;
			}
			
			if(rect.top < 40)
			{
				point.y += rect.top - 40;
			}
			
			if(rect.bottom > height - 10)
			{
				point.y += rect.bottom - height + 10;
			}
			
			//map.panBy(point);
		}
		
		private function markerMouseOverHandler(event:MouseEvent):void
		{
			var marker:UIComponent = event.currentTarget as UIComponent;
			setChildIndex(marker, getChildren().length - 1);
		}
		
		private var _pervBounds:LatLngBounds;
		
		private function mapReadyHandler(event:YoMapEvent):void
		{
			_pervBounds = _map.getLatLngBounds();
			mapReady = true;
			HistoryManager.register(this);
		}
		
		private function mapViewChangeStepHandler(event:YoMapEvent):void
		{
			invalidateDisplayList();
		}
		
		private function mapViewChangeEndHandler(event:YoMapEvent):void
		{
			var bounds:LatLngBounds = map.getLatLngBounds();
			
			if(_pervBounds == null || !bounds.equals(_pervBounds))
			{
				if(uow != null)
				{
					if(uow.service.login != "guest" && mineMarkersVisible)
					{
						fetchMineGomees(bounds);
						fetchUsers(bounds);
					}
					else
					{
						if(_startGomee != null && usersMarkersVisible)
						{
							fetchTheirsGomees(_startGomee.owner, bounds, _startGomee.tags);
						}
					}
					
					if(searchMarkersVisible && searchMarkersVisible)
					{
						fetchSearchGomees(bounds);
					}
				}
				_pervBounds = bounds;
			}
			
			if(!_stateLoaded)
			{
				HistoryManager.save();
			}
			_stateLoaded = false;
		}
		
		private var _startGomee:Gomee;
		
		private function fetchStartGomee():void
		{
			uow.gomeeRepository.getGomee(gomeeId)
				.addCallback(
					function(gomee:Gomee):void
					{
						_startGomee = gomee;
						if(!updateIfPresentInTheirsGomees(gomee))
						{
							var marker:YoGomeeMarker = new YoGomeeMarker();
							marker.latLng = new LatLng(gomee.lat, gomee.lng);
							marker.caption = gomee.caption;
							marker.address = gomee.address;
							marker.description = gomee.description;
							marker.common = gomee.common;
							marker.tags = gomee.tags.join(", ");
							marker.data = gomee;
							marker.editable = false;
							marker.deletable = false;
							marker.setStyle("iconColor", 0x000000);
									
							YoTagsInput.addTags(gomee.tags);			
							addChild(marker);
						
							_theirsGomees.push(gomee);
							_theirsGomeesMarkers[gomee.id] = marker;
						
							map.setCenter(marker.latLng, 3);
						}
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error fetching satrt gomee:", fail.value);
					});
		}
		
		private var _me:User;
		
		private function fetchMe():void
		{
			uow.userRepository.getMe()
					.addCallback(
						function(me:User):void
						{
							_me = me;
						})
					.addErrback(
						function(fail:Failure):void
						{
							trace("error fetching me", fail.value);
						});	
		}
		
		private var _mineHomeMarkers:Array = [];
		
		private function fetchMineProfile():void
		{
			uow.profileRepository.getProfile()
				.addCallback(
					function(profile:Profile):void
					{
						var gomees:Array = profile.getGomees();
										
						for(var i:int = 0; i < gomees.length; i++)
						{
							var gomee:Gomee = gomees[i];
							var homeMarker:YoHomeMarker = new YoHomeMarker();
							
							homeMarker.latLng = new LatLng(gomee.lat, gomee.lng);
							homeMarker.caption = gomee.caption;
							homeMarker.address = gomee.address;
							homeMarker.description = gomee.description;
							homeMarker.common = gomee.common;
							homeMarker.tags = gomee.tags;
							homeMarker.login = profile.user.login;
							homeMarker.firstName = profile.firstName;
							homeMarker.lastName = profile.lastName;
							homeMarker.email = profile.email;
							homeMarker.twitterLogin = profile.twitterLogin;
							homeMarker.twitterSecret = profile.twitterSecret;
							homeMarker.twitterUpdateOnAddGomee = profile.twitterUpdateOnAddGomee;
							homeMarker.twitterUpdateOnSaveGomee = profile.twitterUpdateOnSaveGomee;
							homeMarker.twitterUpdateOnDeleteGomee = profile.twitterUpdateOnDeleteGomee;
							homeMarker.data = gomee;
							
							_mineHomeMarkers.push(homeMarker);
							addChild(homeMarker);
						}
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error fetching profile:", fail.value);
					});
		}
		
		private function fetchUsers(bounds:LatLngBounds):void
		{
			var ll1:LatLng = bounds.getNorthWest();
			var ll2:LatLng = bounds.getSouthEast();
			
			uow.userRepository.getUsers(ll1, ll2)
				.addCallback(
					function(users:Array):void
					{
						for(var i:int = 0; i < users.length; i++)
						{
							var user:User = users[i];
							if(user.id != _me.id)
							{
								fetchUserProfile(user);
								fetchTheirsGomees(user, bounds);						
							}
						}
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error fetching users:", fail.value);
					});
		}
		
		private var _usersHomeGomees:Array = [];
		private var _usersHomeMarkers:Object = new Object();
		
		private function updateIfPresentInUsersHomes(gomee:Gomee, profile:Profile):Boolean
		{
			for(var i:int = 0; i < _usersHomeGomees.length; i++)
			{
				var hgomee:Gomee = _usersHomeGomees[i] as Gomee;
				var marker:YoGomeeMarker = _usersHomeMarkers[hgomee.id] as YoGomeeMarker;
				if (gomee.id == hgomee.id)
				{
					_usersHomeGomees[i] = gomee;
					marker.caption = gomee.caption;
					marker.address = gomee.address;
					marker.description = gomee.description;
					marker.common = gomee.common;
					marker.tags = gomee.tags.join(", ");
					
					return true;
				}
			}
			
			return false;
		}
		
		private function fetchUserProfile(user:User):void
		{
			uow.profileRepository.getProfile(user)
				.addCallback(
					function(profile:Profile):void
					{
						var gomees:Array = profile.getGomees();
								
						for(var i:int = 0; i < gomees.length; i++)
						{
							var gomee:Gomee = gomees[i];
							if (!updateIfPresentInUsersHomes(gomee, profile))
							{
								var homeMarker:YoHomeMarker = new YoHomeMarker();
							
								homeMarker.latLng = new LatLng(gomee.lat, gomee.lng);
								homeMarker.caption = gomee.caption;
								homeMarker.address = gomee.address;
								homeMarker.description = gomee.description;
								homeMarker.common = gomee.common;
								homeMarker.tags = gomee.tags;
								homeMarker.login = profile.user.login;
								homeMarker.firstName = profile.firstName;
								homeMarker.lastName = profile.lastName;
								homeMarker.email = profile.email;
								homeMarker.editable = false;
								homeMarker.twitterVisible = false;
								homeMarker.setStyle("iconColor", 0x000000);
								homeMarker.data = gomee;
							
								_usersHomeGomees.push(gomee);
								_usersHomeMarkers[gomee.id] = homeMarker;
								addChild(homeMarker);
							}
						}											
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error fecthing profile:", fail.value);
					});
		}
		
		private var _mineGomees:Array = [];
		private var _mineGomeesMarkers:Object = new Object();
		
		private function updateIfPresentInMineGomees(gomee:Gomee):Boolean
		{
			for(var i:int = 0; i < _mineGomees.length; i++)
			{
				var mgomee:Gomee = _mineGomees[i] as Gomee;
				var marker:YoGomeeMarker = _mineGomeesMarkers[mgomee.id] as YoGomeeMarker;
				if (gomee.id == mgomee.id)
				{
					_mineGomees[i] = gomee;
					marker.caption = gomee.caption;
					marker.address = gomee.address;
					marker.description = gomee.description;
					marker.common = gomee.common;
					marker.tags = gomee.tags.join(", ");
					
					return true;
				}
			}
			
			return false;
		}
		
		private function fetchMineGomees(bounds:LatLngBounds):void
		{
			var ll1:LatLng = bounds.getNorthWest();
			var ll2:LatLng = bounds.getSouthEast();
			
			uow.gomeeRepository.getGomees(ll1, ll2)
				.addCallback(
					function(gomees:Array):void
					{
						for(var i:int = 0; i < gomees.length; i++)
						{
							var gomee:Gomee = gomees[i];
							if(gomee.type != 0)
							{
								if(!updateIfPresentInMineGomees(gomee))
								{
									var marker:YoGomeeMarker = new YoGomeeMarker();
									marker.latLng = new LatLng(gomee.lat, gomee.lng);
									marker.caption = gomee.caption;
									marker.address = gomee.address;
									marker.description = gomee.description;
									marker.common = gomee.common;
									marker.tags = gomee.tags.join(", ");
									marker.data = gomee;
									
									YoTagsInput.addTags(gomee.tags);
									
									_mineGomees.push(gomee);
									_mineGomeesMarkers[gomee.id] = marker;
									addChild(marker);
								}
							}
						}
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error getting gomees:", fail.value);
					});
		}
		
		private var _theirsGomees:Array = [];
		private var _theirsGomeesMarkers:Object = new Object();
		
		private function updateIfPresentInTheirsGomees(gomee:Gomee):Boolean
		{
			for(var i:int = 0; i < _theirsGomees.length; i++)
			{
				var tgomee:Gomee = _theirsGomees[i] as Gomee;
				var marker:YoGomeeMarker = _theirsGomeesMarkers[tgomee.id] as YoGomeeMarker;
				if (gomee.id == tgomee.id)
				{
					_theirsGomees[i] = gomee;
					marker.caption = gomee.caption;
					marker.address = gomee.address;
					marker.description = gomee.description;
					marker.common = gomee.common;
					marker.tags = gomee.tags.join(", ");
					
					return true;
				}
			}
			
			return false;
		}
		
		private function fetchTheirsGomees(user:User, bounds:LatLngBounds, tags:Array = null):void
		{
			var ll1:LatLng = bounds.getNorthWest();
			var ll2:LatLng = bounds.getSouthEast();
			
			uow.gomeeRepository.getGomees(ll1, ll2, user, tags)
				.addCallback(
					function(gomees:Array):void
					{
						for(var i:int = 0; i < gomees.length; i++)
						{
							var gomee:Gomee = gomees[i];
							if(gomee.type != 0)
							{
								if(!updateIfPresentInTheirsGomees(gomee))
								{
									var marker:YoGomeeMarker = new YoGomeeMarker();
									marker.latLng = new LatLng(gomee.lat, gomee.lng);
									marker.caption = gomee.caption;
									marker.address = gomee.address;
									marker.description = gomee.description;
									marker.common = gomee.common;
									marker.tags = gomee.tags.join(", ");
									marker.data = gomee;
									marker.editable = false;
									marker.deletable = false;
									marker.setStyle("iconColor", 0x000000);
									
									YoTagsInput.addTags(gomee.tags);			
									addChild(marker);
									
									_theirsGomees.push(gomee);
									_theirsGomeesMarkers[gomee.id] = marker;
								}
							}
						}
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error getting gomees:", fail.value);
					});
		}
		
		
		private var _searchGomees:Array = [];
		private var _searchGomeesMarkers:Object = new Object();
		
		private function updateIfPresentInsearchGomees(gomee:Gomee):Boolean
		{
			for(var i:int = 0; i < _searchGomees.length; i++)
			{
				var tgomee:Gomee = _searchGomees[i] as Gomee;
				if (gomee.id == tgomee.id)
				{
					_searchGomees[i] = gomee;
					
					var marker:YoGomeeMarker = _searchGomeesMarkers[tgomee.id] as YoGomeeMarker;
					marker.caption = gomee.caption;
					marker.address = gomee.address;
					marker.description = gomee.description;
					marker.common = gomee.common;
					marker.tags = gomee.tags.join(", ");
					
					return true;
				}
			}
			
			return false;
		}
		
		private function fetchSearchGomees(bounds:LatLngBounds):void
		{
			var ll1:LatLng = bounds.getNorthWest();
			var ll2:LatLng = bounds.getSouthEast();
			
			var service:GoogleSearchService = new GoogleSearchService();
			
			service.search(searchQuery, bounds)
				.addCallback(
					function(results:Array):void
					{
						function add_marker(s:Boolean, result:Object):Deferred
						{
							var gomee:Gomee = new Gomee();
							gomee.id = "_" + result.lat.toString() + "_" + result.lng.toString();
							gomee.lat = result.lat;
							gomee.lng = result.lng;
							gomee.type = 2;
							gomee.caption = result.titleNoFormatting;
							
							if(result.addressLines != null)
							{
								if(result.addressLines.length > 0)
								{
									gomee.address = result.addressLines.join(", ");
								}
							}
							
							if(gomee.address == null)
							{
								gomee.address = "";
								
								if(result.streetAddress != null)
								{
									gomee.address += result.streetAddress + ", "; 
								}
								
								if(result.city != null)
								{
									gomee.address += result.city + ", ";	
								}
								
								if(result.country != null)
								{
									gomee.address += result.country + ", ";	
								}
							} 
							
							
							if(gomee.type != 0)
							{
								if(!updateIfPresentInsearchGomees(gomee))
								{
									var marker:YoGomeeMarker = new YoGomeeMarker();
									marker.latLng = new LatLng(gomee.lat, gomee.lng);
									marker.caption = gomee.caption;
									marker.address = gomee.address;
									marker.description = gomee.description;
									marker.common = gomee.common;
									marker.tags = gomee.tags.join(", ");
									marker.data = gomee;
									marker.editable = true;
									marker.deletable = false;
									marker.setStyle("iconColor", 0x333333);
									
									YoTagsInput.addTags(gomee.tags);			
									addChild(marker);
									
									_searchGomees.push(gomee);
									_searchGomeesMarkers[gomee.id] = marker;
								}
							}
							
							var d:Deferred = new Deferred();
							Deferred.callLater(0, d.callback, true);
							return d;
						}
						
						var d:Deferred = new Deferred();
						
						for(var i:int = 0; i < results.length; i++)
						{
							d.addCallback(add_marker, results[i]);
						}
						
						Deferred.callLater(0, d.callback, true);
					})
				.addErrback(
					function(fail:Failure):void
					{
						trace("error getting gomees:", fail.value);
					});
		}
	}
}