package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class FinalImage
	{
		
		[Embed(source="../assets/tree_final.png")]
		public static var Tree:Class;
		
		public function FinalImage()
		{
		
		}
		
		/**
		 * Generates a one dimensional array representing the pixels in the Tree image.
		 * The Array is a queue of sorts: the order represents the order pixels should be attached to
		 * the Particle System object.
		 *
		 * Each element in the array is an array with three parameters:
		 * 0 - The row that pixel is in
		 * 1 - The column that pixel is in
		 * 2 - The color of that pixel
		 * @return The one dimensional array that does the stuff I said in the function description
		 */
		public static function GenerateImagePlacementArray():Array
		{
			var treeImage:Bitmap = new Tree();
			var treeImageData:BitmapData = treeImage.bitmapData;
			
			// the following code generates the spiral pattern we so desperately want
			// it assumes that treeImage is a perfect square of sidelength 64
			// this better be true or so help me I will throw an error
			
			var treeImagePixels:Array = new Array(); // the "queue" we describe above
			
			if (treeImage.width != 64 || treeImage.height != 64)
			{
				throw new DefinitionError("Motherfucker you're using the wrong image!");
			}
			
			var r:int = 31; // the current row we're searching
			var c:int = 32; // the current column we're searching
			
			var amt:uint = 1; // how many pixels we should go before turning
			var moves:uint = 0; // how far we've gone since the last turn
			var turns:uint = 0; // how many turns we've made since the last change of "amt"
			
			var dir:uint = 2; // what direction we're headed
			// 0 = up, 1 = right, 2 = down, 3 = left
			
			while (true)
			{
				// we flip r and c in getPixel because getPixel takes x and y instead 
				// of row and column
				var pixel:Array = [r, c, treeImageData.getPixel(c, r)];
				
				treeImagePixels.push(pixel);
				
				// find out what we're doing based on direction				
				switch (dir)
				{
					case 0: 
						r -= 1;
						break;
					case 1: 
						c += 1;
						break;
					case 2: 
						r += 1;
						break;
					case 3: 
						c -= 1;
						break;
				}
				
				// holy shit did we get out of bounds?
				// dude stop before we throw an error
				if (r >= 64 || r < 0 || c >= 64 || c < 0)
				{					
					break;
				}	
								
				// we went a distance
				moves++;
				
				// have we gone the right amt?
				if (moves >= amt)
				{
					moves = 0;
					turns++;
					
					// let's turn!
					
					dir++;
					if (dir > 3)
						dir = 0;
				}
				
				// if we've turned more than twice, we should
				// increase the walk distance (because it's a spiral)
				if (turns >= 2)
				{
					amt++;
					turns = 0;
				}
			}
						
			// now let's do jason's local shuffle
			// make sure you have relevant music
			
			// what size do you want the localized blocks to be?
			// it should be in powers of 2 because i said so
			const BLOCK_SIZE:uint = 64;
						
			// how much overlap do you want between blocks?
			// bigger overlap means more reshuffling
			const OVERLAP:uint = 64;
						
			// cycle through each block
			for (var i:uint = BLOCK_SIZE / 2; i < treeImagePixels.length - OVERLAP - (BLOCK_SIZE / 2); i += BLOCK_SIZE)
			{
				// generate a random index array becaues my code sucks
				var randArr:Array = FinalImage.randomIndexArray(BLOCK_SIZE + OVERLAP);
				
				// cycle through the block including overlap
				for (var j:uint = 0; j < BLOCK_SIZE + OVERLAP; j++)
				{					
					// swap the random index's value with the current index in cycle 
					var temp:Array = treeImagePixels[i + randArr[j]];
					treeImagePixels[i + randArr[j]] = treeImagePixels[i + j];
					treeImagePixels[i + j] = temp;
				}
				
			}
			
			return treeImagePixels;		
		}
		
		public static function randomIndexArray(size:uint):Array 
		{
			var a:Array = new Array();
			
			for (var i:uint = 0; i < size; i++) {
				a.push(i);
			}
			
			for (var j:uint = 0; j < size; j++) {
				var randPos:uint = (uint) (Math.random() * size);
				
				var temp:uint = a[randPos];
				a[randPos] = a[j];
				a[j] = temp;				
			}
			
			return a;
		}
	
	}

}