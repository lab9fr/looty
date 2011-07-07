/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 12/04/2010 02:06
 * @version 0.1
 */

package org.looty.form 
{
	import org.looty.core.form.AbstractFormItem;
	import org.looty.core.looty;
	import org.looty.text.TextInput;
	
	use namespace looty;
	
	public class FormConfirmation extends AbstractFormItem
	{
		
		private var _original		:FormTextInput;
		private var _duplicated		:TextInput;
		
		
		public function FormConfirmation(original:FormTextInput, duplicated:TextInput) 
		{
			_original = original;
			_duplicated = duplicated;
			
			_duplicated.looty::focusIns.add(hideError);			
			_duplicated.looty::focusOuts.add(validate);
			
			super(true, "");	
			
			_duplicated.restrict = _original.textInput.restrict;
			_duplicated.maxChars = _original.textInput.maxChars;	
		}
		
		override public function get content():* { return ""; }
		
		override protected function handleValidation():void 
		{
			isValid = _original.textInput.text == _duplicated.text;
		}
		
		override public function setTabIndex(value:uint):uint 
		{
			_duplicated.tabIndex = value;
			return 1;
		}
		
		public function get original():FormTextInput { return _original; }
		
		public function get duplicated():TextInput { return _duplicated; }
		
	}
	
}