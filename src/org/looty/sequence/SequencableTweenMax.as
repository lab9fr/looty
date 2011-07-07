/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.sequence 
{
	import com.greensock.TweenMax;
	
	public class SequencableTweenMax extends Sequencable
	{
		
		private var _target		:Object;
		private var _duration 	:Number;
		private var _vars		:Object;
		
		public function SequencableTweenMax($target:Object, $duration:Number, $vars:Object) 
		{
			_target = $target;
			_duration = $duration;
			_vars = $vars;
			
			setEntry(createTween)
			if (_vars.onComplete != null) this.onComplete = _vars.onComplete;
			_vars.onComplete = doComplete;
		}
		
		private function createTween():void
		{
			new TweenMax(_target, _duration, _vars);
		}
		
	}
	
}