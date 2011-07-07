/**
 * @project CBa
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @created 09/11/2009 18:25
 * @version 0.1
 */

package org.looty.ui 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import org.looty.core.looty;
	import org.looty.display.EncapsulatedLayer;
	import org.looty.Looty;
	
	use namespace looty;
	
	//TODO : refactor Hscroll and Vscroll / width height...

	public class ScrollPane extends EncapsulatedLayer implements IUserInterface
	{
		
		private var _scroller			:IScroller;
		
		private var _blur				:BlurFilter;
		private var _motionBlur			:Number;
		private var _blurY				:Number;
		
		private var _objectiveY			:int;
		
		private var _scrollRect			:Rectangle;
		
		private var _difY				:Number;
		
		private var _pane				:Sprite;
		
		private var _isMoving			:Boolean;
		
		private var _background			:Bitmap;
		
		public function ScrollPane(width:uint = 100, height:uint = 100, motionBlur:Number = 1 ) 
		{
			_pane = new Sprite();
			_background = new Bitmap(new BitmapData(100, 100, true, 0x00000000));
			looty::addChildToContainer(_background);
			
			super(_pane);		
			
			_scrollRect = new Rectangle(0, 0, 0, 0);
			
			this.width = width;
			this.height = height;
			this.motionBlur = motionBlur;			
			
			reset();
		}
		
		public function get scroller():IScroller { return _scroller; }
		
		public function set scroller(value:IScroller):void 
		{
			if (_scroller == value) return;
			
			if (_scroller != null)
			{
				_scroller.onChange = null;
			}
			
			_scroller = value;
			
			_scroller.onChange = scroll;
		}
		
		public function reset():void
		{
			_objectiveY = 0;
			_scrollRect.y = 0;
			_pane.scrollRect = _scrollRect;
			
			encapsulated.filters = [];
			if (_scroller != null) _scroller.reset();
		}
		
		//override public function get width():Number { return _scrollRect.width; }
		
		override public function set width(value:Number):void 
		{
			_scrollRect.width = uint(value);
			_pane.scrollRect = _scrollRect;
			_background.width = _scrollRect.width;
			updateScroller();
		}
		
		//override public function get height():Number { return _scrollRect.height; }
		
		override public function set height(value:Number):void 
		{
			_scrollRect.height = uint(value);
			_pane.scrollRect = _scrollRect;
			_background.height = _scrollRect.height;	
			
			updateScroller();
		}
		
		public function get motionBlur():Number { return _motionBlur; }
		
		public function set motionBlur(value:Number):void 
		{
			_motionBlur = value;
			
			if (_motionBlur == 0) _blur = null;
			else if (_blur == null) _blur = new BlurFilter(0, 0, 1);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			var child:DisplayObject =  super.addChild(child);
			updateScroller();
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			child =  super.addChildAt(child, index);
			updateScroller();
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			child =  super.removeChild(child);
			updateScroller();
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = super.removeChildAt(index);
			updateScroller();
			return child;
		}
		
		protected function updateScroller():void
		{
			if (_scroller == null) return;
			_scroller.height = _scrollRect.height;
			_scroller.ratio = _scrollRect.height / encapsulated.height;
			scroll();
		}
		
		override protected function doActivate():void 
		{
			super.doActivate();
			Looty.addEnterFrame(render);
		}
		
		override protected function doDeactivate():void 
		{
			Looty.removeEnterFrame(render);
			super.doDeactivate();
		}
		
		protected function scroll():void
		{
			_objectiveY = _scroller.position * (encapsulated.height - _scrollRect.height);
			_isMoving = true;
			//trace("SCROLL", _objectiveY, height, encapsulated.height, _scrollRect.height,_scroller.position);
		}		
		
		public function render():void
		{
			if (_scroller != null) _scroller.render();	
			
			if (!_isMoving) return;		
			
			_difY = _objectiveY - _scrollRect.y;
			
			if (_difY > -1 && _difY < 1)
			{
				_difY = 0;
				_scrollRect.y = _objectiveY;
				_isMoving = false;
			}
			else _scrollRect.y = (_scrollRect.y + _difY * .2);			
			
			_pane.scrollRect = _scrollRect;
			
			if (_motionBlur != 0)
			{
				_blurY = _difY * _motionBlur * .3;
				if (_blurY < 0) _blurY = - _blurY;
				if (_blurY < .1) encapsulated.filters = [];
				else 
				{
					_blur.blurY = _blurY;
					encapsulated.filters = [_blur];
				}
			}
		}
		
	}

}