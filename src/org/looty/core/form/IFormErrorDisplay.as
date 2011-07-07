/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 11/12/2009 08:27
 * @version 0.1
 */

package org.looty.core.form 
{
	
	public interface IFormErrorDisplay 
	{		
		function showError(code:String = ""):void
		function hideError():void		
	}
	
}