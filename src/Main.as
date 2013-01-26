package 
{
	import org.flixel.*;
	
	[SWF(width = "512", height = "512", frameRate = "60", backgroundColor = "#FFFFFF")]
	
	public class Main extends FlxGame
	{
		
		public static var PIXEL:Number = 8;
		public static const WIDTH:int = 512;
		public static const HEIGHT:int = 512;
		public static const DEBUG:Boolean = false;
		
		public function Main():void 
		{
			super(WIDTH, HEIGHT, PlayState, 1, 60, 30, true);
			//forceDebugger = DEBUG;
		}
				
	}
	
}