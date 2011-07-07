/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 0.1
 */

package org.looty.sequence 
{
	
	public interface ISequencable 
	{
		function setEntry(value:Function):void;
		function start():Boolean;
		function complete():void;
		function get isProcessing():Boolean;
		function cancel():void;
	}
	
}