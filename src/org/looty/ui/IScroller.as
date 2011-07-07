/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 16/12/2010 17:45
 * @version 0.1
 */

package org.looty.ui 
{
	import org.looty.display.IRenderable;
	
	public interface IScroller extends IRenderable
	{
		
		function set width(value:Number):void;
		function get width():Number;
		function set height(value:Number):void;
		function get height():Number;
		function set ratio(value:Number):void;
		function get ratio():Number;
		function get position():Number;
		function get onChange():Function;		
		function set onChange(value:Function):void;
		function reset():void;
		
	}
	
}