/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 09/20/2010 20:08
 * @version 0.1
 */

package org.looty.data 
{
	import flash.utils.Dictionary;
	import org.looty.log.Looger;
	
	
	public class Command
	{
		
		private var _closures				:Dictionary;	
		
		public function Command() 
		{
			_closures = new Dictionary();
		}
		
		
		public function register(key:String, closure:Function):void
		{			
			if (_closures[key] != undefined) Looger.warn("command '" + key + "' already registered");
			else _closures[key] = closure;
		}
		
		public function unregister(key:String):void
		{
			_closures[key] = null;
			delete _closures[key];
		}
		
		public function execute(key:String, ... args:Array):*
		{
			if (_closures == null || _closures[key] == undefined || _closures[key] == null) return null;
			return _closures[key].apply(this, args);
		}
		
		public function has(key:String):Boolean { return _closures[key] != null && _closures[key] != undefined; }
		
	}
	
}