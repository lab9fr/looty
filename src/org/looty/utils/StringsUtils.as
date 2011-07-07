/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.utils 
{
	
	public class StringsUtils 
	{
		
		public function StringsUtils() 
		{
			
		}
		
		static public function occurence (searchString:String, pattern:String):int
		{
			var startIndex:int = 0;
			var count:int = 0;
			while (searchString.indexOf (pattern, startIndex) != -1)
			{
				count ++;
				startIndex = searchString.indexOf (pattern, startIndex)
			}			
			return count;
		}
		
		static public function mailIsValid (mail:String):Boolean
		{
			var regExp:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)++(?:[A-Z]{2}|arpa|biz|name|pro|com|info|net|org|aero|asia|cat|coop|edu|gov|int|jobs|mil|mobi|museum|travel|tel)$/i;			
			return regExp.exec(mail) != null;
		}
		
		static public function noSpecialChar (str:String):Boolean
		{
			var regExp:RegExp = /^[A-Z0-9]$/i;
			return regExp.exec(str) != null;
		}
		
		static public function phoneIsValid (phone:String):Boolean
		{
			var regExp:RegExp = /^06[0-9]{8}$/i;
			return regExp.exec(phone) != null;
		}
		
		static public function zipCodeIsValid (zipCode:String):Boolean
		{
			var regExp:RegExp = /^[0-9]{5}$/i;
			return regExp.exec(zipCode) != null;
		}
		
		static public function replaceSpecialChars(text:String):String
		{
			if (/[ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿ]/.test(text))
			{
				text = text.replace(/[ÀÁÂÃÄÅ]/g, "A");
				text = text.replace(/[Æ]/g, "AE");
				text = text.replace(/[Ç]/g, "C");
				text = text.replace(/[ÈÉÊË]/g, "E");
				text = text.replace(/[ÌÍÎÏ]/g, "I");
				text = text.replace(/[Ð]/g, "D");
				text = text.replace(/[Ñ]/g, "N");
				text = text.replace(/[ÒÓÔÕÖØ]/g, "O");
				text = text.replace(/[ÙÚÛÜ]/g, "U");
				text = text.replace(/[Ý]/g, "Y");
				text = text.replace(/[ß]/g, "SS");
				text = text.replace(/[àáâãäå]/g, "a");
				text = text.replace(/[æ]/g, "ae");
				text = text.replace(/[ç]/g, "c");
				text = text.replace(/[èéêë]/g, "e");
				text = text.replace(/[ìíîï]/g, "i");
				text = text.replace(/[ñ]/g, "n");
				text = text.replace(/[òóôõöø]/g, "o");
				text = text.replace(/[ùúûü]/g, "u");
				text = text.replace(/[ýÿ]/g, "y");				
			}			
			return text;
		}
		
	}
	
}