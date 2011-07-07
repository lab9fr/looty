/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.3
 */

package org.looty.pool 
{
	import flash.display.*;
	import flash.errors.*;
	import org.looty.utils.*;
	
	public class DisplayObjectPool extends WeakReferencePool
	{
		
		protected var _container			:DisplayObjectContainer
		
		public function DisplayObjectPool(container:DisplayObjectContainer, allocated:uint = 0, keyProp:String = "", keyPropOverwrite:Boolean = true) 
		{
			super (allocated, keyProp, keyPropOverwrite);
			
			_type = DisplayObject;
			
			if (container == null) throw new IllegalOperationError ("org.looty.pool.DisplayObjectPool must have a valid container set in his constructor");
			_container = container;		
		}
		
		override public function set type(value:Class):void 
		{
			if (!ClassUtils.compare(value,DisplayObject))  throw new IllegalOperationError ("org.looty.pool.DisplayObjectPool can handle only DisplayObject type");
			_type = value;
			content.forEach (isType);
		};
		
		public function sortBy (prop:String, options:Object = null):void
		{
			var defined:Array = content.slice();
			defined.sortOn (prop, options);
			
			var lgt:int = defined.length
			
			for (var i:int = 0; i < lgt; i++)
			{
				_container.setChildIndex (defined [i] as DisplayObject, i);
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROTECTED METHODS
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override protected function storeElement (element:*):void
		{
			_container.addChild (element as DisplayObject);
			super.storeElement (element);			
		};
		
		override protected function clearElement (element:*):void
		{
			if (_container.contains(element)) _container.removeChild (element as DisplayObject)
			super.clearElement (element);
		};
		
	}
	
}