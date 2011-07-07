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
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import org.looty.pattern.Abstract;
	
	public class AbstractFormItem extends Abstract implements IFormItem
	{
		
		private var _isRequired		:Boolean;
		private var _isValid		:Boolean;
		private var _urlVarName		:String;
		private var _active			:Boolean;
		private var _errorDisplays	:Array;
		private var _invalidItem	:IFormItem;
		
		private var _loopBreaker	:Boolean;
		
		private var _defaultValue	:*;
		
		
		public function AbstractFormItem(isRequired:Boolean, urlVarName:String, defaultValue:* = null) 
		{
			makeAbstract(AbstractFormItem);
			_isRequired = isRequired;
			_urlVarName = urlVarName;
			_defaultValue = defaultValue;
			_errorDisplays = [];
			_invalidItem = this;
		}
		
		public function addErrorDisplay(errorDisplay:IFormErrorDisplay):void
		{
			if (errorDisplay == null) throw new IllegalOperationError("can't add a null IFormErrorDisplay");
			_errorDisplays.push(errorDisplay);
		}
		
		public function get content():* { return _defaultValue; }
		
		public function get isRequired():Boolean { return _isRequired; }
		
		public function get isValid():Boolean 
		{
			if (!_loopBreaker) validate();
			return _isValid; 
		}
		
		public function set isValid(value:Boolean):void 
		{
			_isValid = value;
		}
		
		final public function validate():void
		{
			_loopBreaker = true;
			handleValidation();
			_loopBreaker = false;
			_isValid || !_isRequired ? hideError():showError();
		}
		
		protected function handleValidation():void
		{			
			//to be overriden through inhéritence.
		}
		
		public function showError(code:String = ""):void
		{
			for each(var errorDisplay:IFormErrorDisplay in _errorDisplays) errorDisplay.showError(code);
		}
		
		public function hideError():void
		{
			for each(var errorDisplay:IFormErrorDisplay in _errorDisplays) errorDisplay.hideError();
		}
		
		public function get urlVarName():String { return _urlVarName; }
		
		public function get invalidItem():IFormItem { return _invalidItem; }
		
		protected function set invalidItem(value:IFormItem):void
		{
			_invalidItem = value;
		}
		
		public function toString():String 
		{
			return "[ " + getQualifiedClassName(this) + " ]  isRequired : " + _isRequired + "  isValid : " + _isValid + "  urlVarName : " + _urlVarName;
		}
		
		public function setTabIndex(value:uint):uint
		{
			return 0;
		}
		
	}
	
}