package knightage.display
{
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import jsion.Insets;
	import jsion.display.Image;
	import jsion.display.LabelButton;
	
	import knightage.StaticRes;
	
	public class YellowButton extends LabelButton
	{
		private static const UpImageBMD:YellowButtonUpAsset = new YellowButtonUpAsset(0, 0);
		
		private var m_txt:String;
		
		public function YellowButton(text:String = "Button")
		{
			m_txt = text;
			super();
		}
		
		override protected function configUI():void
		{
			var img:Image = new Image();
			
			img.beginChanges();
			img.freeSource = false;
			img.source = UpImageBMD;
			img.scale9Insets = new Insets(14, 20, 14, 20);
			img.commitChanges();
			
			beginChanges();
			upImage = img;
			label = m_txt;
			labelColor = StaticRes.WhiteColor;
			vOffset = -1;
			styleSheet = StaticRes.ButtonDefaultStyle;
			textFormat = StaticRes.ButtonDefaultTextFormat;
			labelUpFilters = StaticRes.ButtonDefaultFilters;
			labelOverFilters = StaticRes.ButtonDefaultFilters;
			labelDownFilters = StaticRes.ButtonDefaultFilters;
			commitChanges();
		}
	}
}