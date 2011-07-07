/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 22/12/2010 23:49
 * @version 0.1
 */

package org.looty.core.handlers 
{
	import flash.utils.Dictionary;
	import org.looty.key.KeyInteraction;
	
	public class KeyCodeHandler 
	{ 
		
		private var _interactions		:Dictionary;
		
		private var _isKeyDown				:Boolean;
		
		private var _keyCode			:uint;
		
		public function KeyCodeHandler(keyCode:uint) 
		{
			_keyCode = keyCode;
			_interactions = new Dictionary(true);
		}
		
		internal function register(interaction:KeyInteraction):void
		{
			_interactions[interaction] = true;
		}
		
		internal function unregister(interaction:KeyInteraction):void
		{
			_interactions[interaction] = null;
			delete _interactions[interaction];
		}
		
		internal function keyDown(combination:uint = 0):void
		{
			if (_isKeyDown) return;
			_isKeyDown = true;
			for (var interaction:* in _interactions) KeyInteraction(interaction).keyDown(combination);
		}
		
		internal function keyUp():void
		{
			if (!_isKeyDown) return;
			_isKeyDown = false;
			for (var interaction:* in _interactions) KeyInteraction(interaction).keyUp();
		}
		
		public function get keyCode():uint { return _keyCode; }
		
		
		
	}
	
}