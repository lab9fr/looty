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
	import com.djamplayer.core.media.ProgressiveVideoPlayer;
	import com.djamplayer.core.state.PlayerState;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.setTimeout;

	public class ProgressiveClient extends AbstractClient
	{
		
		public function ProgressiveClient() 
		{
			super();
		}
		
		override public function asyncErrorHandler(e:AsyncErrorEvent):void 
		{
			super.asyncErrorHandler(e);
			
			videoPlayer.state = PlayerState.CONNECTION_ERROR;
		}
		
		override public function IOErrorHandler(e:IOErrorEvent):void 
		{
			super.IOErrorHandler(e);
			
			videoPlayer.state = PlayerState.CONNECTION_ERROR;
		}
		
		override public function securityErrorHandler(e:SecurityErrorEvent):void 
		{
			super.securityErrorHandler(e);
			
			videoPlayer.state = PlayerState.CONNECTION_ERROR;
		}
		
		override public function netStatusHandler(e:NetStatusEvent):void 
		{
			super.netStatusHandler(e);
			
			switch(e.info.code)
			{
				case NetConnectionStatus.CONNECT_SUCCESS:
				protected::isConnected = true;
				videoPlayer.state = PlayerState.STOPPED;
				break;
				
				case NetConnectionStatus.CONNECT_CLOSED:
				protected::isConnected = false;
				videoPlayer.state = PlayerState.DISCONNECTED;
				break;
				
				case NetStreamStatus.BUFFER_EMPTY:
				videoPlayer.state = PlayerState.BUFFERING;
				break;
				
				case NetStreamStatus.BUFFER_FLUSH:
				
				break;
				
				case NetStreamStatus.PLAY_START:
				//case NetStreamStatus.BUFFER_FULL:
				videoPlayer.state = PlayerState.PLAYING;				
				break;
				
				
				
				case NetStreamStatus.PLAY_STOP:
				videoPlayer.playComplete();
				break;
				
				case NetStreamStatus.PLAY_NO_SUPPORTED_TRACK_FOUND:
				case NetStreamStatus.FAILED:
				case NetStreamStatus.PLAY_FAILED:
				case NetStreamStatus.PLAY_FILE_STRUCTURE_INVALID:				
				case NetConnectionStatus.CONNECT_APP_SHUTDOWN:
				case NetConnectionStatus.CONNECT_FAILED:
				case NetConnectionStatus.CONNECT_REJECTED:
				videoPlayer.state = PlayerState.CONNECTION_ERROR;
				break;
			}
		}
		
		override public function onMetaData(metaData:Object):void
		{
			super.onMetaData(metaData);
		}
		
		override public function onXMPData(info:Object):void 
		{
			//super.onXMPData(info);
		}
		
		protected function get progressiveVideoPlayer():ProgressiveVideoPlayer { return ProgressiveVideoPlayer(videoPlayer); }
		
	}

}