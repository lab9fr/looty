/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.net 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import org.looty.core.looty;
	import org.looty.core.net.AbstractDisplayLoad;
	
	use namespace looty;

	public class SWFLoad extends AbstractDisplayLoad implements ILoad
	{
		
		//TODO : check url domain : relative or different domain 
		//, allowExternalDomain:Boolean = false
		
		private var _content		:Sprite;
		
		public function SWFLoad(url:String, noCache:Boolean = false, allowCodeImport:Boolean = true) 
		{
			super(url, noCache, allowCodeImport);
			weight = 200000;
		}
		
		override looty function fillContent(data:* = null):void  
		{
			_content = Sprite(data);
			if (_content is MovieClip) MovieClip(_content).gotoAndStop(1);
			
			super.looty::fillContent();
		}
		
		override looty function reset():void
		{
			super.looty::reset();
			
			_content = null;
		}
		
		public function get content():Sprite
		{
			return _content;
		}
		
	}

}