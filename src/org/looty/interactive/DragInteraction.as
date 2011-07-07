/**
 * @project Editor
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 09/12/2010 16:10
 * @version 0.1
 */

package org.looty.interactive 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.log.Looger;
	import org.looty.Looty;
	import org.looty.utils.MathPlus;
	
	use namespace looty;
	
	public class DragInteraction extends Interaction
	{
		
		private var _offsets		:Dictionary;
		
		private var _rectangle		:Rectangle;
		
		private var _normal			:Point;
		
		private var _onMove			:Function;
		
		private var _isDragEnabled	:Boolean;			
		private var _isDragging		:Boolean;
		
		public function DragInteraction(target:InteractiveObject, rectangle:Rectangle = null) 
		{
			super(target);
			
			_rectangle = rectangle;
			
			_offsets = new Dictionary(true);
			
			_isDragEnabled = true;
			
			if (_rectangle != null) _normal = new Point();
		}
		
		override public function mouseDown():void 
		{
			super.mouseDown();
			if (_isDragEnabled) startDrag();
		}
		
		override public function mouseUp():void 
		{
			super.mouseUp();
			if (_isDragging) stopDrag();
		}
		
		private function startDrag():void
		{
			_isDragging = true;		
			
			for (var target:* in looty::targets) _offsets[target] = new Point(target.mouseX * target.scaleX, target.mouseY * target.scaleY);
			
			Looty.addMouseMove(move);
		}
		
		private function stopDrag():void
		{
			_isDragging = false;
			
			Looty.removeMouseMove(move);
		}
		
		public function move():void 
		{
			var point:Point;
			var target:*;
			
			for (target in looty::targets) 
			{
				point = _offsets[target];
				target.x += target.mouseX * target.scaleX - point.x;
				target.y += target.mouseY * target.scaleY - point.y;
				
				if (_rectangle != null)
				{
					target.x = MathPlus.clamp(target.x, _rectangle.x, _rectangle.x + _rectangle.width);
					target.y = MathPlus.clamp(target.y, _rectangle.y, _rectangle.y + _rectangle.height);
				}
			}
			
			if (_normal)
			{
				_normal.x = (this.target.x - _rectangle.x) / _rectangle.width;
				_normal.y = (this.target.y - _rectangle.y) / _rectangle.height;	
			}
			
			if (_onMove != null) _onMove();
		}
		
		
		public function get normal():Point { return _normal; }
		
		public function get onMove():Function { return _onMove; }
		
		public function set onMove(value:Function):void 
		{
			_onMove = value;
		}
		
		public function modifyNormal(x:Number, y:Number):void
		{
			if (!_normal)
			{
				Looger.error("null rectangle on contruction, no normal");
				return;
			}
			
			_normal.x = MathPlus.clamp(_normal.x + x, 0, 1) || 0;
			_normal.y = MathPlus.clamp(_normal.y + y, 0, 1) || 0;
			
			target.x = _rectangle.x + _normal.x * _rectangle.width;
			target.y = _rectangle.y + _normal.y * _rectangle.height;
			
			if (_onMove != null) _onMove();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			_offsets = null;
			_rectangle = null;
			_normal = null;
		}
		
		public function get rectangle():Rectangle { return _rectangle; }		
		
		public function set rectangle(value:Rectangle):void 
		{
			_rectangle = value;
		}
		
		public function get isDragEnabled():Boolean { return _isDragEnabled; }
		
		public function set isDragEnabled(value:Boolean):void 
		{
			_isDragEnabled = value;
		}
		
		public function get isDragging():Boolean { return _isDragging; }
		
	}

}