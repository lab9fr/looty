/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.core.net
{
	import flash.events.*;
	import org.looty.core.disposable.IDisposable;
	import org.looty.log.Looger;
	import org.looty.core.looty;
	import org.looty.core.net.HTTPStatus;
	import org.looty.pattern.Abstract;
	
	
	use namespace looty;
	
	public class AbstractDispatcher extends Abstract implements IDisposable
	{		
		
		private var _dispatcher			:IEventDispatcher;
		
		private var _totalBytes			:int;
		private var _loadedBytes		:int;
		private var _progress			:Number;
		
		private var _load				:AbstractLoad;
		
		internal var loadNext			:Function;
		
		private var _isProcessing		:Boolean;
		
		private var _canComplete		:Boolean;
		
		public function AbstractDispatcher(dispatcher:IEventDispatcher) 
		{
			makeAbstract(AbstractDispatcher);
			
			_dispatcher = dispatcher;
			addListeners();
		}
		
		public function setLoad(load:AbstractLoad, canComplete:Boolean = true):void
		{
			reset();
			_load = load;
			_canComplete = canComplete;
			start();
		}
		
		/**
		 * 
		 */
		public function get totalBytes():int { return _totalBytes; }
		
		/**
		 * 
		 */
		public function get loadedBytes():int { return _loadedBytes; }
		
		/**
		 * 
		 */
		public function initialise ():void
		{
			
		}
		
		/**
		 * 
		 */
		public function reset():void
		{
			_totalBytes 			= 1;
			_loadedBytes 			= 0;
			
			_isProcessing = false;
			
		}
		
		/**
		 * 
		 */
		public function start():void
		{
			_isProcessing = true;
		}
		
		/**
		 * 
		 */
		public function dispose ():void
		{
			removeListeners();
			_dispatcher = null;			
		}
		
		
		public function get dispatcher():IEventDispatcher { return _dispatcher; }
		
		public function get load():AbstractLoad { return _load; }
		
		public function get isProcessing():Boolean { return _isProcessing; }
		
		/***************************************************************************************************************
		 * PROTECTED METHODS
		 ***************************************************************************************************************/
		
		/**
		 * 
		 */
		protected function addListeners ():void
		{
			_dispatcher.addEventListener (Event.COMPLETE, handleComplete);
			_dispatcher.addEventListener (ProgressEvent.PROGRESS, handleProgress);
			_dispatcher.addEventListener (IOErrorEvent.IO_ERROR, handleError);
			_dispatcher.addEventListener (SecurityErrorEvent.SECURITY_ERROR, handleError);
			_dispatcher.addEventListener (Event.OPEN, handleOpen);
			_dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);       
		}
		
		/**
		 * 
		 */
		protected function removeListeners ():void
		{
			if (_dispatcher.hasEventListener(Event.COMPLETE)) 						_dispatcher.removeEventListener (Event.COMPLETE, handleComplete);
			if (_dispatcher.hasEventListener(ProgressEvent.PROGRESS)) 				_dispatcher.removeEventListener (ProgressEvent.PROGRESS, handleProgress);
			if (_dispatcher.hasEventListener(IOErrorEvent.IO_ERROR)) 				_dispatcher.removeEventListener (IOErrorEvent.IO_ERROR, handleError);
			if (_dispatcher.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) 	_dispatcher.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, handleError);
			if (_dispatcher.hasEventListener(Event.OPEN)) 							_dispatcher.removeEventListener (Event.OPEN, handleOpen);
			if (_dispatcher.hasEventListener(HTTPStatusEvent.HTTP_STATUS)) 			_dispatcher.removeEventListener (HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
		}
		
		/**
		 * @private
		 * @param	e
		 */
		protected function handleComplete(e:Event):void 
		{			
			_isProcessing = false;
			if (_canComplete) Looger.log  ("\"" + _load.request.url + "\" complete");
			
			handleContent();
			
			if (Boolean(loadNext)) loadNext(load);
		}	
		
		protected function handleContent():void
		{
			
		}
		
		/**
		 * @private
		 * @param	e
		 */
		protected function handleProgress(e:ProgressEvent):void 
		{
			_totalBytes 			= e.bytesTotal;
			_loadedBytes 			= e.bytesLoaded;
			_progress				= _loadedBytes / _totalBytes;
			
			load.looty::setProgress(_progress);
		}
		
		/**
		 * @private
		 * @param	e
		 */
		protected function handleError(e:ErrorEvent):void 
		{
			_isProcessing = false;
			Looger.error (e.text);			
			load.error();
			if (Boolean(loadNext)) loadNext();
		}
		
		/**
		 * @private
		 * @param	e
		 */
		protected function handleHTTPStatus(e:HTTPStatusEvent):void 
		{
			Looger.log ("\"" + _load.request.url + "\" HTTP status : " + e.status + " - " + HTTPStatus.getStatus(e.status));
		}
		
		/**
		 * @private
		 * @param	e
		 */
		protected function handleOpen(e:Event):void 
		{
			Looger.log  ("\"" + _load.request.url + "\" open");
		}
		
	}
	
}