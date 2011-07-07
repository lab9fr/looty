/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 27/01/2010 21:03
 * @version 0.1
 */

package org.looty.interactive 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import org.looty.log.Looger;
	
	public class ToggleInteraction extends Interaction
	{
		
		static public const ON		:String = "on";
		static public const OFF		:String = "off";
		
		public var onToggleOn		:Function;
		public var onToggleOff		:Function;
		
		private var _allowOn			:Boolean;
		private var _allowOff		:Boolean;
		
		private var _state			:String;
		
		
		public function ToggleInteraction(target:InteractiveObject, initialState:String = "off") 
		{
			super(target);
			
			_allowOn = true;
			_allowOff = true;
			
			switch(initialState)
			{
				case ON:
				_state = ON;
				break;
				
				case OFF:
				default:
				_state = OFF;
				break;
			}
		}
		
		override public function mouseDown():void 
		{
			super.mouseDown();
			toggle();
		}
		
		public function off():void
		{
			if (!_allowOff) return;
			_state = OFF;
			if (Boolean(onToggleOff)) onToggleOff();
		}
		
		public function on():void
		{
			if (!_allowOn) return;
			_state = ON;
			if (Boolean(onToggleOn)) onToggleOn();
		}
		
		public function toggle():void
		{			
			switch(_state)
			{
				case ON:
				off();
				break;
				
				case OFF:
				on();
				break;				
			}
		}
		
		public function stateOn():void
		{
			_state = ON;
		}
		
		public function stateOff():void
		{
			_state = OFF;
		}
		
		public function get state():String { return _state; }
		
		public function set state(value:String):void 
		{
			switch(true)
			{
				case _state == ON && value == OFF:
				off();
				break;
				
				case _state == OFF && value == ON:
				on();
				break;
				
				default:
				Looger.warn("trying to set the same state or a value not corresponding to any state state to ToggleButton"); 
				return;
			}
		}
		
		public function get allowOn():Boolean { return _allowOn; }
		
		public function set allowOn(value:Boolean):void 
		{
			_allowOn = value;
		}
		
		public function get allowOff():Boolean { return _allowOff; }
		
		public function set allowOff(value:Boolean):void 
		{
			_allowOff = value;
		}
		
	}
	
}