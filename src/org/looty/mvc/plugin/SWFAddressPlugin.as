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
	
	import com.asual.swfaddress.*;
	import flash.net.*;
	import org.looty.core.mvc.AbstractPlugin;
	import org.looty.localisation.*;
	
	public class SWFAddressPlugin extends AbstractPlugin
	{
		
		private var _isStarted		:Boolean;
		
		public function SWFAddressPlugin() 
		{
			super("SWFAddressPlugin");
			vars.urlVariables = new URLVariables();
			
			command.register("start", start);
			command.register("update", update);
		}
		
		private function start():void
		{
			if (_isStarted) return;
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, change);
			_isStarted = true;
		}
		
		private function change(e:SWFAddressEvent):void
		{
			var query:String = SWFAddress.getQueryString();
			var parts:Object;
			
			vars.urlVariables = new URLVariables();
			
			if (query != null) for each (var element:String in query.split("&")) if (/^\S+=\S+$/.test(element))
			{
				parts = /^(?P<prop>\S+)=(?P<value>\S+)$/.exec(element);
				vars.urlVariables[parts.prop] = parts.value;				
			}
			
			if (vars.dynamicLang)
			{
				var lang:String = vars.urlVariables.lang;
				
				if (lang != null && Localisation.hasLanguage(lang) && Localisation.language != lang) 
				{
					Localisation.language = lang;
					controller.rewriteCurrentPath();
					return;
				}
			}
			
			vars.path = SWFAddress.getPath();
			
			controller.change(vars.path);
		}
		
		private function update():void
		{
			if (vars.dynamicLang) vars.urlVariables.lang = Localisation.language;
			
			var query:String = "";
			var sep:String = "";
			for (var prop:String in vars.urlVariables) 
			{
				if (vars.urlVariables[prop] == null || vars.urlVariables[prop] == undefined) continue;
				query += sep +  prop + "=" + vars.urlVariables[prop];
				sep = "&";
			}
			
			SWFAddress.setValue(vars.path + (query != "" ? "?" + query : ""));
		}
		
	}
	
}