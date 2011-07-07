/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.net 
{
	import org.looty.core.looty;
	import org.looty.core.net.AbstractLoad;
	
	use namespace looty;

	public class TextLoad extends AbstractLoad implements ILoad
	{
		
		private var _content		:String;
		
		public function TextLoad(url:String, noCache:Boolean = false) 
		{
			super(url, noCache);
		}
		
		override looty function fillContent(data:* = null):void  
		{
			_content = String(bytes);
			super.looty::fillContent();
		}
		
		override looty function reset():void
		{
			super.looty::reset();
			
			_content = "";
		}
		
		public function get content():String
		{
			return _content;
		}
		
	}

}