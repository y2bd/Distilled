package  
{
	import org.flixel.*;
	
	/**
	 * A pixel object in the game.
	 */
	public class Pixel extends FlxSprite
	{
		
		public function Pixel(x:int, y:int) 
		{
			super(x, y);
			makeGraphic(32, 32, 0xff2050c0);
			scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
		}
		
		override public function update():void
		{
			
		}
		
	}

}