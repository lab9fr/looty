/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 17/03/2010 21:22
 * @version 0.1
 */

package org.looty.core.media
{

	public class NetConnectionStatus
	{
		
		/**
		 * The NetConnection.call method was not able to invoke the server-side method or command.
		 * Error
		 * @param description:String
		 */
		static public const CALL_FAILED						:String			= "NetConnection.Call.Failed";
		
		/**
		 * The application has been shut down (for example, if the application is out of memory resources and must shut down to prevent the server from crashing) or the server has shut down.
		 * Error
		 */
		static public const CONNECT_APP_SHUTDOWN			:String 		= "NetConnection.Connect.AppShutdown";
		
		/**
		 * The URI specified in the NetConnection.connect method did not specify "rtmp" as the protocol. "rtmp" must be specified when connecting to Flash Communication Server.
		 * Error
		 */
		static public const CALL_BAD_VERSION				:String			= "NetConnection.call.BadVersion";
		
		/**
		 * The connection was closed successfully.
		 * Status
		 */
		static public const CONNECT_CLOSED					:String			= "NetConnection.Connect.Closed";
		
		/**
		 * The connection attempt failed.
		 * Error
		 */
		static public const CONNECT_FAILED					:String			= "NetConnection.Connect.Failed";
		
		/**
		 * The client does not have permission to connect to the application, the application expected different parameters from those that were passed, or the application name specified during the connection attempt was not found on the server.
		 * Error
		 * @param application:*
		 */
		static public const CONNECT_REJECTED				:String			= "NetConnection.Connect.Rejected";
		
		/**
		 * The connection attempt succeeded.
		 * Status
		 */
		static public const CONNECT_SUCCESS					:String			= "NetConnection.Connect.Success";
		
		/**
		 * The proxy server is not responding. See the ProxyStream class.
		 * Error
		 */
		static public const PROXY_NOT_RESPONDING			:String			= "NetConnection.Proxy.NotResponding";

		public function NetConnectionStatus() 
		{
			
		}
		
	}

}