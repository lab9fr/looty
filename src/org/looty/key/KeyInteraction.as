/**
 * @project looty
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 19/12/2010 17:38
 * @version 0.1
 */

package org.looty.key 
{
	import org.looty.activable.Activable;
	import org.looty.core.handlers.KeyInteractionHandler;
	
	public class KeyInteraction extends Activable
	{
		
		static private const HANDLER			:KeyInteractionHandler = new KeyInteractionHandler();
		
		static public const SHIFT_COMBINATION	:uint = 0;
		static public const CTRL_COMBINATION	:uint = 1;
		static public const ALT_COMBINATION		:uint = 2;
		
		private var _onKeyDown			:Function;
		private var _onKeyUp			:Function;
		
		private var _isKeyDown			:Boolean;
		private var _ignoreCombination	:Boolean;
		
		private var _combination		:uint;
		
		private var _keyCode			:uint;
		
		public function KeyInteraction(keyCode:uint, ignoreCombination:Boolean = true, shiftCombination:Boolean = false, ctrlCombination:Boolean = false, altCombination:Boolean = false) 
		{
			_keyCode = keyCode;
			super();
			_combination = (uint(shiftCombination) << SHIFT_COMBINATION) | (uint(ctrlCombination) << CTRL_COMBINATION) | (uint(altCombination) << ALT_COMBINATION);
			_ignoreCombination = ignoreCombination;
		}
		
		override protected function doActivate():void 
		{
			HANDLER.register(this);
		}
		
		override protected function doDeactivate():void 
		{
			HANDLER.unregister(this);
		}
		
		public function keyDown(combination:uint = 0):void
		{
			if (_isKeyDown || (!_ignoreCombination && _combination != combination)) return;
			_isKeyDown = true;
			if (Boolean(_onKeyDown)) _onKeyDown();
		}
		
		public function get onKeyDown():Function { return _onKeyDown; }
		
		public function set onKeyDown(value:Function):void 
		{
			_onKeyDown = value;
		}
		
		public function keyUp():void
		{
			if (!_isKeyDown) return;
			_isKeyDown = false;
			if (Boolean(_onKeyUp)) _onKeyUp();
		}
		
		public function get onKeyUp():Function { return _onKeyUp; }
		
		public function set onKeyUp(value:Function):void 
		{
			_onKeyUp = value;
		}
		
		public function get keyCode():uint { return _keyCode; }
		
		public function get isKeyDown():Boolean { return _isKeyDown; }
		
	}

}