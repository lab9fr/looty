/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 27/06/2010 12:49
 * @version 0.1
 */

package org.looty.text 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import org.looty.core.text.*;
	
	//TODO : get character value (String)
	
	public class BitmapLetter extends Sprite
	{
		
		private var _bitmap			:Bitmap;
		
		private var _position		:Point;
		
		private var _character		:BitmapCharacter;
		
		public function BitmapLetter(character:BitmapCharacter, textFormat:TextFormat, smoothing:Boolean = false) 
		{
			_position = new Point();
			_character = character;
			
			_bitmap = new Bitmap(character.getColor(Number(textFormat.color)), PixelSnapping.ALWAYS, smoothing);
			addChild(_bitmap);			
			
			_bitmap.x = - _bitmap.width * .5;
			_bitmap.y = - _bitmap.height * .5;		
		}
		/*
		override public function set x(value:Number):void 
		{
			super.x = value + .4) | 0;
		}
		
		override public function set y(value:Number):void 
		{
			super.y = (value + .4) | 0;
		}
		*/
		public function remove3D():void
		{
			if (transform.matrix3D == null) return;
			var matrix:Matrix = new Matrix(transform.matrix3D.rawData[0], 0, 0, transform.matrix3D.rawData[5], transform.matrix3D.rawData[12], transform.matrix3D.rawData[13]);
			transform.matrix = matrix;
		}
		
		public function get bitmap():Bitmap { return _bitmap; }
		
		public function get position():Point { return _position; }
		
		public function get character():BitmapCharacter { return _character; }
		
	}
	
}