/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.core.display 
{
	import org.looty.display.Updateable;
	import org.looty.interactive.IInteractive;
	
	//FIXME implement new interaction && rendering and resizing
	

	public class AbstractModal extends Updateable implements IInteractive
	{
		
		public var onClose			:Function;
		
		private var _color			:uint;
		private var _alpha			:Number;
		
		public var tweenDuration	:Number;
		
		private var _isOpened		:Boolean;	
		
		public function AbstractModal(color:uint, alpha:Number) 
		{
			_color = color;
			_alpha = alpha;
			
			tweenDuration = .7;
			
			this.alpha = 0;
			
			mouseChildren = false;
		}
		
		public function open():void
		{
			if (_isOpened) return;
			draw(stageWidth, stageHeight);
			_isOpened = true;
			tweenOpacityTo(1);
		}
		
		public function close():void
		{
			if (!_isOpened) return;
			_isOpened = false;
			tweenOpacityTo(0);
			if (Boolean(onClose)) onClose();
		}
		
		protected function tweenOpacityTo(value:Number):void
		{
			//to be overriden through inheritance
		}
		
		protected function clear():void
		{
			graphics.clear();
		}
		
		private function draw(w:int, h:int):void
		{
			graphics.clear()
			graphics.beginFill(_color, _alpha);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
		override public function resize():void
		{
			if (alpha > 0 ) draw(stageWidth, stageHeight);
		}
		
		/* INTERFACE org.looty.interactive.IInteractive */
		
		public function get onOver():Function { return null; }
		
		public function set onOver(value:Function):void	{}
		
		public function get onOut():Function { return null; }
		
		public function set onOut(value:Function):void {}
		
		public function get onDown():Function {	return close; }
		
		public function set onDown(value:Function):void { onClose = value; }
		
		public function get onUp():Function { return null; }
		
		public function set onUp(value:Function):void {}
		
		public function get isDown():Boolean { return false; }
		
		public function set isDown(value:Boolean):void {}		
		
		public function get isOver():Boolean { return false; }
		
		public function set isOver(value:Boolean):void {}	
		
	}

}