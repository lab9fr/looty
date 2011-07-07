/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 19/11/2010 16:31
 * @version 0.1
 */

package org.looty.mvc.plugin 
{
	import com.google.analytics.GATracker;
	import org.looty.core.mvc.AbstractPlugin;
	import org.looty.Looty;
	
	public class GoogleAnalyticsPlugin extends AbstractPlugin
	{
		
		private var _tracker		:GATracker;
		
		private var _account		:String;
		
		private var _visualDebug	:Boolean;
		
		public function GoogleAnalyticsPlugin(account:String, visualDebug:Boolean = false) 
		{
			super("GoogleAnalyticsPlugin");
			
			_account = account;
			_visualDebug = visualDebug;			
			
			command.register("trackPageView", trackPageView);
			command.register("trackEvent", trackEvent);
			
		}
		
		override public function initialise():void 
		{
			super.initialise();
			_tracker = new GATracker(Looty.stage, _account, "AS3", _visualDebug);
		}
		
		
		private function trackPageView(value:String):void
		{
			_tracker.trackPageview(value);
		}
		
		private function trackEvent(category:String, label:String, value:Number = NaN):void
		{
			_tracker.trackEvent(category, label, isNaN(value) ? "" : String(value));
		}
		
	}

}