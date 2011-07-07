/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 12/06/2010 17:44
 * @version 0.1
 */

package org.looty.utils 
{
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	public class Asset 
	{
		
		public function Asset() 
		{
			
		}
		
		static public function createDisplayObject(name:String):DisplayObject
		{
			return new (getDefinitionByName(name) as Class)();
		}
		
	}
	
}