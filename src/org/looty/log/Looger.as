/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 0.1
 */

package org.looty.log 
{
	import flash.external.ExternalInterface;
	import flash.utils.getDefinitionByName;
	import org.looty.pattern.Singleton;
	import org.looty.Version;
	
	public class Looger extends Singleton
	{
		
		static public const TRACE_MODE			:int = 1;
		static public const DEBUG_PANEL			:int = 2;
		static public const ALERT_MODE			:int = 4;
		static public const FIREBUG_MODE		:int = 8;
		static public const POPUP_MODE			:int = 16;
		
		static public var mode					:int = 1;
		static public var levels				:int = 61;
		
		static private const LEVELS				:Array = [ "LOG:", "DEBUG:", "INFO:", "WARN:", "ERROR:", "FATAL:" ];
		
		static public const LOG					:uint = 0;
		static public const DEBUG				:uint = 1;
		static public const INFO				:uint = 2;
		static public const WARN				:uint = 3;
		static public const ERROR				:uint = 4;
		static public const FATAL				:uint = 5;
		
		private var _logs						:Array;
		
		public function Looger() 
		{			
			_logs = ["Looty © 2010 - http://www.looty.org\nversion :" + Version.Major + "." + Version.Minor + "." + Version.Build + "." + Version.Revision + " (" + Version.Timestamp + ")\n\n"];
			
			trace(_logs);
		}
		
		static public function get instance():Looger { return getInstanceOf(Looger); }
		
		static public function get logs():Array { return instance._logs; }
		
		/**
		 * Basic log
		 */
		static public function log(msg:String, ...args:Array):void
		{
			if (1 << LOG & levels) instance.write(LOG, msg, args);
		}
		
		/**
		 * Debug log.
		 */
		static public function debug(msg:String, ...args:Array):void
		{
			if (1 << DEBUG & levels) instance.write(DEBUG, msg, args);
		}
		
		/**
		 * Interesting runtime events.
		 */
		static public function info(msg:String, ...args:Array):void
		{
			if (1 << INFO & levels) instance.write(INFO, msg, args);
		}
		
		/**
		 * Runtime situations that are undesirable or unexpected, but not necessarily 'wrong'.
		 */
		static public function warn(msg:String, ...args:Array):void
		{
			if (1 << WARN & levels) instance.write(WARN, msg, args);
		}
		
		/**
		 * Runtime errors or unexpected conditions.
		 */
		static public function error(msg:String, ...args:Array):void
		{
			if (1 << ERROR & levels) instance.write(ERROR, msg, args);
		}
		
		/**
		 * Severe errors that cause premature termination.
		 */
		static public function fatal(msg:String, ...args:Array):void
		{
			if (1 << FATAL & levels) instance.write(FATAL, msg, args);
		}
		
		private function write(level:uint, msg:String, args:Array):void
		{
			if (mode == 0) return;
			
			var d:Array;
			
			_logs.push([level, msg, String(args), "\n"]);
			
			if (mode & TRACE_MODE)
			{
				d = args.slice();
				d.unshift(LEVELS[level], msg);
				d.unshift((level - int(Boolean(level))) + ":");
				trace.apply(null, d);
			}
			
			if (mode & DEBUG_PANEL)
			{
				//TODO : DebugPanel
			}
				
			if (mode & ALERT_MODE)
			{
				d = args.slice();
				d.unshift(LEVELS[level], msg);				
				ExternalInterface.call("alert", d.join(" "));				
			}
			
			if (mode & FIREBUG_MODE)
			{
				//TODO : implement firebug ?
			}
			
			if (mode & POPUP_MODE)
			{
				//TODO : implement popup ?
			}
			
		}
		
		static public function addMode(value:int):void
		{
			mode |= value;
		}
		
		static public function removeMode(value:int):void
		{
			mode &= ~value;
		}
		
		static public function addLevel(value:int):void
		{
			levels |= (1 << value);
		}
		
		static public function removeLevel(value:int):void
		{
			levels &= ~(1 << value);
		}
		
	}
	
}