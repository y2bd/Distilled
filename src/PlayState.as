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
		
		public function PlayState()
		{
			
		}
		
		override public function update():void
		{
			
			FlxG.bgColor = 0xFF6677AA;
			
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
			if (zoomTime)
			{
				Main.PIXEL -= zoomFactor;
				player.scale = new FlxPoint(Main.PIXEL / 8, Main.PIXEL / 8);
				for (var index2:int = 0; index2 < MAX_PIXELS; index2++)
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
			else if (nextPixelTime >= PIXEL_DELAY && numPixels < MAX_PIXELS)
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
				var newPixel:Pixel = new Pixel(x, y);
				pixelGroup.add(newPixel);
				add(newPixel);
				numPixels++;
				nextPixelTime = 0;
			}
			
			if (FlxG.keys.justPressed("SPACE"))
			{
				transition();
			}
			
			if (transitionFlag)
			{
				transitionFlag = false;
				transition();
			}
			
			super.update();
		}
		
		public function transition():void
		{
			zoom();
		}
		
		public function zoom():void
		{
			MAX_PIXELS += 3;
			PIXEL_DELAY--;
			zoomTime = 50;
			zoomFactor = Main.PIXEL / (4 * zoomTime);
			player.boundingSize *= 3/4;
			for (var index:int = 0; index < MAX_PIXELS; index++)
			{
				if (pixelGroup.members[index])
				{
					var xOffset:int, yOffset:int;
					xOffset = pixelGroup.members[index].x - cameraFocus.x;
					xOffset /= 4;
					zoomMoves[index] = xOffset / zoomTime;
					yOffset = pixelGroup.members[index].y - cameraFocus.y;
					yOffset /= 4;
					zoomMoves[MAX_PIXELS + index] = yOffset / zoomTime;
					pixelGroup.members[index].velocity.x /= Main.PIXEL / 8;
					pixelGroup.members[index].velocity.y /= Main.PIXEL / 8;
				}
			}
		}
		
		override public function create():void
		{
			add(new Background());
			
			pixelGroup = new FlxGroup();
			//add(pixelGroup);
			
			player = new PlayerPixel(Main.WIDTH / 2 - 16, Main.HEIGHT / 2 - 16);
			add(player);
			
			cameraFocus = new CameraFocus(player);
			add(cameraFocus);
			FlxG.camera.follow(cameraFocus);
			
			zoom();
		}
	}

}