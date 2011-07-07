/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 27/05/2010 18:33
 * @version 0.1
 */

package org.looty.core.core 
{
	import flash.utils.getTimer;
	
	//TODO : change package and move
	
	public class DelayedCall 
	{
		
		private var _triggerAt		:Number;	
		private var _callback		:Function;
		private var _params			:Array;		
		
		public function DelayedCall(delay:Number, callback:Function, params:Array) 
		{
			_triggerAt = getTimer() + delay;
			_callback = callback;
			_params = params;
		}
		
		public function execute():void
		{
			_callback.apply(this, _params);
		}
		
		public function get triggerAt():Number { return _triggerAt; }
		
		public function get callback():Function { return _callback; }
		
	}
	
}