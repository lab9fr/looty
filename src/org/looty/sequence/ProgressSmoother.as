/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/03/2010 23:00
 * @version 0.1
 */

package org.looty.sequence 
{
	import org.looty.core.disposable.IDisposable;
	import org.looty.core.looty;
	
	use namespace looty;
	
	public class ProgressSmoother
	{
		
		private var _smoothing		:Number;
		private var _delta			:Number;
		private var _target			:Number;
		private var _smoothed		:Number; 
		private var _progress		:Number; 
		
		internal var doComplete		:Function;
		internal var isComplete		:Boolean;
		internal var allowComplete	:Boolean;
		
		public function ProgressSmoother(smoothing:Number = .1, delta:Number = .05) 
		{
			switch(true)
			{
				case isNaN(smoothing):
				case smoothing <= 0 :
				case smoothing > 1 :
				_smoothing = 1;
				break;
				
				default:
				_smoothing = smoothing;
			}
			
			switch(true)
			{
				case isNaN(delta):
				case delta <= 0 :
				case delta > 1 :
				_delta = .1;
				break;
				
				default:
				_delta = delta;
			}
			
		}
		
		internal function start():void
		{
			_target = 0;
			_progress = 0;
			_smoothed = 0;
			isComplete = false;
			allowComplete = false;
		}
		
		internal function setTarget(value:Number):void
		{
			switch(true)
			{
				case isNaN(value):
				case value < 0:
				_target = 0;
				break;
				
				case value > 1:
				_target = 1;
				break;
				
				default:
				_target = value;				
			}
		}
		
		internal function render():void
		{
			_smoothed += (_target - _smoothed) * _smoothing;
			_progress = _smoothed + _delta;
			if (_progress > 1) _progress = 1;
			
			if (allowComplete && !isComplete &&  _target == 1 && _progress == 1)
			{
				_progress = 1;
				isComplete = true;
				doComplete();
			}
		}
		
		public function get progress():Number { return _progress; }
		
	}
	
}