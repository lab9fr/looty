/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 10/12/2009 05:38
 * @version 0.1
 */

package org.looty.core.text 
{
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import org.looty.*;
	import org.looty.core.looty;
	import org.looty.text.*;
	
	use namespace looty;
	
	public class TextInputContainer
	{
		
		private var _textInputs			:Dictionary;
		
		public function TextInputContainer() 
		{
			construct();
		}
		
		private function construct():void
		{
			_textInputs = new Dictionary(true);
			
			if (Looty.isInitialised) initialise();
			else Looty.looty::onInitialisation.add(initialise);
		}
		
		
		private function initialise():void
		{			
			Looty.stage.addEventListener (FocusEvent.FOCUS_IN, handleFocusIn, true);
			Looty.stage.addEventListener (FocusEvent.FOCUS_OUT, handleFocusOut, true);
			Looty.stage.addEventListener (Event.CHANGE, handleChange, true);			
		}
		
		public function register(target:TextField, textInput:TextInput):void
		{
			_textInputs[target] = textInput;
		}
		
		public function unregister(target:TextField):void
		{
			_textInputs[target] = null;
			delete _textInputs[target];
		}
		
		
		private function handleFocusIn(e:FocusEvent):void 
		{
			var target:TextInput = _textInputs[e.target] as TextInput;
			if (Boolean(target)) target.focusIn();
		}
		
		private function handleFocusOut(e:FocusEvent):void 
		{
			var target:TextInput = _textInputs[e.target] as TextInput;
			if (Boolean(target)) target.focusOut();
		}
		
		private function handleChange(e:Event):void 
		{
			var target:TextInput = _textInputs[e.target] as TextInput;
			if (Boolean(target)) target.textChange();
		}
		
	}
	
}