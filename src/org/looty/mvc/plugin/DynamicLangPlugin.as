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
	import org.looty.core.mvc.AbstractPlugin;
	import org.looty.localisation.Localisation;
	import org.looty.localisation.LocalisationData;
	import org.looty.mvc.controller.Presenter;
	
	public class DynamicLangPlugin extends AbstractPlugin
	{
		
		private var _detectLanguage		:Boolean;
		
		public function DynamicLangPlugin(detectLanguage:Boolean = false) 
		{
			_detectLanguage = detectLanguage;
			
			super("DynamicLangPlugin")
			
			initialisation.onComplete = setDefaultLanguage;
		}
		
		override public function configure(xml:XML, presenter:Presenter = null):void 
		{
			
			if (xml.langs.@defaultLanguage[0] != undefined) Localisation.defaultLanguage = xml.langs.@defaultLangage			
			
			var node:XML;
			var locData:LocalisationData;
			
			for each (node in xml.langs.lang)
			{
				//trace("node", node)
				locData = new LocalisationData(node);				
				initialisation.append(locData);
			}
			
			super.configure(xml, presenter);
		}
		
		
		private function setDefaultLanguage():void
		{
			if (!_detectLanguage || !Localisation.detectLanguage()) Localisation.language = Localisation.defaultLanguage;
			
		}
		
		
	}
	
}