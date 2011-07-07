/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 12/12/2009 09:12
 * @version 0.1
 */

package org.looty.data 
{
	import flash.utils.Dictionary;
	import org.looty.core.disposable.IDisposable;
	
	public class MethodList implements IDisposable
	{
		
		private var _dictionnary		:Dictionary;
		
		public function MethodList() 
		{
			clear();
		}
		
		public function add(method:Function):void
		{
			if (Boolean(method)) _dictionnary[method] = true;
		}
		
		public function remove(method:Function):void
		{
			_dictionnary[method] = null;
			delete _dictionnary[method];
		}
		
		public function has(method:Function):Boolean
		{
			return _dictionnary[method];
		}
		
		public function clear():void
		{
			_dictionnary = new Dictionary();
		}
		
		public function call():void
		{
			for (var method:* in _dictionnary) if (Boolean(method)) method();
		}
		
		public function dispose():void
		{
			for (var prop:String in _dictionnary) delete _dictionnary[prop];
			_dictionnary = null;
		}
		
	}
	
}