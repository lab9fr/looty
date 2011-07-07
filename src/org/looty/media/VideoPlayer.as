/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/03/2010 21:22
 * @version 0.1
 */

package org.looty.media 
{
	
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import org.looty.display.*;
	import org.looty.log.Looger;
	import org.looty.sequence.*;
	import org.looty.core.*;
	
	
	use namespace looty;
	
	public class VideoPlayer extends CroppedLayer
	{
		
		private var _netConnection		:NetConnection;
		private var _netStream			:NetStream;
		private var _video				:Video;
		private var _url				:String;
		
		private var _duration			:Number;
		
		private var _load				:Sequencable;
		
		private var _isRepeating		:Boolean;
		
		private var _isInitialised		:Boolean;
		
		public function VideoPlayer(url:String, width:Number = 0, height:Number = 0, autoplay:Boolean = false) 
		{
			_url = url;
			
			super(width, height);
			
			_video = new Video();
			addChild(_video);
			
			if (autoplay) play();
			
			
			
		}
		
		private function initialise():void
		{
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_netConnection.connect(null);
			
			_isInitialised = true;
		}
		
		private function netStatusHandler(e:NetStatusEvent):void 
		{
			//trace("netstatus", e.info.code);
			
			switch (e.info.code) 
			{
                case "NetConnection.Connect.Success":					
                    _netStream = new NetStream(_netConnection);
					_netStream.client = { onMetadata : onMetaData, onCuePoint : onCuePoint };
					_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					_video.attachNetStream(_netStream);
					
					//_video.deblocking = 1;
					//_video.smoothing = false;
					
					_netStream.play(_url);
                    break;
					
				case "NetStream.Play.Start":
					
				break;
					
					
                case "NetStream.Play.StreamNotFound":
                    Looger.fatal("Stream not found : " + _url);
                break;
					
				case "NetStream.Play.Stop":
					if (_isRepeating) _netStream.seek(0);
					
				break;
				
				case "NetStream.Buffer.Full":
					_video.width = _video.videoWidth;
					_video.height = _video.videoHeight;
					updateSize();
				break;
            }
			
		}
		
		public function onMetaData(info:Object):void 
		{
			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			
			for (var prop:String in info) trace(prop, " : ", info[prop]);
			
		}
		
		public function onCuePoint(info:Object):void 
		{
			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		public function play():void
		{
			if (_isInitialised) _netStream.play();
			else initialise();
		}
		
		public function pause():void
		{
			_netStream.pause();
		}
		
		public function stop():void
		{
			_netStream.seek(0);
			_netStream.pause();
		}
		
		public function close():void
		{
			_netStream.close();
		}
		
		
		
		public function get netStream():NetStream { return _netStream; }
		
		public function get video():Video { return _video; }
		
		public function get duration():Number { return _duration; }
		
		public function get load():Sequencable 
		{
			if (_load == null) 
			{
				_load = new Sequencable();
				initialise();
			}
			return _load; 
		}
		
		public function get isRepeating():Boolean 
		{
			return _isRepeating;
		}
		
		public function set isRepeating(value:Boolean):void 
		{
			_isRepeating = value;
		}
		
	}
	
}