package controls.text
{
	import com.adobe.flex.extras.controls.AutoComplete;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.utils.StringUtil;
	
	public class YoTagsInput extends AutoComplete
	{
		[Bindable]
		static private var _source:IList = new ArrayCollection();
		
		static public function addTags(tags:Array):void
		{
			for(var i:int = 0; i < tags.length; i++)
			{
				addTag(tags[i]);
			}
		}
		
		static public function addTag(tag:String):void
		{
			var source:Array = _source.toArray();
			var count:int = source.filter(
				function(item:Object, index:int, array:Array):Boolean
				{
					if(item["name"] == tag)
					{
						return true;
					}
					return false;
				}).length;
				
			if(count == 0)
			{
				_source.addItem({"name" : tag});	
			}
		}
		
		public function YoTagsInput()
		{
			super();
			filterFunction = ff;
			lookAhead = true;
			
			this.dataProvider = _source;
			this.labelField = "name";
		}
		
		private function ff(element:*, text:String):Boolean 
		{
	    	var label:String = itemToLabel(element);
	    	var tags:Array = text.split(",");
	    	var text:String = StringUtil.trim(tags[tags.length - 1]);
	    	if(text == "") return false;
	    	var s1:String = label.toLowerCase().substring(0,text.length);
	    	var b:Boolean = s1 == text.toLowerCase();  
	    	return b;
		}
	}
}