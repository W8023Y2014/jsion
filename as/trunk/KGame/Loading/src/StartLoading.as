package 
{
	import flash.display.Stage;

	public function StartLoading(stage:Stage, config:XML):void
	{
		trace("Please wait, now is loading...");
		
		stage.addChild(new LoadingView(stage, config));
	}
}