package  
{
	import org.flixel.*;
	
	/**
	 * The only state of the game.
	 */
	public class PlayState extends FlxState
	{
		
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
						x = player.x + Math.random() * Main.WIDTH - Main.WIDTH / 2;
						y = player.y - 32 - Main.HEIGHT / 2;
						break;
					case 1:
						x = player.x + Math.random() * Main.WIDTH - Main.WIDTH / 2;
						y = player.y + Main.HEIGHT / 2;
						break;
					case 2:
						x = player.x - 32 - Main.WIDTH / 2;
						y = player.y + Math.random() * Main.HEIGHT - Main.HEIGHT / 2;
						break;
					case 3:
						x = player.x + Main.WIDTH / 2;
						y = player.y + Math.random() * Main.HEIGHT - Main.HEIGHT / 2;
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
			
			var cameraFocus:CameraFocus = new CameraFocus(player);
			add(cameraFocus);
			FlxG.camera.follow(cameraFocus);
		}
	}

}