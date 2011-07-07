/**
 * @project Editor
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 16/12/2010 17:59
 * @version 0.1
 */

package org.looty.ui 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	//TODO horizontal axis
	
	public class MouseScroller implements IScroller
	{
		
		private var _width		:Number;
		private var _height		:Number;
		private var _ratio		:Number;
		private var _position	:Number;
		private var _isChanged	:Boolean;
		private var _onChange	:Function;
		
		private var _margin		:Number;	
		
		private var _mouseReference	:DisplayObject;
		
		private var _isRendering:Boolean;
		
		public function MouseScroller(mouseReference:DisplayObject, margin:Number = 5) 
		{
			_mouseReference = mouseReference;
			_width = 0;
			_height = 0;
			_margin = margin;
			
			_mouseReference.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			_mouseReference.addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		private function rollOver(e:MouseEvent):void 
		{
			_isRendering = true;
		}
		
		private function rollOut(e:MouseEvent):void 
		{
			_isRendering = false;
		}
		
		/* INTERFACE org.looty.ui.IScroller */
		
		public function set width(value:Number):void 
		{
			_width = value
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set ratio(value:Number):void 
		{
			trace("RATIO", value)
			switch(value)
			{
				case value < 0:
				case value >= 1:
				_ratio = 1;
				setPosition(0);
				break;
				
				default:
				_ratio = value;
			}
			
		}
		
		public function get ratio():Number 
		{
			return _ratio;
		}
		
		private function setPosition(value:Number):void
		{
			switch(true)
			{
				case isNaN(value): 
				case value < 0 : 
				value = 0; 
				break;
				
				case value > 1 : 
				value = 1; 
				break;				
			}
			
			if (_position == value) return;
			
			_position = value;
			_isChanged = true;
		}
		
		public function get position():Number 
		{
			return _position;
		}
		
		public function get onChange():Function 
		{
			return _onChange;
		}
		
		public function set onChange(value:Function):void 
		{
			_onChange = value;
		}
		
		public function get isRendering():Boolean { return _isRendering; }
		
		public function get margin():Number { return _margin; }
		
		public function set margin(value:Number):void 
		{
			_margin = value;
		}
		
		public function reset():void 
		{
			setPosition(0);
		}
		
		public function render():void 
		{
			if (_isRendering && _ratio < 1) setPosition((_mouseReference.mouseY - _margin) / (_height - 2 * _margin));
			
			if (_isChanged)
			{
				onChange();
				_isChanged = false;
			}
		}
		
	}

}