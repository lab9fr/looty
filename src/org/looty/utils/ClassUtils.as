/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.utils 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.*;
	
	public class ClassUtils 
	{
		
		public function ClassUtils() 
		{
			
		}
		
		static public function compare (class1:Class, class2:Class):Boolean
		{
			var desc1:XML 			= XML(describeType (class1));
			var desc2:XML 			= XML(describeType (class2));
			var name1:String		= desc1.@name;
			var name2:String		= desc2.@name;
			var name:String;
			
			var equals:Boolean		= false
			
			equals				  ||= name1 == name2
			
			for each (name in desc1.factory.extendsClass.@type) equals ||= name == name2;
			for each (name in desc1.factory.implementsInterface.@type) equals ||= name == name2;			
			for each (name in desc2.factory.extendsClass.@type) equals ||= name == name1;
			for each (name in desc2.factory.implementsInterface.@type) equals ||= name == name1;		
			
			return equals;
		}
		
		static public function createInstanceOf (definition:Class, params:Array = null):*
		{
			switch (params.length)
			{
				case 0:
				return new definition ();
				break;
				
				case 1:
				return new definition (params [0]);
				break;
				
				case 2:
				return new definition (params [0], params [1]);
				break;
				
				case 3:
				return new definition (params [0], params [1], params [2]);
				break;
				
				case 4:
				return new definition (params [0], params [1], params [2], params [3]);
				break;
				
				case 5:
				return new definition (params [0], params [1], params [2], params [3], params [4]);
				break;
				
				case 6:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5]);
				break;
				
				case 7:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6]);
				break;
				
				case 8:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7]);
				break;
				
				case 9:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8]);
				break;
				
				case 10:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9]);
				break;
				
				case 11:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10]);
				break;
				
				case 12:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11]);
				break;
				
				case 13:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12]);
				break;
				
				case 14:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12], params [13]);
				break;
				
				case 15:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12], params [13], params [14]);
				break;
				
				case 16:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12], params [13], params [14], params [15]);
				break;
				
				case 17:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12], params [13], params [14], params [15], params [16]);
				break;
				
				case 18:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12], params [13], params [14], params [15], params [16], params [17]);
				break;
				
				case 19:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12], params [13], params [14], params [15], params [16], params [17], params [18]);
				break;
				
				case 20:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9], params [10], params [11], params [12], params [13], params [14], params [15], params [16], params [17], params [18], params [19]);
				break;
				
				default:
				throw new IllegalOperationError ("Are you kidding me ? A constructor with more than 20 parameters ?"); 
				break;
			}
		}
		
		static public function dump (instance:*):String
		{
			var str:String;
			str = String.fromCharCode (13)
			str += "###########################################################" + String.fromCharCode (13);
			str += "[ " + getQualifiedClassName (instance) + " ]" + String.fromCharCode (13);
			str += "-----------------------------------------------------------" + String.fromCharCode (13);
			
			var description:XML = describeType(instance);
			
			for each (var variable:XML in description.variable)	
			{
				str += " + " + variable.@name + "	:" + variable.@type + "	->	"; 
				switch (String(variable.@type))
				{
					case "Array":
					str += "length : " + (instance[variable.@name] as Array).length + " / "+ describeArray (instance[variable.@name]);
					break;
					//case "Dictionnary"//TODO: dictionnary, xml...
					default :
					str += instance[variable.@name] 
				}
				str += String.fromCharCode (13); 
			}
			str += "···························································" + String.fromCharCode (13);
			for each (var accessor:XML in description.accessor)	
			{
				if (!accessor.@access == "readwrite" && !accessor.@access == "readonly") continue;
				str += " + " + accessor.@name + "	:" + accessor.@type  + "	—>	"; 
				switch (String(accessor.@type))
				{
					case "Array":
					str += "length : " + (instance[variable.@name] as Array).length + " / "+ describeArray (instance[variable.@name]);
					break;
					default :
					str += instance[accessor.@name] 
				}
				str += String.fromCharCode (13);			
			}
			str += "###########################################################" + String.fromCharCode (13);
			return str;
		}
		
		static private function describeArray(array:Array):String
		{
			return "[ " + array.map (elementToType).join(" ,") + " ]";
		}
		
		static private function elementToType (element:*, index:int, array:Array):String 
		{
			return getQualifiedClassName(element) 
		}
			
	}
	
}