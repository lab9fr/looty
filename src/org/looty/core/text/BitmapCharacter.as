/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 25/06/2010 12:04
 * @version 0.1
 */

package org.looty.core.text 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class BitmapCharacter extends BitmapData
	{
		private var _colors		:Dictionary;
		
		private var _size		:Point;
		
		private var _lineOffset	:Number;
		
		public function BitmapCharacter(bitmapData:BitmapData, bounds:Rectangle, size:Point, lineOffset:Number) 
		{
			super(bounds.width, bounds.height, true, 0x0000000);
			copyPixels(bitmapData, bounds, new Point(0, 0));
			_colors = new Dictionary();
			_colors[0x000000] = this;
			
			_size = size;
			_lineOffset = lineOffset;
		}
		
		public function getColor(value:Number):BitmapData
		{
			if (_colors[value] == null)
			{
				var bmd:BitmapData = this.clone();
				var transform:ColorTransform = new ColorTransform();
				transform.color = value;
				bmd.colorTransform(bmd.rect, transform);
				_colors[value] = bmd;
			}			
			return _colors[value];
		}
		
		public function get size():Point { return _size; }
		
		public function get lineOffset():Number { return _lineOffset; }
		
		
	}
	
}