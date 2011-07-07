/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.interactive 
{
	import flash.display.*;
	import flash.net.*;
	import flash.utils.*;
	import org.looty.activable.Activable;
	import org.looty.core.*;
	import org.looty.core.disposable.IDisposable;
	import org.looty.core.handlers.MouseInteractionHandler;
	import org.looty.log.Looger;
	
	use namespace looty;
	
	public class Interaction extends Activable
	{
		private var _onMouseOver		:Function;
		private var _onMouseOut			:Function;
		private var _onMouseDown		:Function;
		private var _onMouseUp			:Function;
		
		private var _isMouseDown		:Boolean;
		private var _isMouseOver		:Boolean;
		
		private var _buttonMode			:Boolean;
		private var _mouseEnabled		:Boolean;
		
		private var _url				:String;
		private var _window				:String;
		
		private var _targets			:Dictionary;
		private var _target				:InteractiveObject;
		
		private var _targetIndex		:uint;
		
		static private const HANDLER	:MouseInteractionHandler = new MouseInteractionHandler();
		
		
		public function Interaction(target:InteractiveObject = null) 
		{
			_url = "";
			_targets = new Dictionary(true);
			_target = target;
			addTarget(target);	
			
			this.buttonMode = true;
		}
		
		override protected function doActivate():void 
		{
			for (var target:* in _targets) if (target != null) HANDLER.register(target, this);
		}
		
		override protected function doDeactivate():void 
		{
			for (var target:* in _targets) if (target != null) HANDLER.unregister(target);
		}
		
		public function get onMouseOver():Function { return _onMouseOver; }
		
		public function set onMouseOver(value:Function):void 
		{
			_onMouseOver = value;
		}
		
		public function mouseOver():void
		{
			if (_isMouseOver) return;
			_isMouseOver = true;
			if (Boolean(_onMouseOver)) _onMouseOver();
		}
		
		public function get onMouseOut():Function { return _onMouseOut; }
		
		public function set onMouseOut(value:Function):void 
		{
			_onMouseOut = value;
		}
		
		public function mouseOut():void
		{
			if (!_isMouseOver) return;
			_isMouseOver = false;
			if (Boolean(_onMouseOut)) _onMouseOut();
		}
		
		public function get onMouseDown():Function { return _onMouseDown; }
		
		public function set onMouseDown(value:Function):void 
		{
			_onMouseDown = value;
		}
		
		public function mouseDown():void
		{
			if (_isMouseDown) return;
			_isMouseDown = true;
			
			HANDLER.focusDown(this);
			
			if (_url != "") navigateToURL(new URLRequest(_url), _window || "_blank");
			if (Boolean(_onMouseDown)) _onMouseDown();
		}
		
		public function get onMouseUp():Function { return _onMouseUp; }
		
		public function set onMouseUp(value:Function):void 
		{
			_onMouseUp = value;
		}
		
		public function mouseUp():void
		{
			if (!_isMouseDown) return;
			_isMouseDown = false;
			
			HANDLER.focusUp(this);
			
			if (Boolean(_onMouseUp)) _onMouseUp();
		}
		
		public function get isMouseDown():Boolean { return _isMouseDown; }
		
		looty function set isMouseDown(value:Boolean):void 
		{
			_isMouseDown = value;
		}
		
		public function get isMouseOver():Boolean { return _isMouseOver; }
		
		looty function set isMouseOver(value:Boolean):void 
		{
			_isMouseOver = value;
		}
		
		public function addTarget(target:InteractiveObject):InteractiveObject
		{
			if (target == null)
			{
				Looger.error("can't add an Interaction on a null target");
				return null;
			}
			
			if (isActive) HANDLER.register(target, this);
			_targets[target] = _targetIndex;
			++ _targetIndex;
			applyButtonMode();
			return target;
		}
		
		public function removeTarget(target:InteractiveObject):InteractiveObject
		{
			if (target == null) return null;
			HANDLER.unregister(target);
			_targets[target] = null;
			delete _targets[target];
			if (_target == target) _target = getTargets()[0];
			return target;
		}
		
		public function get buttonMode():Boolean { return _buttonMode; }
		
		public function set buttonMode(value:Boolean):void 
		{
			_buttonMode = value;
			applyButtonMode();
		}
		
		public function get mouseEnabled():Boolean { return _mouseEnabled; }
		
		public function set mouseEnabled(value:Boolean):void 
		{
			_mouseEnabled = value;
			
			for (var target:* in _targets) 
			{
				target.mouseEnabled = value;
				target.mouseChildren = !value;
			}
		}
		
		looty function get targets():Dictionary { return _targets; }
		
		public function get url():String { return _url; }
		
		public function set url(value:String):void 
		{
			_url = value;			
		}
		
		public function get window():String { return _window; }
		
		public function set window(value:String):void 
		{
			_window = value;
		}
		
		public function getTargets():Array
		{
			var array:Array = [];
			for (var io:* in _targets) if (_targets[io] != null && !isNaN(_targets[io])) array[uint(_targets[io])] = io;
			array.filter(filterNull);
			return array;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_target = null;
			_targets = null;
		}
		
		private function filterNull(io:InteractiveObject, index:int, array:Array):Boolean 
		{
			return io != null
		}
		
		public function get target():InteractiveObject 
		{ 
			return _target;
		}
		
		private function applyButtonMode():void
		{
			for (var target:* in _targets) if (target is Sprite) 
			{
				target.mouseChildren = false;
				target.buttonMode = _buttonMode;
			}	
		}
		
	}
	
}