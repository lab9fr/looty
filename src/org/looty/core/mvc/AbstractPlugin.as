/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 27/05/2010 20:28
 * @version 0.1
 */

package org.looty.core.mvc 
{
	import org.looty.core.looty;
	import org.looty.mvc.controller.Presenter;
	import org.looty.mvc.plugin.IPlugin;
	
	use namespace looty;
	
	public class AbstractPlugin extends AbstractLayerElement implements IPlugin
	{
		
		private var _vars		:Object;
		
		public function AbstractPlugin(id:String) 
		{
			_vars = new Object();
			looty::setId(id);
		}
		
		override public function configure(xml:XML, presenter:Presenter = null):void 
		{
			//super.configure(xml, presenter);
		}
		
		public function get vars():Object { return _vars; }
		
	}
	
}