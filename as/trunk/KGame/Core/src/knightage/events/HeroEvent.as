package knightage.events
{
	import flash.events.Event;
	
	public class HeroEvent extends Event
	{
		public static const ADD_HERO:String = "addHero";
		
		public var data:*;
		
		public function HeroEvent(type:String, data:*)
		{
			this.data = data;
			
			super(type);
		}
	}
}