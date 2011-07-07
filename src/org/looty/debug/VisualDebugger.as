/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 18/02/2010 16:25
 * @version 0.1
 */

package org.looty.debug 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import net.hires.debug.Stats;
	import org.looty.notifier.Registration;
	
	public class VisualDebugger extends Sprite
	{
		
		private var _registration		:Registration;
		
		private var _text				:TextField;
		
		public function VisualDebugger() 
		{
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect (0, 0, 400, 300);
			graphics.endFill();
			
			//var stats:Stats = new Stats();
			//addChild(stats);
			
			_registration = new Registration(DebugConst.DEBUG_DISPLAY).register(display);
			_text = new TextField();
			_text.width = 390;
			_text.height = 290;
			_text.x = 5;
			_text.y = 5;
			_text.textColor = 0xBB0000;
			_text.multiline = true;
			_text.wordWrap = true;
			addChild(_text);
		}
		
		private function display(message:String):void
		{
			_text.appendText(message+ "\n");
		}
		
		
		
	}
	
}