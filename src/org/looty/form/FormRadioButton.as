/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 11/12/2009 09:18
 * @version 0.1
 */

package org.looty.form 
{
	import org.looty.core.form.AbstractFormItem;
	import org.looty.ui.RadioButton;
	
	public class FormRadioButton extends AbstractFormItem
	{
		
		private var _radioButton		:RadioButton;
		
		private var _value				:*;
		
		public function FormRadioButton(radioButton:RadioButton, isRequired:Boolean = false, urlVarName:String = "", value:* = null) 
		{
			super(isRequired, urlVarName);
			
			_radioButton = radioButton;
			_value = value;
		}
		
		override protected function handleValidation():void 
		{
			isValid = _radioButton.isSelected;
		}
		
		override public function get content():* { return ((_value == null) ? _radioButton.isSelected : _value); }		
		
		public function get radioButton():RadioButton { return _radioButton; }
		
		override public function setTabIndex(value:uint):uint 
		{
			_radioButton.tabIndex = value;
			return 1;
		}
		
		
		
	}
	
}