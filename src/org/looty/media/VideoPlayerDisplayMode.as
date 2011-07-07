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
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import org.looty.Looty;

	public final class VideoPlayerDisplayMode
	{
		
		/**
		 * player will resize to the video size.
		 */
		static public const PLAYER_AUTO_FIT		:VideoPlayerDisplayMode 		= new DjamPlayerDisplayMode("playerAutoFit");
		
		/**
		 * picture will fill the entire player without trying to preserve the original aspect ratio.
		 */
		static public const STRETCHED_FIT		:VideoPlayerDisplayMode 		= new DjamPlayerDisplayMode("stretchedFit");
		
		/**
		 * picture will fill the entire player, without distortion but possibly with some cropping, while maintaining the original aspect ratio.
		 */
		static public const CROPPED_FIT			:VideoPlayerDisplayMode 		= new DjamPlayerDisplayMode("croppedFit");
		
		/**
		 * picture will fill the width or the height of the player, with some borders, while maintaining the original aspect ratio
		 */
		static public const LETTERBOX			:VideoPlayerDisplayMode			= new DjamPlayerDisplayMode("letterbox");
		
		/**
		 * picture will keep orginal format
		 */
		static public const NO_SCALE			:VideoPlayerDisplayMode 		= new DjamPlayerDisplayMode("noScale");
		
		private var _type			:String;
		
		public function VideoPlayerDisplayMode(type:String) 
		{
			_type = type;
		}
		
		internal function changeState(player:VideoPlayer):void
		{		
			switch(true)
			{
				case type == FULLSCREEN.type && !_isFullScreen :
				
				if (_stage == null) return;
				_player = player;
				Looty.stage.displayState = StageDisplayState.FULL_SCREEN;							
				break;
				
				case _isFullScreen && type != FULLSCREEN.type :
				_player = null;
				Looty.stage.displayState = StageDisplayState.NORMAL;			
				break;				
			}		
		}
		
		private function handleFullScreen(e:FullScreenEvent):void 
		{
			switch(true)
			{
				
				case e.fullScreen && !_isFullScreen:
				_isFullScreen = true;
				_player.x = 0;
				_player.y = 0;
				_player.width = _stage.fullScreenWidth;
				_player.height = _stage.fullScreenHeight;
				
				Looty.stage.addChild(_player);
				Looty.stage.align = StageAlign.TOP_LEFT;
				Looty.stage.scaleMode = StageScaleMode.NO_SCALE;	
				
				break;
				
				case !e.fullScreen && _isFullScreen:
				_isFullScreen = false;
				_player.uncacheDisplay();				
			} 
		}
		
		internal function resize(palyer:VideoPlayer):void
		{			
			if (player.screenWidth == 0 || player.screenHeight == 0) return;	
			
			var rw:Number = djamPlayer.width / player.screenWidth ;
			var rh:Number = djamPlayer.height / player.screenHeight;			
			
			switch(type)
			{
				case PLAYER_AUTO_FIT.type:
				player.x = 0;
				player.y = 0;
				player.width = player.screenWidth;
				player.height = player.screenHeight;
				if (djamPlayer.width != player.screenWidth || djamPlayer.height != player.screenHeight) djamPlayer.setSize(player.screenWidth, player.screenHeight);
				break;
				
				case STRETCHED_FIT.type:
				player.x = 0;
				player.y = 0;
				player.width = djamPlayer.width ;
				player.height = djamPlayer.height;				
				break;
				
				case CROPPED_FIT.type:
				case FULLSCREEN.type:
				if (rw > rh)
				{
					player.width = djamPlayer.width;
					player.height = rw * player.screenHeight;
					player.x = 0;
					player.y = (djamPlayer.height - player.height) >> 1;
					
				}
				else
				{
					player.height = djamPlayer.height;
					player.width = rh * player.screenWidth;
					player.x = (djamPlayer.width - player.width) >> 1;
					player.y = 0;
					
					
				}
				
				break;
				
				case LETTERBOX.type:
				if (rw < rh)
				{
					player.width = djamPlayer.width;
					player.height = rw * player.screenHeight;
					player.x = 0;
					player.y = (djamPlayer.height - player.height) >> 1;
					//trace("#1",player.width, player.height, player.x, player.y);
				}
				else
				{
					player.height = djamPlayer.height;
					player.width = rh * player.screenWidth;
					player.x = (djamPlayer.width - player.width) >> 1 ;
					player.y = 0;
					//trace("#2",rh * player.screenWidth, player.screenWidth, player.width, player.height, player.x, player.y);
				}
				break;
				
				case NO_SCALE.type:
				default:
				player.width = player.screenWidth;
				player.height = player.screenHeight;
				player.x = (djamPlayer.width - player.width) >> 1;
				player.y = (djamPlayer.height - player.height) >> 1;
				
				
			}
		}		
		
		public function get type():String { return _type; }
		
	}

}