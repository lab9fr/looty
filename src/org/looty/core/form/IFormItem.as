/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 0.1
 */

package org.looty.core.form 
{
	
	public interface IFormItem 
	{
		function get content():*;
		function get isRequired():Boolean;		
		function get isValid():Boolean;	
		function validate():void;
		function get urlVarName():String;
		function showError(code:String = ""):void
		function hideError():void;
		function get invalidItem():IFormItem;
		function setTabIndex(value:uint):uint;
	}
	
}