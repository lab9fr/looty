/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 0.1
 */

package org.looty.tracking
{
	import com.google.analytics.GATracker;
	import org.looty.Looty;
	
	public class ExternalLoaderGATracker implements IExternalLoaderTracker
	{
		
		private var _tracker		:GATracker;
		
		private var _account		:String;
		
		private var _visualDebug	:Boolean;
		
		public function ExternalLoaderGATracker(account:String, visualDebug:Boolean = false) 
		{	
			_account = account;
			_visualDebug = visualDebug;
			_tracker = new GATracker(Looty.stage, _account, "AS3", _visualDebug);
		}
		
		public function start():void
		{
			_tracker.trackEvent("Loader", "loading started");
		}
		
		public function complete():void
		{
			_tracker.trackEvent("Loader", "loading completed");
		}
		
		public function track(value:String):void
		{
			_tracker.trackPageview(value);
		}
		
		
		
	}

}