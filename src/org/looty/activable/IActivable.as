/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 19/12/2010 17:40
 * @version 0.1
 */

package org.looty.activable 
{
	
	public interface IActivable 
	{
		function activate():Boolean;
		function deactivate():Boolean;
		function get isActive():Boolean;		
	}
	
}