/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.localisation 
{
	import flash.errors.IllegalOperationError;
	import flash.external.*;
	import flash.system.*;
	import flash.utils.*;
	import org.looty.core.looty;
	import org.looty.log.*;
	import org.looty.pattern.*;
	
	use namespace looty;
	
	//TODO : better implementation for localised load
	//TODO : localised bitmap...
	
	/**
	 * Localisation langage code is built from the langage code defined in the <a href="http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes" >ISO 639</a> standard along with the country code defined in the <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2" >ISO 3166</a>. eg : en_UK, fr_FR
	 */
	
	public final class Localisation extends Singleton
	{
		
		private var _langs					:Array;
		private var _texts					:Dictionary;
		private var _styles					:Dictionary;
		
		private var _callbacks				:Array;
		
		private var _defaultLanguage		:String;
		
		private var _styleChange			:Function;
		
		public function Localisation() 
		{
			_langs = [];
			_defaultLanguage = "";
			_texts = new Dictionary();
			_callbacks = [];
		}
		
		static public function get instance():Localisation
		{
			return getInstanceOf(Localisation);
		}
		
		static public function hasLanguage(lang:String):Boolean	{ return langs.indexOf(lang.toLowerCase()) != -1;	}
		
		static private function get texts():Dictionary { return instance._texts; }
		
		static private function get langs():Array { return instance._langs; }
		
		static private function get callbacks():Array { return instance._callbacks; }
		
		//TODO : check this is working
		static public function detectLanguage():Boolean
		{			
			/*var js:XML=
			<script>
				<![CDATA[
				function ()
				{
					getLanguage = function () 
					{
						return (navigator.appName == 'Netscape') ? navigator.language : navigator.browserLanguage;
					}
				}
				]]>
			</script>;
			*/
			if (ExternalInterface.available)
			{
				var lang:String = ExternalInterface.call("navigator.appName") == "Netscape" ? ExternalInterface.call("navigator.language") : ExternalInterface.call("navigator.browserLanguage");
				Looger.info("browser language : " + lang);
				
				if (langs.indexOf(lang) != -1) 
				{
					defaultLanguage = lang;
					return true;
				}
				else if (langs.indexOf(lang.substr(0, 2)) != -1)
				{
					defaultLanguage = lang.substr(0, 2);
					return true;
				}
			}			
			
			if (langs.indexOf(Capabilities.language) != -1) 
			{
				Looger.info("system language : " + Capabilities.language);
				defaultLanguage = Capabilities.language;
				return true;
			}
			
			return false;
		}
		
		static public function fill(key:String, lang:String, value:String, style:String = ""):void
		{
			if (key == null || lang == null || value == null) throw new IllegalOperationError("key, lang and value can't be null. key : " + key + " - lang : " + lang + " - value : " + value);
			lang = lang.toLowerCase();
			var text:Text; 
			if (texts[key] == null) 
			{
				text = new Text(key);
				texts[key] = text;
			}
			else text = Text(texts[key]);
			
			if (!hasLanguage(lang)) 
			{
				langs.push(lang);
				if (defaultLanguage == "") defaultLanguage = lang;
			}
			value = value.replace(/(\r\n)|(\n\r)/g, "\n");
			text.fill(langs.indexOf(lang), value, style);
		}
		
		static public function hasText(key:String):Boolean { return instance._texts[key] != null; }
		
		static public function getText(key:String):Text	{ return instance._texts[key]; }
		
		static public function registerText(text:Text):void	{ instance._texts[text.key] = text;	}
		
		static public function get language():String { return langs[Text.looty::index];  }
		
		static public function set language(value:String):void
		{
			value = value.toLowerCase();
			if (String(langs[Text.looty::index]) == value) return;
			
			if (!hasLanguage(value)) 
			{
				if (defaultLanguage != "") value = defaultLanguage;
			}
			
			Text.looty::index = langs.indexOf(value);
			
			instance.update();
		}
		
		private function update():void
		{
			if (Boolean(_styleChange)) _styleChange();
			
			for each (var text:Text in _texts) if (Boolean(text.looty::onChange)) text.looty::onChange();
			
			_callbacks = _callbacks.filter(executeCallbacks);
		}
		
		static private function executeCallbacks(onChange:Function, index:int, array:Array):Boolean
		{
			if (onChange == null) return false;
			onChange();
			return true;
		}
		
		static private function get defaultIndex():int
		{
			var i:int = langs.indexOf(instance._defaultLanguage);
			if (i == -1) i = 0;
			return i;
		}
		
		static public function get defaultLanguage():String { return instance._defaultLanguage; }
		
		static public function set defaultLanguage(value:String):void 
		{
			instance._defaultLanguage = value.toLowerCase();
		}
		
		static public function registerOnChangeLang(onChange:Function):void
		{
			if (callbacks.indexOf(onChange) != -1) return;
			callbacks.push(onChange);
		}
		
		static public function unregisterOnChangeLang(onChange:Function):void
		{
			if (callbacks.indexOf(onChange) == -1) return;
			callbacks.splice(callbacks.indexOf(onChange), 1);
		}
		
		static looty function setStyleChange(value:Function):void
		{
			instance._styleChange = value;
		}

		
		static looty function get callbacks():Array { return instance._callbacks; }
		
		static public function dump():void
		{
			for each (var text:Text in texts) Looger.log(text.toString());
		}		
		
	}	
	
}