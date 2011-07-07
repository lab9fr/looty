/**
 * @project CBa
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @created 08/11/2009 22:01
 * @version 0.1
 */

package org.looty.ui 
{
	import flash.display.*;
	import org.looty.display.*;
	import org.looty.interactive.*;
	import org.looty.utils.*;
	
	//TODO: mouse wheel (also for mac)	

	public class ScrollBar extends Layer implements IUserInterface, IRenderable, IScroller
	{
		
		private var _trackInteraction		:Interaction;
		private var _thumbInteraction		:Interaction;
		
		private var _interactiveTrack		:InteractiveObject;
		private var _interactiveThumb		:InteractiveObject;
		
		private var _onChange					:Function;
		
		private var _ratio					:Number;
		
		private var _gapY					:Number;
		
		private var _thumbY					:Number;
		
		private var _isThumbAutoScale		:Boolean;
		
		private var _isRendering			:Boolean;
		
		
		public function ScrollBar(track:DisplayObject, thumb:DisplayObject) 
		{
			_ratio = 1;
			
			_isThumbAutoScale = true;
			
			if (track is InteractiveObject) _interactiveTrack = InteractiveObject(track);
			else
			{
				_interactiveTrack = new Sprite();
				Sprite(_interactiveTrack).addChild(track);
			}
			
			if (thumb is InteractiveObject) _interactiveThumb = InteractiveObject(thumb);
			else
			{
				_interactiveThumb = new Sprite();
				Sprite(_interactiveThumb).addChild(thumb);
			}
			
			
			_trackInteraction = new Interaction(_interactiveTrack);
			addChild(_interactiveTrack);
			
			_thumbInteraction = new Interaction(_interactiveThumb);
			addChild(_interactiveThumb);
			
			_thumbInteraction.onMouseDown = startScroll;
			_thumbInteraction.onMouseUp = stopScroll;
			_trackInteraction.onMouseDown = scrollTo;
			
			isRendering = false;
		}
		
		public function reset():void
		{
			position = 0;
		}
		
		private function scrollTo():void
		{
			var point:Number = mouseY / _interactiveTrack.height;
			if (isNaN(point)) return;
			position = MathPlus.clamp(point, 0, 1);
		}
		
		private function stopScroll():void
		{
			
			isRendering = false;
		}	
		
		private function startScroll():void
		{
			_gapY = mouseY - _interactiveThumb.y;
			isRendering = true;
		}
		
		public function render():void 
		{
			if (!_isRendering) return;
			thumbY = MathPlus.clamp(mouseY - _gapY, 0, _interactiveTrack.height - _interactiveThumb.height);
			
		}
		
		override public function get height():Number { return _interactiveTrack.height; }
		
		override public function set height(value:Number):void 
		{
			_interactiveTrack.height = value;
			if (_isThumbAutoScale) _interactiveThumb.height = _ratio * value;
			else _interactiveThumb.scaleY = 1;
		}
		
		public function get position():Number { return _interactiveThumb.y / (_interactiveTrack.height - _interactiveThumb.height); }
		
		public function set position(value:Number):void 
		{
			thumbY = (_interactiveTrack.height - _interactiveThumb.height) * value;
		}
		
		public function get ratio():Number { return _ratio; }
		
		public function set ratio(value:Number):void 
		{
			if (value <= 0) return;
			if (value > 1) 
			{
				value = 1;
				visible = false;
			}
			else visible = true;
			
			_ratio = value;
			
			if (_isThumbAutoScale) _interactiveThumb.height = _interactiveTrack.height * value;
			else _interactiveThumb.scaleY = 1;
		}
		
		public function get thumbY():Number { return _thumbY; }
		
		public function set thumbY(value:Number):void 
		{
			_thumbY = value;
			_interactiveThumb.y = value | 0;
			if (Boolean(onChange)) onChange();
		}
		
		public function get isThumbAutoScale():Boolean { return _isThumbAutoScale; }
		
		public function set isThumbAutoScale(value:Boolean):void 
		{
			_isThumbAutoScale = value;
			height = height;
		}
		
		public function get isRendering():Boolean { return _isRendering; }
		
		public function set isRendering(value:Boolean):void 
		{
			_isRendering = value;
		}
		
		public function get onChange():Function { return _onChange; }
		
		public function set onChange(value:Function):void 
		{
			_onChange = value;
		}
		
		
		
	}

}