/**
 * @project mortelscooter
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @created 21/10/2009 01:52
 * @version 0.1
 */

package org.looty.utils 
{

	public class MathPlus
	{
		
		public function MathPlus() 
		{
			
		}
		
		static public function clamp(value:Number, min:Number, max:Number):Number
		{
			if (value < min) value = min;
			if (value > max) value = max;
			return value;
		}
		
		static public function sign(num:Number):Number { return num >= 0 ? 1 : -1; }
		
	}

}