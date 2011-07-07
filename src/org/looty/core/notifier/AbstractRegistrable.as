/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 4.0
 */

package org.looty.core.notifier 
{
	import flash.errors.IllegalOperationError;
	import org.looty.pattern.Abstract;
	
	public class AbstractRegistrable extends Abstract implements IRegistrable
	{
		
		private var _regKey		:String;
		
		public function AbstractRegistrable(regKey:String) 
		{
			makeAbstract(AbstractRegistrable);
			
			if (regKey == "undefined") throw new IllegalOperationError("wrong regKey in org.looty.core.notifier.AbstractRegistrable");
			
			_regKey = regKey;
		}
		
		public function isRegistrable():Boolean { return _regKey.length > 0; }
		
		public function get regKey():String { return _regKey; }
		
	}
	
}