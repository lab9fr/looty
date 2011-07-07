/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.net 
{
	import flash.display.*;
	import org.looty.core.looty;
	import org.looty.core.net.AbstractDisplayLoad;
	
	use namespace looty;

	public class BitmapDataLoad extends AbstractDisplayLoad implements ILoad
	{
		
		private var _content		:BitmapData;
		
		public function BitmapDataLoad(url:String, noCache:Boolean = false) 
		{
			super(url, noCache);
			
			allowCodeImport = false;
			
			weight = 30000;
			
		}
		
		override looty function reset():void
		{
			super.looty::reset();
			
			if (_content != null) _content.dispose();
			_content = null;
		}
		
		override looty function fillContent(data:* = null):void 
		{
			_content = Bitmap(data).bitmapData;
			super.looty::fillContent();
		}
		
		public function get content():BitmapData
		{
			return _content.clone();
		}
		
	}

}