/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @version 0.1
 */

package org.looty.net 
{
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import org.looty.core.*;
	import org.looty.core.display.*;
	import org.looty.core.net.*;
	import org.looty.data.DistantCommand;
	import org.looty.log.*;
	import org.looty.Looty;
	import org.looty.sequence.*;
	import org.looty.tracking.IExternalLoaderTracker;
	
	use namespace looty;
	
	public class ExternalLoader extends Sprite
	{
		
		private var _swfLoad				:SWFLoad;		
		private var _content				:Sprite;		
		private var _smoother				:ProgressSmoother;		
		private var _isComplete				:Boolean;		
		private var _url					:String;		
		private var _noCache				:Boolean;
		
		private var _mainRatio				:Number;		
		private var _mainProgress			:Number;
		
		private var _bootStrapCommand		:DistantCommand; 		
		private var _command				:DistantCommand;
		
		private var _unselection			:ISequencable;
		
		private var _trackers				:Array;
			
		static public const COMMAND_ID		:String = "org.looty.net.ExternalLoader";
		
		//TODO : finish trackers implementation
		
		public function ExternalLoader(url:String = "", noCache:Boolean = false, isRelease:Boolean = false, isResizable:Boolean = false, isLowerQuality:Boolean = false) 
		{
			_mainRatio = 0;
			_mainProgress = 0;
			
			_bootStrapCommand = DistantCommand.getCommand("org.looty.mvc.BootStrap");
			_command = DistantCommand.getCommand(COMMAND_ID);
			
			Looty.initialise(stage);
			
			if (isRelease) Looger.removeMode(Looger.TRACE_MODE);			
			if (isLowerQuality) stage.quality = StageQuality.MEDIUM;
			if (isResizable) 
			{
				visible = false;
				Looty.addResize(doResize);
				Looty.delayedCall(0, doResize);
			}
			
			_noCache = noCache;		
			
			_url = Looty.parameters.main || url || "";
		}
		
		public function addTracker(tracker:IExternalLoaderTracker):void
		{
			if (_trackers == null) _trackers = [];
			_trackers.push(tracker);
		}
		
		private function doResize():void 
		{
			visible = true;
			resize();
		}
		
		private function doComplete():void
		{
			_content = _swfLoad.content;
			
			_isComplete = true;
			
			_swfLoad = null;
			
			onComplete();
		}
		
		public function start():void
		{
			for each (var tracker:IExternalLoaderTracker in _trackers) tracker.start();
			
			_swfLoad = new SWFLoad(url, noCache, true);
			_swfLoad.onProgress = onProgress;
			_swfLoad.onError = onError;
			_swfLoad.onComplete = doComplete;
			if (_smoother != null) _swfLoad.smoother = _smoother;
			_swfLoad.start();
		}
		
		
		/*******************************************************************************************************************************************
		 * protected & public methods
		 *******************************************************************************************************************************************/
		
		protected function resize():void
		{
			//to be overriden through inheritance
		}
		
		protected function onProgress():void
		{
			//to be overriden through inheritance
		}
		
		protected function onComplete():void
		{
			startBootStrap();
		}
		
		protected function onError():void
		{
			//to be overriden through inheritance
		}
		
		looty function setMainProgress(value:Number):void
		{
			_mainProgress = value;
			onProgress();
		}
		
		public function get progress():Number { return (_isComplete ? 1 : _swfLoad.progress) * (1 - _mainRatio)  + _mainProgress * _mainRatio; }
		
		public function get content():Sprite { return _content; }
		
		public function get stageWidth():Number { return stage.stageWidth; }
		
		public function get stageHeight():Number { return stage.stageHeight; }
		
		public function get smoother():ProgressSmoother { return _swfLoad.smoother; }
		
		public function set smoother(value:ProgressSmoother):void 
		{
			_smoother = value;
			if (_swfLoad != null) _swfLoad.smoother = value;
		}
		
		public function get url():String { return _url; }
		
		public function set url(value:String):void 
		{
			_url = value;
		}
		
		public function get noCache():Boolean { return _noCache; }
		
		public function set noCache(value:Boolean):void 
		{
			_noCache = value;
		}
		
		public function get mainRatio():Number { return _mainRatio; }
		
		public function set mainRatio(value:Number):void 
		{
			if (value >= 1 || value <= 0) 
			{
				value = 1;
				_command.unregister(COMMAND_ID + "_setMainProgress");
			}
			else _command.register(COMMAND_ID + "_setMainProgress", looty::setMainProgress);			
			
			_mainRatio = value;
		}
		
		looty function getUnselection():ISequencable { return _unselection; }
		
		public function get unselection():ISequencable { return _unselection; }
		
		public function set unselection(value:ISequencable):void 
		{
			_unselection = value;
			if (_unselection != null) _command.register(COMMAND_ID + "_getUnselection", getUnselection);
			else _command.unregister(COMMAND_ID + "_getUnselection");
		}
		
		public function get bootStrapCommand():DistantCommand { return _bootStrapCommand; }
		
		public function get command():DistantCommand { return _command; }
		
		public function startBootStrap():void
		{
			if (!_isComplete) 
			{
				Looger.error("BootStrap can't be started before completion of the loading");
				return;
			}
			_bootStrapCommand.execute("org.looty.mvc.BootStrap_start");	
		}
		
	}

}