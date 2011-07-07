/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 27/06/2010 21:32
 * @version 0.1
 */

package org.looty.core.text 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import org.looty.pattern.Singleton;
	
	public class FontManager extends Singleton
	{
		
		private var _tables		:Dictionary;
		
		private const FONTSTYLES		:Array = [FontStyle.REGULAR, FontStyle.ITALIC, FontStyle.BOLD, FontStyle.BOLD_ITALIC];
		
		private var _cachedTest		:Dictionary;
		
		public function FontManager() 
		{
			_tables = new Dictionary();
			_cachedTest = new Dictionary();
		}
		
		static private function get instance():FontManager { return getInstanceOf(FontManager); }
		
		static public function getTable(textFormat:TextFormat):CharactersTable
		{
			var key:String = instance.getKey(textFormat);
			if (instance._tables[key] == undefined) instance._tables[key] = new CharactersTable(textFormat);
			
			return instance._tables[key];
		}
		
		static public function clear(textFormat:TextFormat):void
		{
			var key:String = instance.getKey(textFormat);			
			instance._tables[key] = null;
			delete instance._tables[key];
		}		
		
		private function getKey(textFormat:TextFormat):String
		{
			return String(textFormat.font) + "#" + (int(textFormat.italic) + (int(textFormat.bold) << 1) + (int(textFormat.underline) << 2) + "#" + textFormat.size);
		}
		
		static public function testEmbed(textFormat:TextFormat):Boolean
		{			
			var fontStyle:String = instance.FONTSTYLES[int(textFormat.italic) + (int(textFormat.bold) << 1)];
			
			if (instance._cachedTest[(textFormat.font + "#" + fontStyle )]) return true;
			
			var isEmbed:Boolean;
			
			for each(var font:Font in Font.enumerateFonts()) 
			{
				if (font.fontName == textFormat.font && font.fontStyle == fontStyle) isEmbed = true;
				instance._cachedTest[(font.fontName + "#" + font.fontStyle)] = true;
			}
			
			return isEmbed;			
		}
		
		static public function getFont(textFormat:TextFormat):Font
		{
			var fontStyle:String = instance.FONTSTYLES[int(textFormat.italic) + (int(textFormat.bold) << 1)];
			
			for each(var font:Font in Font.enumerateFonts()) if (font.fontName == textFormat.font && font.fontStyle == fontStyle) return font;
			return null;	
		}
		
	}
	
}