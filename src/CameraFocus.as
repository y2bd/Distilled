package  
{
	import org.flixel.*;
	
	/**
	 * Object that follows the player around gradually. The camera focuses on this.
	 */
	public class CameraFocus extends FlxSprite
	{
		private const RATIO:Number = 0.03;
		
		private var player:PlayerPixel;
		
		public function CameraFocus(p:PlayerPixel) 
		{
			super(p.x + p.width / 2, p.y + p.width / 2);
			player = p;
			makeGraphic(8, 8, 0x00ff0000);
		}
		
		override public function update():void
		{
			x = x + (player.x + player.width / 2 - x) * RATIO;
			y = y + (player.y + player.width / 2 - y) * RATIO;
		}
		
	}

}