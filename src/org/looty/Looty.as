/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 09/06/2010 08:56
 * @version 0.4
 */

package org.looty
{
	import flash.display.*;
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.ApplicationDomain;
	import flash.utils.*;
	import org.looty.core.*;
	import org.looty.core.core.*;
	import org.looty.data.*;
	import org.looty.log.*;
	import org.looty.pattern.*;
	
	use namespace looty;
	
	public class Looty extends Singleton
	{
		
		private var _enterFrames					:MethodList;
		private var _nextFrames						:Array;
		private var _exitFrames						:MethodList;
		private var _resizes						:MethodList;
		private var _mouseMoves						:MethodList;
		private var _shape							:Shape;
		
		private var _previous						:int;
		private var _current						:int;
		private var _elapsed						:int;
		private var _elapsedSeconds					:Number;
		
		private var _delayedCalls					:List;
		
		private var _stage							:Stage;
		
		private var _parameters						:Object;
		
		private var _isResizing						:Boolean;
		
		private var _mouseMotion					:Point;
		private var _mouseSpeed						:Point;
		
		private var _mouseX							:Number;
		private var _mouseY							:Number;
		
		private var _isInitialised					:Boolean;
		
		private var _onInitialisation				:MethodList;
		
		private var _useDeviceFonts					:Boolean;
		
		private var _useWhiteBitmapTextColorType	:Boolean;
		
		private var _isFullScreen					:Boolean;		
		private var _fullScreenTarget				:DisplayObject;
		private var _fullScreenTargetParent			:DisplayObjectContainer;
		private var _fullScreenTargetMatrix			:Matrix;
		private var _fullScreenTargetRect			:Rectangle;
		private var _fullscreenChildren				:Array;
		
		private var _enterFullScreens				:MethodList;	
		
		private var _mouseEventsEnabled				:Boolean;
				
		public function Looty() 
		{
			super();
			
			construct();
		}
		
		private function construct():void
		{			
			Looger.instance;
			
			_useDeviceFonts = true;
			_useWhiteBitmapTextColorType = true;
			_mouseEventsEnabled = true;
			
			_enterFrames = new MethodList();
			_exitFrames = new MethodList();
			_resizes = new MethodList();
			
			_delayedCalls = new List(false);
			
			_shape = new Shape();
			_shape.addEventListener(Event.ENTER_FRAME, enterFrame);
			_shape.addEventListener(Event.EXIT_FRAME, exitFrame);
			
			_enterFullScreens = new MethodList();
			
			_previous = getTimer();
			
			_parameters = new Object();
			
			_mouseMotion = new Point();
			_mouseSpeed = new Point();
			
			_onInitialisation = new MethodList();
		}
		
		static private function get instance():Looty { return getInstanceOf(Looty); }		
		
		
		/**
		 * initialise Looty. already done when using <code>org.looty.mvc.Bootstrap</code> or <code>org.looty.net.ExternalLoader</code>
		 * @param	stage 
		 */
		static public function initialise(stage:Stage, isResizing:Boolean = true):void
		{
			if (isInitialised)
			{
				Looger.warn("attempt to initialise a second time Looty");
				return;
			}
			
			if (stage == null)
			{
				Looger.fatal("Looty initialisation with a null value for the stage");
				return;
			}
			
			
			instance._isInitialised = true;
			
			instance._stage = stage;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, instance.handleFullScreen);
			stage.addEventListener(Event.RESIZE, instance.resize);
			stage.stageFocusRect = false;
			stage.focus = stage;
			
			instance._mouseX = stage.mouseX;
			instance._mouseY = stage.mouseY;
			
			if (instance._isResizing || isResizing) instance.initResize();
			
			var params:Object = instance._stage.loaderInfo.parameters;
			
			var prop:String;
			for (prop in params) instance._parameters[prop] = params[prop];
			
			instance._onInitialisation.call();
			instance._onInitialisation.dispose();
			instance._onInitialisation = null;			
		}	
		
		static looty function get onInitialisation():MethodList { return instance._onInitialisation; }
		
		private function resize(e:Event):void 
		{
			_resizes.call();
		}
		
		private function enterFrame(e:Event):void 
		{
			_current = getTimer();
			_elapsed = _current - _previous;
			_previous = _current;
			if (_elapsed < 0) _elapsed = 0;
			if (_elapsed > 1000) _elapsed = 1000;
			
			_elapsedSeconds = _elapsed * .001;
			
			if (Boolean(stage))
			{
				_mouseMotion.x = stage.mouseX - _mouseX;
				_mouseX = stage.mouseX;
				
				_mouseMotion.y = stage.mouseY - _mouseY;
				_mouseY = stage.mouseY;
				
				_mouseSpeed.x = _mouseMotion.x / _elapsed * 1000;
				_mouseSpeed.y = _mouseMotion.y / _elapsed * 1000;
			}		
			
			_enterFrames.call();
			
			if (_nextFrames)
			{
				for each (var method:Function in _nextFrames) if (method != null) method();
				_nextFrames = null;
			}
			
			_delayedCalls.forEach(triggerCall);
		}
		
		private function exitFrame(e:Event):void 
		{
			_exitFrames.call();
		}
		
		private function triggerCall(delayedCall:DelayedCall):void
		{
			if (delayedCall.triggerAt <= _current)
			{
				delayedCall.execute();
				_delayedCalls.remove(delayedCall);
			}
		}
		
		/**
		 * execute a specified callback after a specified delay
		 * @param	delay the delay in milliseconds until the callback is executed
		 * @param	callback method to execute
		 * @param	...params an optional list of parameters to be passed to the callback 
		 */		
		static public function delayedCall(delay:Number, callback:Function, ...params:Array):void
		{
			instance._delayedCalls.add(new DelayedCall(delay, callback, params));
		}
		
		/**
		 * removes all previously registered delayedCalls to a specified method.
		 * @param	callback function to execute
		 */
		static public function killDelayedCallsTo(callback:Function):void
		{
			for each (var delayedCall:DelayedCall in instance._delayedCalls) if (delayedCall.callback == callback) instance._delayedCalls.remove(delayedCall);
		}
		
		/**
		 * allows to trigger a specified method on each frame
		 * @param	method function to execute
		 */
		static public function addEnterFrame(method:Function):void
		{
			instance._enterFrames.add(method);
		}
		
		/**
		 * removes a previously registered enterFrame
		 * @param	method function to execute
		 */
		static public function removeEnterFrame(method:Function):void
		{
			instance._enterFrames.remove(method);
		}
		
		/**
		 * allows to delay the execution of a specified method to the next frame
		 * @param	method function to execute
		 */
		static public function executeNextFrame(method:Function):void
		{
			if (instance._enterFrames.has(method)) return;
			
			if (instance._nextFrames == null) instance._nextFrames = [];
			
			instance._nextFrames.push(method);
			//instance._enterFrames.add(method);
		}
		
		/**
		 * allows to trigger a specified method on each frame just before the displayList is drawn
		 * @param	method function to execute
		 */
		static public function addExitFrame(method:Function):void
		{
			instance._exitFrames.add(method);
		}
		
		/**
		 * removes a previously registered exitFrame
		 * @param	method function to execute
		 */
		static public function removeExitFrame(method:Function):void
		{
			instance._exitFrames.remove(method);
		}
		
		/**
		 * triggers a specified method when a <code>Event.RESIZE</code> event occurs
		 * @param	method method to execute
		 */
		static public function addResize(method:Function):void
		{
			if (!instance._isResizing) instance.initResize();
			instance._resizes.add(method);
		}
		
		private function initResize():void
		{
			_isResizing = true;
			if (_isInitialised)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}			
		}
		
		/**
		 * removes a previously registered resize
		 * @param	method method to execute
		 */
		static public function removeResize(method:Function):void
		{
			instance._resizes.remove(method);
		}
		
		/**
		 * triggers a specified method when a <code>MouseEvent.MOUSE_MOVE</code> event occurs
		 * @param	method
		 */
		static public function addMouseMove(method:Function):void
		{
			if (instance._mouseMoves == null)
			{
				if (isInitialised) instance.initialiseMouseMove();
				else instance._onInitialisation.add(instance.initialiseMouseMove);
				
				instance._mouseMoves = new MethodList();
			}
			
			instance._mouseMoves.add(method);
		}
		
		/**
		 * 
		 * @param	method
		 */
		static public function removeMouseMove(method:Function):void
		{
			if (instance._mouseMoves != null) instance._mouseMoves.remove(method);
		}
		
		private function initialiseMouseMove():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		private function mouseMove(e:Event):void
		{
			_mouseMoves.call();
		}		
		
		/**
		 * allows to trigger a specified method when entering fullscreen
		 * @param	method function to execute
		 */
		static public function addOnEnterFullScreen(method:Function):void
		{
			instance._enterFullScreens.add(method);
		}
		
		/**
		 * removes a previously registered onEnterFullScreen
		 * @param	method function to execute
		 */
		static public function removeOnEnterFullScreen(method:Function):void
		{
			instance._enterFullScreens.remove(method);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	extendToFit
		 * @return
		 */
		static public function enterFullScreen(target:DisplayObject = null, extendToFit:Boolean = true):Boolean
		{
			if (isFullScreen)
			{
				if (instance._fullScreenTarget == null && target == null) return false;				
				instance.removeFullScreenTarget();
			}
			
			instance._isFullScreen = true;
			
			instance._enterFullScreens.call();
			
			if (Boolean(target))
			{
				instance._fullScreenTarget = target;				
				instance._fullScreenTargetParent = target.parent;				
				instance._fullScreenTargetMatrix = target.transform.matrix; //TODO handle Matrix3D ? is it really useful ?
				//instance._fullScreenTargetRect = new Rectangle(target.x, target.y, target.width, target.y);
				
				target.x = 0;
				target.y = 0;
				
				if (extendToFit)
				{
					target.width = stage.fullScreenWidth;
					target.height = stage.fullScreenHeight;
				}
				
				stage.addChild(target);
				
				//instance._fullscreenChildren TODO : for performances
			}
			
			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.focus = stage;
			
			return true;
		}		
		
		/**
		 * 
		 * @return
		 */
		static public function exitFullScreen():Boolean
		{
			if (!isFullScreen) return false;
			
			instance._isFullScreen = false;
			
			instance.removeFullScreenTarget();
			
			stage.displayState = StageDisplayState.NORMAL;
			stage.focus = stage;
			
			return true;
		}
		
		private function removeFullScreenTarget():void
		{
			if (Boolean(_fullScreenTarget))
			{
				if (stage.contains(_fullScreenTarget)) stage.removeChild(_fullScreenTarget);
				_fullScreenTarget.transform.matrix = _fullScreenTargetMatrix;				
				if (Boolean(_fullScreenTargetParent)) _fullScreenTargetParent.addChild(_fullScreenTarget);
				
				_fullScreenTarget = null;
				_fullScreenTargetParent = null;
				_fullScreenTargetMatrix = null;
			}
		}
		
		/**
		 * 
		 */
		static public function get isFullScreen():Boolean { return instance._isFullScreen; }
		
		private function handleFullScreen(e:FullScreenEvent):void 
		{
			if (_isFullScreen && !e.fullScreen) exitFullScreen();			
		}
		
		/**
		 * 
		 * @param	name
		 * @param	params
		 * @return
		 */
		static public function createInstanceByName(name:String, params:Array = null):*
		{
			if (!ApplicationDomain.currentDomain.hasDefinition(name))
			{
				Looger.fatal("impossible to create an instance.\n[" + name + "] isn't defined in current domain");
				return null;
			}
			
			var definition:Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
			
			if (params == null) params = [];
			
			switch (params.length)
			{
				case 0:
				return new definition ();
				break;
				
				case 1:
				return new definition (params [0]);
				break;
				
				case 2:
				return new definition (params [0], params [1]);
				break;
				
				case 3:
				return new definition (params [0], params [1], params [2]);
				break;
				
				case 4:
				return new definition (params [0], params [1], params [2], params [3]);
				break;
				
				case 5:
				return new definition (params [0], params [1], params [2], params [3], params [4]);
				break;
				
				case 6:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5]);
				break;
				
				case 7:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6]);
				break;
				
				case 8:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7]);
				break;
				
				case 9:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8]);
				break;
				
				case 10:
				return new definition (params [0], params [1], params [2], params [3], params [4], params [5], params [6], params [7], params [8], params [9]);
				break;
				
				default:
				throw new IllegalOperationError ("Seriously ? A constructor with more than 10 parameters ?"); 
				return null
			}
		}
		
		/**
		 * 
		 */
		static public function get elapsed():Number { return instance._elapsedSeconds; }
		
		/**
		 * 
		 */
		static public function get stage():Stage { return instance._stage; }
		
		/**
		 * 
		 */
		static public function get parameters():Object { return instance._parameters; }
		
		/**
		 * 
		 */
		static public function get mouseMotion():Point { return instance._mouseMotion; }
		
		/**
		 * 
		 */
		static public function get mouseSpeed():Point { return instance._mouseSpeed; }
		
		/**
		 * 
		 */
		static public function get isInitialised():Boolean { return instance._isInitialised; }
		
		/**
		 * 
		 */
		static public function get useDeviceFonts():Boolean { return instance._useDeviceFonts; }
		
		/**
		 * 
		 */
		static public function set useDeviceFonts(value:Boolean):void 
		{
			instance._useDeviceFonts = value;
		}
		
		/**
		 * 
		 */
		static public function get useWhiteBitmapTextColorType():Boolean { return instance._useWhiteBitmapTextColorType; }
		
		/**
		 * 
		 */
		static public function set useWhiteBitmapTextColorType(value:Boolean):void 
		{
			instance._useWhiteBitmapTextColorType = value;
		}
		
		/**
		 * @private
		 */
		static public function get mouseEventsEnabled():Boolean { return instance._mouseEventsEnabled; }
		
		/**
		 * when false, only interactions are allowed, propagation of events being stopped. Could help with performance with lots of displayObjects.
		 */
		static public function set mouseEventsEnabled(value:Boolean):void 
		{
			instance._mouseEventsEnabled = value;
		}
		
	}
	
}