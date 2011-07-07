/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 0.1
 */

package org.looty.core.sequence 
{	
	import org.looty.data.*;
	import org.looty.log.*;
	import org.looty.core.looty;
	import org.looty.Looty;
	
	use namespace looty;
		
	public class AbstractASynchrone extends AbstractSequencable
	{
		
		private var _onComplete			:Function;
		private var _onCompleteParams	:Array;
		private var _onStart			:Function;
		private var _onStartParams		:Array;
		private var _onCancel			:Function;
		private var _onCancelParams		:Array;
		private var _onError			:Function;
		private var _onErrorParams		:Array;
		private var _onProgress			:Function;
		private var _onProgressParams	:Array;
		private var _onFailure			:Function;
		private var _onFailureParams	:Array;
		
		private var _starts				:MethodList;
		private var _completes			:MethodList;	
		
		private var _useOnce			:Boolean;
		private var _isComplete			:Boolean;
		private var _isFailed			:Boolean;
		private var _progress			:Number;
		private var _weight				:Number;
		
		private var _retries			:int;
		private var _errors				:int;
		
		public function AbstractASynchrone() 
		{
			makeAbstract (AbstractASynchrone);
			
			weight = 1;
			
			looty::reset();
		}
		
		protected function setCallbacks(onComplete:Function = null, onProgress:Function = null, onError:Function = null, onFailure:Function = null, onCancel:Function = null, onStart:Function = null):void
		{
			if (Boolean(onComplete)) 		this.onComplete 		= onComplete;
			if (Boolean(onProgress)) 		this.onProgress 		= onProgress;
			if (Boolean(onError)) 			this.onError 			= onError;
			if (Boolean(onFailure)) 		this.onFailure 			= onFailure;
			if (Boolean(onCancel)) 			this.onCancel 			= onCancel;
			if (Boolean(onStart)) 			this.onStart 			= onStart;
		}
		
		
		/**
		 * method to be executed when the operation is completed.
		 */
		public function get onComplete():Function { return _onComplete; }
		
		/**
		 * @private
		 */
		public function set onComplete(value:Function):void 
		{
			_onComplete 		= value;
		}
		
		override public function complete():void
		{
			super.complete();
			doComplete();
		}
		
		/**
		 * @private
		 */
		protected function doComplete():void
		{			
			Looger.debug (name + " complete");
			
			_isComplete = true;
			
			Looty.removeEnterFrame(doProgress);
			looty::setProgress(1);
			doProgress();	
			
			if (_completes != null) _completes.call();			
			if (Boolean(_onComplete)) _onComplete.apply(null, onCompleteParams);
			
			looty::exit();
		}
		
		/**
		 * method to be executed at each step of progression.
		 */
		public function get onProgress():Function { return _onProgress; }
		
		/**
		 * @private
		 */
		public function set onProgress(value:Function):void 
		{		
			_onProgress 		= value;
		}
		
		/**
		 * @private
		 */
		protected function doProgress():void
		{
			if (Boolean(_onProgress)) _onProgress.apply(null, onProgressParams);
		}
		
		looty function setProgress(value:Number):void
		{
			switch(true)
			{
				case isNaN(value):
				case value < 0:
				_progress = 0;
				break;
				
				case value > 1:
				_progress = 1;
				break;
				
				default:
				_progress = value;				
			}
			
			Looger.debug(name + " progress : " + value);
		}
		
		
		/**
		 * get progress ratio as a floating Number from 0 to 1.
		 */
		public function get progress():Number 
		{
			return _progress; 
		}
		
		/**
		 * method to be executed when an error is encountered during the operation.
		 */
		public function get onError():Function { return _onError; }
		
		/**
		 * @private
		 */
		public function set onError(value:Function):void 
		{
			_onError 			= value;
		}		
		
		/**
		 * @private
		 */
		protected function doError():void
		{
			Looty.removeEnterFrame(doProgress);
			
			if (Boolean(_onError)) _onError.apply(null, onErrorParams);
			
			++_errors;
			if (_errors > _retries) doFail();
			else 
			{
				Looger.warn(name + " retry " + _errors + " / " + _retries);
				looty::reset();
				Looty.delayedCall(3000, start);				
			}
			
		}
		
		/**
		 * method to be executed after operation has failed.
		 */
		public function get onFailure():Function { return _onFailure; }
		
		/**
		 * @private 
		 */
		public function set onFailure(value:Function):void 
		{
			_onFailure = value;
		}
		
		/**
		 * @private
		 */
		protected function doFail():void
		{
			Looger.error (name + " fails");
			
			if (Boolean(_onFailure)) _onFailure.apply(null, onFailureParams);
			
			_isFailed = true;
			_errors = 0;
			
			looty::exit();
		}
		
		/**
		 * method to be executed after operation has been effectively canceled.
		 */
		public function get onCancel():Function { return _onCancel; }
		
		/**
		 * @private 
		 */
		public function set onCancel(value:Function):void 
		{
			_onCancel = value;
		}
		
		/**
		 * @private
		 */
		protected function doCancel():void
		{
			Looger.warn (name + " cancel");		
			
			looty::reset();
			
			_isFailed = true;
			_errors = 0;
			
			if (Boolean(_onCancel)) _onCancel.apply(null, onCancelParams);
		}
		
		/**
		 * 
		 */
		public function cancel():void
		{
			doCancel();			
		}
		
		/**
		 * @private
		 */
		override looty function reset():void
		{
			super.looty::reset();
			
			Looty.removeEnterFrame(doProgress);
			
			_progress = 0;
			_isFailed = false;
			_isComplete = false;
		}
		
		/**
		 * method to be executed when the operation is completed.
		 */
		public function get onStart():Function { return _onStart; }
		
		/**
		 * @private
		 */
		public function set onStart(value:Function):void 
		{
			_onStart 		= value;
		}
		
		/**
		 * 
		 */
		override public function start():Boolean
		{
			if (!super.start()) return false;
			
			if (_isComplete && _useOnce)
			{				
				Looger.warn(name + " already complete and can only be used once");
				return false;
			}
			
			Looger.debug (name + " start");
			doStart();
			
			return true;
		}
		
		protected function doStart():void
		{
			_isFailed = false;			
			
			Looty.addEnterFrame(doProgress);
			if (_starts != null) _starts.call();
			if (Boolean(_onStart)) _onStart.apply(null, onStartParams);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			if (isProcessing && !isComplete) doCancel();
			
			if (_starts != null) _starts.dispose();
			_starts = null;
			
			if (_completes != null) _completes.dispose();
			_completes = null;
			
			_onStart = null;
			_onCancel = null;
			_onComplete = null;
			_onError = null;
			_onFailure = null;
			_onProgress = null;
			_onCancelParams = null;
			_onCompleteParams = null;
			_onErrorParams = null;
			_onFailureParams = null;
			_onProgressParams = null;
			_onStartParams = null;
			
			_errors = 0;
			_retries = 0;		
		}
		
		
		/**
		 * <code>true</code> when process is achieved.
		 */
		public function get isComplete():Boolean { return _isComplete; }		
		
		/**
		 * 
		 */
		public function get useOnce():Boolean { return _useOnce; }
		
		/**
		 * 
		 */
		protected function set useOnce(value:Boolean):void 
		{
			_useOnce = value;
		}
		
		/**
		 * <code>true</code> when process has failed.
		 */
		public function get isFailed():Boolean { return _isFailed; }
		
		public function get retries():int { return _retries; }
		
		public function set retries(value:int):void 
		{
			_retries = value;
		}
		
		public function get onCompleteParams():Array { return _onCompleteParams; }
		
		public function set onCompleteParams(value:Array):void 
		{
			_onCompleteParams = value;
		}
		
		public function get onStartParams():Array { return _onStartParams; }
		
		public function set onStartParams(value:Array):void 
		{
			_onStartParams = value;
		}
		
		public function get onCancelParams():Array { return _onCancelParams; }
		
		public function set onCancelParams(value:Array):void 
		{
			_onCancelParams = value;
		}
		
		public function get onErrorParams():Array { return _onErrorParams; }
		
		public function set onErrorParams(value:Array):void 
		{
			_onErrorParams = value;
		}
		
		public function get onProgressParams():Array { return _onProgressParams; }
		
		public function set onProgressParams(value:Array):void 
		{
			_onProgressParams = value;
		}
		
		public function get onFailureParams():Array { return _onFailureParams; }
		
		public function set onFailureParams(value:Array):void 
		{
			_onFailureParams = value;
		}
		
		public function get weight():Number { return _weight; }
		
		public function set weight(value:Number):void 
		{
			_weight = value;
		}
		
		looty function get starts():MethodList 
		{
			if (_starts == null) _starts = new MethodList();
			return _starts; 
		}
		
		looty function get completes():MethodList 
		{
			if (_completes == null) _completes = new MethodList();
			return _completes; 
		}
		
		
	}
	
}