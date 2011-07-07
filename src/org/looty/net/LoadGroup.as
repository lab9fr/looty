/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 0.1
 */

package org.looty.net 
{
	import org.looty.data.List;
	import org.looty.core.looty;
	import org.looty.core.net.AbstractLoad;
	import org.looty.sequence.Sequencable;
	
	public class LoadGroup extends Sequencable
	{
		
		private var _content	:List;		
		private var _queue		:List;
		private var _loads		:Array;
		
		public function LoadGroup() 
		{
			clear();
			
			_content = new List();
			_queue = new List();
			_loads = [];
		}
		
		override protected function reset():void 
		{
			super.reset();
			_content = new List();
			_queue = new List();
		}
		
		public function clear():void
		{
			_loads = [];
		}
		
		//TODO : use ILoad
		public function add(load:AbstractLoad):void 
		{			
			_loads[_loads.length] = load;
			load.looty::setExit(checkCompletion);
			if (isProcessing) _queue.add(load);
		}
		
		private function checkCompletion():void
		{
			for each (var load:AbstractLoad in _queue.content)
			{
				switch(true)
				{
					case load.isComplete: 
					_content.add(load);
					case load.isFailed:
					_queue.remove(load);
					break;
				}
			}
			
			if (_queue.content.length == 0) doComplete();
		}
		
		override public function start():Boolean
		{
			if (super.start()) for each(var load:AbstractLoad in _loads) 
			{
				_queue.add(load);
				load.start();
			}
			
			return isProcessing;
		}
		
		public function get content():Array { return _content.content; }
		
		public function get loads():Array { return _loads; }
		
	}
	
}