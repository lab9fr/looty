/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 21/01/2010 17:26
 * @version 0.1
 */

package org.looty.localisation 
{
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.core.net.AbstractLoad;
	import org.looty.net.BitmapDataLoad;
	import org.looty.net.SWFLoad;
	import org.looty.net.XMLLoad;
	import org.looty.sequence.Sequencable;
	
	//TODO : implement forced type ...
	//TODO : completely refactor ...
	//TODO : adapt to new version
	
	public class LocalisableLoad extends Sequencable
	{
		
		private var _loads		:Dictionary;
		
		private var _load		:AbstractLoad;
		
		private var _text		:Text;
		
		private var _type		:String;
		
		private var _noCache	:String;
		
		public var fillLoad		:Function;
		
		public var id			:String;
		
		public function LocalisableLoad(key:String, noCache:String) 
		{
			throw new Error();
			_text = Localisation.getText(key);
			
			_loads = new Dictionary();
			
			setEntry(create);
		}
		
		public function create():void 
		{
			var url:String = _text.content;
			
			if (_loads[url] == null)
			{
				_load = createLoad(url);
				_loads[url] = _load;
			}
			else _load = _loads[url];
			
			if (_load == null)
			{
				complete();
				return;
			}
			
			_load.onComplete = _fillLoad;			
			_load.start();		
		}
		
		private function _fillLoad():void
		{
			fillLoad(id, _load);
			complete();
		}
		
		protected function createLoad(url:String):AbstractLoad
		{
			var extension:String;
			
			extension = url.substring(url.lastIndexOf(".") + 1).toLowerCase();
			
			//trace("extension", url, extension);
			
			switch(extension)
			{
				case "swf":
				return new SWFLoad(url, _noCache == "true");					
				break;
				
				case "jpg":
				case "jpeg":
				case "png":
				return new BitmapDataLoad(url, _noCache == "true");
				break;
				
				case "xml":
				return new XMLLoad(url, _noCache != "false");
				break;
				
				default:
				return null;
			}
			
		}
		
		public function get content():* { return _load != null ? _load["content"] : null; }
		
	}
	
}