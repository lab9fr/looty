/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.mvc.view 
{
	import flash.display.StageDisplayState;
	import flash.errors.IllegalOperationError;
	import flash.events.FullScreenEvent;
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.log.Looger;
	import org.looty.Looty;
	import org.looty.mvc.view.Mediator;
	
	use namespace looty;

	public class View extends Mediator
	{
		
		private var _isFullScreen					:Boolean;
		private var _onDisplayStateChange			:Function;
		
		private var _isStarted						:Boolean;
		
		public function View() 
		{
			layer.visible = false;			
			isRendering = false;
			
			command.register("start", start);
		}
		
		public function get isFullScreen():Boolean { return _isFullScreen; }
		
		public function set isFullScreen(value:Boolean):void 
		{
			if (value == _isFullScreen) return;
			_isFullScreen = value;
			
			value ? Looty.enterFullScreen() : Looty.exitFullScreen();
			
			if (Boolean(_onDisplayStateChange)) _onDisplayStateChange();
		}
		
		private function start():void
		{
			if (_isStarted) return;
			_isStarted = true;
			
			Looty.addEnterFrame(looty::doRender);
			Looty.addResize(doResize);
			Looty.stage.addChildAt(layer, 0);	
			
			resize();
			layer.visible = true;
			isRendering = true;
		}
		
		public function get onDisplayStateChange():Function { return _onDisplayStateChange; }
		
		public function set onDisplayStateChange(value:Function):void 
		{
			_onDisplayStateChange = value;
		}		
		
		final override public function set component(value:*):void 
		{
			throw new IllegalOperationError("component setter is disabled on View. Yes it is.");
			//super.component = value;
		}
		
	}
	
}