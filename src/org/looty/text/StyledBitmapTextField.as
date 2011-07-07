/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.text 
{
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.looty.localisation.Text;
	import org.looty.log.Looger;
	import org.looty.text.StyledTextField;

	public class StyledBitmapTextField extends StyledTextField
	{
		
		private var _bitmapCache		:Bitmap;
		private var _bitmapCacheData	:BitmapData;
		private var _smoothing			:Boolean;
				
		public function StyledBitmapTextField(text:Text = null, width:int = 0, height:Number = 0) 
		{			
			super(text, width, height);
		}
		
		override protected function createContainer():void 
		{
			_bitmapCache = new Bitmap(null, PixelSnapping.NEVER, false);
			addChild(_bitmapCache);
			
			textFieldContainer = new Sprite();
		}
		
		override public function update():Boolean 
		{
			if (!super.update()) return false;
			
			draw();
			
			return true
		}
		
		override public function resize(width:Number):void 
		{
			super.resize(width);
			
			draw();
		}
		
		override internal function fillOverflow(styled:StyledTextField):void 
		{
			super.fillOverflow(styled);
			
			draw();
		}
		
		protected function draw():void
		{		
			if (length == 0)
			{
				_bitmapCache.visible = false;
				return;
			}
			else _bitmapCache.visible = true;
			
			if (width > 2880)
			{
				resize(2800);
				return;
			}
			
			if (height > 2880)
			{
				height = 2800;
				return;
			}
			
			if (width == 0 || height == 0) 
			{
				Looger.warn("StyledBitmapTextField size error");
				return;
			}
			
			_bitmapCacheData = new BitmapData(width, height, true, backgroundColor);			
			
			_bitmapCacheData.draw(textFieldContainer);
			_bitmapCache.bitmapData = _bitmapCacheData;
			if (_smoothing) _bitmapCache.smoothing = true;			
			
		}
		
		public function get bitmapData():BitmapData { return _bitmapCache.bitmapData; }
		
		public function get smoothing():Boolean { return _smoothing; }
		
		public function set smoothing(value:Boolean):void 
		{
			_smoothing = value;
			draw();
		}
		
		public function get bitmap():Bitmap { return _bitmapCache; }
		
		
	}

}