package  
{
	
	public class DistilledHelper 
	{
		/**
		 * The background colors we should cycle though.
		 */
		public static const BG_COLORS:Array = [0x8fdd78, 0x69c7b9, 0x8388cb, 0xc291d9,
											   0xe18181, 0xefbb61, 0xe7e253, 0x8fdd78];
		
		/**
		 * The <tt>lerp</tt> function calculates a specified position between two Numbers.
		 * @param	start The number which we start the distance calculation from.
		 * @param	end The number which we end the distance calculation from.
		 * @param	position The position between the two numbers to calculate. Must be between 0 and 1.
		 * @return  The lerped number.
		 */
		public static function lerp (start:Number, end:Number, position:Number):Number {
			if (position < 0 || position > 1) {
				throw new ArgumentError("Parameter 'position' must be between 0 and 1, inclusive.");
			}
			
			var distance:Number = end - start;
			
			return start + (distance * position);			
		}
		
		/**
		 * The <tt>lerpColor</tt> function calculates a specified transtion color between two RGB colors.
		 * @param	startColor The start RGB color.
		 * @param	endColor The end RGB color.
		 * @param	position The position between the two colors to calculate. Must be between 0 and 1.
		 * @return  The lerped color.
		 */
		public static function lerpColor (startColor:uint, endColor:uint, position:Number):uint {
			var r1:uint = startColor >> 16 & 0xFF;
			var g1:uint = startColor >> 8  & 0xFF;
			var b1:uint = startColor       & 0xFF;
			
			var r2:uint = endColor >> 16 & 0xFF;
			var g2:uint = endColor >> 8  & 0xFF;
			var b2:uint = endColor       & 0xFF;
			
			var rLerp:uint = uint(DistilledHelper.lerp (r1, r2, position));
			var gLerp:uint = uint(DistilledHelper.lerp (g1, g2, position));
			var bLerp:uint = uint(DistilledHelper.lerp (b1, b2, position));
			
			return (rLerp << 16) | (gLerp << 8) | bLerp;
		}
		
	}

}