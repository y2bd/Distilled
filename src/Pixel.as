package  
{
	import org.flixel.*;
	
	/**
	 * A pixel object in the game.
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
		private var fadeCount:int;
		private var color1:uint;
		private var color2:uint;
		
		public function Pixel(x:int, y:int) 
		{
			super(x, y);
			makeGraphic(32, 32, 0xffffffff);
			color = Math.random() * 0xffffff;
			scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
			velocity.x = Math.random() * 50 - 25;
			velocity.y = Math.random() * 50 - 25;
		}
		
		public function pickup(p:PlayerPixel, xoffset:int, yoffset:int, c:uint):void
		{
			pickedup = true;
			player = p;
			ease = Math.random() * 0.05 + 0.02;
			k = Math.random() * 8 + 2;
			this.xoffset = xoffset;
			this.yoffset = yoffset;
			fadeCount = 60;
			color1 = color;
			color2 = c;
		}
		
		override public function update():void
		{
			if (pickedup)
			{
				velocity.x *= .97;
				velocity.y *= .97;
				var pixelSize:Number = Main.PIXEL * 4;
				//x += (player.x + Number(xoffset) * pixelSize - x) * ease;
				//y += (player.y + Number(yoffset) * pixelSize - y) * ease;
				//trace(player.boundingSize);
				acceleration.x = k * (player.x + xoffset * pixelSize - x);
				acceleration.y = k * (player.y + yoffset * pixelSize - y);
			}
			else {
				velocity.x += (Math.random() * 5 - 2.5) / Main.PIXEL / 8;
				velocity.y += (Math.random() * 5 - 2.5) / Main.PIXEL / 8;
			}
			
			if (fadeCount > 0)
			{
				fadeCount--;
				color = DistilledHelper.lerpColor(color1, color2, (60 - fadeCount) / 60);
			}
		}
		
	}

}