package
{
	import mx.core.FlexApplicationBootstrap;
	import org.flixel.*;
	import flash.display.StageQuality;
	
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
		
		// hehe audio
		[Embed(source="../assets/audio/first.mp3")]
		public var audio1:Class;
		
		[Embed(source="../assets/audio/second.mp3")]
		public var audio2:Class;
		
		[Embed(source="../assets/audio/third.mp3")]
		public var audio3:Class;
		
		[Embed(source="../assets/audio/fourth.mp3")]
		public var audio4:Class;
		
		[Embed(source="../assets/audio/fifth.mp3")]
		public var audio5:Class;
		
		[Embed(source="../assets/audio/sixth.mp3")]
		public var audio6:Class;
		
		[Embed(source="../assets/audio/seventh.mp3")]
		public var audio7:Class;
		
		[Embed(source="../assets/audio/eighth.mp3")]
		public var audio8:Class;
		
		// audio vars
		public var audioTime:Number;
		public var audioSection:Number;
		
		public var currAudio:Class;
		public var nextAudio:Class;
		
		public var prevMusic:FlxSound;
		public var currMusic:FlxSound;
		public var nextMusic:FlxSound
		
		// timer
		public var timer:SimpleTimer;
		public var timerNumber:Number;
		public var timerState:Number;
		public var timerText:FlxText;
		
		public function PlayState()
		{
		
		}
		
		override public function update():void
		{
			FlxG.bgColor = backgroundColor;
			
			// Delete pixels that are 1 screen width from the center of the screen
			for (var index:int = 0; index < pixelGroup.length; index++)
			{
				if (pixelGroup.members[index])
					if (pixelGroup.members[index].x > cameraFocus.x + Main.WIDTH || pixelGroup.members[index].x < cameraFocus.x - Main.WIDTH || pixelGroup.members[index].y > cameraFocus.y + Main.HEIGHT || pixelGroup.members[index].y < cameraFocus.y - Main.HEIGHT)
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
				switch (side)
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
			if (backgroundChangeTime > 0)
			{
				
				backgroundColor = DistilledHelper.lerpColorWithAlpha(backgroundColor, DistilledHelper.backgroundColors[0], (100 - backgroundChangeTime) / 100);
				
				backgroundChangeTime--;
			}
			else if (backgroundChangeTime == 0)
			{
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
			
			// audio is broken, this is fix
			prevMusic.update();
			currMusic.update();
			nextMusic.update();
			
			// deal with timer
			if (timerState >= 0) {
				var min:Number = (int) ((timer.getElapsedTime() / 1000) / 60);
				var sec:Number = (int) ((timer.getElapsedTime() / 1000) % 60)
				
				timerText.text = min + ":" + (sec.toString().length == 1 ? "0" : "") + sec;
			}
			
			if (timerState == 0) {
				timerText.alpha = (120 - timerNumber) / 120;
				
				timerNumber --;
				
				if (timerNumber == 0) {
					timerState = 1;
					timerNumber = 120;
				}
			}
			else if (timerState == 1) {
				timerNumber --;
				
				if (timerNumber == 0) {
					timerNumber = 240;
					timerState = 2;
				}
			}
			else if (timerState == 2) {
				timerText.y = 244 + (240 - timerNumber);
				
				timerNumber --;
				
				if (timerNumber == 0) {
					timerState = 3;
				}
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
				backgroundChangeTime = 100;
			
			audioSection++;
			
			switch (audioSection)
			{
				case 1: 
					currAudio = audio1;
					currMusic.loadEmbedded(currAudio, true);
					currMusic.fadeIn(1);
					break;
				case 2: 
					nextAudio = audio2;
					break;
				case 3: 
					nextAudio = audio3;
					break;
				case 4: 
					nextAudio = audio4;
					break;
				case 5: 
					nextAudio = audio5;
					break;
				case 6: 
					nextAudio = audio6;
					break;
				case 7: 
					nextAudio = audio7;
					break;
				case 8: 
					nextAudio = audio8;
					timerState = 0;
					timerNumber = 120;
					break;
			}
			
			if (audioSection > 1 && audioSection < 9)
			{
				
				nextMusic = new FlxSound();
				nextMusic.loadEmbedded(nextAudio, true);
				
				currMusic.fadeOut(2);
				nextMusic.fadeIn(2);
				
				prevMusic = currMusic;
				
				currAudio = nextAudio;
				currMusic = nextMusic;
				
				audioTime = 60;
			}
			
			trace("Transitions");
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
			
			audioTime = -1;
			audioSection = 0;
			
			prevMusic = new FlxSound();
			currMusic = new FlxSound();
			nextMusic = new FlxSound();
			
			timer = new SimpleTimer(true);
			timerNumber = 0;
			timerState = -1;
			timerText = new FlxText(0, 244, 512);
			timerText.alignment = "center";
			timerText.size = 24;
			timerText.alpha = 0;
			
			add(timerText);
		}
	}

}