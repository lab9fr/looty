/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.utils 
{
	
	import flash.system.Security
	
	public class NetUtils 
	{	
		
		static public const LOCAL				:Boolean			= Security.sandboxType != Security.REMOTE;
		
		public function NetUtils() 
		{
			
		}
		
	}
	
}