package  
{
	import org.flixel.*;
	
	/**
	 * The only state of the game.
	 */
	public class PlayState extends FlxState
	{
		
		override public function update():void
		{
			add(new Pixel(50, 50));
		}
		
	}

}