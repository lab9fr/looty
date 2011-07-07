/**
 * @project looty
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @version 1.0
 */

package org.looty.core.net
{
	import flash.net.URLStream;
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.log.Looger;
	import org.looty.net.ILoad;
	import org.looty.pattern.Singleton;
	
	//TODO : implement filereference
	//TODO : add bandwidth test
	
	use namespace looty;
	
	public class MassLoader extends Singleton
	{
		
		private var _streamQueue	:Array;
		private var _displayQueue	:Array;
		private var _duplicateds	:Array;
		
		private var _streamLoaders	:Array;
		private var _displayLoader	:DisplayLoader;
		
		private const maxConcurentLoads	:int = 4;	
		
		public function MassLoader() 
		{
			super();
			
			_streamLoaders = [];
			_streamQueue = [];
			_displayQueue = [];
			_duplicateds = [];
			
			var streamLoader:StreamLoader;
			var i:int;
			for (i = 0; i < maxConcurentLoads; ++i) 
			{
				streamLoader = new StreamLoader();
				streamLoader.loadNext = loadNextStream;
				_streamLoaders.push(streamLoader);
			}
			
			_streamQueue = [];
			_displayLoader = new DisplayLoader();
			_displayLoader.loadNext = loadNextDisplay;
		}
		
		static private function get instance ():MassLoader
		{
			return getInstanceOf(MassLoader);
		}
		
		static public function enqueue(load:AbstractLoad):void
		{
			instance._enqueue(load);
		}
		
		private function _enqueue(load:AbstractLoad):void
		{
			switch(load.loadType)
			{
				case LoadType.DISPLAY_LOAD:
				case LoadType.STREAM_LOAD :
				_streamQueue.push(load);
				loadNextStream();
				break;
				
			}			
		}
		
		private function loadNextStream(load:AbstractLoad = null):void
		{
			if (Boolean(load))
			{
				switch(load.loadType)
				{
					case LoadType.STREAM_LOAD :
					load.looty::fillContent();
					break;
					
					case LoadType.DISPLAY_LOAD :
					_displayQueue.push(load);
					loadNextDisplay();
					break;
				}
			}
			
			
			var streamLoader:StreamLoader;
			var loader:StreamLoader;
			var currents:Array = [];
			
			for each (streamLoader in _streamLoaders)
			{
				if (streamLoader.isProcessing) currents.push(streamLoader.load.url)
				else if (loader == null) loader = streamLoader;
			}
			
			if (_displayLoader.isProcessing) currents.push(_displayLoader.load.url);
			
			
			for each (var duplicated:AbstractLoad in _duplicateds)
			{
				if (currents.indexOf(duplicated.url) == -1)
				{
					_streamQueue.unshift(duplicated)
					_duplicateds.splice(_duplicateds.indexOf(duplicated), 1);
				}
			}
			
			if (loader == null || _streamQueue.length == 0) return;
			
			var next:AbstractLoad = _streamQueue.shift();
			
			if (currents.indexOf(next.url) != -1)
			{
				_duplicateds.push(next);
				loadNextStream();
				return;
			}
			
			loader.setLoad(next, next.loadType == LoadType.STREAM_LOAD);			
		}
		
		private function loadNextDisplay(load:AbstractLoad = null):void
		{
			if (!_displayLoader.isProcessing && _displayQueue.length > 0)
			{
				_displayLoader.setLoad(_displayQueue.shift());
			}
			
			if (load != null) loadNextStream();
		}
		
	}
	
}