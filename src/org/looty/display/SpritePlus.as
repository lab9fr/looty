/**
 * @project looty
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @version 1.0
 */

package org.looty.display 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class SpritePlus extends Sprite
	{
		
		public function SpritePlus() 
		{
			
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			if (child == null || !contains(child)) return null;
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			if (child == null || !contains(child)) return null;
			return super.removeChildAt(index);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			if (!hasEventListener(type)) return;
			super.removeEventListener(type, listener, useCapture);
		}
		
	}
	
}