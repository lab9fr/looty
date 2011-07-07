/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 4.0
 */

package org.looty.core.notifier 
{
	
	/**
	 * base class to access to the registry methods and get a proxy reference.
	 */
	
	import flash.errors.IllegalOperationError;
	 
	public class AbstractRegistration extends AbstractRegistrable
	{
		
		private var _type				:String;
		private var _proxy				:RegistrationProxy;
		
		public function AbstractRegistration(type:String, regKey:String = "") 
		{
			makeAbstract (AbstractRegistration);
			
			super(regKey);
			
			if (type.length < 1 || type == "undefined") throw new IllegalOperationError ("AbstractRegistration with no type.");		
			
			_type			= type;
			_proxy			= RegistrationProxy.getProxy (type);
		}
		
		public function get type():String { return _type; }
		
		protected function get proxy():RegistrationProxy { return _proxy; }	
		
	}
	
}