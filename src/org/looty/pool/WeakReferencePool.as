/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.5
 */

package org.looty.pool 
{
	import flash.utils.*;
	import org.looty.log.*;
	import org.looty.core.pool.*;
	
	
	/**
	 * Lets you create a collection of elements with a weak reference.
	 */
	public class WeakReferencePool extends AbstractPool
	{
		/**
		 * @private
		 */
		protected var _pool						:Dictionary;
		
		/**
		 * Lets you create a collection of elements with a weak reference.
		 * 
		 * @param	allocated An integer that specifies the number of elements allowed in the pool when instancied.
		 * @param	keyProp Defines a specific property being a unique key for all elements stored in the pool.
		 * @param	keyPropOverwrite Specifies behavior when key properties of two elements have the same value. when <code>true</code>, the newly added element replace previously stored. When <code>false</code>, first element stored is ever kept.
		 */
		public function WeakReferencePool(allocated:uint = 0, keyProp:String = "", keyPropOverwrite:Boolean = true) 
		{
			super (allocated, keyProp, keyPropOverwrite);			
		};
		
		/**
		 * Checks whether pool contains a specified element.
		 * 
		 * @param	element Element to be checked
		 * @return	<code>true</code> when pool contains element, <code>false</code> otherwise.
		 */
		override public function has (element:*):Boolean
		{
			return _pool[element] == true;
		};
		
		/**
		 * Get an Array of all elements stored in the pool.
		 * 
		 * @return				Array		elements in the pool
		 */
		override public function get content ():Array
		{
			var result:Array = new Array();			
			for (var element:* in _pool) result.push (element);
			return result;
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROTECTED METHODS
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function initialise ():void
		{
			_pool = new Dictionary (true);
		};
		
		/**
		 * @private
		 */
		override protected function storeElement (element:*):void
		{
			_pool [ element ] = true;
		};
		
		/**
		 * @private
		 */
		override protected function clearElement (element:*):void
		{
			if (_pool [ element ] != true)  Looger.warn ("'" + element + "' isn't in the Pool" )
			else delete _pool [ element ];			
		};
		
	};
	
};