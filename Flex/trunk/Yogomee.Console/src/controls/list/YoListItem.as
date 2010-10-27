package controls.list
{
	import controls.list.events.YoListItemEvent;
	
	import domainModel.entities.Gomee;
	import domainModel.entities.events.GomeeEvent;
	import domainModel.values.GomeeSource;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	
	public class YoListItem extends UIComponent
	{
		public function YoListItem()
		{
		}

		private var _gomee:Gomee;
		private var _gomeeChanged:Boolean;
		
		public function get gomee():Gomee
		{
			return _gomee;
		}
		
		public function set gomee(gomee:Gomee):void
		{
			if(_gomee != gomee)
			{
				if(_gomee != null)
				{
					_gomee.removeEventListener(GomeeEvent.CaptionChanged, gomeeCaptionChangedHandler);
					_gomee.removeEventListener(GomeeEvent.AddressChanged, gomeeAddressChangedHandler);
					_gomee.removeEventListener(GomeeEvent.DescriptionChanged, gomeeDescriptionChangedHandler);
				}
				
				_gomee = gomee;
				
				if(_gomee != null)
				{
					_gomee.addEventListener(GomeeEvent.CaptionChanged, gomeeCaptionChangedHandler);
					_gomee.addEventListener(GomeeEvent.AddressChanged, gomeeAddressChangedHandler);
					_gomee.addEventListener(GomeeEvent.DescriptionChanged, gomeeDescriptionChangedHandler);
				}
				
				_gomeeChanged = true;
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
			
			if(_gomeeChanged)
			{
				updateGomee();
				_gomeeChanged = false;
			}
			
			if(_captionChanged)
			{
				updateCaption();
				_captionChanged = false;
			}
			
			if(_addressChanged)
			{
				updateAddress();
				_addressChanged = false;
			}
			
			if(_descriptionChanged)
			{
				updateDescription();
				_descriptionChanged = false;
			}
		}
		
		private function updateGomee():void
		{
			if(gomee != null)
			{
				updateCaption();
				updateAddress();
				updateDescription();
				updateSource();
			}
		}
		
		private function updateCaption():void
		{
			if(gomee != null)
			{
				if(_captionText != null)
				{
					_captionText.text = gomee.caption;
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
		}
		
		private function updateAddress():void
		{
			if(gomee != null)
			{
				if(_addressText != null)
				{
					_addressText.text = gomee.address;
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
		}
		
		private function updateDescription():void
		{
			if(gomee != null)
			{
				if(_descriptionText != null)
				{
					_descriptionText.text = gomee.description;
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
		}
		
		private function updateSource():void
		{
			if(gomee != null)
			{
				if(_icon != null)
				{
					_icon.visible = true;
					
					if(gomee.source == GomeeSource.Mine)
					{
						_icon.source = "resources/sidebar_G_mine.png";
					}
					if(gomee.source == GomeeSource.Theirs)
					{
						_icon.source = "resources/sidebar_G_theirs.png";
					}
					if(gomee.source == GomeeSource.Google)
					{
						_icon.source = "resources/sidebar_G_google.png";
					}
					
					invalidateSize();
					invalidateDisplayList();
				}
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			if(_mainBox == null)
			{
				createMainBox();
				addChild(_mainBox);
			}
		}
		
		private var _mainBox:HBox;
		
		private function createMainBox():void
		{
			if(_mainBox == null)
			{
				_mainBox = new HBox();
				_mainBox.verticalScrollPolicy = ScrollPolicy.OFF;
				_mainBox.horizontalScrollPolicy = ScrollPolicy.OFF;
				_mainBox.addChild(createIconBox());
				_mainBox.addChild(createInfoBox());
				_mainBox.percentWidth = 100;
			}
		}
		
		private function createInfoBox():UIComponent
		{
			var box:VBox = new VBox();
			
			box.addChild(createCaption());
			box.addChild(createAddress());
			box.addChild(createDescription());
			box.addChild(createBottomPanel());
				
			box.setStyle("paddingTop", 5);
			box.setStyle("verticalGap", 2);
			box.setStyle("paddingBottom", 5);
			box.setStyle("paddingRight", 5);
			box.percentWidth = 100;
			return box;
		}
		
		private var _icon:Image;
		
		private function createIconBox():UIComponent
		{
			var box:VBox = new VBox();
			
			if(_icon == null)
			{
				_icon = new Image();
				_icon.visible = false;
				_icon.useHandCursor = true;
				_icon.buttonMode = true;
				
				_icon.addEventListener(MouseEvent.CLICK, iconClickHandler);
			}
			
			box.addChild(_icon);
			
			return box;	
		}
		
		private var _captionText:Text;
		private var _captionChanged:Boolean;
		
		protected function createCaption():UIComponent
		{
			var box:HBox = new HBox();

			if(_captionText == null)
			{
				_captionText = new Text();
				_captionText.styleName = "YoEntryTitle";
				_captionText.selectable = false;
				_captionText.percentWidth = 100;
				_captionText.useHandCursor = true;
				_captionText.buttonMode = true;
				_captionText.mouseChildren = false;
				
				_captionText.addEventListener(MouseEvent.CLICK, captionTextClickHandler);
			}
			
			box.addChild(_captionText);
			box.percentWidth = 100;
			return box;
		}
		
		private var _addressText:Text;
		private var _addressChanged:Boolean;
		
		protected function createAddress():UIComponent
		{
			var box:HBox = new HBox();
			
			if(_addressText == null)
			{
				_addressText = new Text();
				_addressText.styleName = "YoEntryAddress";
				_addressText.selectable = false;
				_addressText.percentWidth = 100;
			}
			
			box.addChild(_addressText);
			box.percentWidth = 100;
			return box;
		}
		
		private var _descriptionText:Text;
		private var _descriptionChanged:Boolean;
		
		protected function createDescription():UIComponent
		{
			var box:HBox = new HBox();
			
			if(_descriptionText == null)
			{
				_descriptionText = new Text();
				_descriptionText.styleName = "YoEntryContent";
				_descriptionText.selectable = false;
				_descriptionText.percentWidth = 100;
			}
			
			box.addChild(_descriptionText);
			box.percentWidth = 100;
			return box;
		}
		
		private var _removeText:Image;
		private var _editText:Image;
		
		protected function createBottomPanel():UIComponent
		{
			var box:HBox = new HBox();
			
			if(_editText == null)
			{
				_editText = new Image();
				_editText.source = "resources/pencil_11x11.png";
				_editText.scaleContent = false;
				_editText.buttonMode = true;
				_editText.useHandCursor = true;
				_editText.mouseChildren = false;
				
				_editText.addEventListener(MouseEvent.CLICK, editClickHandler);
			}
			
			box.addChild(_editText);
			
			if(_removeText == null)
			{
				_removeText = new Image();
				_removeText.source = "resources/trash_11x11.png";
				_removeText.scaleContent = false;
				_removeText.buttonMode = true;
				_removeText.useHandCursor = true;
				_removeText.mouseChildren = false;
				
				_removeText.addEventListener(MouseEvent.CLICK, removeClickHandler);
			}
			
			box.addChild(_removeText);
			
			box.percentWidth = 100;
			box.setStyle("horizontalGap", 4);
			box.setStyle("horizontalAlign", "right");
			return box;
		}
		
		private function editClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new YoListItemEvent(YoListItemEvent.EditClick));
		}
		
		private function removeClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new YoListItemEvent(YoListItemEvent.RemoveClick));
		}
		
		private function iconClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new YoListItemEvent(YoListItemEvent.ItemClick));
		}
		
		private function captionTextClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new YoListItemEvent(YoListItemEvent.ItemClick));
		}
		
		private function gomeeCaptionChangedHandler(event:GomeeEvent):void
		{
			_captionChanged = true;
			invalidateProperties();
		}
		
		private function gomeeAddressChangedHandler(event:GomeeEvent):void
		{
			_addressChanged = true;
			invalidateProperties();
		}
		
		private function gomeeDescriptionChangedHandler(event:GomeeEvent):void
		{
			_descriptionChanged = true;
			invalidateProperties();
		}
	}
}