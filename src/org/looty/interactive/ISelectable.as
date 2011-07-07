/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 14/01/2010 22:10
 * @version 0.1
 */

package org.looty.interactive 
{
	import org.looty.sequence.Sequence;
	
	public interface ISelectable 
	{
		function get selection():Sequence;		
		function get unselection():Sequence;
	}
	
}