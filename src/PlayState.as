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
		private var cameraFocus:CameraFocus;
		private var pixelGroup:FlxGroup;
		private var numPixels:int = 0;
		
		public function PlayState()
		{
			
		}
		
		override public function update():void
		{
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
			if (nextPixelTime >= 10 && numPixels < 20)
			{
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
						y = cameraFocus.y + Main.HEIGHT / 2;
						break;
					case 2:
						x = cameraFocus.x - 32 - Main.WIDTH / 2;
						y = cameraFocus.y + Math.random() * Main.HEIGHT - Main.HEIGHT / 2;
						break;
					case 3:
						x = cameraFocus.x + Main.WIDTH / 2;
						y = cameraFocus.y + Math.random() * Main.HEIGHT - Main.HEIGHT / 2;
						break;
				}
				var newPixel:Pixel = new Pixel(x, y);
				pixelGroup.add(newPixel);
				numPixels++;
				nextPixelTime = 0;
			}
			
			if (FlxG.keys.justPressed("SPACE"))
			{
				Main.PIXEL /= 2;
				player.scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
				for (var index2:int = 0; index2 < pixelGroup.length; index2++)
				{
					if (pixelGroup.members[index2])
					{
						var xOffset:int, yOffset:int;
						xOffset = pixelGroup.members[index2].x - cameraFocus.x;
						xOffset /= 2;
						pixelGroup.members[index2].x -= xOffset;
						yOffset = pixelGroup.members[index2].y - cameraFocus.y;
						yOffset /= 2;
						pixelGroup.members[index2].y -= yOffset;
						pixelGroup.members[index2].scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
					}
				}
			}
			
			super.update();
		}
		
		override public function create():void
		{
			pixelGroup = new FlxGroup(20);
			add(pixelGroup);
			
			player = new PlayerPixel(Main.WIDTH / 2 - 16, Main.HEIGHT / 2 - 16);
			add(player);
			
			cameraFocus = new CameraFocus(player);
			add(cameraFocus);
			FlxG.camera.follow(cameraFocus);
		}
	}

}