/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 14/01/2010 22:24
 * @version 0.1
 */

package org.looty.interactive 
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.sequence.Sequencable;
	
	use namespace looty;
	
	public class ColoredInteraction extends SelectableInteraction
	{
		
		private var _baseColor			:Number;
		private var _overColor			:Number;
		private var _selectedColor		:Number;
		
		public var interactiveDuration	:Number;
		public var stateDuration		:Number;
		public var selectionDuration	:Number;
		public var unselectionDuration	:Number;
		
		protected var colorDelayOut		:Number;
		
		private var _selectionChange	:Sequencable;
		private var _unselectionChange	:Sequencable;
		
		private var _colorTargets		:Dictionary;
		
		public function ColoredInteraction(target:InteractiveObject, colorTarget:DisplayObject = null) 
		{
			super(target);
			
			_colorTargets = new Dictionary(true);
			
			_colorTargets[colorTarget == null ? target : colorTarget] = true;
			
			colorDelayOut = 0;
			
			_baseColor = 0x000000;
			_overColor = 0x666666;
			_selectedColor = 0x666666;
			
			_selectionChange = new Sequencable();
			_selectionChange.setEntry(selectionEntry);
			selection.append(_selectionChange);
			
			_unselectionChange = new Sequencable();
			_unselectionChange.setEntry(unselectionEntry);
			unselection.append(_unselectionChange);			
			
			stateDuration = 0;
			interactiveDuration = selectionDuration = unselectionDuration = .4;			
		}
		
		public function addColorTarget(colorTarget:DisplayObject):void
		{
			_colorTargets[colorTarget] = true;
		}
		
		public function setColor(baseColor:uint, overColor:uint, selectedColor:uint):void
		{
			_baseColor = baseColor;
			_overColor = overColor;
			_selectedColor = selectedColor;
			
			if (isSelected) changeColor(_selectedColor, stateDuration);
			else if (isMouseOver) changeColor(_overColor, stateDuration);
			else changeColor(_baseColor, stateDuration);
		}
		
		public function changeColor(color:uint, duration:Number, delay:Number = 0, onComplete:Function = null):void
		{
			for (var target:* in _colorTargets) TweenMax.to(target, duration, {colorTransform:{tint:color, tintAmount:1}, ease: Quad.easeOut, onComplete : onComplete, delay : delay } );
		}
		
		override public function mouseOver():void
		{
			if (!isSelected) changeColor(_overColor, interactiveDuration);
		}
		
		override public function mouseOut():void
		{
			if (!isSelected) changeColor(_baseColor, interactiveDuration, colorDelayOut);
		}
		
		private function selectionEntry():void 
		{
			changeColor(_selectedColor, selectionDuration, 0, _selectionChange.complete);
		}
		
		private function unselectionEntry():void 
		{
			changeColor(isMouseOver ? _overColor : _baseColor, selectionDuration, 0, _unselectionChange.complete);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			/*
			selection.dispose();
			selection = null;
			unselection.dispose();
			unselection = null;
			*/
			_colorTargets = null;
		}
		
	}
	
}