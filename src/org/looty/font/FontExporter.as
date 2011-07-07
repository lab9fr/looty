/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 10/01/2010 01:04
 * @version 0.1
 */

package org.looty.font 
{
	import flash.display.Sprite;
	import flash.text.Font;
	import org.looty.log.Looger;
	
	public class FontExporter extends Sprite
	{
		
		public function FontExporter() 
		{
			
		}
		
		protected function registerFont(font:Class):void
		{
			Looger.info("export font :" + new font().fontName);
			Font.registerFont(font);
		}
		
	}
	
}