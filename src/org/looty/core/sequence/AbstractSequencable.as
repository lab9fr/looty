/**
 * Copyright © 2009-2010 lab9
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.1
 */

package org.looty.core.sequence 
{
	import flash.utils.getQualifiedClassName;
	import org.looty.core.disposable.IDisposable;
	import org.looty.log.Looger;
	
	import org.looty.core.looty;
	import org.looty.pattern.Abstract;
	
	use namespace looty;
	
	public class AbstractSequencable extends Abstract implements IDisposable
	{
		
		private var _onEntry				:Function;
		private var _onExit					:Function;	
		
		private var _state					:uint;		
		public var name						:String;
		
		static internal const STANDBY		:uint = 0;
		static internal const ENTERED		:uint = 1;
		static internal const EXITED		:uint = 2;
		
		public function AbstractSequencable() 
		{			
			name = getQualifiedClassName(this);
			
			makeAbstract(AbstractSequencable);
		}
		
		public function setEntry(value:Function):void 
		{
			_onEntry = value;
		}
		
		looty function entry():void
		{
			if (!start()) looty::exit();			
		}
		
		public function start():Boolean
		{
			switch(state)
			{
				case ENTERED:
				Looger.warn(name + " currently processing");
				return false;
				break;				
			}
			
			_state = ENTERED;			
			if (Boolean(_onEntry)) _onEntry();
			
			return true;
		}
		
		looty function reset():void
		{
			_state = STANDBY;
		}
		
		public function complete():void
		{
			_state = EXITED;
		}
		
		looty function exit():void 
		{
			_state = EXITED;
			if (Boolean(_onExit)) _onExit();
		}
		
		looty function setExit(value:Function):void
		{
			_onExit = value;
		}
		
		/**
		 * <code>true</code> when process has started until completion.
		 */
		public function get isProcessing():Boolean { return _state == ENTERED; }
		
		internal function get state():uint { return _state; }
		
		public function dispose():void
		{
			//
		}
		
		public function toString():String
		{
			return "[ " + name + " ]" + _state;
		}
		
	}
	
}