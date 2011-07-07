/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @version 0.1
 */

package org.looty.net 
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.net.URLVariables;
	
	//TODO : a lot of things ... datas through urlvars, onFlushStatus to precise.
	
	public class Session 
	{
		private var _sharedObject			:SharedObject;
		private var _size					:int;
		
		public function Session(name:String, size:int = 1000) 
		{
			_sharedObject 		= SharedObject.getLocal(name, "/");
			_size				= size;
		}		
		//FIXME : 
		public function get data ():URLVariables { return _sharedObject.data }
		
		public function set data (value:URLVariables):void 
		{
			//_sharedObject.data = value;
			update();
		}
		
		public function update():void
		{
			var flushStatus:String;
			
			try
			{
				flushStatus = _sharedObject.flush (_size);
			}
			catch (e:Error)
			{
				
			}
			
			switch (flushStatus) 
			{
                
				case SharedObjectFlushStatus.PENDING:
					//Requesting permission to save object...
					_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
				break;
				case SharedObjectFlushStatus.FLUSHED:
					//Value flushed to disk.
				break;
                
            }

		}
		
		private function onFlushStatus(event:NetStatusEvent):void 
		{
			switch (event.info.code) 
			{
				case "SharedObject.Flush.Success":
					//User granted permission -- value saved.
				break;
				
				case "SharedObject.Flush.Failed":
					//User denied permission -- value not saved.
				break;
			}

			_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }

		
		public function get sharedObject():SharedObject { return _sharedObject; }
		
		public function get capping():int 
		{
			if (!_sharedObject.data.hasOwnProperty("capping")) 
			{
				_sharedObject.data.capping = 1;
				update();
				return 0;
			}
			var c:int = int(_sharedObject.data.capping);
			_sharedObject.data.capping = c + 1;
			update();
			return c; 
		}
		
	}
	
}