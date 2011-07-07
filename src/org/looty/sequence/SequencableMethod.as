/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 03/02/2010 18:20
 * @version 0.1
 */

package org.looty.sequence 
{
	
	public class SequencableMethod extends Sequencable
	{
		
		private var _method		:Function;
		
		public function SequencableMethod(method:Function) 
		{
			_method = method;
			setEntry(execute);
		}
		
		private function execute():void
		{
			if (Boolean(_method)) _method();
			doComplete();
		}
		
		public function get method():Function { return _method; }
		
		public function set method(value:Function):void 
		{
			_method = value;
		}
		
	}
	
}