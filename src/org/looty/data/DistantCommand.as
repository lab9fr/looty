/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 09/21/2010 11:00
 * @version 0.1
 */

package org.looty.data 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	
	public class DistantCommand extends Command
	{
		
		static private var _commands		:Dictionary;
		
		static private var _allowConstruction	:Boolean;
		
		private var _id		:String;
		
		public function DistantCommand(id:String) 
		{
			if (!_allowConstruction) throw new IllegalOperationError("DistantCommand can't be instantiated directly, use static method getCommand");
			_id = id;
		}
		
		static public function getCommand(id:String):DistantCommand 
		{
			if (_commands == null) _commands = new Dictionary();
			
			if (id == null) throw new IllegalOperationError("id can't be null");
			
			if (_commands[id] == undefined)
			{
				_allowConstruction = true;
				_commands[id] = new DistantCommand(id);
				_allowConstruction = false;
			}
			
			return _commands[id];
		}
		
		static public function clear(id:String):void
		{
			_commands[id] = null;
			delete _commands[id];
		}
		
		public function get id():String { return _id; }
		
	}
	
}