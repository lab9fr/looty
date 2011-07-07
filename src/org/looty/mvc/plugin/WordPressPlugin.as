/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 23/04/2010 14:40
 * @version 0.1
 */

package org.looty.mvc.plugin 
{
	import org.looty.net.XMLLoad;
	
	public class WordPressPlugin 
	{
		
		private var _configuration		:String;		
		private var _xmlLoad			:XMLLoad;
		
		private const GET_POST_CATEGORIES		:String = "";
		
		public function WordPressPlugin(configuration:String)
		{
			
		}
		
		private function callMethod(method:String, ...parameters:Array):void
		{
			_xmlLoad = new XMLLoad(_configuration);
			
			var query:String = '<?xml version="1.0" encoding="utf-8"?><methodCall><methodName>' + method + '</methodName>';
			
			if (parameters.length > 0)
			{
				query += '<params>';
				
				//for each var 
			}
		}
 
  <param>
   <value><string>1064</string></value>
   </param>
  <param>
   <value><string>admin</string></value>
   </param>
  <param>
   <value><string>[password]</string></value>
   </param>
  </params>
 </methodCall>

			
			_xmlLoad.request.data = 
			var 
		}
		
	}
	
}