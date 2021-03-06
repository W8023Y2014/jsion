package jsion.debug
{
	import flash.display.Stage;

	/**
	 * 信息调试器代理(全局静态)
	 * @author Jsion
	 */	
	public class DEBUG
	{
		public static const TOP:int = 1;
		public static const BOTTOM:int = 2;
		
		private static var m_bar:DebugBar;
		private static var m_visible:Boolean;
		private static var m_debugger:Debugger;
		private static var m_stage:Stage;
		
		public static function setup(stage:Stage, w:int):void
		{
			if(m_debugger) return;
			
			m_bar = new DebugBar(stage.stageWidth, 40, stage);
			stage.addChild(m_bar);
			
			m_bar.add(new JsionFPS());
			
			m_debugger = m_bar.add(new Debugger(w, stage.stageHeight)) as Debugger;
			
			m_visible = false;
		}
		
		public static function loadCSS(path:String):void
		{
			m_debugger.loadCSS(path);
		}
		
		public static function info(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.info.apply(null, args);
		}
		
		public static function debug(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.debug.apply(null, args);
		}
		
		public static function warn(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.warn.apply(null, args);
		}
		
		public static function error(obj:*, ...args):void
		{
			args.unshift(obj);
			m_debugger.error.apply(null, args);
		}
		
		public static function showBar(align:int = BOTTOM):void
		{
			if(m_visible) return;
			
			m_visible = true;
			
			if(align == TOP)
			{
				m_bar.y = 0;
			}
			else if(align == BOTTOM)
			{
				m_bar.y = m_stage.stageHeight - m_bar.height;
			}
		}
		
		public static function hideBar():void
		{
			if(m_visible)
			{
				m_visible = false;
				
				m_bar.y = m_bar.y - m_bar.height;
			}
		}
	}
}