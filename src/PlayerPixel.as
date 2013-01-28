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
		private var pixelLocations:Array;
		private var numNewLayers:int = 0;
		
		/**
		 * Creates a player.
		 * @param	x X coordinate of the new PlayerPixel.
		 * @param	y Y coordinate of the new PlayerPixel.
		 */
		public function PlayerPixel(x:int, y:int) 
		{
			super(x, y);
			maxVelocity.x = MAXVELOCITY;
			maxVelocity.y = MAXVELOCITY;
			
			boundingSize = 32; // Let is pick up pixels 1/2 Pixel width outside of the PlayerPixel
			pixelLocations = FinalImage.GenerateImagePlacementArray();
			
			// We don't want the random movement from Pixel
			velocity.x = 0;
			velocity.y = 0;
			
			// Make it part of the final image
			playerPixels.add(this);
			Pixel(this).pickup(this, pixelLocations[playerPixels.length-1][1] - 32, pixelLocations[playerPixels.length-1][0] - 32, pixelLocations[playerPixels.length-1][2]);
		}
		
		override public function update():void
		{
			// Move
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
			
			checkCollisions(); // See if we need to get any Pixels
			
			// Scale all Pixels that have been picked up
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
			
			// Make it the correct color
			if (fadeCount > 0)
			{
				fadeCount--;
				color = DistilledHelper.lerpColor(color1, color2, (60 - fadeCount) / 60);
			}
		}
		
		/**
		 * See if the player has touched any stray Pixels.
		 * If so add them to the final image.
		 */
		private function checkCollisions():void
		{
			for (var index:int = 0; index < PlayState.MAX_PIXELS; index++)
			{
				// Only pick up Pixels if we aren't scaling, it exists, and the pciture is not complete
				if (PlayState.pixelGroup.members[index] && !PlayState.zoomTime && size < 4096)
				{
					var x:int = PlayState.pixelGroup.members[index].x;
					var y:int = PlayState.pixelGroup.members[index].y;
					// If it is in the bounding box
					if (x > this.x - boundingSize && x < this.x + boundingSize &&
						y > this.y - boundingSize && y < this.y + boundingSize)
					{
						// Add it to the final image
						size++;
						var thisGuy:FlxSprite = PlayState.pixelGroup.members[index];
						playerPixels.add(thisGuy);
						Pixel(thisGuy).pickup(this, pixelLocations[playerPixels.length - 1][1] - 32, pixelLocations[playerPixels.length - 1][0] - 31, pixelLocations[playerPixels.length - 1][2]);
						// Remove it from the stray Pixel group
						PlayState.pixelGroup.remove(thisGuy);
						PlayState.numPixels--;
					}
				}
			}
			
			// If we filled up another circle around the center then increase the bounding box
			if (size > Math.pow(boundingSize / (2 * Main.PIXEL) + 1, 2) && !PlayState.zoomTime)
			{
				boundingSize += 10 * Main.PIXEL;
				numNewLayers++;
				// Do we want to zoom out?
				if (numNewLayers == 1 || numNewLayers == 2 || numNewLayers == 3 || numNewLayers == 4
				 || numNewLayers == 6 || numNewLayers == 8 || numNewLayers == 10 || numNewLayers == 12)
					PlayState.transitionFlag = true;
			}
		}
		
	}

}