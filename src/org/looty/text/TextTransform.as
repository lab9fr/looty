/**
 * @project CBa
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @created 24/10/2009 02:00
 * @version 0.1
 */

package org.looty.text 
{

	public class TextTransform
	{
		
		static public const NONE				:TextTransform = new TextTransform("none");
		static public const LOWER_CASE			:TextTransform = new TextTransform("lowercase");
		static public const UPPER_CASE			:TextTransform = new TextTransform("uppercase");
		static public const SENTENCE			:TextTransform = new TextTransform("sentence");
		static public const CAPITALIZE			:TextTransform = new TextTransform("capitalize");
		
		private var _type			:String;
		
		public function TextTransform(type:String="none") 
		{
			_type = type;
		}
		
		static public function getFormater(value:String):TextTransform
		{
			switch(value)
			{
				case LOWER_CASE.type : return LOWER_CASE; break;
				case UPPER_CASE.type : return UPPER_CASE; break;
				case SENTENCE.type : return SENTENCE; break;
				case CAPITALIZE.type : return CAPITALIZE; break;				
			}
			return NONE;
		}
		
		//TODO : refactor with regex
		
		public function format(text:String):String
		{
			var i:int = 0;
			var lgt:int = text.length;
			
			var endBalise:String = "";
			var startIndex:int = 0;
			var apply:Boolean;
			var capital:Boolean = true;
			var char:String;
			
			
			for (i = 0; i < lgt; ++i) 
			{
				char = text.charAt(i);
				if (endBalise != "")
				{
					if (endBalise != char) continue;
					endBalise = "";
					startIndex = i + 1;
				}
				else switch(char)
				{
					case "$":
					if (text.charAt(i+1) == "{") endBalise = "}";					
					apply = true;
					break;
					
					case "<":
					endBalise = ">";
					apply = true;
					break;
				}
				
				if (i == lgt - 1) apply = true;
				
				switch(_type)
				{
					case LOWER_CASE.type:
						if (apply) text = text.substring(0, startIndex) + text.substring(startIndex, i + 1).toLowerCase() + text.substr(i + 1);
					break;
					
					case UPPER_CASE.type:
						if (apply) text = text.substring(0, startIndex) + text.substring(startIndex, i + 1).toUpperCase() + text.substr(i + 1);
					break;
					
					case SENTENCE.type:
					
						if (capital && /[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿ]/.test(text.charAt(i))) 
						{
							text = text.substring(0, i) + char.toUpperCase() + text.substr(i + 1);
							capital = false;
						}
						if (/[.!?]/.test(char)) capital = true;				
					break;
					
					case CAPITALIZE.type:
						if (capital && /[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿ]/.test(text.charAt(i))) 
						{
							text = text.substring(0, i) + char.toUpperCase() + text.substr(i+1);
							capital = false;
						}
						if (!(/[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿ]/.test(char))) 
						{
							capital = true;
						}
					break;
				}
				
				apply = false;
			}
			
			return text;
		}
		
		public function get type():String { return _type; }
		
	}

}