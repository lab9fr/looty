/**
 * @project Fanta KOTP Park
 * @author Bertrand Larrieu - lab9
 * @mail lab9.fr@gmail.com
 * @timestamp 27/01/2011 12:35
 * @version 0.1
 */

package org.looty.utils 
{
	import flash.utils.getTimer;
	import org.looty.log.Looger;
	import org.looty.Looty;
	
	public class ActionProfiler 
	{
		
		private var _start		:Number;
		
		private var _name		:String;
		
		public function ActionProfiler(name:String="") 
		{
			_name = name;
		}
		
		public function start():void
		{
			_start = getTimer();
		}
		
		public function end():void
		{
			Looger.info(_name + " elapsed time ms : " + (getTimer() - _start));
		}
		
		
		
	}

}