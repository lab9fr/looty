/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 14/12/2009 09:21
 * @version 0.1
 */

package org.looty.core.net 
{
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	public class AbstractDisplayLoad extends AbstractLoad
	{
		
		private var _loaderContext			:LoaderContext;
		
		public function AbstractDisplayLoad(url:String, noCache:Boolean, allowCodeImport:Boolean = false) 
		{
			_loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			
			this.allowCodeImport = allowCodeImport;
			
			super(url, noCache);
			
			protected::loadType = LoadType.DISPLAY_LOAD;
		}
		
		public function get applicationDomain():ApplicationDomain { return _loaderContext.applicationDomain; }
		
		public function set applicationDomain(value:ApplicationDomain):void 
		{
			_loaderContext.applicationDomain = value;
		}		
		
		public function get securityDomain():SecurityDomain { return _loaderContext.securityDomain; }
		
		public function set securityDomain(value:SecurityDomain):void 
		{
			_loaderContext.securityDomain = value;
		}
		
		public function get allowCodeImport():Boolean { return _loaderContext.hasOwnProperty("allowCodeImport") ? _loaderContext["allowCodeImport"] : true; }
		
		public function set allowCodeImport(value:Boolean):void 
		{
			if (_loaderContext.hasOwnProperty("allowCodeImport")) 
			{
				_loaderContext["allowCodeImport"] = value;
			}
		}
		
		public function get loaderContext():LoaderContext { return _loaderContext; }
		
		
	}
	
}