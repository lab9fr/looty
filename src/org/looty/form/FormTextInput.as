/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 11/12/2009 09:16
 * @version 0.1
 */

package org.looty.form 
{
	import org.looty.core.form.AbstractFormItem;
	import org.looty.core.looty;
	import org.looty.text.TextInput;
	import org.looty.form.Validator;
	
	use namespace looty;
	
	public class FormTextInput extends AbstractFormItem
	{
		
		
		private var _textInput		:TextInput;
		
		private var _validator		:Validator;
		
		public function FormTextInput(textInput:TextInput, isRequired:Boolean = false, urlVarName:String = "", defaultValue:String = "", validator:Validator = null) 
		{
			_textInput = textInput;
			
			_textInput.looty::focusIns.add(hideError);			
			_textInput.looty::focusOuts.add(validate);
			
			super(isRequired, urlVarName, defaultValue);
			
			_validator = validator != null ? validator : Validator.NONE;		
			
			if (_validator.restrict != "") _textInput.target.restrict = _validator.restrict;
			if (_validator.maxChars > 0) _textInput.target.maxChars = _validator.maxChars;	
		}
		
		override public function get content():* { return _textInput.text != "" ? _textInput.text : super.content; }
		
		override protected function handleValidation():void 
		{
			isValid = _validator.validate(content);
		}
		
		override public function setTabIndex(value:uint):uint 
		{
			_textInput.target.tabIndex = value;
			return 1;
		}
		
		public function get textInput():TextInput { return _textInput; }
		
	}
	
}