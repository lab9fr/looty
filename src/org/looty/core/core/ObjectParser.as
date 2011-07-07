/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 16/04/2010 17:28
 * @version 0.1
 */

package org.looty.core.core 
{
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import org.looty.log.Looger;
	
	public class ObjectParser 
	{
		
		public function ObjectParser() 
		{
			
		}
		
		static public function createObject(type:String = "", constructor:String = "", properties:String = ""):Object
		{
			var definition:Class;
			var object:Object;
			var splitted:Array;
			var value:String;
			
			if (type != "")
			{
				splitted = type.split(".");
				value = "";
				definition = null;
				
				while (definition == null && splitted.length > 0)
				{
					value += splitted.shift();
					definition = getDefinition(value);
					value += ".";						
				}
				
				while (splitted.length > 0 && definition != null) definition = definition[splitted.shift()];
				
				if (definition == null) 
				{
					Looger.error("wrong object definition :" + type);
					definition = Object;
				}
				
			}
			else definition = Object;
			
			object = createInstanceOf(definition, /^\s*\[.*\]\s*$/.test(constructor) ? createArray(constructor) : null);
			
			createProperties(properties, object);
			
			return object;		
		}
		
		static public function createProperties(properties:String, object:Object = null):Object
		{
			if (object == null) object = {};
			
			if (/^\s*\{.*\}\s*$/.test(properties)) properties = properties.substring(properties.indexOf("{") + 1, properties.lastIndexOf("}"));
			
			var locals:Array = [];
			var i:int;
			
			while (/['][^']*[']/.test(properties))
			{
				locals[i] = properties.match(/['][^']*[']/);
				properties = properties.replace(/['][^']*[']/, "${LOC" + i + "}");
				++i;
			}
			
			while (/["][^"]*["]/.test(properties))
			{
				locals[i] = properties.match(/["][^"]*["]/);
				properties = properties.replace(/["][^"]*["]/, "${LOC" + i + "}");
				++i;
			}			
				
			var elements:Array = properties.split(",");
			var prop:String;
			var value:String;
			
			for each (var element:String in elements)
			{
				if (!(/\s*\w+\s*:.*/.test(element)))
				{
					Looger.error ("format error in object property : " + element);
					continue;
				}
				
				prop = element.substring(0, element.indexOf(":"));				
				prop = prop.replace(/^\s+|\s+$/g, "");
				
				if (!(/^\w+$/.test(prop)))
				{
					Looger.error ("format error in object property : " + element);
					continue;
				}
				
				value = element.substring(element.indexOf(":") + 1);
				
				while (/\$\{LOC\d+\}/.test(value)) value = value.replace(/\$\{LOC\d+\}/, locals[Number(/\$\{LOC(?P<index>\d+)\}/.exec(value).index)])
				
				object[prop] = typeVar(value);
			}
			
			return object;
			
		}
		
		static public function createArray(properties:String):Array
		{
			var array:Array = [];
			
			if (/^\s*\[.*\]\s*$/.test(properties)) properties = properties.substring(properties.indexOf("[") + 1, properties.lastIndexOf("]"));
			
			var locals:Array = [];
			var i:int;
			
			while (/['][^']*[']/.test(properties))
			{
				locals[i] = properties.match(/['][^']*[']/);
				properties = properties.replace(/['][^']*[']/, "${LOC" + i + "}");
				++i;
			}
			
			while (/["][^"]*["]/.test(properties))
			{
				locals[i] = properties.match(/["][^"]*["]/);
				properties = properties.replace(/["][^"]*["]/, "${LOC" + i + "}");
				++i;
			}			
				
			var elements:Array = properties.split(",");
			
			for each (var element:String in elements)
			{
				if (!(/\s*\w+\s*/.test(element))) 
				{
					Looger.warn ("empty property in array : " + properties);
					continue;
				}
				
				element = element.replace(/^\s+|\s+$/g, "");
				
				while (/\$\{LOC\d+\}/.test(element)) element = element.replace(/\$\{LOC\d+\}/, locals[Number(/\$\{LOC(?P<index>\d+)\}/.exec(element).index)])
				
				array.push(typeVar(element));
			}
			
			return array;
		}
		
		static public function getDefinition(value:String):Class
		{
			if (!ApplicationDomain.currentDomain.hasDefinition(value)) return null;
			
			try 
			{
				return getDefinitionByName(value) as Class;
			}
			catch (e:Error)
			{
				Looger.error("Error getting definition on '" + value + "' \n" + e.message);				
			}
			
			return null;
		}
		
		static public function typeVar(value:String, ...args):*
		{
			
			value = value.replace(/^\s+|\s+$/g, ""); 
			
			switch(true)
			{
				//Boolean true
				case (/^\s*true\s*$/i.test(value)):
				return true;
				break;
				
				//Boolean false
				case (/^\s*false\s*$/i.test(value)):
				return false;
				break;
				
				//uint
				case (/^\s*0x[0-9A-F]+\s*$/i.test(value)):
				return uint(value);
				break;
				
				//int
				case (/^\s*[+\-]?\s*\d+\s*$/.test(value)):
				return int(value);
				break;
				
				//Number
				case (/^\s*[+\-]?\s*\d*\.\d+\s*$/.test(value)):
				return Number(value);
				break;
				
				//Array
				case (/^\s*\[.*\]\s*$/.test(value)):				
				return createArray(value);
				break;
				
				//Object
				case (/^\s*\{.*\}\s*$/.test(value)):
				return createProperties(value);
				break;
				
				//XML
				
				case (/^\s*<\s*(\w+)\s*>.*<\/\s*\1\s*>\s*$/s.test(value)):
				
				var xml:XML;
				
				try
				{
					xml = XML(value);
				}
				catch(e:Error)
				{
					Looger.warn("error recognizing XML var \n" + e.message);
				}
				
				return xml != null ? xml : value;
				
				break;
				
				default:
				if (/^\s*".*"\s*$/.test(value)) value = value.replace(/^\s*"|"\s*$/g, "");
				if (/^\s*'.*'\s*$/.test(value)) value = value.replace(/^\s*'|'\s*$/g, "");
				return value;
			}
		}
		
		static public function createInstanceOf (definition:Class, params:Array = null):*
		{
			if (params == null) return new definition ();
			
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
				
				default:
				Looger.fatal("Dynamic contruction overload, no more than 10 paremeters in contructor");
				return null;
				break;
			}
		}
		
	}
	
}