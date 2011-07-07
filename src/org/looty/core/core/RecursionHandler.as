/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 04/03/2010 23:12
 * @version 0.1
 */

package org.looty.core.core 
{
	import flash.utils.Dictionary;
	import org.looty.Looty;
	
	public class RecursionHandler 
	{
		
		private var _recursions				:uint;	
		static private const MAX_RECURSIONS	:uint = 10000;
		
		static private var _methods			:Array;
		static private var _handlers		:Dictionary;
		static private var _isRendering		:Boolean;
		
		
		public function RecursionHandler() 
		{
			if (!_isRendering) 
			{
				Looty.addEnterFrame(render);
				_isRendering = true;
			}
			_recursions = 0;
		}		
		
		static public function create(type:String):RecursionHandler
		{
			if (_handlers == null) 
			{
				_handlers = new Dictionary();
				_methods = [];
			}
			if (_handlers[type] == null) _handlers[type] = new RecursionHandler();
			return _handlers[type];
		}
		
		public function test():Boolean
		{
			++_recursions;
			return _recursions < MAX_RECURSIONS;
		}
		
		public function store(method:Function):void
		{
			_methods.push(method);
		}
		
		internal function reset():void
		{
			_recursions = 0;
		}
		
		static private function render():void
		{
			var executions:Array = _methods.slice();
			_methods = [];
			for each (var handler:RecursionHandler in _handlers) handler.reset();
			for each (var method:Function in executions) method();	
		}
		
	}
	
}