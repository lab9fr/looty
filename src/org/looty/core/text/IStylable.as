/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 06/01/2010 12:13
 * @version 0.1
 */

package org.looty.core.text 
{
	import flash.text.StyleSheet;
	
	public interface IStylable 
	{		
		function get styleSheet():StyleSheet;		
		function set styleSheet(value:StyleSheet):void;	
	}
	
}