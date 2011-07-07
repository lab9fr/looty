/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 09/12/2009 06:01
 * @version 0.1
 */

package org.looty.media 
{
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import org.looty.log.Looger;
	
	//TODO : onComplete, infinite loops, load...
	
	public class SoundPlayer 
	{
		
		private var _sound				:Sound;
		private var _soundChannel		:SoundChannel;
		private var _soundTransform		:SoundTransform;
		
		private var _source				:String;
		
		private var _volume				:Number;
		
		private var _loops				:int;
		
		private var _playhead			:Number;
		
		private var _isPlaying			:Boolean;
		
		public function SoundPlayer() 
		{
			_playhead = 0;
			_soundTransform = new SoundTransform();
			_soundTransform.volume = .6;
			_volume = 0.6;
		}
		
		public function play():void
		{
			if (_isPlaying) return;
			_isPlaying = true;
			_soundChannel = _sound.play(_playhead, _loops, _soundTransform);
		}
		
		public function pause():void
		{
			if (!_isPlaying) return;
			_isPlaying = false;
			_playhead = _soundChannel.position;
			if (_soundChannel != null) _soundChannel.stop();
		}
		
		public function stop():void
		{
			if (!_isPlaying) return;
			_isPlaying = false;
			_playhead = 0;
			if (_soundChannel != null) _soundChannel.stop();
		}
		
		
		private function rewind():void
		{
			stop();
			play();
		}
		
		private function close():void
		{
			if (_sound == null) return;
			
			stop();
			_sound.close();
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_sound = null;
			_soundChannel = null;
		}
		
		public function get source():String { return _source; }
		
		public function set source(value:String):void 
		{
			if (_source == value)
			{
				rewind();
				return;
			}
			
			close();
			
			_source = value;
			_sound = new Sound(new URLRequest(value));
			_sound.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
		
		private function handleIOError(e:IOErrorEvent):void 
		{
			Looger.error("Sound IOError");
		}	
		
		public function get volume():Number { return _volume; }
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			if (_volume > 1) _volume = 1;
			if (_volume < 0) _volume = 0;
			_soundTransform.volume = _volume;
			if (_soundChannel != null) _soundChannel.soundTransform = _soundTransform
		}
		
		public function get loops():int { return _loops; }
		
		public function set loops(value:int):void 
		{
			_loops = value;
			if (_isPlaying) 
			{
				pause();
				play();
			}
			
		}
		
		public function get isPlaying():Boolean { return _isPlaying; }
		
	}
	
}