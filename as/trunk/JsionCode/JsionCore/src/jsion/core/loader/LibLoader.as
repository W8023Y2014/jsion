package jsion.core.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class LibLoader extends BytesLoader
	{
		protected var m_loader:Loader;
		
		public function LibLoader(file:String, root:String = "", managed:Boolean = true)
		{
			super(file, root, managed);
		}
		
		override protected function onCompleted():void
		{
			if(m_loader == null)
			{
				m_data = m_loader;
				
				m_loader = new Loader();
				m_loader.loadBytes(m_urlLoader.data, new LoaderContext(false, ApplicationDomain.currentDomain));
				m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __embedInDomainHandler);
			}
			else
			{
				super.onCompleted();
			}
		}
		
		private function __embedInDomainHandler(e:Event):void
		{
			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			super.onCompleted();
		}
		
		override public function dispose():void
		{
			if(m_loader) m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __embedInDomainHandler);
			
			m_loader = null;
			
			super.dispose();
		}
	}
}