/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.form 
{
	import flash.net.URLVariables;
	import org.looty.core.form.AbstractFormItem;
	import org.looty.core.form.IFormItem;
	import org.looty.log.Looger;
	
	//TODO : check Form inside Form
	
	public class Form extends AbstractFormItem implements IFormItem
	{
		
		private var _itemIsValid		:Boolean;
		
		private var _id					:int;
		
		private var _formItems			:Array; 
		
		public function Form(id:int = 0) 
		{
			_id = id;
			super(true, "");
			_formItems = new Array();
		}
		
		public function addItem(item:IFormItem):void
		{
			_formItems.push(item);
			
			setTabIndex(1);
		}
		
		override protected function handleValidation():void 
		{
			protected::invalidItem = null;
			isValid = _formItems.every(everyIsValid);
		}
		
		internal function get formItems():Array { return _formItems; }
		
		public function get id():int { return _id; }
		
		private function everyIsValid(item:IFormItem, index:int, array:Array):Boolean
		{
			_itemIsValid = !item.isRequired || item.isValid;
			
			if (!_itemIsValid) 
			{
				protected::invalidItem = item.invalidItem;
				Looger.info("invalide item :", public::invalidItem.urlVarName);
			}
			return _itemIsValid;
		}
		
		override public function get content():*
		{
			return _formItems.map(getItemContent);
		}
		
		
		//TODO : function, not property (cause object is reconstructed each time)
		public function get urlVariables():URLVariables
		{
			var urlVars:URLVariables = new URLVariables();		
			
			for each(var item:IFormItem in _formItems)
			{
				if (item.urlVarName != "") urlVars[item.urlVarName] = item.content;
			}
			
			return urlVars;
		}
		
		private function getItemContent(item:IFormItem, index:int, array:Array):*
		{
			return item.content;
		}
		
		override public function setTabIndex(value:uint):uint 
		{
			for each(var item:IFormItem in _formItems)
			{
				value += item.setTabIndex(value);
			}
			
			return value;
		}
		
	}
	
}