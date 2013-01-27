package  
{
	import org.flixel.*;
	
	/**
	 * An object that every pixel in the image or floating is an instance of.
	 */
	public class Pixel extends FlxSprite
	{
		private var ease:Number;
		private var k:Number;
		private var target:FlxPoint;
		private var player:PlayerPixel;
		private var pickedup:Boolean;
		private var xoffset:int;
		private var yoffset:int;
		protected var fadeCount:int;
		protected var color1:uint;
		protected var color2:uint;
		private var updateCount:int = 0;
		
		/**
		 * Creates a Pixel object.
		 * @param	x X position of new object.
		 * @param	y Y position of new object.
		 */
		public function Pixel(x:int, y:int) 
		{
			super(x, y);
			makeGraphic(32, 32, 0xffffffff);
			color = Math.random() * 0xffffff;
			scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8); // Make sure that it is the correct size
			
			// Make it randomly drift around
			velocity.x = Math.random() * 50 - 25;
			velocity.y = Math.random() * 50 - 25;
		}
		
		/**
		 * Called when the player collides with a Pixel. It adds the Pixel
		 * to the player's group.
		 * @param	p The PlayerPixel that is picking up the Pixel.
		 * @param	xoffset The horizontal offset in the final image of the Pixel.
		 * @param	yoffset The vertical  offset in the final image of the Pixel.
		 * @param	c The color that the Pixel will have in the final image.
		 */
		public function pickup(p:PlayerPixel, xoffset:int, yoffset:int, c:uint):void
		{
			pickedup = true;
			player = p;
			k = Math.random() * 8 + 2; // Set the spring constant
			this.xoffset = xoffset;
			this.yoffset = yoffset;
			fadeCount = 60; // The speed of the color change
			color1 = color;
			color2 = c;
		}
		
		override public function update():void
		{
			if (pickedup && updateCount > 5) // Only update motion every 5 ticks to improve performance
			{
				// Slows the Pixel down so that the image comes together when the player stops
				velocity.x *= .97;
				velocity.y *= .97;
				
				var pixelSize:Number = Main.PIXEL * 4;
				/* Set the acceleration based on Hooke's Law
				 * Let flixel handle movement for us */
				acceleration.x = k * (player.x + xoffset * pixelSize - x);
				acceleration.y = k * (player.y + yoffset * pixelSize - y);
			}
			else { //Let the Pixel change speed and direction
				velocity.x += (Math.random() * 5 - 2.5) / Main.PIXEL / 8;
				velocity.y += (Math.random() * 5 - 2.5) / Main.PIXEL / 8;
			}
			
			// Slowly change the color
			if (fadeCount > 0)
			{
				fadeCount--;
				color = DistilledHelper.lerpColor(color1, color2, (60 - fadeCount) / 60);
			}
			updateCount++;
		}
		
	}

}