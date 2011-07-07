/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 10/12/2009 06:14
 * @version 0.1
 */

package org.looty.form 
{
	
	public class Validator 
	{
		
		static public const NONE						:Validator = new Validator(NONE_TYPE);
		static public const MAIL						:Validator = new Validator(MAIL_TYPE);
		static public const NO_SPECIAL_CHARS			:Validator = new Validator(NO_SPECIAL_CHARS_TYPE);
		static public const NUMBER						:Validator = new Validator(NUMBER_TYPE);
		static public const PHONE						:Validator = new Validator(PHONE_TYPE);
		static public const POSTAL						:Validator = new Validator(POSTAL_TYPE);
		static public const DATE						:Validator = new Validator(DATE_TYPE);
		static public const DATE_DAY					:Validator = new Validator(DATE_DAY_TYPE);
		static public const DATE_MONTH					:Validator = new Validator(DATE_MONTH_TYPE);
		static public const DATE_YEAR					:Validator = new Validator(DATE_YEAR_TYPE);
		
		static private const NONE_TYPE					:String = "none";
		static private const MAIL_TYPE					:String = "mail";
		static private const NO_SPECIAL_CHARS_TYPE		:String = "no_special_chars";
		static private const NUMBER_TYPE				:String = "number";
		static private const PHONE_TYPE					:String = "phone";
		static private const POSTAL_TYPE				:String = "postal";
		static private const DATE_TYPE					:String = "date";
		static private const DATE_DAY_TYPE				:String = "date_day";
		static private const DATE_MONTH_TYPE			:String = "date_month";
		static private const DATE_YEAR_TYPE				:String = "date_year";
		
		private var _type		:String;
		private var _restrict	:String;
		private var _maxChars	:uint;
		
		
		public function Validator(type:String) 
		{
			_type = type;
			
			switch(_type)
			{
				case MAIL_TYPE:
				_restrict = "a-zA-Z0-9%+@_.\\-";
				_maxChars = 50;
				break;
				
				case NO_SPECIAL_CHARS_TYPE:
				_restrict = " a-zA-Z0-9@_.\\-";
				_maxChars = 0;
				break;
				
				case NUMBER_TYPE:
				_restrict = "0-9";
				_maxChars = 0;
				break;
				
				case PHONE_TYPE:
				_restrict = " +()0-9x";
				_maxChars = 20;
				break;
				
				case POSTAL_TYPE:
				_restrict = "A-Z0-9 ";
				_maxChars = 7;
				break;
				
				case DATE_TYPE:
				_restrict = "0-9/ .";
				_maxChars = 10;
				break;
				
				case DATE_DAY_TYPE:
				_restrict = "0-9";
				_maxChars = 2;
				break;
				
				case DATE_MONTH_TYPE:
				_restrict = "0-9";
				_maxChars = 2;
				break;
				
				case DATE_YEAR_TYPE:
				_restrict = "0-9";
				_maxChars = 4;
				break;
				
				default:
				_restrict = "";
				_maxChars = 0;
			}
		}
		
		public function validate(text:String):Boolean
		{
			var regExp:RegExp;
			
			switch(_type)
			{
				case MAIL_TYPE:
				return (/^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)++(?:[A-Z]{2}|arpa|biz|name|pro|com|info|net|org|aero|asia|cat|coop|edu|gov|int|jobs|mil|mobi|museum|travel|tel)$/i.test(text));
				break;
				
				case NO_SPECIAL_CHARS_TYPE:
				return (/^[A-Z0-9]+$/i.test(text));
				break;
				
				case NUMBER_TYPE:
				return (/^\d.?\d*$/.test(text));
				break;
				
				case PHONE_TYPE:
				//return (/^\+?\d{1,3}[\s.()-]*(\d[\s.()-]*){10,12}(x\d*)?$/i.test(text));
				return (/^\+?\d{1,3}[\s.()-]*(\d[\s.()-]*){6,18}(x\d*)?$/i.test(text));
				return regExp.exec(text) != null;
				break;
				
				case POSTAL_TYPE:
				return (/^\d{5}$/.test(text));
				break;
				
				case DATE_TYPE:
				//TODO : date type
				return true;
				break;
				
				case DATE_DAY_TYPE:
				return (Number(text) >= 1 && Number(text) <= 31);
				break;
				
				case DATE_MONTH_TYPE:
				return (Number(text) >= 1 && Number(text) <= 12);
				break;
				
				case DATE_YEAR_TYPE:
				return (Number(text) >= 1900 && Number(text) <= (new Date().fullYear + 1));
				break;
				
				default:
				return text != "";
			}
		}
		
		public function get restrict():String { return _restrict; }
		
		public function get type():String { return _type; }
		
		public function get maxChars():uint { return _maxChars; }
		
	}
	
}