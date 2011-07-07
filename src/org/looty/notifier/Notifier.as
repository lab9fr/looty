/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 4.0
 */

package org.looty.notifier
{	
	
	import flash.errors.*;
	import org.looty.log.*;
	import org.looty.core.notifier.*;
	
	/**
	 * <code>Notifier</code> allows to trigger an unknow method through the execution of a <code>Registration</code> of the same type.
	 */
	public class Notifier extends AbstractRegistration
	{		
		protected var _channels			:Array;
		protected var _persist			:Boolean;
		protected var _strict			:Boolean;
		
		/**
		 * allows to trigger an unknow method through the execution of a <code>Registration</code> of the same type. 
		 * @param	type only <code>Registration</code> of the same type will be triggered.
		 */
		public function Notifier(type:String) 
		{
			super (type);
		}
		
		/**
		 * build and sends a <code>Notification</code> to all <code>Registration</code> of the same type. 
		 * @param	...parameters to be applied on <code>Registration</code>'s command method.
		 * @return	an Array of elements returned by each <code>Listene</code> execution.
		 */
		public function notify (...parameters:Array):Array
		{
			Looger.debug ("notify \"" + type + "\" [" + parameters + "]");
			
			return handleNotification (new Notification (parameters, _channels, persist));
		}
		
		/**
		 * sends the specified <code>Notification</code> to all <code>Registration</code> of the same type.
		 * @param	notification to be applied on <code>Registration</code>'s execution.
		 * @return an Array of elements returned by each <code>Listene</code> execution.
		 */
		public function handleNotification (notification:Notification):Array
		{
			var allRegistrations:Array		= getRegistrations ();
			var validRegistrations:Array 	= [];
			var results:Array				= [];
			
			var registration:Registration;
			
			if (notification.channels == null) validRegistrations = allRegistrations;	
			else for each (registration in allRegistrations) if (notification.match (registration.channels)) validRegistrations.push (registration);
			
			if (validRegistrations.length == 0) handleNoRegistration (notification);
			else for each (registration in validRegistrations) if (registration.enabled) results.push (registration.execute (notification));	
			
			return results;
		}
		
		/**
		 * an <code>Array</code> of <code>int</code> and/or <code>String</code>.When notifying on a specified channel, only <code>Registration</code> set to the same channel can be triggered.
		 * @default <code>null</code> all channels are notified
		 */
		public function get channels():Array { return _channels; }
		
		/**
		 * @private
		 */
		public function set channels(value:Array):void 
		{
			_channels = value;
		}
		
		/**
		 * if a persistent <code>Notification</code> is sent when no matching <code>Registration</code> has yet been constructed, the <code>Notification</code> will be stored and executed on <code>Registration</code> construction.
		 * @default <code>false</code>
		 */
		public function get persist():Boolean { return _persist; }
		
		/**
		 * @private
		 */
		public function set persist(value:Boolean):void 
		{
			_persist = value;
		}
		
		/**
		 * 
		 */
		public function get strict():Boolean { return _strict; }
		
		/**
		 * @private
		 */
		public function set strict(value:Boolean):void 
		{
			_strict = value;
		}
		
		private function getRegistrations():Array
		{
			var registrations:Array 	= new Array ();
			var absolute:Boolean 		= false;
			/*
			for each (var wire:Wire in proxy.retrieve (Wire.REGKEY))
			{
				registrations 			= registrations.concat (wire.registrations);
				absolute 			  ||= wire.absolute;
			}
			
			if (absolute) return registrations;
			*/
			
			registrations = registrations.concat (proxy.retrieve (Registration.REGKEY));
				
			return registrations;			
		}
		
		private function handleNoRegistration(notification:Notification):void
		{
			var msg:String = "org.looty.notifier.Notifier notify() failed, no org.looty.notifier.Registration of type \"" + type + "\" registered";
			Looger.warn(msg);
			if (notification.persist)
			{				
				proxy.register (notification);
				Looger.info("store persitent org.looty.notifier.Notification");
			}
			else if (_strict) throw new IllegalOperationError (msg);
		}
		
	}
	
}