/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 08/06/2010 21:18
 * @version 0.1
 */

package org.looty.display 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import org.looty.core.looty;
	import org.looty.Looty;
	
	use namespace looty;
	
	public class Resizable 
	{
		
		private var _displayObject		:DisplayObject;
		private var _reference			:DisplayObject;
		
		private var _ratioX				:Number;
		private var _ratioY				:Number;
		private var _offsetX			:Number;
		private var _offsetY			:Number;
		private var _ratioWidth			:Number;
		private var _ratioHeight		:Number;
		private var _absolute			:Boolean;
		private var _keepAspectRatio	:Boolean;
		
		public function Resizable(displayObject:DisplayObject) 
		{
			if (displayObject == null) throw new IllegalOperationError("displayObject can't be null");
			_displayObject = displayObject;
			if (Looty.isInitialised) _reference = Looty.stage;
			else Looty.looty::onInitialisation.add(setStageReference);
			_ratioX = 0;
			_ratioY = 0;
			_offsetX = 0;
			_offsetY = 0;
			
			_keepAspectRatio = true;
		}		
		
		private function setStageReference():void
		{
			if (_reference == null) _reference = Looty.stage;
		}
		
		public function update():void
		{
			if (_reference == null) return;
			
			var w:Number = _reference is Stage ? Stage(_reference).stageWidth : _reference.width;
			var h:Number = _reference is Stage ? Stage(_reference).stageHeight : _reference.height;
			
			if (!isNaN(_ratioWidth))
			{
				_displayObject.width = w * _ratioWidth;
				if (_keepAspectRatio ) _displayObject.scaleY = _displayObject.scaleX;
			}
				
			if (!isNaN(_ratioHeight))
			{			
				_displayObject.height = h * _ratioHeight;
				if (_keepAspectRatio ) _displayObject.scaleX = _displayObject.scaleY;
			}
			
			_displayObject.x = _absolute ? 0 : _ratioX * w + _ratioX;
			_displayObject.y = _absolute ? 0 : _ratioY * h + _ratioY;
		}
		
		public function get ratioX():Number { return _ratioX; }
		
		public function set ratioX(value:Number):void 
		{
			_ratioX = value;
			update();
		}
		
		public function get ratioY():Number { return _ratioY; }
		
		public function set ratioY(value:Number):void 
		{
			_ratioY = value;
			update();
		}
		
		public function get offsetX():Number { return _offsetX; }
		
		public function set offsetX(value:Number):void 
		{
			_offsetX = value;
			update();
		}
		
		public function get offsetY():Number { return _offsetY; }
		
		public function set offsetY(value:Number):void 
		{
			_offsetY = value;
			update();
		}
		
		public function get ratioWidth():Number { return _ratioWidth; }
		
		public function set ratioWidth(value:Number):void 
		{
			_ratioWidth = value;
			update();
		}
		
		public function get ratioHeight():Number { return _ratioHeight; }
		
		public function set ratioHeight(value:Number):void 
		{
			_ratioHeight = value;
			update();
		}
		
		public function get absolute():Boolean { return _absolute; }
		
		public function set absolute(value:Boolean):void 
		{
			_absolute = value;
			update();
		}
		
		public function get keepAspectRatio():Boolean { return _keepAspectRatio; }
		
		public function set keepAspectRatio(value:Boolean):void 
		{
			_keepAspectRatio = value;
			update();
		}
		
		public function get displayObject():DisplayObject { return _displayObject; }
		
		public function get reference():DisplayObject { return _reference; }
		
		public function set reference(value:DisplayObject):void 
		{
			_reference = value;
		}
		
	}
	
}