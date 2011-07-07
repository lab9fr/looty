/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.5
 */

package org.looty.pool 
{
	import org.looty.log.*;
	import org.looty.core.pool.*;
	
	/**
	 * Lets you create a collection of elements.
	 * 
	 */
	public class Pool extends AbstractPool
	{
		/**
		 * @private
		 */
		protected var _pool					:Array;
		
		/**
		 * Lets you create a <code>Pool</code> of the specified number of elements 
		 * 
		 * @param	allocated An integer that specifies the number of elements allowed in the pool when instancied.
		 * @param	keyProp Defines a specific property being a unique key for all elements stored in the pool.
		 * @param	keyPropOverwrite Specifies behavior when key properties of two elements have the same value. when <code>true</code>, the newly added element replace previously stored. When <code>false</code>, first element stored is ever kept.
		 */
		public function Pool(allocated:uint = 0, keyProp:String = "", keyPropOverwrite:Boolean = true) 
		{
			super (allocated, keyProp, keyPropOverwrite);			
		};
		
		/**
		 * Checks whether <code>Pool</code> contains a specified element.
		 * 
		 * @param	element Element to be checked
		 * @return	<code>true</code> when pool contains element, <code>false</code> otherwise.
		 */
		override public function has (element:*):Boolean
		{
			return _pool.indexOf (element) != -1;
		};
		
		/**
		 * Get an Array of all elements stored in the pool.
		 * 
		 * @return				Array		elements in the pool
		 */
		override public function get content ():Array
		{
			return _pool.filter (isDefined);
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROTECTED METHODS
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override protected function initialise ():void
		{
			_pool = new Array (_allocated);
		};
		
		/**
		 * @private
		 */
		override protected function storeElement (element:*):void
		{
			var index:int = _pool.indexOf (undefined);
			
			if (index == -1) 
			{
				if (hasAllocation) Looger.warn ("Pool allocated space overflowed");
				index = _pool.length
			}
			
			_pool [ index ] = element
		};
		
		/**
		 * @private
		 */
		override protected function clearElement (element:*):void
		{
			var index:int = _pool.indexOf (element);
			
			if (index == -1) Looger.warn ("'" + element + "' isn't in the Pool")
			else _pool [ index ] = undefined;			
		};
		
	};
	
};