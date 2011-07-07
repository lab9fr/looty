/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.3
 */

package org.looty.pool 
{
	import flash.errors.*;
	import org.looty.utils.*;
	
	public class MethodPool extends WeakReferencePool
	{
		
		protected var _arguments			:Array
		protected var _results				:Array
		
		/**
		 * Constructor.
		 * 
		 * @param	allocated		int		An integer that specifies the number of elements allowed in the pool when instancied.
		 */
		public function MethodPool ( allocated:uint = 0 ) 
		{
			super ( allocated )
			_type = Function;
		}		
		
		/**
		 * execute all methods in the MethodPool. also, clean null methods. 
		 * 
		 * @param		args				arguments to apply to the notified methods.
		 * @return			Array		elements returned by notified methods in an Array.
		 */
		public function execute (... args):Array
		{
			if ( length == 0 ) return null;
			
			removeElement (null);
			
			_arguments 		= args
			_results		= content.map (executeMethod)
			
			_results.filter (isDefined)
			
			return _results
		}
		
		override public function set type(value:Class):void 
		{
			if (!ClassUtils.compare(value, Function)) throw new IllegalOperationError ("org.looty.pool.MethodPool can handle only Function type");
			_type = value;
			content.forEach (isType);
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROTECTED METHODS
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		protected function executeMethod (method:Function, index:int, array:Array):*
		{
			return method.apply (this, _arguments)
		}
		
	}
	
}