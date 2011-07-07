/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.utils 
{
	
	public class DateUtils 
	{
		
		public function DateUtils() 
		{
			
		}
		
		static public function secondsToMinute (seconds:Number, format:String = "mm:ss"):String
		{
			var mn:String = String(int (seconds / 60));
			if (mn.length == 1) mn = "0" + mn;
			var sec:String = String(int(seconds % 60));
			if (sec.length == 1) sec = "0" + sec;
			
			format = format.replace("mm", mn);
			format = format.replace("ss", sec);
			
			return format;
		}
		
	}
	
}