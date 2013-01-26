package 
{
	import org.flixel.*;
	
	[SWF(width = "512", height = "512", frameRate = "60", backgroundColor = "#FFFFFF")]
	
	public class Main extends FlxGame
	{
		
		public static const PIXEL:int = 1;
		public static const WIDTH:int = 512 / PIXEL;
		public static const HEIGHT:int = 512 / PIXEL;
		public static const DEBUG:Boolean = true;
		
		public function Main():void 
		{
			super(WIDTH, HEIGHT, PlayState, PIXEL, 60, 60, true);
			forceDebugger = DEBUG;
		}
				
	}
	
}