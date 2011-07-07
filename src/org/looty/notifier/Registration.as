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
	 * <code>Registration</code> permits to trigger a specific command through a <code>Notification</code> sent by a <code>Notifier</code> of the same type.
	 */
	public class Registration extends AbstractRegistration
	{	
		/**
		 * @private
		 */
		static public const REGKEY	:String		= "RegistrationRegistryKey";
		
		/**
		 * @private
		 */
		protected var _command		:Function
		
		/**
		 * @private
		 */
		protected var _channels		:Array
		
		/**
		 * @private
		 */
		protected var _enabled		:Boolean
		
		/**
		 * permits to trigger a specific command through a <code>Notification</code> sent by a <code>Notifier</code> of the same type.
		 * @param	type	Best practice, the value of this constant has to describe the specific action that will be triggered
		 */
		public function Registration(type:String) 
		{
			_enabled			= true;			
			super (type, REGKEY);		
		}
		
		/**
		 * 
		 * @param	command method executed on <code>Notification</code>
		 * @return
		 */
		public function register(command:Function):Registration
		{
			_command			= command;			
			proxy.register(this, true);
			
			return this;
		}
		
		public function executePersistents():Array
		{
			var results:Array = [];
			if (_enabled) for each (var notification:Notification in proxy.retrieve (Notification.REGKEY)) if (notification.match(channels)) results.push(execute (notification));
			
			return results;
		}
		
		/**
		 * an <code>Array</code> of <code>int</code> and/or <code>String</code>. When listening to a specified channel, only notification sent on the same channel can trigger execution.
		 * @default <code>null</code> listening to all channels
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
		 * when <code>false</code>, stops listening.
		 * @default <code>true</code>
		 */
		public function get enabled():Boolean { return _enabled; }
		
		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		/**
		 * execute the command with notification's parameters. Triggered by <code>Notifier.notify</code> when type and channels match.
		 * @param	notification contains parameters to be applied on the command method.
		 * @return value returned by the executed command.
		 */
		public function execute (notification:Notification):*
		{
			return _command.apply (this, notification.parameters);
		}
		
		
		
	}
	
}