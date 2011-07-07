/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 4.0
 */

package org.looty.notifier
{
	import org.looty.core.notifier.*;
	
	/**
	 * contains all infos dispatched on a <code>Notifier.notify</code> and is applied on corresponding <code>Registration</code> executions.
	 */
	public class Notification extends AbstractRegistrable
	{
		/**
		 * @private
		 */
		static public const REGKEY			:String			= "notificationRegistryKey";
		
		/**
		 * @private
		 */
		protected var _parameters		:Array;
		
		/**
		 * @private
		 */
		protected var _channels			:Array;
		
		/**
		 * @private
		 */
		protected var _persist			:Boolean;
		
		/**
		 * contains all infos dispatched on a <code>Notifier.notify</code> and is applied on corresponding <code>Registration</code> executions.
		 * @param	parameters to be applied on <code>Registration</code>'s command method
		 * @param	channels an <code>Array</code> of <code>int</code> and/or <code>String</code>.
		 * @param	persist when <code>true</code>, if no <code>Registration</code> is registered, will be executed at <code>Registration</code>'s construction.
		 */
		public function Notification (parameters:Array, channels:Array, persist:Boolean) 
		{
			super(REGKEY);
			_parameters				= parameters;
			_persist				= persist;
			if (channels) _channels	= channels.slice();
		}
		
		/**
		 * checks wether or not <code>Notification</code> channels and specified channels matches.
		 * @param	channels an <code>Array</code> of <code>int</code> and/or <code>String</code>
		 * @return <code>true</code> when matching, <code>false</code>otherwise 
		 */
		public function match (channels:Array):Boolean
		{
			if (_channels == null || channels == null) return true;
			
			for each (var channel:* in channels) if (_channels.indexOf (channel) != -1) return true;
			
			return false;
		}
		
		/**
		 * parameters getter 
		 */
		public function get parameters():Array { return _parameters; }
		
		/**
		 * channels getter
		 */
		public function get channels():Array { return _channels; }
		
		/**
		 * if a persistent <code>Notification</code> is sent when no matching <code>Registration</code> has yet been constructed, the <code>Notification</code> will be stored and executed on <code>Registration</code> construction.
		 * @default <code>false</code>
		 */
		public function get persist():Boolean { return _persist; }	
		
	}
	
}