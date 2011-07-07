/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @timestamp 19/12/2010 17:50
 * @version 0.1
 */

package org.looty.activable 
{
	import flash.utils.Dictionary;
	import org.looty.core.disposable.IDisposable;
	import org.looty.core.looty;
	import org.looty.Looty;
	
	use namespace looty;
	
	//TODO : separate children. implement id && name in an another class
	
	public class Activable implements IActivable, IDisposable
	{
		private var _isActive		:Boolean;		
		private var _activables		:Dictionary;
		
		looty var doActivation		:Function;
		looty var doDeactivation	:Function;
		
		public function Activable(activateByDefault:Boolean = true) 
		{
			_activables = new Dictionary(true);
			
			looty::doActivation = doActivate;
			looty::doDeactivation = doDeactivate;
			
			if (activateByDefault) activate();
		}	
		
		final public function activate():Boolean
		{
			for (var activable:* in _activables) IActivable(activable).activate();
			
			if (_isActive) return false;
			
			_isActive = true;			
			looty::doActivation();
			
			return true;
		}
		
		protected function doActivate():void 
		{
			
		}	
		
		final public function deactivate():Boolean
		{
			for (var activable:* in _activables) IActivable(activable).deactivate();
			
			if (!_isActive) return false;
			
			_isActive = false;			
			looty::doDeactivation();
			
			return true;
		}
		
		protected function doDeactivate():void 
		{
			
		}	
		
		public function addActivable(activable:IActivable):void
		{
			_activables[activable] = true;
			_isActive ? activable.activate() : activable.deactivate();
		}
		
		public function removeActivable(activable:IActivable):void
		{
			_activables[activable] = null;
			delete _activables[activable];
		}
		
		public function dispose():void
		{
			deactivate();
			_activables = null;
		}
		
		public function get isActive():Boolean { return _isActive; }
		
	}
	
}