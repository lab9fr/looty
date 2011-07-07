/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 12/12/2009 09:33
 * @version 0.1
 */

package org.looty.data 
{
	import flash.utils.Dictionary;
	import org.looty.core.disposable.IDisposable;
	
	public class List implements IDisposable
	{
		
		private var _dictionnary		:Dictionary;
		
		private var _weakReference		:Boolean;
		
		public function List(weakReference:Boolean = true) 
		{
			_weakReference = weakReference;
			_dictionnary = new Dictionary(_weakReference);
		}
		
		public function add(element:*):void
		{
			if (element != null) _dictionnary[element] = true;
		}
		
		public function remove(element:*):void
		{
			_dictionnary[element] = null;
			delete _dictionnary[element];
		}
		
		public function clear():void
		{
			_dictionnary = new Dictionary(_weakReference);
		}
		
		public function has(element:*):Boolean { return _dictionnary[element] == true; }
		
		public function get content():Array
		{
			var elements:Array = [];
			for (var element:* in _dictionnary) elements[elements.length] = element;
			return elements;
		}
		
		public function forEach(method:Function):void
		{
			for (var element:* in _dictionnary) method(element);
		}
		
		public function dispose():void
		{
			for (var prop:String in _dictionnary) delete _dictionnary[prop];
			_dictionnary = null;
		}
		
	}
	
}