/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

//FIXME : requestHeaders & contentType not working

package org.looty.core.net
{
	import flash.events.Event;
	import flash.net.*;
	import flash.utils.ByteArray;

	public class StreamLoader extends AbstractDispatcher
	{
		
		public function StreamLoader() 
		{
			super(new URLStream());
		}
		
		override public function reset():void 
		{
			super.reset();
			
			if (urlStream.connected) urlStream.close();
		}
		
		override public function start():void 
		{
			super.start();
			
			if (load.noCache) 
			{
				load.urlVariables.nocache = String(new Date().getTime() + Math.random()).replace(".", "");
				//if (load.request.requestHeaders == null) load.request.requestHeaders = [];
				load.request.requestHeaders.push(new URLRequestHeader("Cache-Control", "no-store, no-cache, must-revalidate"));
				load.request.requestHeaders.push(new URLRequestHeader("Pragma", "no-cache"));
				load.request.requestHeaders.push(new URLRequestHeader("Cache", "no store"));
				load.request.requestHeaders.push(new URLRequestHeader("Expires", "0"));
			}
			
			//trace(load.url);
			//trace(load.request.requestHeaders);
			//trace(load.request.method);
			//trace(load.request.contentType);
			
			urlStream.load(load.request);			
		}
		
		override protected function handleContent():void 
		{			
			urlStream.readBytes(load.bytes, 0, urlStream.bytesAvailable);			
		}
		
		public function get urlStream():URLStream { return URLStream(dispatcher); }	
		
	}

}