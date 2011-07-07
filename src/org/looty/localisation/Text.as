/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 19/04/2010 20:48
 * @version 0.1
 */

package org.looty.localisation 
{
	import flash.utils.*;
	import org.looty.core.*;
	import org.looty.log.*;
	import org.looty.text.*;
	
	use namespace looty;
	
	public class Text 
	{
		static looty var index				:uint;
		
		private var _contents				:Array;
		private var _defaultContent			:String;
		private var _styles					:Array;
		private var _style					:String;
		private var _defaultStyle			:String;		
		private var _key					:String;
		
		public var textTransform			:TextTransform;
		
		looty var onChange					:Function;
		private var _onChangeLang			:Function;
		
		public function Text(key:String) 
		{
			_key = key;
			_contents = [];
			_styles = [];
			_style = "";
			_defaultStyle = "";
			_defaultContent = "";
			
			if (Localisation.hasText(_key)) copyContent(Localisation.getText(key));
			
			Localisation.registerText(this);
		}
		
		public function fill(langIndex:uint, value:String, style:String = ""):void
		{
			if (_contents[langIndex] != null) Looger.error("duplicate content set in Text. key: " + _key);
			
			_contents[langIndex] = value;			
			
			if (style != "") _styles[langIndex] = style;
		}
		
		private function copyContent(text:Text):void
		{
			_contents = text._contents;
			_defaultContent = text._defaultContent;
			_styles = text._styles;
			_style = text._style;
			_defaultStyle = text._defaultStyle;
			_key = text._key.split("@#")[0] + "@#" + (new Date().getTime() + Math.random() * 1E12).toString(36);
		}
		
		public function get content():String 
		{
			var value:String;
			switch(true)
			{
				case _contents[looty::index] != null :
				value = _contents[looty::index];
				break;
				
				case _defaultContent != "":
				value = _defaultContent;
				break;
				
				default:
				return "missing content " + key;
			}
			
			if (textTransform != null) value = textTransform.format(value)
			
			return value;
		}
		
		public function get style():String
		{
			switch(true)
			{
				case _style != "":
				return _style;
				break;
				
				case _styles[looty::index] != null:
				return _styles[looty::index];
				break;
				
				case _defaultStyle != "":
				return _defaultStyle;
				break;
				
				default:
				return "default";
			}
		}
		
		public function set style(value:String):void 
		{
			_style = value;
			
			if (Boolean(looty::onChange)) looty::onChange();
		}
		
		public function get styledContent():String
		{
			return style != null ? "<span class='" + style + "' >" + content + "</span>" : content;
		}
		
		public function clone():Text
		{
			return new Text(key);
		}
		
		public function get key():String { return _key; }	
		
		public function get onChangeLang():Function { return _onChangeLang; }
		
		public function set onChangeLang(value:Function):void 
		{
			if (Boolean(value)) Localisation.registerOnChangeLang(value);
			else Localisation.unregisterOnChangeLang(_onChangeLang);
			_onChangeLang = value;
		}
		
		public function get defaultContent():String { return _defaultContent; }
		
		public function set defaultContent(value:String):void 
		{
			_defaultContent = value;
		}
		
		public function get defaultStyle():String { return _defaultStyle; }
		
		public function set defaultStyle(value:String):void 
		{
			_defaultStyle = value;
		}
		
		public function toString():String 
		{
			return "[" + getQualifiedClassName(this) + "] key : " + _key + " - contents : \"" + _contents.join("\" \"") + "\""; 
		}
		
	}
	
}