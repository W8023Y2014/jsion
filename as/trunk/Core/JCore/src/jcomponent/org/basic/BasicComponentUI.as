package jcomponent.org.basic
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jcomponent.org.basic.borders.IBorder;
	import jcomponent.org.basic.graphics.Graphics2D;
	import jcomponent.org.basic.graphics.SolidBrush;
	import jcomponent.org.mgrs.UIMgr;
	
	import jutils.org.util.DisposeUtil;

	public class BasicComponentUI extends UIResources implements IComponentUI
	{
		public function BasicComponentUI()
		{
		}
		
		public function install(component:Component):void
		{
		}
		
		public function uninstall(component:Component):void
		{
		}
		
		public function getPreferredSize(component:Component):IntDimension
		{
			return null;
		}
		
		public function getMinimumSize(component:Component):IntDimension
		{
			return null;
		}
		
		public function getMaximumSize(component:Component):IntDimension
		{
			return null;
		}
		
		public function paint(component:Component, bounds:IntRectangle):void
		{
			if(component.opaque) paintBackgroundColor(component, bounds);
		}
		
		protected function paintBackgroundColor(component:Component, bounds:IntRectangle):void
		{
			var dis:Sprite;
			
			if(component.m_background == null)
			{
				dis = new Sprite();
				component.m_background = dis;
				
				component.addChildAt(dis, component.getLowestIndexAboveBackground());
			}
			else
			{
				dis = component.m_background as Sprite;
			}
			
			if(dis)
			{
				var g:Graphics2D = new Graphics2D(dis.graphics);
				
				g.fillRectangle(new SolidBrush(component.backcolor), bounds.x, bounds.y, bounds.width, bounds.height);
				
				DisposeUtil.free(g);
				g = null;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		override public function getUI(target:Component):IComponentUI
		{
			return UIMgr.getUI(target);
		}
		
		override public function getBoolean(key:String):Boolean
		{
			if(containsResourceKey(key)) return super.getBoolean(key);
			
			return UIMgr.getBoolean(key);
		}
		
		override public function getNumber(key:String):Number
		{
			if(containsResourceKey(key)) return super.getNumber(key);
			
			return UIMgr.getNumber(key);
		}
		
		override public function getInt(key:String):int
		{
			if(containsResourceKey(key)) return super.getInt(key);
			
			return UIMgr.getInt(key);
		}
		
		override public function getUint(key:String):uint
		{
			if(containsResourceKey(key)) return super.getUint(key);
			
			return UIMgr.getUint(key);
		}
		
		override public function getString(key:String):String
		{
			if(containsResourceKey(key)) return super.getString(key);
			
			return UIMgr.getString(key);
		}
		
		override public function getBorder(key:String):IBorder
		{
			if(containsResourceKey(key)) return super.getBorder(key);
			
			return UIMgr.getBorder(key);
		}
		
		override public function getIcon(key:String):IICON
		{
			if(containsResourceKey(key)) return super.getIcon(key);
			
			return UIMgr.getIcon(key);
		}
		
		override public function getGroundDecorator(key:String):IGroundDecorator
		{
			if(containsResourceKey(key)) return super.getGroundDecorator(key);
			
			return UIMgr.getGroundDecorator(key);
		}
		
		override public function getColor(key:String):ASColor
		{
			if(containsResourceKey(key)) return super.getColor(key);
			
			return UIMgr.getColor(key);
		}
		
		override public function getFont(key:String):ASFont
		{
			if(containsResourceKey(key)) return super.getFont(key);
			
			return UIMgr.getFont(key);
		}
		
		override public function getInsets(key:String):Insets
		{
			if(containsResourceKey(key)) return super.getInsets(key);
			
			return UIMgr.getInsets(key);
		}
		
		override public function getStyleTune(key:String):StyleTune
		{
			if(containsResourceKey(key)) return super.getStyleTune(key);
			
			return UIMgr.getStyleTune(key);
		}
		
		override public function getConstructor(key:String):Class
		{
			if(containsResourceKey(key)) return super.getConstructor(key);
			
			return UIMgr.getConstructor(key);
		}
		
		override public function getInstance(key:String):*
		{
			if(containsResourceKey(key)) return super.getInstance(key);
			
			return UIMgr.getInstance(key);
		}
	}
}