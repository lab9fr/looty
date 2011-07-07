/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 14/01/2010 22:24
 * @version 0.1
 */

package org.looty.interactive 
{
	import flash.display.*;
	import flash.errors.*;
	
	public class MultiColoredInteraction extends ColoredInteraction
	{
		
		
		
		private var _baseColors			:Array;
		private var _overColors			:Array;
		private var _selectedColors		:Array;
		
		private var _index				:int;
		
		private var _states				:Array;
		
		public function MultiColoredInteraction(target:InteractiveObject) 
		{
			super(target);
			
			stateDuration = 0.4;
			
			_baseColors = [];
			_overColors = [];
			_selectedColors = [];
			_states = [];
		}
		
		public function setColors(state:String, baseColor:uint, overColor:uint, selectedColor:uint):void
		{
			state = state.toLowerCase();
			if (_states.indexOf(state) == -1) _states.push(state);
			var index:int = _states.indexOf(state);
			
			_baseColors[index] = baseColor;
			_overColors[index] = overColor;
			_selectedColors[index] = selectedColor;
			
			if (_states.length == 1) this.state = state;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			_baseColors = null;
			_overColors = null;
			_selectedColors = null;
		}
		
		public function get state():String { return _states[_index]; }
		
		public function set state(value:String):void 
		{
			value = value.toLowerCase();
			var next:int = _states.indexOf(value);
			if (next == -1) throw new IllegalOperationError("wrong state");
			if (_index == next) return;
			
			_index = next;
			
			setColor(_baseColors[_index], _overColors[_index], _selectedColors[_index]);			
		}
		
	}
	
}