/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 25/06/2010 12:02
 * @version 0.1
 */

package org.looty.core.text 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	import org.looty.log.Looger;
	import org.looty.Looty;
	
	public class CharactersTable
	{
		
		private var _table			:Dictionary;
		
		private var _textField		:TextField;
		
		private var _container		:Sprite;
		
		private var _font			:Font;
		
		private var _isEmbed		:Boolean;
		
		public function CharactersTable(textFormat:TextFormat) 
		{
			_table = new Dictionary();
			_container = new Sprite();
			_textField = new TextField();
			_container.addChild(_textField);
			_textField.defaultTextFormat = new TextFormat(textFormat.font, textFormat.size, Looty.useWhiteBitmapTextColorType ? 0xFFFFFF : 0x000000, Boolean(textFormat.bold), Boolean(textFormat.italic), Boolean(textFormat.underline), null, null, TextFormatAlign.CENTER);
			_font = FontManager.getFont(textFormat);			
			_isEmbed = _font != null;
			_textField.selectable = false;
			_textField.autoSize = TextFieldAutoSize.NONE;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.gridFitType = GridFitType.PIXEL;
			_textField.width = Number(textFormat.size) << 1;
			_textField.height = Number(textFormat.size) << 1;
		}
		
		
		public function getCharacter(value:String):BitmapCharacter
		{
			if (_table[value] == undefined)
			{
				_textField.embedFonts = _isEmbed && _font.hasGlyphs(value);
				_textField.text = value;
				
				var metrics:TextLineMetrics = _textField.getLineMetrics(0);
				var bounds:Rectangle = _textField.getCharBoundaries(0);				
				
				if (bounds == null) 
				{
					Looger.error("Error at character creation of " +  (_font != null ? _font.fontName + " " + _font.fontStyle : "") + " U+" + value.charCodeAt().toString(16) + " embedFonts " + _textField.embedFonts);
					_table[value] = null;
					return null;
				}
				
				var rect:Rectangle = new Rectangle(int(bounds.x), int(bounds.y) - 1, int(bounds.width + .96), int(bounds.height + .96) + 2);
				if (rect.width & 1 == 1) ++rect.width;
				
				var bmd:BitmapData = new BitmapData(_textField.width, rect.height, true, 0x00000000);
				
				var matrix:Matrix = new Matrix(1, 0, 0, 1, 0, - rect.y);
				bmd.draw(_container, matrix);
				
				var colorRect:Rectangle = bmd.getColorBoundsRect(0xFF000000, 0, false);
			
				var diff:int = 0;
				var finalDiff:int = 0;
				
				
				diff = rect.x - colorRect.x;
				if (diff > finalDiff) finalDiff = diff;
				
				diff = (colorRect.x + colorRect.width) - (rect.x + rect.width);
				if (diff > finalDiff) finalDiff = diff;				
				
				_table[value] = new BitmapCharacter(bmd, new Rectangle(rect.x - finalDiff, 0, rect.width + finalDiff * 2, rect.height), new Point(bounds.width, bounds.height), metrics.ascent - rect.height * .5 + 1);
				
			}
			
			return _table[value]
			
		}
		
	}
	
}