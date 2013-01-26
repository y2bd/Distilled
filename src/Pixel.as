package  
{
	import org.flixel.*;
	
	/**
	 * A pixel object in the game.
	 */
	public class Pixel extends FlxSprite
	{
		private var ease:Number;
		private var target:FlxPoint;
		private var player:PlayerPixel;
		private var pickedup:Boolean;
		private var xoffset:int;
		private var yoffset:int;
		
		public function Pixel(x:int, y:int) 
		{
			super(x, y);
			makeGraphic(32, 32, 0xffffffff);
			color = Math.random() * 0xffffff;
			scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
			velocity.x = Math.random() * 50 - 25;
			velocity.y = Math.random() * 50 - 25;
		}
		
		public function pickup(p:PlayerPixel, xoffset:int, yoffset:int):void
		{
			pickedup = true;
			player = p;
			ease = Math.random() * 0.05 + 0.02;
			this.xoffset = xoffset;
			this.yoffset = yoffset;
		}
		
		override public function update():void
		{
			if (pickedup)
			{
				velocity.x = 0;
				velocity.y = 0;
				var pixelSize:Number = Main.PIXEL * 4;
				x += (player.x + Number(xoffset) * pixelSize - x) * ease;
				y += (player.y + Number(yoffset) * pixelSize - y) * ease;
				//trace(player.boundingSize);
			}
			else {
				velocity.x += Math.random() * 5 - 2.5;
				velocity.y += Math.random() * 5 - 2.5;
			}
		}
		
	}

}