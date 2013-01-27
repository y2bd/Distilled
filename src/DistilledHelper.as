package  
{
	
	public class DistilledHelper 
	{
		/**
		 * The background colors we should cycle though.
		 */
		public static var backgroundColors:Array = [0xFF8fdd78, 0xFF69c7b9, 0xFF8388cb, 0xFFc291d9,
													0xFFe18181, 0xFFefbb61, 0xFFe7e253, 0xFF8fdd78];
		
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
		public static function lerpColor (startColor:Number, endColor:Number, position:Number):Number {
			var r1:Number = startColor >> 16 & 0xFF;
			var g1:Number = startColor >> 8  & 0xFF;
			var b1:Number = startColor       & 0xFF;
			
			var r2:Number = endColor >> 16 & 0xFF;
			var g2:Number = endColor >> 8  & 0xFF;
			var b2:Number = endColor       & 0xFF;
			
			var rLerp:Number = Number(DistilledHelper.lerp (r1, r2, position));
			var gLerp:Number = Number(DistilledHelper.lerp (g1, g2, position));
			var bLerp:Number = Number(DistilledHelper.lerp (b1, b2, position));
			
			return (rLerp << 16) | (gLerp << 8) | bLerp;
		}
		
		/**
		 * The <tt>lerpColorWithAlpha</tt> function calculates a specified transtion color between two ARGB colors.
		 * @param	startColor The start ARGB color.
		 * @param	endColor The end ARGB color.
		 * @param	position The position between the two colors to calculate. Must be between 0 and 1.
		 * @return  The lerped color.
		 */
		public static function lerpColorWithAlpha (startColor:Number, endColor:Number, position:Number):Number {
			var a1:Number = startColor >> 24 & 0xFF;
			var r1:Number = startColor >> 16 & 0xFF;
			var g1:Number = startColor >> 8  & 0xFF;
			var b1:Number = startColor       & 0xFF;
			
			var a2:Number = endColor >> 24 & 0xFF;
			var r2:Number = endColor >> 16 & 0xFF;
			var g2:Number = endColor >> 8  & 0xFF;
			var b2:Number = endColor       & 0xFF;
			
			var aLerp:Number = DistilledHelper.lerp (a1, a2, position);
			var rLerp:Number = DistilledHelper.lerp (r1, r2, position);
			var gLerp:Number = DistilledHelper.lerp (g1, g2, position);
			var bLerp:Number = DistilledHelper.lerp (b1, b2, position);
			
			return (aLerp << 24) | (rLerp << 16) | (gLerp << 8) | bLerp;
		}
		
	}

}