/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 22/04/2010 15:49
 * @version 0.1
 */

package org.looty.mvc.view 
{
	import org.looty.sequence.TimeLineMaxSequencer;
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	
	public class TimelineMediator extends Mediator
	{
		
		private var _timeline		:TimeLineMaxSequencer;	
		
		public function TimelineMediator() 
		{
			_timeline = new TimeLineMaxSequencer();
			selection.append(_timeline.selection);
			unselection.append(_timeline.unselection);
		}
		
		override public function construct():void
		{
			component.alpha = 0;
			timeline.append(new TweenMax(component, 1, { alpha : 1, ease:Quad.easeOut } ));			
		}
		/*
		override public function destruct():void
		{
			
		}	
		*/
		public function get timeline():TimeLineMaxSequencer { return _timeline; }
		
	}
	
}