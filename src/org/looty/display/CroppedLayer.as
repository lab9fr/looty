/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 11/07/2010 21:00
 * @version 0.1
 */

package org.looty.display 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.looty.core.looty;
	import org.looty.ui.IUserInterface;
	
	//TODO : different displayModes, may be
	
	use namespace looty;
	
	public class CroppedLayer extends EncapsulatedLayer
	{
		
		private var _scrollRect		:Rectangle;
		
		protected var _layerWidth	:Number;
		protected var _layerHeight	:Number;
		
		private var _anchor			:Point;
		
		public function CroppedLayer(width:Number, height:Number) 
		{
			_scrollRect = new Rectangle(0, 0, uint(width), uint(height));
			_anchor = new Point(.5, .5);
			updateSize();			
		}
		
		override public function get width():Number { return _scrollRect.width; }
		
		override public function set width(value:Number):void 
		{
			_scrollRect.width = uint(value);			
			updateSize();			
		}
		
		override public function get height():Number { return _scrollRect.height; }
		
		override public function set height(value:Number):void 
		{
			_scrollRect.width = uint(value);
			updateSize();
		}
		
		public function get anchor():Point { return _anchor; }
		
		public function set anchor(value:Point):void 
		{
			_anchor = value;
		}
		
		public function updateSize():void
		{
			scrollRect = _scrollRect;
			
			if (looty::encapsulated.width == 0 || looty::encapsulated.height == 0) return;
			
			
			var rw:Number = _scrollRect.width / looty::encapsulated.width ;
			var rh:Number = _scrollRect.height / looty::encapsulated.height;	
			
			if (rw > rh)
			{
				encapsulated.width = width;
				encapsulated.scaleY = encapsulated.scaleX;
				encapsulated.x = 0;
				encapsulated.y = (height - encapsulated.height) * _anchor.y;				
			}
			else
			{
				encapsulated.height = height;
				encapsulated.scaleX = encapsulated.scaleY;
				encapsulated.y = 0;
				encapsulated.x = (width - encapsulated.width) * _anchor.x;				
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			super.addChild(child);			
			updateSize();			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			super.addChildAt(child, index);
			updateSize();			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			super.removeChild(child);
			updateSize();			
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			var child:DisplayObject = super.removeChildAt(index);			
			updateSize();			
			return child;
		}
		
	}
	
}