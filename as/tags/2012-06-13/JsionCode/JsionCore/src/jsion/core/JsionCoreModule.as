package jsion.core
{
	import jsion.core.modules.BaseModule;
	import jsion.core.modules.ModuleInfo;
	
	/**
	 * JsionCore模块
	 * @author Jsion
	 */	
	public class JsionCoreModule extends BaseModule
	{
		public function JsionCoreModule(info:ModuleInfo)
		{
			super(info);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function startup():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function stop():void
		{
			
		}
	}
}