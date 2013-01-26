package  
{
	import org.flixel.*;
	
	/**
	 * The only state of the game.
	 */
	public class PlayState extends FlxState
	{
		override public function create():void
		{
			var p:PlayerPixel = new PlayerPixel(100, 100);
			add(p);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}