/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.display 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import org.looty.core.looty;
	import org.looty.ui.IUserInterface;
	
	use namespace looty;

	public class EncapsulatedLayer extends Layer
	{
		
		looty var encapsulated		:Layer;
		
		public function EncapsulatedLayer(container:DisplayObjectContainer = null) 
		{
			looty::encapsulated = new Layer();
			
			if (container != null)
			{
				super.addChild(container);
				container.addChild(looty::encapsulated);
			}
			else super.addChild(looty::encapsulated);
		}
		
		looty function addChildToContainer(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			return looty::encapsulated.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			return looty::encapsulated.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			return looty::encapsulated.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			return looty::encapsulated.removeChildAt(index);
		}
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void 
		{
			looty::encapsulated.swapChildren(child1, child2);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void 
		{
			looty::encapsulated.swapChildrenAt(index1, index2);
		}
		
		override public function contains(child:DisplayObject):Boolean 
		{
			return looty::encapsulated.contains(child);
		}
		
		override public function getChildAt(index:int):DisplayObject 
		{
			return looty::encapsulated.getChildAt(index);
		}
		
		override public function getChildByName(name:String):DisplayObject 
		{
			return looty::encapsulated.getChildByName(name);
		}
		
		override public function getChildIndex(child:DisplayObject):int 
		{
			return looty::encapsulated.getChildIndex(child);
		}
		
		override public function get numChildren():int { return looty::encapsulated.numChildren; }
		
		protected function get encapsulated():Layer 
		{
			return looty::encapsulated; 
		}
		
	}

}