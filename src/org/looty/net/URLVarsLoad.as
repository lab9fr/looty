/**
 * @project looty
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @created 28/11/2009 15:12
 * @version 0.1
 */

package org.looty.net 
{
	import flash.net.URLVariables;
	import org.looty.core.looty;
	import org.looty.core.net.AbstractLoad;
	
	use namespace looty;

	public class URLVarsLoad extends AbstractLoad implements ILoad
	{
		
		private var _content		:URLVariables;
		
		public function URLVarsLoad(url:String, noCache:Boolean = false) 
		{
			super(url, noCache);
		}
		
		override looty function fillContent(data:* = null):void  
		{
			_content = URLVariables(bytes);
			super.looty::fillContent();
		}
		
		override looty function reset():void
		{
			super.looty::reset();
			
			_content = null;
		}
		
		public function get content():URLVariables
		{
			return _content;
		}
		
	}

}