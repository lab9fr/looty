/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/02/2010 16:31
 * @version 0.1
 */

package org.looty.mvc.plugin 
{
	import flash.errors.IllegalOperationError;
	import org.looty.core.mvc.AbstractPlugin;
	import org.looty.localisation.Localisation;
	import org.looty.localisation.LocalisationData;
	import org.looty.mvc.controller.Presenter;
	
	public class StaticLangPlugin extends AbstractPlugin
	{
		
		private var _lang		:String;
		
		public function StaticLangPlugin(lang:String) 
		{
			_lang = lang;
			
			super("StaticLangPlugin");
			
			initialisation.onComplete = setLanguage;
		}
		
		override public function configure(xml:XML, presenter:Presenter = null):void 
		{
			Localisation.defaultLanguage = _lang;
			Localisation.language = _lang;
			
			var node:XML;
			var locData:LocalisationData;
			
			var hasLang:Boolean;
			
			for each (node in xml.langs.lang) 			
			{
				if (node.@code[0] != _lang) continue;
				locData = new LocalisationData(node);				
				initialisation.append(locData);
				
				hasLang = true;
				
				break;
			}
			
			if (!hasLang) throw new IllegalOperationError("lang with code '" + _lang + "' not present in xml");
			
			
			
			super.configure(xml, presenter);
		}
		
		
		private function setLanguage():void
		{
			Localisation.language = _lang;
			
		}
		
	}
	
}