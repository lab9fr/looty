/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.core.net
{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import org.looty.core.looty;
	import org.looty.core.net.AbstractDisplayLoad;
	import org.looty.log.Looger;
	
	use namespace looty;

	public class DisplayLoader extends AbstractDispatcher
	{
		
		private var _hasLoaded		:Boolean;
		
		private var _loader			:Loader;
		
		public function DisplayLoader() 
		{
			_loader = new Loader();
			
			super(_loader.contentLoaderInfo);
		}
		
		override public function reset():void 
		{
			super.reset();
			
			try 
			{
				loader.close();
			}
			catch (error:Error)
			{
				
			}
			
			loader.unload();			
		}
		
		override public function start():void 
		{
			super.start();
			
			_hasLoaded = true;
			
			loader.loadBytes(load.bytes, displayLoad.loaderContext);
		}
		
		override protected function handleContent():void 
		{
			load.looty::fillContent(loader.content);
			
			//loader.unloadAndStop(true); //FIXME : kills font loaded externally		
		}
		
		public function get loader():Loader { return _loader; }	
		
		public function get displayLoad():AbstractDisplayLoad { return AbstractDisplayLoad(load); }
		
	}

}