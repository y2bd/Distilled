package  
{
	import mx.core.FlexSprite;
	import org.flixel.*;
	
	/**
	 * Pixel the player controls with the arrow keys.
	 */
	public class PlayerPixel extends Pixel
	{
		private const ACCEL:Number = 800; // in pixels per second per second
		private const MAXVELOCITY:Number = 200; // in pixels per second
		private const EPSILON:Number = 5;
		public var boundingSize:int;
		private var size:int = 1;
		public static var playerPixels:FlxGroup = new FlxGroup();
		
		public function PlayerPixel(x:int, y:int) 
		{
			super(x, y);
			maxVelocity.x = MAXVELOCITY;
			maxVelocity.y = MAXVELOCITY;
			boundingSize = 32;
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
			
			if (velocity.x < EPSILON && velocity.x > -EPSILON) velocity.x = 0;
			if (velocity.y < EPSILON && velocity.y > -EPSILON) velocity.y = 0;
			
			checkCollisions();
			
			if (PlayState.zoomTime)
			{
				for (var zoomIndex:int = 0; zoomIndex < playerPixels.length; zoomIndex++)
				{
					if (playerPixels.members[zoomIndex])
					{
						playerPixels.members[zoomIndex].scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
					}
				}
			}
		}
		
		private function checkCollisions():void
		{
			for (var index:int = 0; index < PlayState.MAX_PIXELS; index++)
			{
				if (PlayState.pixelGroup.members[index] && !PlayState.zoomTime)
				{
					var x:int = PlayState.pixelGroup.members[index].x;
					var y:int = PlayState.pixelGroup.members[index].y;
					if (x > this.x - boundingSize && x < this.x + boundingSize &&
						y > this.y - boundingSize && y < this.y + boundingSize)
					{
						size++;
						var thisGuy:FlxSprite = PlayState.pixelGroup.members[index];
						Pixel(thisGuy).pickup(this, int(Math.random()*5-3), int(Math.random()*5-3));
						playerPixels.add(thisGuy);
						PlayState.pixelGroup.remove(thisGuy);
						PlayState.numPixels--;
					}
				}
			}
			if (size > Math.pow(boundingSize / (2 * Main.PIXEL) + 1, 2) && !PlayState.zoomTime)
			{
				boundingSize += 4 * Main.PIXEL;
				PlayState.transitionFlag = true;
				trace("+");
			}
		}
		
	}

}