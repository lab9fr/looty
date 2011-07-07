/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.net 
{
	import flash.text.StyleSheet;
	import org.looty.core.looty;
	import org.looty.core.net.AbstractLoad;
	
	use namespace looty;

	public class CSSLoad extends AbstractLoad implements ILoad
	{		
		private var _content		:StyleSheet;
		
		public function CSSLoad(url:String, noCache:Boolean = false) 
		{
			super(url, noCache);
		}
		
		override looty function fillContent(data:* = null):void 
		{
			_content = new StyleSheet();
			_content.parseCSS(String(bytes));
			
			super.looty::fillContent();
		}
		
		override looty function reset():void
		{
			super.looty::reset();
			
			_content = null;
		}
		
		public function get content():StyleSheet
		{
			return _content;
		}
		
	}

}