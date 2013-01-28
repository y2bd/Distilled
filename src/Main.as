package 
{
	import org.flixel.*;
	import flash.display.StageQuality;
	
	[SWF(width = "512", height = "512", frameRate = "60", backgroundColor = "#FFFFFF")]
	
	/**
	 * The class that starts the game.
	 */
	public class Main extends FlxGame
	{
		
		public static var PIXEL:Number = 8;
		public static const WIDTH:int = 512;
		public static const HEIGHT:int = 512;
		
		public function Main():void 
		{
			super(WIDTH, HEIGHT, PlayState, 1, 60, 30, true);
			forceDebugger = true;
			
			stage.quality = StageQuality.LOW;
		}
				
	}
	
}