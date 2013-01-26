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
		
		private var player:PlayerPixel;
		private var nextPixelTime:int = 0;
		
		public function PlayState()
		{
			
		}
		
		override public function update():void
		{
			nextPixelTime++;
			if (nextPixelTime >= 15)
			{
				var side:int = Math.random() * 4 % 4;
				var x:int, y:int;
				switch(side)
				{
					case 0:
						x = Math.random() * Main.WIDTH;
						y = -32;
						break;
					case 1:
						x = Math.random() * Main.WIDTH;
						y = Main.HEIGHT;
						break;
					case 2:
						x = -32;
						y = Math.random() * Main.HEIGHT;
						break;
					case 3:
						x = Main.WIDTH;
						y = Math.random() * Main.HEIGHT;
						break;
				}
				var newPixel:Pixel = new Pixel(x, y);
				add(newPixel);
				nextPixelTime = 0;
			}
			super.update();
		}
		
		override public function create():void
		{
			player = new PlayerPixel(Main.WIDTH / 2 - 16, Main.HEIGHT / 2 - 16);
			add(player);
		}
	}

}