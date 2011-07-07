/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.core.handlers 
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.interactive.Interaction;
	import org.looty.Looty;
	
	use namespace looty;
	
	public class MouseInteractionHandler
	{
		private var _focused		:Interaction;		
		private var _interactions	:Dictionary;
		
		public function MouseInteractionHandler() 
		{
			construct();
		}
		
		private function construct():void
		{
			_interactions = new Dictionary(true);
			
			if (Looty.isInitialised) initialise();
			else Looty.looty::onInitialisation.add(initialise);
		}
		
		private function initialise():void
		{
			Looty.stage.addEventListener (MouseEvent.MOUSE_OVER, handleMouseOver, true);
			Looty.stage.addEventListener (MouseEvent.MOUSE_OUT, handleMouseOut, true);
			Looty.stage.addEventListener (MouseEvent.MOUSE_DOWN, handleMouseDown, true);			
			Looty.stage.addEventListener (MouseEvent.MOUSE_UP, handleMouseUp);
			
			Looty.addOnEnterFullScreen(enterFullScreen);
		}
		
		private function enterFullScreen():void 
		{
			if (_focused != null) _focused.mouseUp();
		}
		
		public function register(target:InteractiveObject, interaction:Interaction):void
		{
			_interactions[target] = interaction;
		}
		
		public function unregister(target:InteractiveObject):void
		{
			_interactions[target] = null;
			delete _interactions[target];
		}
		
		public function focusDown(interaction:Interaction):void
		{
			if (_focused != null) _focused.mouseUp();
			_focused = interaction;
		}
		
		public function focusUp(interaction:Interaction):void
		{
			if (_focused == interaction) _focused = null;
		}
		
		private function handleMouseOver(e:MouseEvent):void 
		{
			var interaction:Interaction = _interactions[e.target];
			
			if (Boolean(interaction)) interaction.mouseOver();			
			
			if (!Looty.mouseEventsEnabled) e.stopImmediatePropagation();
		}
		
		private function handleMouseOut(e:MouseEvent):void 
		{
			var interaction:Interaction = _interactions[e.target];
			
			if (Boolean(interaction)) interaction.mouseOut();
			
			if (!Looty.mouseEventsEnabled) e.stopImmediatePropagation();
		}
		
		private function handleMouseUp(e:MouseEvent):void 
		{
			if (Boolean(_focused)) _focused.mouseUp();	
			if (!Looty.mouseEventsEnabled) e.stopImmediatePropagation();
		}
		
		private function handleMouseDown(e:MouseEvent):void 
		{
			var interaction:Interaction = _interactions[e.target];
			if (Boolean(interaction)) interaction.mouseDown();
			if (!Looty.mouseEventsEnabled) e.stopImmediatePropagation();
		}

	}
	
}