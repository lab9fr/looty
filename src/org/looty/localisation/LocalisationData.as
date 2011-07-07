/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.localisation 
{
	import flash.errors.*;
	import org.looty.net.*;
	import org.looty.sequence.*;
	import org.looty.text.*;
	
	//TODO : localisation labels (array of buttons label) + index for user choice of language

	public class LocalisationData extends Sequence
	{
		
		private var _locals:Array;
		private var _fonts:Array;
		private var _styles:Array;
		private var _lang:String;
		
		public function LocalisationData(xml:XML) 
		{
			super(0);
			
			var node:XML;
			
			var fontLoad:SWFLoad;
			_fonts = [];
			
			for each (node in  xml.fontlib)
			{
				fontLoad = new SWFLoad(node, false);
				_fonts.push(fontLoad);
				append(fontLoad);
			}
			
			var cssLoad:CSSLoad;
			_styles = [];
			
			for each (node in xml.style)
			{
				cssLoad = new CSSLoad(String(node), true);
				cssLoad.name = node.style[0] != undefined ? String(node.style[0]) : "";
				append(cssLoad);
				_styles.push(cssLoad);				
			}
			
			if (xml.src[0] == undefined) throw new IllegalOperationError("undefined localisation source file");
			
			var localLoad:XMLLoad;
			_locals = [];
			
			for each (node in  xml.src)
			{
				localLoad = new XMLLoad(node, true);
				append(localLoad);
				_locals.push(localLoad);
			}
			
			onComplete = parse;
			
			if (xml.@code[0] == undefined) throw new IllegalOperationError("undefined lang code");
			
			_lang = String(xml.@code[0]);
		}
		
		private function parse():void
		{
			for each (var cssLoad:CSSLoad in _styles) StyleManager.addStyleSheet(cssLoad.content, _lang, cssLoad.name);
			
			for each (var localLoad:XMLLoad in _locals) for each (var node:XML in localLoad.content.text)
			{
				if (node.@key[0] == undefined) continue;
				
				Localisation.fill(node.@key, _lang, String(node), node.@styleName != null ? node.@styleName : "");
			}
		}
		
		public function get lang():String { return _lang; }
		
	}

}