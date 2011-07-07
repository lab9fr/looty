/**
 * @project looty
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 19/12/2010 17:33
 * @version 0.1
 */

package org.looty.core.handlers 
{
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.key.KeyInteraction;
	import org.looty.Looty;
	
	use namespace looty;
	
	public class KeyInteractionHandler 
	{
		
		private var _keyCodes		:Vector.<KeyCodeHandler>;
		
		public function KeyInteractionHandler() 
		{
			construct();
		}
		
		private function construct():void
		{
			_keyCodes = new Vector.<KeyCodeHandler>(0xff);
			
			if (Looty.isInitialised) initialise();
			else Looty.looty::onInitialisation.add(initialise);
		}
		
		private function initialise():void
		{
			Looty.stage.addEventListener (KeyboardEvent.KEY_DOWN, handleKeyDown);
			Looty.stage.addEventListener (KeyboardEvent.KEY_UP, handleKeyUp);			
		}
		
		public function register(interaction:KeyInteraction):void
		{
			getKeyCodeHandler(interaction.keyCode).register(interaction);
		}
		
		public function unregister(interaction:KeyInteraction):void
		{			
			getKeyCodeHandler(interaction.keyCode).unregister(interaction);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void 
		{
			getKeyCodeHandler(e.keyCode).keyDown((uint(e.shiftKey) << KeyInteraction.SHIFT_COMBINATION) | (uint(e.ctrlKey) << KeyInteraction.CTRL_COMBINATION) | (uint(e.altKey) << KeyInteraction.ALT_COMBINATION));
		}
		
		private function handleKeyUp(e:KeyboardEvent):void 
		{
			getKeyCodeHandler(e.keyCode).keyUp();
		}
		
		public function getKeyCodeHandler(keyCode:uint):KeyCodeHandler
		{
			if (_keyCodes[keyCode] == null) _keyCodes[keyCode] = new KeyCodeHandler(keyCode);
			return _keyCodes[keyCode];
		}
		
		
	}

}