/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 06/01/2010 12:11
 * @version 0.1
 */

package org.looty.text 
{
	import flash.text.*;
	import flash.utils.*;
	import org.looty.core.*;
	import org.looty.data.*;
	import org.looty.core.text.*;
	import org.looty.localisation.*;
	import org.looty.log.*;
	import org.looty.pattern.*;
	
	use namespace looty;
	
	public class StyleManager extends Singleton
	{
		
		private var _stylables			:List;		
		private var _styleSheets		:Dictionary;
		private var _defaultStyleSheet	:StyleSheet;
		private var _styleSheet			:StyleSheet;		
		private var _style				:String;
		private var _language			:String;
		
		public function StyleManager() 
		{
			_stylables = new List();
			_styleSheets = new Dictionary();
			_style = "default";
			_language = "";
			
			Localisation.looty::setStyleChange(update);			
		}
		
		static private function get instance():StyleManager { return getInstanceOf(StyleManager); }
		
		static looty function addStylable(value:IStylable):void
		{
			if (!instance._stylables.has(value)) instance._stylables.add(value);
			if (instance._styleSheet != null) value.styleSheet = instance._styleSheet;
		}
		
		static public function addStyleSheet(styleSheet:StyleSheet, lang:String = "", style:String = "", isDefault:Boolean = false):void
		{
			if (style == "") style = "default";
			
			Looger.info("add styleSheet [ lang:" + lang + " - style:" + style + " ]");
			
			instance._styleSheets[(lang + "@#" + style)] = styleSheet;
			if (instance._defaultStyleSheet == null || isDefault) instance._defaultStyleSheet = styleSheet;
			
			if (lang == Localisation.language) update();
		}
		
		static public function get styleSheet():StyleSheet { return instance._styleSheet; }
		
		static public function set styleSheet(value:StyleSheet):void
		{
			instance._styleSheet = value;
			instance._stylables.forEach(instance.forEachSetStyleSheet);
		}
		
		static private function update():void
		{
			var lang:String = Localisation.language;
			
			switch(true)
			{
				case instance._styleSheets[(lang + "@#" + style)] != null :
				styleSheet = instance._styleSheets[(lang + "@#" + style)];
				Looger.info("switch to styleSheet [ lang:" + lang + " - style:" + style + " ]");
				break;
				
				case instance._styleSheets[(lang + "@#default")] != null :
				styleSheet = instance._styleSheets[(lang + "@#default")];
				Looger.error("missing styleSheet - style : '" + style + "' - language : '" + lang + " / switching to default - " + lang);
				break;
				
				case instance._defaultStyleSheet != null:
				styleSheet = instance._defaultStyleSheet;
				Looger.error("missing styleSheet - language : '" + lang + "' - style : '" + style + "' / switching to default");
				break;
				
				default:
				Looger.error("missing styleSheet - language : '" + lang + "' - style : '" + style + "'" );
			}			
			
		}
		
		static public function get style():String { return instance._style; }
		
		static public function set style(value:String):void 
		{
			instance._style = value;
			update();
		}
		
		private function forEachSetStyleSheet(stylable:IStylable):void
		{
			stylable.styleSheet = _styleSheet;
		}
		
	}
	
}