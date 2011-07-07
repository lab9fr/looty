/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/03/2010 21:22
 * @version 0.1
 */

package org.looty.core.media 
{
	import com.djamplayer.core.media.AbstractVideoPlayer;
	import com.djamplayer.core.system.Disposable;
	import flash.events.*;

	public class AbstractClient extends Disposable
	{
		
		private var _videoPlayer		:AbstractVideoPlayer;
		
		private var _hasMetaData		:Boolean;
		
		private var _metaData			:Object;
		
		private var _isConnected		:Boolean;
		
		private var _duration			:Number;
		
		public function AbstractClient() 
		{
			_duration = 0;
		}
		
		public function setPlayer(videoPlayer:AbstractVideoPlayer):void
		{
			_videoPlayer = videoPlayer;
		}
		
		public function asyncErrorHandler(e:AsyncErrorEvent):void
		{
			//trace("[AsyncErrorEvent]", e.error);
		}
		
		public function IOErrorHandler(e:IOErrorEvent):void
		{
			//trace("[IOErrorEvent]");
		}
		
		public function securityErrorHandler(e:SecurityErrorEvent):void
		{
			//trace("[SecurityErrorEvent]");
		}
		
		public function netStatusHandler(e:NetStatusEvent):void
		{
			//trace("[NetStatusEvent]#######################################");
			//for (var prop:* in e.info) trace("#", prop, " : ", e.info[prop]);
		}
		
		public function onStatus(info:Object):void
		{
			//trace("[onStatus]#######################################");
			//for (var prop:* in info) trace("#", prop, " : ", info[prop]);
		}
		
		public function onPlayStatus(info:Object):void
		{
			//trace("[onPlayStatus]#######################################");
			
			//for (var prop:* in info) trace("#", prop, " : ", info[prop]);
			
			
		}
		
		public function onXMPData(info:Object):void
		{
			//trace("[onXMPData]#######################################");
			//for (var prop:* in info) trace("#", prop, " : ", info[prop]);
		}
		
		public function onMetaData(metaData:Object):void
		{
			//trace("[onMetaData]#######################################");
			//for (var prop:* in metaData) //trace("#", prop, " : ", metaData[prop]);
			
			videoPlayer.setScreenSize(metaData.width, metaData.height);
			_duration = metaData.duration;
			
		}
		
		public function onCuePoint(cuePoint:Object):void
		{
			//trace("[onCuePoint]#######################################");
			//for (var prop:* in cuePoint) trace("#", prop, " : ", cuePoint[prop]);
		}
		
		override public function dispose():void 
		{
			_videoPlayer = null;
		}
		
		protected function get videoPlayer():AbstractVideoPlayer { return _videoPlayer; }
		
		public function get metaData():Object { return _metaData; }
		
		public function get isConnected():Boolean { return _isConnected; }
		
		protected function set isConnected(value:Boolean):void 
		{
			_isConnected = value;
		}
		
		public function get duration():Number { return _duration; }
		
	}

}