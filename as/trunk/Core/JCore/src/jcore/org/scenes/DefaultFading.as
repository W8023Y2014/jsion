package jcore.org.scenes
{
	import flash.display.Sprite;
	
	public class DefaultFading extends Sprite implements IFading, IDispose
	{
		public function DefaultFading()
		{
			super();
		}
		
		public function setFading(callback:Function):void
		{
			callback();
		}
		
		public function dispose():void
		{
		}
	}
}