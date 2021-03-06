package jsion.ui.layouts
{
	import flash.display.DisplayObject;
	
	import jsion.*;
	import jsion.ui.Container;
	import jsion.ui.IGroundDecorator;
	import jsion.ui.UIUtil;
	import jsion.ui.components.containers.AbstractBox;

	public class VBoxLayout extends EmptyLayout
	{
		public function VBoxLayout()
		{
			super();
		}
		
		override public function layoutContainer(target:Container):void
		{
			var viewRect:IntRectangle = new IntRectangle();
			viewRect.setSize(target.getSize());
			
			var box:AbstractBox = AbstractBox(target);
			
			var count:int = target.numChildren;
			
			if(count <= 0) return;
			
			var fore:Boolean, back:Boolean;
			var ground:IGroundDecorator = target.backgroundDecorator;
			if(ground && ground.getDisplay(target)) back = true;
			ground = target.foregroundDecorator;
			if(ground && ground.getDisplay(target)) fore = true;
			
			var i:int = 0;
			if(back) i = 1;
			if(fore) count -= 1;
			
			var preDis:DisplayObject;
			var maxW:int;
			
			var tmpRect:IntRectangle = new IntRectangle();
			
			for(; i < count; i++)
			{
				var dis:DisplayObject = target.getChildAt(i);
				
				if(dis == target.mask) continue;
				
				if(preDis)
				{
					dis.y = preDis.y + preDis.height;
					dis.y += box.gap;
				}
				else
				{
					dis.y = 0;
				}
				
				tmpRect.setRectXYWH(0, 0, dis.width, dis.height);
				
				UIUtil.layoutPosition(viewRect, box.hAlign, box.vAlign, 0, 0, tmpRect);
				
				dis.x = tmpRect.x;
				
				maxW = Math.max(dis.width, maxW);
				
				preDis = dis;
			}
		}
	}
}