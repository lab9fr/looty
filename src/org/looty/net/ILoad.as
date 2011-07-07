/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 24/02/2010 01:21
 * @version 0.1
 */

package org.looty.net 
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import org.looty.sequence.IASynchrone;
	
	public interface ILoad extends IASynchrone
	{		
		function get url():String;
		function get request():URLRequest;
		function get method():String;
		function set method(value:String):void;
		function get urlVariables():URLVariables;
		function set urlVariables(value:URLVariables):void; 
		function get noCache():Boolean;
	}
	
}