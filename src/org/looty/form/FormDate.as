/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.form 
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import org.looty.core.form.AbstractFormItem;
	import org.looty.core.form.IFormErrorDisplay;
	import org.looty.core.form.IFormItem;
	import org.looty.text.TextInput;
	
	
	public class FormDate extends AbstractFormItem implements IFormItem
	{
		
		private var _day		:FormTextInput;
		private var _month		:FormTextInput;
		private var _year		:FormTextInput;	
		
		public var format		:String;
		
		public function FormDate(day:TextInput, month:TextInput, year:TextInput, isRequired:Boolean = false, urlVarName:String = "") 
		{
			super(isRequired, urlVarName);
			
			_day = new FormTextInput(day, isRequired, "day_form", "", Validator.DATE_DAY);
			_month = new FormTextInput(month, isRequired, "month_form", "", Validator.DATE_MONTH);
			_year = new FormTextInput(year, isRequired, "year_form", "", Validator.DATE_YEAR);
			
			format = "DD/MM/YYYY";
		}
		
		override public function get content():* 
		{
			var d:String = _day.content;
			if (d.length == 1) d = "0" + d;
			
			var m:String = _month.content;
			if (m.length == 1) m = "0" + m;
			
			var y:String = _year.content;	
			
			return format.replace("DD", d).replace("MM", m).replace("YYYY", y);
		}
		
		public function get day():FormTextInput { return _day; }
		
		public function get month():FormTextInput { return _month; }
		
		public function get year():FormTextInput { return _year; }
		
		override protected function handleValidation():void
		{
			switch(false)
			{
				case _day.isValid:
				protected::invalidItem = _day;
				isValid = false;
				break;
				
				case _month.isValid:
				protected::invalidItem = _month;
				isValid = false;
				break;
				
				case _year.isValid:
				protected::invalidItem = _year;
				isValid = false;
				break;
				
				default:
				isValid = true;
			}
		}
		
		public function addErrorDisplayDay(errorDisplay:IFormErrorDisplay):void
		{
			_day.addErrorDisplay(errorDisplay);
		}
		
		public function addErrorDisplayMonth(errorDisplay:IFormErrorDisplay):void
		{
			_month.addErrorDisplay(errorDisplay);
		}
		
		public function addErrorDisplayYear(errorDisplay:IFormErrorDisplay):void
		{
			_year.addErrorDisplay(errorDisplay);
		}
		
		override public function setTabIndex(value:uint):uint 
		{
			_day.setTabIndex(value);
			_month.setTabIndex(value + 1);
			_year.setTabIndex(value + 2);
			return 3;
		}
		
	}
	
}