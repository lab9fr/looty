/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.ui 
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.looty.data.MethodList;
	import org.looty.display.Layer;
	import org.looty.interactive.Interaction;
	
	
	//TODO refactoring
	
	public class RadioButton extends Layer implements IUserInterface
	{
		
		private var _background			:DisplayObject;
		private var _icon				:DisplayObject;
		
		//private var _valueOn			:*
		//private var _valueOff			:*
		
		private var _onChanges			:MethodList;
		
		private var _interaction		:Interaction;
		
		public function RadioButton(background:DisplayObject, icon:DisplayObject, container:InteractiveObject = null) 
		{
			_background = background;
			_icon = icon;
			
			if (container == null) //TODO : refactor
			{
				addChild(_background);
				addChild(_icon);
				container = this;
			}
			
			
			_icon.visible = false;
			
			
			
			_onChanges = new MethodList();
			
			_interaction = new Interaction(container);
			_interaction.onMouseDown = toggle;
			
			/*
			graphics.beginFill(0xFF0000, .5);
			var rect:Rectangle = this.getBounds(_background)
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
			*/
		}
		
		public function addOnChange(method:Function):void
		{
			_onChanges.add(method);
		}
		
		public function removeOnChange(method:Function):void
		{
			_onChanges.remove(method);
		}
		
		public function toggle():void
		{
			isSelected = !isSelected;			
		}
		
		public function get isSelected():Boolean { return _icon.visible; }
		
		public function set isSelected(value:Boolean):void 
		{
			if (value == _icon.visible) return;		
			
			_icon.visible = value;
			
			_onChanges.call();
		}
		
		public function get background():DisplayObject { return _background; }
		
		public function get icon():DisplayObject { return _icon; }	
		
	}

}