/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 14/01/2010 22:23
 * @version 0.1
 */

package org.looty.interactive 
{
	
	import flash.display.*;
	import org.looty.core.looty;
	import org.looty.mvc.controller.*;
	import org.looty.sequence.Sequence;
	
	use namespace looty;
	
	public class SelectableInteraction extends Interaction implements ISelectable
	{
		
		private var _isSelected		:Boolean;		
		private var _presenter		:Presenter;
		private var _allow			:Boolean;
		
		private var _selection		:Sequence;
		private var _unselection	:Sequence;		
		
		public function SelectableInteraction(target:InteractiveObject = null) 
		{
			super(target);
			
			_selection = new Sequence();
			_selection.looty::starts.add(doSelect);
			_unselection = new Sequence();
			_unselection.looty::starts.add(doUnselect);
			
			_allow = true;
		}
		
		override public function mouseOver():void 
		{
			if (_isSelected) _allow = false;
			super.mouseOver();
			_allow = true;
		}
		
		override public function mouseOut():void 
		{
			if (_isSelected) _allow = false;
			super.mouseOut();
			_allow = true;
		}
		
		override public function get onMouseOut():Function 
		{
			return _allow ? null : super.onMouseOut; 
		}
		
		override public function get onMouseOver():Function 
		{
			return _allow ? null : super.onMouseOver; 
		}	
		
		private function doSelect():void
		{
			_isSelected = true;
			mouseEnabled = false;
		}
		
		private function doUnselect():void
		{
			_isSelected = false;
			mouseEnabled = true;
			/*
			switch(isMouseOver)
			{
				case true:
				if (Boolean(onMouseOver)) onMouseOver();
				break;
				
				case false:
				if (Boolean(onMouseOut)) onMouseOut();
			}*/
		}
		
		public function get isSelected():Boolean { return _isSelected; }
		
		public function get presenter():Presenter { return _presenter; }
		
		public function set presenter(value:Presenter):void 
		{
			if (value == null && _presenter != null) _presenter.selectables.remove(this);
			_presenter = value;
			if (_presenter != null) _presenter.selectables.add(this);			
		}
		
		public function get selection():Sequence { return _selection; }
		
		public function get unselection():Sequence { return _unselection; }
		
	}
	
}