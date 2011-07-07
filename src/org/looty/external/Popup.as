/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.external
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	public class Popup 
	{
		
		private var _title			:String;
		
		static private var _embed	:Boolean
		
		public function Popup(title:String = "") 
		{
			if (!_embed) embedASPopup ()
			
			_title = title != "" ? title.replace(" ","_") : "_blank";			
		}
		
		
		
		public function open (url:String, width:int, height:int):void
		{			
			if (!ExternalInterface.call ("ASPopup", url , _title, width, height)) 
			{
				var left:int=(Capabilities.screenResolutionX - width)/2;
				var top:int=(Capabilities.screenResolutionY - height)/2;
				navigateToURL(new URLRequest("javascript:popup=window.open(\""+ url + "\",\"" + _title + "\",\"top=" + top + ",left=" + left + ",width=" + width + ",height=" + height + ",toolbar=0,scrollbars=0,location=1,statusbar=0,menubar=0,resizable=0\");void(0);"), '_self');
			}
		}
		
		private function embedASPopup():void
		{
			var js:XML =
			<script>
				<![CDATA[
				function ()
				{
					ASPopup = function (url, popname, width, height) 
					{
						var left=(screen.width - width)/2;   
						var top=(screen.height - height)/2;
						var options = "top=" + top + ",left=" + left + ",width=" + width + ",height=" + height + ",toolbar=0,scrollbars=0,location=1,statusbar=0,menubar=0,resizable=0";
						var newWin = window.open(url, popname, options);

						if (!newWin) 
						{
							newWin = window.open('',popname, options);
							newWin.location.href = url;
							if (!newWin) return false;							
						}
						
						newWin.focus();
						return true;
						
					}
				}
				]]>
			</script>;
			
			ExternalInterface.call (js);
			
			_embed = true;
		}
		
	}
	
}