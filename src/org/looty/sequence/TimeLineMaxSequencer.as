/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/01/2010 03:29
 * @version 0.1
 */

package org.looty.sequence 
{
	import com.greensock.TimelineMax;
	import org.looty.core.sequence.AbstractASynchrone;
	import org.looty.core.looty;
	
	public class TimeLineMaxSequencer extends TimelineMax
	{
		
		private var _selection			:Sequencable;
		private var _unselection		:Sequencable;
		
		public var selectionTimeScale	:Number;
		public var unselectionTimeScale	:Number;
		
		public function TimeLineMaxSequencer(vars:Object = null) 
		{
			super(vars);
			
			selectionTimeScale = 1;
			unselectionTimeScale = 1.4;
			
			_selection = new Sequencable();
			_selection.name = "TimeLineMax selection #" + (Math.random() * 1000000).toString(36);
			_unselection = new Sequencable();
			_unselection.name = "TimeLineMax unselection #" + (Math.random() * 1000000).toString(36);
			
			this.vars.onComplete = _selection.complete;
			this.vars.onReverseComplete = _unselection.complete;		
			
			_selection.setEntry(select);
			_unselection.setEntry(unselect);		
			
			_selection.onCancel = pause;
			_unselection.onCancel = pause;
			//trace(_unselection.id, _unselection.onCancel);
		}
		
		private function select():void
		{
			timeScale = selectionTimeScale;
			if (isNaN(currentProgress) || currentProgress == 1) _selection.complete();
			else play();
		}
		
		override public function pause():void 
		{
			super.pause();
		}
		
		private function unselect():void
		{
			timeScale = unselectionTimeScale;
			
			if (isNaN(currentProgress) || currentProgress == 0) _unselection.complete();
			else 
			{
				reverse();
			}
		}
		
		public function get selection():Sequencable { return _selection; }
		
		public function get unselection():Sequencable { return _unselection; }
		
		
	}
	
}