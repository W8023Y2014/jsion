package jcomponent.org.basic
{
	import flash.display.DisplayObject;
	
	public class Icon implements IICON
	{
		public function Icon()
		{
		}
		
		public function get getIconWidth():int
		{
			return 0;
		}
		
		public function get getIconHeight():int
		{
			return 0;
		}
		
		public function updateIcon(component:Component, x:int, y:int):void
		{
		}
		
		public function getDisplay(component:Component):DisplayObject
		{
			return null;
		}
		
		public function dispose():void
		{
			if(this == DefaultRes.DEFAULT_ICON) return;
			
			
		}
	}
}