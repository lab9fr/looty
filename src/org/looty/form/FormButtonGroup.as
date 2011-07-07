/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 07/12/2009 08:55
 * @version 0.1
 */

package org.looty.form 
{
	
	import flash.utils.Dictionary;
	import org.looty.core.form.AbstractFormItem;
	import org.looty.ui.RadioButton;
	
	
	public class FormButtonGroup extends AbstractFormItem
	{
		
		private var _forms			:Dictionary;		
		private var _current		:RadioButton;
		
		//TODO : mutliple selection required...
		
		public function FormButtonGroup(isRequired:Boolean = false, urlVarName:String = "", defaultValue:* = null) 
		{
			super(isRequired, urlVarName, defaultValue);
			_forms = new Dictionary();
			
			isValid = false;
		}
		
		public function addRadioButton (button:RadioButton, value:* = null):void
		{
			_forms[button] = new FormRadioButton(button, isRequired, "", value);
			button.addOnChange(change);			
		}
		
		
		
		public function removeRadioButton (button:RadioButton):void
		{
			_forms[button] = null;
			delete _forms[button];
			
			button.removeOnChange(null);
		}
		
		override public function get content():* 
		{
			var contents:Array = [];
			
			for each(var form:FormRadioButton in _forms) 
			{
				if (form.isValid) contents.push(form.content);
			}
			
			switch(contents.length)
			{
				case 0:
				return super.content;
				break;
				
				case 1:
				return contents[0];
				
				default:
				return contents;
			}
		}
		
		override protected function handleValidation():void 
		{
			var valid:Boolean = false;
			
			for each(var form:FormRadioButton in _forms) valid ||= form.isValid;
			
			isValid = valid;
		}
		
		private function change():void 
		{
			var target:RadioButton;
			for (var button:* in _forms) if (button.isSelected && button != _current) target = button;
			
			if (Boolean(target))
			{
				if (_current != null && target != _current) _current.isSelected = false;
				_current = target;
			}
			else _current = null;
		}
		
		override public function setTabIndex(value:uint):uint 
		{
			for each(var form:FormRadioButton in _forms) value += form.setTabIndex(value);
			return value;
		}
		
	}
	
}