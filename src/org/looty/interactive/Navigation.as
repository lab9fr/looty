/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 07/01/2010 12:07
 * @version 0.1
 */

package org.looty.interactive 
{
	import flash.display.*;
	import org.looty.core.looty;
	import org.looty.display.Layer;
	import org.looty.localisation.Localisation;
	import org.looty.mvc.controller.*;
	import org.looty.sequence.Sequence;
	import org.looty.sequence.TimeLineMaxSequencer;
	
	use namespace looty;
	
	public class Navigation extends Layer
	{
		
		private var _buttons		:Array;
		
		private var _isHorizontal	:Boolean;
		private var _gap			:Number;
		
		private var _selection		:Sequence;
		private var _unselection	:Sequence;
		
		private var _timeline		:TimeLineMaxSequencer;
		
		public function Navigation(presenters:Array, buttonType:Class = null, isHorizontal:Boolean = true, gap:Number = 10)
		{
			_buttons = [];
			
			_selection = new Sequence();
			_unselection = new Sequence();
			
			_timeline = new TimeLineMaxSequencer();
			_selection.append(_timeline.selection);
			unselection.append(_timeline.unselection);
			
			
			looty::build(presenters, buttonType);
			
			_isHorizontal = isHorizontal;
			_gap = gap;
			update();			
			
			defineTransition();
		}
		
		public function defineTransition():void
		{
			
		}
		
		looty function build(presenters:Array, buttonType:Class = null):void
		{
			var button:Layer;
			
			if (buttonType == null) buttonType = NavigationButton;
			
			for each (var presenter:Presenter in presenters) 
			{
				button = new buttonType(presenter);
				addChild(button);
				_buttons.push(button);
			}
			
			
			Localisation.registerOnChangeLang(update);
		}	
		
		public function update():void
		{
			var position:int = 0;
			var button:Sprite;
			
			if (_isHorizontal) for each (button in _buttons)
			{
				button.x = position;
				position += button.width + gap;
			}
			else for each (button in _buttons)
			{
				button.y = position;
				position += button.height + gap;
			}
		}
		
		public function get buttons():Array { return _buttons; }
		
		public function get gap():Number { return _gap; }
		
		public function set gap(value:Number):void 
		{
			_gap = value;
			
			update();
		}
		
		public function get selection():Sequence { return _selection; }
		
		public function get unselection():Sequence { return _unselection; }
		
		public function get isHorizontal():Boolean { return _isHorizontal; }
		
		public function set isHorizontal(value:Boolean):void 
		{
			if (_isHorizontal == value) return;
			_isHorizontal = value;
			
			update();
		}
		
	}
	
}