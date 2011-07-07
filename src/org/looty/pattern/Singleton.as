/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.pattern 
{
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
		
	public class Singleton
	{
		
		static private var _allowCreate		:Boolean;
		static private var _instances		:Dictionary;
		
		public function Singleton() 
		{
			if (!_allowCreate) throw new IllegalOperationError ("a Singleton Class can't be directly instancied. Use getInstanceOf method.");			
		}
		
		static protected function getInstanceOf (type:Class):*
		{
			switch (true)
			{
				case _instances == null :
					_instances = new Dictionary ();
					
				case _instances [type] == null :
					_allowCreate		= true;
					_instances [type]	= new type ();
					_allowCreate		= false;				
			}
			
			return _instances [type];
		}
		
	}
	
}