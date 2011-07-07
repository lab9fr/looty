/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 19/03/2010 19:41
 * @version 0.1
 */

package org.looty.localisation 
{
	import flash.text.StyleSheet;
	import org.looty.sequence.Sequencable;
	import org.looty.sequence.Sequence;
	
	public class LocalisationDataEmbed extends Sequence
	{
		
		private var _sequencable		:Sequencable;
		
		private var _lang				:String;
		private var _loc				:XML;
		private var _css				:StyleSheet;
		
		public function LocalisationDataEmbed(lang:String, loc:XML, css:String) 
		{
			_sequencable = new Sequencable();
			_sequencable.setEntry(parse);
			append(_sequencable);
			
			//trace(loc);
			//trace(css);
			_lang = lang;
			_loc = loc;
			_css = new StyleSheet();
			_css.parseCSS(css);
		}
		
		private function parse():void
		{
			var node:XML;
			
			for each (node in _loc.text)
			{
				//trace(node);
				if (node.@unid[0] == undefined) continue;
				Localisation.fill(node.@unid, _lang, String(node), node.@styleName != null ? node.@styleName : "", node.@textTransform != null ? node.@textTransform : "");
			}
			
			Localisation.addStyle(_css, _lang);
			
			
			_sequencable.complete();
		}
		
		
		
		public function get lang():String { return _lang; }
		
	}
	
}