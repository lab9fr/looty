/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 4.0
 */

package org.looty.core.notifier 
{	
	import flash.utils.Dictionary;
	import org.looty.pool.*;
	
	public class RegistrationProxy
	{	
		
		private var _type					:String
		private var _weakPool				:WeakReferencePool
		private var _pool					:Pool; 
		
		static private var _proxies			:Dictionary;
		
		public function RegistrationProxy(type:String) 
		{
			_type				= type;
			clear();
		}
		
		public function register (registration:AbstractRegistrable, isWeakReference:Boolean = false):void
		{
			isWeakReference ? _weakPool.add (registration) : _pool.add (registration);
		}
			
		public function unregister (registration:AbstractRegistrable):void
		{
			_weakPool.remove (registration);
			_pool.remove (registration);
		}
		
		public function clear(regKey:String = ""):void
		{
			if (regKey == "")
			{
				_weakPool			= new WeakReferencePool ();
				_weakPool.type		= AbstractRegistrable;
				
				_pool 				= new Pool ();
				_pool.type 			= AbstractRegistrable;
			}
			else
			{
				_weakPool.removeByProperty("regKey", regKey);
				_pool.removeByProperty("regKey", regKey);
			}			
		}
		
		public function retrieve (regKey:String):Array
		{
			return _weakPool.getByProperty ("regKey", regKey).concat(_pool.getByProperty ("regKey", regKey));	
		}
		
		public function get type():String { return _type; }
		
		static public function getProxy(type:String):RegistrationProxy
		{
			if (!_proxies) _proxies = new Dictionary();
			if (!_proxies[type]) _proxies[type] = new RegistrationProxy(type);
			return _proxies[type];
		}
		
	}
	
}