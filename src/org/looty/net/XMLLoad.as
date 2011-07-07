/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.net 
{
	import org.looty.*;
	import org.looty.core.*;
	import org.looty.core.net.*;
	import org.looty.log.*;
	
	use namespace looty;

	public class XMLLoad extends AbstractLoad implements ILoad
	{
		
		private var _content		:XML;
		
		public function XMLLoad(url:String, noCache:Boolean = false) 
		{
			super(url, noCache);
			
			weight = 10000;
		}
		
		override looty function fillContent(data:* = null):void  
		{
			var xml:String = String(bytes);
			var regExp:RegExp;
			
			for (var id:String in Looty.parameters) 
			{
				regExp = new RegExp("\\$\\{" + id + "\\}");				
				while (regExp.test(xml)) xml = xml.replace(regExp, Looty.parameters[id]);
			}
			
			try 
			{
				_content = XML(xml);
			}
			catch (e:Error)
			{				
				Looger.fatal(e.message + "\n" + xml);				
			}
			
			super.looty::fillContent();
		}
		
		override looty function reset():void
		{
			super.looty::reset();
			
			_content = null;
		}
		
		public function get content():XML
		{
			return _content;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			_content = null;
		}
		
	}

}