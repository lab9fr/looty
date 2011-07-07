/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 24/04/2010 20:35
 * @version 0.1
 */

package org.looty.interactive 
{
	import org.looty.display.*;
	import org.looty.localisation.*;
	import org.looty.mvc.controller.*;
	import org.looty.text.*;
	
	public class NavigationButton extends Layer
	{
		
		private var _interaction		:SelectableInteraction;
		private var _label				:StyledTextField;
		
		private var _presenter			:Presenter;
		
		private var _isBitmapText		:Boolean;
		
		public function NavigationButton(presenter:Presenter, textId:String = "title", isBitmapText:Boolean = true ) 
		{
			_presenter = presenter;
			
			_interaction = new SelectableInteraction(this);
			
			_isBitmapText = isBitmapText;
			
			if (presenter.data.hasText(textId))
			{
				buildLabel(presenter.data.getText(textId));
				addChild(_label);
			}		
			
		}
		
		private function onMouseDown():void
		{
			presenter.writePath(presenter.path);
		}
		
		protected function buildLabel(text:Text):void
		{
			_label = _isBitmapText ? new StyledBitmapTextField(text) : new StyledTextField(text);
		}
		
		public function get interaction():SelectableInteraction { return _interaction; }
		
		public function set interaction(value:SelectableInteraction):void 
		{
			_interaction = value;
			_interaction.presenter = presenter;			
			_interaction.onMouseDown = onMouseDown;
		}
		
		public function get presenter():Presenter { return _presenter; }
		
		public function get label():StyledTextField { return _label; }
		
	}
	
}