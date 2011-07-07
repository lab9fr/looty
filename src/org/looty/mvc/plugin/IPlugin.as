/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/02/2010 16:33
 * @version 0.1
 */

package org.looty.mvc.plugin 
{
	import org.looty.core.mvc.ILayerElement;
	import org.looty.sequence.ISequencable;
	
	public interface IPlugin extends ILayerElement
	{
		function get vars():Object;
	}
	
}