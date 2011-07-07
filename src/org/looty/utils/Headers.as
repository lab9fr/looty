/**
 * @project akoa
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @created 03/07/2010 21:35
 * @version 0.1
 */

package org.looty.utils 
{

	public class Headers
	{
		
		public function Headers() 
		{
			
			public static function checkFileExt(file:FileReference):String
{
var bytes:ByteArray = new ByteArray();
 
file.data.position = 0;
file.data.readBytes(bytes);
 
var len:uint = Math.floor(bytes.length/2);
 
var tmpArray:Array = FileHeaders.slice(0);
 
for(var i:uint=0;i<len;i+=2)
{
var byte:uint;
 
try
{
byte = bytes.readByte();
}
catch(e:Error)
{
break;
}
 
var bstr:String = byte.toString(16);
 
bstr = bstr.slice(bstr.length-2).toUpperCase();
bstr = bstr.length<2 ? “0″+bstr : bstr;
tmpArray = filterLetters(bstr, tmpArray, i);
 
if(tmpArray.length == 1 && tmpArray[0].header.length == i+2)
{
return tmpArray[0].ext;
}
 
if(tmpArray.length == 0)
{
break;
}
}
 
//
return “unknown”;
}
			JPEG (jpg),header:FFD8FF
 
PNG (png),header:89504E47
 
GIF (gif),header:47494638
 
TIFF (tif),header:49492A00
 
Windows Bitmap (bmp),header:424D
 
CAD (dwg),header:41433130
 
Adobe Photoshop (psd),header:38425053
 
Rich Text Format (rtf),header:7B5C727466
 
XML (xml),header:3C3F786D6C
 
HTML (html),header:68746D6C3E
 
MS Word/Excel (xls.or.doc),header:D0CF11E0
 
MS Access (mdb),header:5374616E64617264204A
 
WordPerfect (wpd),header:FF575043
 
Adobe Acrobat (pdf),header:255044462D312E
 
ZIP Archive (zip),header:504B0304
 
Gzip Archive File(.gz;.tar;.tgz), header:1F8B
 
JAR Archive File(jar), header:5F27A889
 
RAR Archive (rar),header:52617221
 
Wave (wav),header:57415645
 
AVI (avi),header:41564920
 
Real Audio (ram),header:2E7261FD
 
Real Media (rm),header:2E524D46
 
MPEG (mpg),header:000001BA
 
MPEG (mpg),header:000001B3
 
Quicktime (mov),header:6D6F6F76
 
Windows Media (asf),header:3026B2758E66CF11
 
MIDI (mid),header:4D546864
		}
		
	}

}