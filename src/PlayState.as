package  
{
	import org.flixel.*;
	
	/**
	 * The only state of the game.
	 */
	public class PlayState extends FlxState
	{
		public static var MAX_PIXELS:int = 20;
		private static var PIXEL_DELAY:int = 10;
		private var player:PlayerPixel;
		private var nextPixelTime:int = 0;
		public static var cameraFocus:CameraFocus;
		public static var pixelGroup:FlxGroup;
		public static var numPixels:int = 0;
		public static var zoomTime:int = 0;
		private var zoomFactor:Number = 0;
		private var zoomMoves:Array = new Array();
		public static var transitionFlag:Boolean;
		
		public static var backgroundColor:Number;
		public static var backgroundChangeTime:Number;		
		
		public function PlayState()
		{
		}
		
		override public function update():void
		{
			FlxG.bgColor = backgroundColor;
			
			// Delete pixels that are 1 screen width from the center of the screen
			for (var index:int = 0; index < pixelGroup.length; index++)
			{
				if(pixelGroup.members[index])
					if (pixelGroup.members[index].x > cameraFocus.x + Main.WIDTH ||
						pixelGroup.members[index].x < cameraFocus.x - Main.WIDTH ||
						pixelGroup.members[index].y > cameraFocus.y + Main.HEIGHT ||
						pixelGroup.members[index].y < cameraFocus.y - Main.HEIGHT)
					{
						pixelGroup.members[index].kill();
						pixelGroup.remove(pixelGroup.members[index]);
						numPixels--;
					}
			}
			
			nextPixelTime++;
			
			// Animate the zooming out
			if (zoomTime)
			{
				Main.PIXEL -= zoomFactor; // The scaling factor changes over time instead of all at once
				player.scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8); // Scale the player
				for (var index2:int = 0; index2 < MAX_PIXELS; index2++) // Move and scale the Pixels
				{
					if (pixelGroup.members[index2])
					{
						pixelGroup.members[index2].x -= zoomMoves[index2];
						pixelGroup.members[index2].y -= zoomMoves[index2 + MAX_PIXELS];
						pixelGroup.members[index2].scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
					}
				}
				zoomTime--;
			}
			
			/* Only spawn Pixels at a rate of 60 / PIXEL_DELAY per second
			 * Never have more than MAX_PIXELS created at a time */
			else if (nextPixelTime >= PIXEL_DELAY && numPixels < MAX_PIXELS)
			{
				// Randomly choose a side to spawn the Pixel on then randomly offset it on that axis just outside the screen
				var side:int = Math.random() * 4 % 4;
				var x:int, y:int;
				switch(side)
				{
					case 0:
						x = cameraFocus.x + Math.random() * Main.WIDTH - Main.WIDTH / 2;
						y = cameraFocus.y - 32 - Main.HEIGHT / 2;
						break;
					case 1:
						x = cameraFocus.x + Math.random() * Main.WIDTH - Main.WIDTH / 2;
						y = cameraFocus.y + Main.HEIGHT / 2 + 10;
						break;
					case 2:
						x = cameraFocus.x - 32 - Main.WIDTH / 2;
						y = cameraFocus.y + Math.random() * Main.HEIGHT - Main.HEIGHT / 2;
						break;
					case 3:
						x = cameraFocus.x + Main.WIDTH / 2 + 10;
						y = cameraFocus.y + Math.random() * Main.HEIGHT - Main.HEIGHT / 2;
						break;
				}
				
				// Add the new Pixels to the group so that they can be updated
				var newPixel:Pixel = new Pixel(x, y);
				pixelGroup.add(newPixel);
				add(newPixel);
				numPixels++;
				nextPixelTime = 0;
			}
			
			// animate background color changing
			if (backgroundChangeTime > 0) {
				
				backgroundColor = DistilledHelper.lerpColorWithAlpha(backgroundColor, DistilledHelper.backgroundColors[0], (50 - backgroundChangeTime) / 50);
				
				backgroundChangeTime --;
			}
			else if (backgroundChangeTime == 0) {
				backgroundColor = DistilledHelper.backgroundColors.shift();
				backgroundChangeTime = -1;
			}
			
			if (FlxG.keys.justPressed("SPACE"))
			{
				transition();
			}
			
			// Set by PlayerPixel after a certain number of Pixels are captured
			if (transitionFlag)
			{
				transitionFlag = false;
				transition();
			}
			
			super.update();
		}
		
		/**
		 * Changes music, color, and scale.
		 */
		public function transition():void
		{
			zoom();
			
			// we can't really change colors if there aren't any more colors left
			if (DistilledHelper.backgroundColors.length > 0) 
				backgroundChangeTime = 50;
		}
		
		/**
		 * Starts the downscaling animation to imitate zooming out.
		 */
		public function zoom():void
		{
			MAX_PIXELS += 5;
			PIXEL_DELAY -= 2;
			
			zoomTime = 50;
			zoomFactor = Main.PIXEL / (3.5 * zoomTime); // How much to increment Main.Pixel each tick while resizing
			player.boundingSize *= 0.7; // Make the player's bounding box scale with him
			
			// Calculate how much each Pixel needs to move per tick and store it in an Array
			for (var index:int = 0; index < MAX_PIXELS; index++)
			{
				if (pixelGroup.members[index])
				{
					var xOffset:int, yOffset:int;
					xOffset = pixelGroup.members[index].x - cameraFocus.x;
					xOffset /= 3.5;
					zoomMoves[index] = xOffset / zoomTime;
					yOffset = pixelGroup.members[index].y - cameraFocus.y;
					yOffset /= 3.5;
					zoomMoves[MAX_PIXELS + index] = yOffset / zoomTime;
					
					// Scale the velocities with the Pixels
					pixelGroup.members[index].velocity.x /= Main.PIXEL / 8;
					pixelGroup.members[index].velocity.y /= Main.PIXEL / 8;
				}
			}
		}
		
		override public function create():void
		{
			add(new Background());
			
			// set the background color
			backgroundColor = DistilledHelper.backgroundColors.shift();
			backgroundChangeTime = -1;
			
			pixelGroup = new FlxGroup();
			
			// Center the player
			player = new PlayerPixel(Main.WIDTH / 2 - 16, Main.HEIGHT / 2 - 16);
			add(player);
			
			/* The camera follows the this object which follows the player to create
			 * a delay between player movement and camera movement */
			cameraFocus = new CameraFocus(player);
			add(cameraFocus);
			FlxG.camera.follow(cameraFocus);
			
			zoom(); // It is to close in otherwise, but I didn't want to have to reset all the scaling by hand
		}
	}

}