package  
{
	import org.flixel.*;
	
	/**
	 * Pixel the player controls with the arrow keys.
	 */
	public class PlayerPixel extends Pixel
	{
		private const ACCEL:Number = 800; // in pixels per second per second
		private const MAXVELOCITY:Number = 200; // in pixels per second
		
		public function PlayerPixel(x:int, y:int) 
		{
			super(x, y);
			maxVelocity.x = MAXVELOCITY;
			maxVelocity.y = MAXVELOCITY;
			
		}
		
		override public function update():void
		{
			var right:Boolean = FlxG.keys.RIGHT;
			var left:Boolean = FlxG.keys.LEFT;
			var up:Boolean = FlxG.keys.UP;
			var down:Boolean = FlxG.keys.DOWN;
			
			if (right && !left) acceleration.x = ACCEL;
			if (left && !right) acceleration.x = -ACCEL;
			if (up && !down) acceleration.y = -ACCEL;
			if (down && !up) acceleration.y = ACCEL;
			
			if ((!right && !left) || (right && left))
			{
				if (velocity.x > 0) acceleration.x = -ACCEL;
				else if (velocity.x < 0) acceleration.x = ACCEL;
				else acceleration.x = 0;
			}
			if ((!up && !down) || (up && down))
			{
				if (velocity.y > 0) acceleration.y = -ACCEL;
				else if (velocity.y < 0) acceleration.y = ACCEL;
				else acceleration.y = 0;
			}
		}
		
	}

}