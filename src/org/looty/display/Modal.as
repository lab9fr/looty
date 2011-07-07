/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.display 
{
	import flash.utils.getTimer;
	import org.looty.core.display.AbstractModal;
	import org.looty.Looty;
	
	public class Modal extends AbstractModal
	{
		
		private var _started		:int;
		private var _current		:int;
		private var _startValue		:Number;
		private var _endValue		:Number;
		private var _isTweening		:Boolean;
		
		public function Modal(color:uint = 0x000000, alpha:Number = .8) 
		{
			super(color, alpha);
		}
		
		override protected function tweenOpacityTo(value:Number):void 
		{
			
			_startValue = alpha;
			_endValue = value;
			_started = getTimer() - (1 - Math.abs(_endValue - _startValue)) * tweenDuration * 1000;
			Looty.addEnterFrame(render);
		}
		
		override public function render():void
		{			
			_current = (getTimer() - _started);
			
			if (_current > tweenDuration * 1000)
			{
				_isTweening = false;
				alpha = _endValue;
				if (_endValue == 0) clear();
				Looty.removeEnterFrame(render);
				return;
			}
			
			alpha = (_current / (tweenDuration * 1000)) * (_endValue - _startValue) + _startValue;
		}
		
	}

}