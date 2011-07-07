/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 15/01/2010 00:08
 * @version 0.1
 */

package org.looty.sequence 
{
	import org.looty.core.sequence.AbstractASynchrone;	
	import org.looty.core.looty;
	
	use namespace looty;
	
	public class Sequencable extends AbstractASynchrone implements IASynchrone
	{
		
		private var _smoother			:ProgressSmoother;
		
		public function Sequencable() 
		{
			
		}
		
		override protected function doProgress():void 
		{
			super.doProgress();
			if (_smoother != null) _smoother.render();
		}
		
		override looty function setProgress(value:Number):void
		{
			if (_smoother != null) _smoother.setTarget(value);
			super.looty::setProgress(value);
		}
		
		override public function get progress():Number { return _smoother != null ? _smoother.progress : super.progress; }
		
		override protected function doComplete():void 
		{
			if (_smoother == null) super.doComplete();
			else if (_smoother.isComplete) super.doComplete();
			else 
			{
				_smoother.allowComplete = true;
				setProgress(1);
			}
		}
		
		override public function start():Boolean 
		{
			if (_smoother != null) _smoother.start();
			
			return super.start();	
		}
		
		public function get smoother():ProgressSmoother { return _smoother; }
		
		public function set smoother(value:ProgressSmoother):void 
		{
			if (_smoother != null && value == null) _smoother.doComplete = null;
			_smoother = value;
			if (_smoother != null) _smoother.doComplete = doComplete;
		}
		
		override public function dispose():void 
		{
			super.dispose();			
			smoother = null;
		}
		
	}
	
}