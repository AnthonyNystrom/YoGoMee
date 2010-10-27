package controls.list
{
	import controls.list.events.YoListItemEvent;
	
	import domainModel.entities.Gomee;
	import domainModel.repositories.IGomeeRepository;
	import domainModel.repositories.events.GomeeRepositoryEvent;
	import domainModel.values.GomeeSource;
	
	import mx.containers.VBox;
	import mx.core.UIComponent;
	
	public class YoList extends UIComponent
	{
		public function YoList()
		{
		}
		
		private var _gomeeSource:GomeeSource;
		private var _gomeeSourceChanged:Boolean;
		
		public function get gomeeSource():GomeeSource
		{
			return _gomeeSource;
		}
		
		public function set gomeeSource(gomeeSource:GomeeSource):void
		{
			if(_gomeeSource != gomeeSource)
			{
				_gomeeSource = gomeeSource;
				_gomeeSourceChanged = true;
				invalidateProperties();
			}
		}
		
		private var _gomeeRepository:IGomeeRepository;
		private var _gomeeRepositoryChanged:Boolean;
		
		public function get gomeeRepository():IGomeeRepository
		{
			return _gomeeRepository;
		}
		
		public function set gomeeRepository(gomeeRepository:IGomeeRepository):void
		{
			if(_gomeeRepository != gomeeRepository)
			{
				if(_gomeeRepository != null)
				{
					_gomeeRepository.removeEventListener(GomeeRepositoryEvent.GomeeRemoved, gomeeRepositoryRemoveHandler);
					_gomeeRepository.removeEventListener(GomeeRepositoryEvent.MineGomeeCountFetched, gomeeRepositoryMineCountFetched);
				}
				
				_gomeeRepository = gomeeRepository;
				
				if(_gomeeRepository != null)
				{
					_gomeeRepository.addEventListener(GomeeRepositoryEvent.GomeeRemoved, gomeeRepositoryRemoveHandler);
					_gomeeRepository.addEventListener(GomeeRepositoryEvent.MineGomeeCountFetched, gomeeRepositoryMineCountFetched);
				}
				
				_gomeeRepositoryChanged = true;
				invalidateProperties();
			}
		}
		
		protected override function measure():void
		{
			super.measure();
			
			if(_mainBox != null)
			{
				measuredWidth = _mainBox.measuredWidth;
				measuredHeight = _mainBox.measuredHeight;
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(_mainBox != null)
			{
				_mainBox.move(0,0);
				_mainBox.setActualSize(unscaledWidth, unscaledHeight);
			}
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(_gomeeSourceChanged)
			{
				updateGomeeSource();
				_gomeeSourceChanged = false;
			}
			
			if(_gomeeRepositoryChanged)
			{
				updateGomeeRepository();
				_gomeeRepositoryChanged = false;
			}
		}
		
		private function updateGomeeSource():void
		{
			if(gomeeSource != null)
			{
				updateGomees();
			}
		}
		
		private function updateGomeeRepository():void
		{
			if(gomeeRepository != null)
			{
				updateGomees();
			}
		}
		
		private function updateGomees():void
		{
			if(gomeeRepository != null)
			{
				if(gomeeSource == GomeeSource.Mine)
				{
					updateMineGomees();
				}
				
				if(gomeeSource == GomeeSource.Theirs)
				{
					updateTheirsGomees();
				}
			}
		}
		
		private var _mineCount:int;
		
		private function updateMineGomees():void
		{
			_mainBox.removeAllChildren();
			
			if(gomeeRepository != null)
			{
				_mineCount = gomeeRepository.mineCount;
				for(var i:int = 0; i < _mineCount; i++)
				{
					var gomee:Gomee = gomeeRepository.getMineGomee(i);
					var item:YoListItem = new YoListItem();
					item.gomee = gomee;
					item.percentWidth = 100;
					item.addEventListener(YoListItemEvent.EditClick, itemEditClickHandler);
					item.addEventListener(YoListItemEvent.ItemClick, itemClickHandler);
					item.addEventListener(YoListItemEvent.RemoveClick, itemRemoveClickHandler);
					_mainBox.addChild(item);
				}
			}
		}
		
		private var _theirsCount:int;
		
		private function updateTheirsGomees():void
		{
			_mainBox.removeAllChildren();
			
			if(gomeeRepository != null)
			{
				_theirsCount = gomeeRepository.theirsCount;
				for(var i:int = 0; i < _theirsCount; i++)
				{
					var gomee:Gomee = gomeeRepository.getTheirsGomee(i);
					var item:YoListItem = new YoListItem();
					item.gomee = gomee;
					item.percentWidth = 100;
					item.addEventListener(YoListItemEvent.EditClick, itemEditClickHandler);
					item.addEventListener(YoListItemEvent.ItemClick, itemClickHandler);
					_mainBox.addChild(item);
				}
			}
		}
		
		private function itemEditClickHandler(event:YoListItemEvent):void
		{
			var item:YoListItem = event.currentTarget as YoListItem;
			var gomee:Gomee = item.gomee;
			
			if(gomee != null)
			{
				if(gomeeRepository != null)
				{
					gomeeRepository.setSelected(gomee, true);
				}
			}
		}
		
		private function itemRemoveClickHandler(event:YoListItemEvent):void
		{
			var item:YoListItem = event.currentTarget as YoListItem;
			var gomee:Gomee = item.gomee;
			
			if(gomee != null)
			{
				if(gomeeRepository != null)
				{
					gomeeRepository.removeGomee(gomee);
				}
			}
		}
		
		private function itemClickHandler(event:YoListItemEvent):void
		{
			var item:YoListItem = event.currentTarget as YoListItem;
			var gomee:Gomee = item.gomee;
			
			if(gomee != null)
			{
				if(gomeeRepository != null)
				{
					gomeeRepository.setSelected(gomee, false);
				}
			}
		}
		
		private function gomeeRepositoryRemoveHandler(event:GomeeRepositoryEvent):void
		{
			var gomee:Gomee = event.gomee;
			
			if(_mainBox != null)
			{
				var children:Array = _mainBox.getChildren();
				for(var i:int = 0; i < children.length; i++)
				{
					var item:YoListItem = children[i] as YoListItem;
					if(item.gomee == gomee)
					{
						_mainBox.removeChild(item);
					}
				}
			}
		}
		
		private function gomeeRepositoryMineCountFetched(event:GomeeRepositoryEvent):void
		{
			_gomeeRepositoryChanged = true;
			invalidateProperties();
		}
		
		private var _mainBox:VBox;
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			if(_mainBox == null)
			{
				_mainBox = new VBox();
				addChild(_mainBox);
			}
		}
	}
}