/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 3.0
 * @contributor : pindi
 */

package org.looty.core.pool 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.*;
	import org.looty.pattern.Abstract;	
	import org.looty.pool.Pool;
	import org.looty.utils.ClassUtils;
	
	//TODO: description of the class
	/**
	 * Description
	 */
	public class AbstractPool extends Abstract
	{
		/**
		 * implemented by inheritance.
		 * @private
		 */
		//protected var _pool						
		
		/**
		 * @private
		 */
		protected var _type						:Class;
		
		/**
		 * @private
		 */
		protected var _allocated				:int;
		
		/**
		 * @private
		 */
		private var _hasAllocation				:Boolean;
		
		/**
		 * @private
		 */
		protected var _keyProp					:String;
		
		/**
		 * @private
		 */
		protected var _hasKeyProp				:Boolean;
		
		/**
		 * @private
		 */
		protected var _keyPropOverwrite			:Boolean;
		
		/**
		 * @private
		 */
		protected var _prop						:String;
		
		/**
		 * @private
		 */
		protected var _value					:*;
		
		
		/**
		 * Constructor.
		 * 
		 * @param	allocated An integer that specifies the number of elements allowed in the pool when instancied.
		 * @param	keyProp Defines a specific property being a unique key for all elements stored in the pool.
		 * @param	keyPropOverwrite Specifies behavior when key properties of two elements have the same value. when <code>true</code>, the newly added element replace previously stored. When <code>false</code>, first element stored is ever kept.
		 */
		public function AbstractPool (allocated:uint = 0, keyProp:String = "", keyPropOverwrite:Boolean = true) 
		{
			makeAbstract (AbstractPool);
			
			_allocated 						= allocated
			_hasAllocation					= allocated > 0;
			_keyProp 						= keyProp;
			_hasKeyProp 					= _keyProp != "";
			_keyPropOverwrite 				= keyPropOverwrite;
			_type 							= Object;
			
			initialise ();
		};
		
		/**
		 * Creates an instance of the Pool's type and add it to the Pool.
		 * 
		 * @param	...params Parameters to be used on the constructor.
		 * @return	return the instance created.
		 */
		
		public function create (...params:Array):*
		{
			var instance:* = ClassUtils.createInstanceOf (_type, params)
			addElement (instance);
			return instance;
		}
		
		/**
		 * Checks whether pool contains a specified element.
		 * 
		 * @param	element Element to be checked
		 * @return	<code>true</code> when pool contains element, <code>false</code> otherwise.
		 */
		public function has (element:*):Boolean
		{
			//method to be overriden in inheritance;
			return false
		};
		
		/**
		 * Stores elements in the pool.
		 * 
		 * @param	...elements Elements to be stored in the pool.
		 */
		public function add (...elements:Array):void
		{
			elements.forEach (addElement);			
		};
		
		/**
		 * Removes specified elements from the pool.
		 * 
		 * @param		...elements Elements to be removed from the pool.
		 */
		public function remove (...elements):void
		{
			if ( length == 0 ) return;
			elements.forEach (removeElement);			
		};	
		
		/**
		 * Checks whether pool contains at least one element having a specified property matching a specified value.
		 * 
		 * @param		prop		String		Element's property to be checked.
		 * @param		value		*		Value to be compared to element's property.
		 * @param		propsAndValues		Array		additives properties and values that need verification (prop1, value1, prop2, value2, ...)
		 * @return				Boolean		<code>true</code> if value parameter matches with property's value of at least one of the elements, otherwise false.
		 */
		public function hasByProperty (prop:String, value:*, ...propsAndValues:Array):Boolean
		{
			propsAndValues.unshift(prop, value);
			return getByProperty.apply(this, propsAndValues).length > 0;			
		};	
		
		/**
		 * Collects every elements with a specified property matching a specified value.
		 * 
		 * @param		prop		String		Element's property to be verified.
		 * @param		value		*		Value to be compared to element's property. value can also be a RegExp to be tested on the property.
		 * @param		propsAndValues		Array		additives properties and values that need verification (prop1, value1, prop2, value2, ...)
		 * @return				Array		An Array of elements with prop parameter matching value parameter.
		 */
		public function getByProperty (prop:String, value:*, ...propsAndValues:Array):Array
		{
			_prop = prop;
			_value = value;
			
			var results:Array = content.filter (hasElementProperty);
			
			if (propsAndValues.length > 0)
			{
				if (propsAndValues.length & 1) throw new IllegalOperationError ("org.looty.core.pool.AbstractPool --> getByProperty : the number of arguments has to be even");
				
				while (propsAndValues.length > 0)
				{
					_prop = propsAndValues.shift();
					_value = propsAndValues.shift();
					results = results.filter(hasElementProperty);
				}
			}
			
			return results;
		};
		
		/**
		 * Removes every elements with a specified property matching a specified value.
		 * 
		 * @param		prop		String		Element's property to be checked.
		 * @param		value		*		Value to be compared to element's property.
		 * @param		propsAndValues		Array		additives properties and values that need verification (prop1, value1, prop2, value2, ...)
		 * @return				int		Number of elements removed from the pool.
		 */
		public function removeByProperty(prop:String, value:*, ...propsAndValues:Array):int 
		{
			var num:int = length;
			
			propsAndValues.unshift(prop, value);
			remove.apply(this, getByProperty.apply(this, propsAndValues));
			
			return num - length;
		};
		
		/**
		 * Return elements present in this pool and a specified one.
		 * @param	pool		AbstractPool		other pool with wich compare this pool
		 * @return 				Array		elements present in both pools
		 */
		public function getCommon(pool:AbstractPool):Array
		{
			var results:Array = [];
			var element:* 
			
			for each (element in pool.content) if (has(element)) results.push(element);
			
			return results;
		}
		
		/**
		 * Return only elements present in this pool or a specified one, not elements present in both.
		 * @param	pool		AbstractPool		other pool with wich compare this pool
		 * @return 				Array		elements present in one pool or the other
		 */
		public function getDifference(pool:AbstractPool):Array
		{
			var results:Array = [];
			var element:* 
			
			for each (element in pool.content) if (!has(element)) results.push(element);
			for each (element in content) if (!has(element)) results.push(element);
			
			return results;
		}
		
		/**
		 * defines which type is allowed to be stored in the Pool.
		 * @default	Object
		 * @throws flash.errors.IllegalOperationError content has been stictly typed to <i>type</i> and can't handle <i>type</i>
		 */
		public function get type():Class { return _type; };
		
		/**
		 * @private set pool type
		 */
		public function set type(value:Class):void 
		{
			_type = value;
			content.forEach (isType);
		};
		
		/**
		 * Clear all elements. 
		 */
		public function clear ():void
		{
			//log ("CLEAR", "all");
			for each (var element:* in content)
			{
				removeElement (element);
			}
			initialise ()
		};		
		
		/**
		 * Get an Array of all elements stored in the pool.
		 * 
		 * @return				Array		elements in the pool
		 */
		public function get content ():Array
		{
			//method to be overriden in inheritance 
			return []
		};
		
		/**
		 * get pool length.
		 * 
		 * @return			int		number of elements in the pool.
		 */
		public function get length():int 
		{	 
			return content.length;
		};
		
		protected function get hasAllocation():Boolean { return _hasAllocation; }
		
		/**
		 * Return a string that represents specified pool and stored elements.
		 * 
		 * @return			String		représentation of pool object.
		 */
		public function toString ():String
		{
			var r:String =  "[ " + getQualifiedClassName (this) + " ]" + String.fromCharCode (13); 
			r += "[ type is restricted to " + getQualifiedClassName (_type) + " ]"  + String.fromCharCode (13);
			r += "[ allocated space " + _allocated + " -  current length " + length + " ]"  + String.fromCharCode (13);
			
			var c:Array = content;
			var n:int = c.length;
			
			if (n == 0) return r;
			
			for ( var i:int = 0; i < n ; i++ )
			{
				r += "[ " + i + " " +  c [ i ] + " " + getQualifiedClassName (c [ i ]) + " ] "  + String.fromCharCode (13);
			};
			
			return r;
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROTECTED METHODS
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function initialise ():void
		{
			//method to be overriden in inheritance;			
		};
		
		/**
		 * @private
		 */
		protected function storeElement (element:*):void
		{
			//method to be overriden in inheritance 
		};
		
		/**
		 * @private
		 */
		protected function clearElement (element:*):void
		{
			//method to be overriden in inheritance 
		};
		
		/**
		 * @private
		 */
		protected function isType (element:*, index:int = 0, arr:Array = null):void 
		{
			if (!(element is _type) || !isDefined (element)) throw new IllegalOperationError ( getQualifiedClassName (this) + " content has been stictly typed to \'" +  getQualifiedClassName(_type) + "\' and can't handle \'" + getQualifiedClassName(element) +"\'");           
        };
		
		/**
		 * @private
		 */
		protected function isDefined (element:*, index:int = 0, arr:Array = null):Boolean
		{
			return element != undefined && element != null;
		};
		
		/**
		 * @private
		 */
		protected function addElement (element:*, index:int = 0, arr:Array = null):void
		{
			isType (element);
			if (has (element)) return;
			
			if ( _hasKeyProp )
			{
				if ( element [_keyProp] == null ) throw new IllegalOperationError ( element + " has no value for the key property \'" + _keyProp + "\'" );          
				
				if (hasByProperty (_keyProp, element [_keyProp]))
				{
					if (_keyPropOverwrite) removeByProperty (_keyProp, element [_keyProp]);
					else return;
				};					
			};
			
			storeElement (element);			
		};
		
		/**
		 * @private
		 */
		protected function removeElement (element:*, index:int = 0, arr:Array = null):void
		{
			isType (element);
			
			if (has(element)) clearElement (element);
			
			if (has(element)) removeElement (element);			
		};
		
		/**
		 * @private
		 */
		protected function hasElementProperty (element:*, index:int = 0, arr:Array = null):Boolean
		{
			switch(true)
			{
				case _value is RegExp :
				return RegExp(_value).test(element[_prop]);
				break;
				
				default:
				return element [ _prop ] == _value;
			}
		};
		
	};
	
};