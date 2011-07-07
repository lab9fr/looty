/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.media 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import org.looty.log.Looger;
	import org.looty.net.BitmapDataLoad;
	
	//TODO : might need refactoring / make abstract to implement Tweenmax outside 

	public class SlideShow extends Sprite
	{
		
		private var _width:Number;
		private var _height:Number;
		
		private var _pictures:Array;
		private var _urls:Array;
		private var _index:int;
		
		private var _current:Bitmap;
		
		private var _transition:uint;
		private var _duration:uint;
		
		public var onChange:Function;
		
		private var _loader:BitmapDataLoad;
		
		private var _isPlaying:Boolean;
		
		public function SlideShow(width:Number, height:Number) 
		{
			_width = width;
			_height = height;
			_transition = 2;
			_duration = 3;
			_urls = [];
			_pictures = [];
		}
		
		public function fill(urls:Array, displayFirst:Boolean = false):void
		{
			_pictures = new Array(urls.length);
			_index = displayFirst ? 0 : - 1;
			_urls = urls;
			if (displayFirst) loadPicture();
		}
		
		public function play():void
		{
			if (_isPlaying) return;
			if (_urls.length < 1) return;
			_isPlaying = true;
			next();
		}
		
		public function pause():void
		{
			if (!_isPlaying) return;
			_isPlaying = false;
		}
		
		public function stop():void
		{
			if (!_isPlaying) return;
			_index = 0
			_isPlaying = false;
			display(true);
		}
		
		public function next():void
		{
			if (!_isPlaying) return;
			++_index;
			_index %= _pictures.length;	
			display();
		}
		
		public function goto(index:int):void
		{
			if (index < 0 || index > _urls.length - 1) return;
			_index = index;
			display();
		}
		
		public function previous():void
		{
			if (!_isPlaying) return;
			--_index;
			if (_index < 0) _index = _pictures.length - _index;
			display();
		}
		
		public function reset():void
		{
			stop();
			_current = null;
			_pictures = [];
			_urls = [];
			clean();
		}
		
		private function display(immediate:Boolean = false):void
		{
			TweenMax.killDelayedCallsTo(next);		
			
			if (_pictures[_index] == undefined) 
			{
				loadPicture();
				return;
			}
			
			var bmd:BitmapDataPlus = new BitmapDataPlus(_width, _height);
			bmd.fitAndCrop(_pictures[_index]);
			
			_current = new Bitmap(bmd, PixelSnapping.AUTO);
			addChild(_current);
			
			if (!immediate)
			{
				_current.alpha = 0;
				TweenMax.to(_current, _transition, { alpha : 1, onComplete : transitionComplete, ease : Quad.easeInOut } );
			}
			else transitionComplete();		
			
			if (Boolean(onChange)) onChange();		 
		}
		
		private function transitionComplete():void
		{
			clean();
			TweenMax.killDelayedCallsTo(next);
			if (_isPlaying) TweenMax.delayedCall(_duration, next);
		}
		
		private function loadPicture():void
		{
			_loader = new BitmapDataLoad(_urls[_index], false);
			_loader.onComplete = onLoadComplete;
			_loader.start();
		}
		
		private function onLoadComplete():void
		{
			_pictures[_index] = _loader.content;
			_loader = null;
			display();
		}
		
		private function clean():void
		{
			var child:DisplayObject
			for (var i:int = numChildren - 1; i > -1; --i)
			{
				child = getChildAt(i);
				if (child != _current) removeChild(child);
			}
		}
		
		
		
		public function get transition():uint { return _transition; }
		
		public function set transition(value:uint):void 
		{
			_transition = value;
		}
		
		public function get duration():uint { return _duration; }
		
		public function set duration(value:uint):void 
		{
			_duration = value;
		}
		
		public function get index():int { return _index; }
		
	}

}