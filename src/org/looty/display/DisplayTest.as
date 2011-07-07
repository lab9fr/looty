/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.display 
{
	import flash.display.*;
	
	public class DisplayTest extends Layer
	{
		
		private var _bitmap		:Bitmap;
		
		public function DisplayTest(width:Number = 100, height:Number = 100, color:uint = 0x00FF00) 
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1, 0xFF0000);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.beginFill(color, 0.5);
			shape.graphics.drawRect(2, 2, width - 4, height - 4);
			shape.graphics.endFill();
			
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);
			bitmapData.draw(shape);
			shape = null;
			
			_bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS, false);
			addChild(_bitmap);
			
			layerIndex = int.MAX_VALUE;
		}
		
	}

}