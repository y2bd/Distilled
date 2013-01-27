package
{
	import org.flixel.*;
	
	/**
	 * The class to hold the tiled background.
	 */
	public class Background extends FlxGroup
	{
		[Embed(source = "../assets/tileTexture.png")]
		public static var BG:Class;
		
		private var imageArray:Array;
		
		// Where the camera was last time the background was moved
		private var oldX:int = Main.WIDTH / 2 - 16;
		private var oldY:int = Main.HEIGHT / 2 - 16;
		
		/**
		 * Contructor for the Background object.
		 */
		public function Background()
		{
			super();
			
			// Create an array of the background image
			imageArray = new Array();
			for (var row:int = 0; row < 8; row++)
			{
				imageArray[row] = [];
				for (var col:int = 0; col < 8; col++)
				{
					add(imageArray[row][col] = new FlxSprite((col - 2) * 128, (row - 2) * 128, BG));
					imageArray[row][col].alpha = 0.1;
					
				}
			}
		}
		
		/**
		 * For every 128 pixels that the player moves move the background 128 pixels.
		 */
		override public function update():void
		{
			var row:int, col:int;
			if (oldX - PlayState.cameraFocus.x >= 128)
			{
				for (row = 0; row < 8; row++)
				{
					for (col = 0; col < 8; col++)
					{
						imageArray[row][col].x -= 128;
					}
				}
				oldX = PlayState.cameraFocus.x;
			}
			else if (oldX - PlayState.cameraFocus.x <= -128)
			{
				for (row = 0; row < 8; row++)
				{
					for (col = 0; col < 8; col++)
					{
						imageArray[row][col].x += 128;
					}
				}
				oldX = PlayState.cameraFocus.x;
			}
			if (oldY - PlayState.cameraFocus.y >= 128)
			{
				for (row = 0; row < 8; row++)
				{
					for (col = 0; col < 8; col++)
					{
						imageArray[row][col].y -= 128;
					}
				}
				oldY = PlayState.cameraFocus.y;
			}
			else if (oldY - PlayState.cameraFocus.y <= -128)
			{
				for (row = 0; row < 8; row++)
				{
					for (col = 0; col < 8; col++)
					{
						imageArray[row][col].y += 128;
					}
				}
				oldY = PlayState.cameraFocus.y;
			}
		}
	}
}