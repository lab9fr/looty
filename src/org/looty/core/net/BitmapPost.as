/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.3
 * 
 * @original code : UploadPostHelper by Jonathan Marston
 * refactored & modified.
 */

package org.looty.core.net 
{
	
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	//FIXME : not working
	
	public class BitmapPost extends ByteArray
	{
		
		private const LB			:String = String.fromCharCode(0x0d) + String.fromCharCode(0x0a);		
		
		private var _boundary			:String;
		
		public function BitmapPost (stream:ByteArray, fileName:String, variables:URLVariables = null) 
		{
			super ();
			
			createBoundary();			
			
			if (variables == null) variables = new URLVariables ();			
			variables.Filename = fileName;
			
			for (var name:String in variables) 
			{
				writeUTFBytes ('--' + _boundary + 'Content-Disposition: form-data; name="' + name + '"' + LB + LB);
				writeUTFBytes (variables[name] + LB);	
			}
			
			writeUTFBytes ('--' + _boundary + 'Content-Disposition: form-data; name="Filedata"; filename="' + fileName + '"' + LB);
			writeUTFBytes ('Content-Type: application/octet-stream' + LB + LB);
			
			writeBytes(stream, 0, stream.length);
			writeUTFBytes (LB + LB);
			
			writeUTFBytes ('--' + _boundary + 'content-Disposition: form-data; name="Upload"' + LB + LB);
			writeUTFBytes ('Submit Query' + LB);
			writeUTFBytes ('--' + _boundary );			
		}
		
		private function createBoundary():void
		{
			_boundary = "";
			var c:int;
			for (var i:int = 0; i < 32; i++ ) 
			{
				c = 97 + Math.random() * 25;
				_boundary += String.fromCharCode(c);
			}
		}
		
		public function get boundary ():String { return _boundary; }
		
	}
	
}