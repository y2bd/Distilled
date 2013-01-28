package
{
	import flash.utils.getTimer;
	
	public class SimpleTimer
	{		
		private var startTime:Number;
		
		public function SimpleTimer(start:Boolean = false)
		{
			startTime = -1;
			
			if (start) startTimer();
		}
		
		public function startTimer():void
		{
			startTime = getTimer();
		}
		
		public function getElapsedTime():Number
		{
			if (startTime == -1) {
				throw new UninitializedError("getElapsedTime cannot be called before startTimer is called at least once.");
			}
			
			return getTimer() - startTime; 
		}
	
	}

}