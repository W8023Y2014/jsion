package jsion.core.modules
{
	/**
	 * 模块加载目标应用程序域
	 * @author Jsion
	 * 
	 */	
	public class ModuleTarget
	{
		/**
		 * 当前应用程序域
		 */		
		public static const Self:String = "_self";
		
		/**
		 * 新的应用程序域
		 */		
		public static const Blank:String = "_blank";
		
		/**
		 * 当前应用程序域的子域
		 */		
		public static const Child:String = "_child";
	}
}