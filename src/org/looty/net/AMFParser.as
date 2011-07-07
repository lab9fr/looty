/**
 * @project Silenzio
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @version 1.0
 */

package org.looty.net 
{
	
	public class AMFParser 
	{
		
		private var _content		:Array;
		private var _columns		:Array;
		
		public function AMFParser(result:Object) 
		{
			_content = new Array();
			
			var datas:Array = result.serverInfo.initialData as Array;
			_columns = result.serverInfo.columnNames as Array;
			var obj:Object;
			
			var dl:int = datas.length;
			var cl:int = _columns.length;
			
			for each(var data:Array in datas)
			{
				obj = new Object();

				for (var i:int = 0; i < cl; i++)
				{
					obj[_columns[i]] = data [i];
				}
				
				_content.push(obj);
			}

 			
		}
		
		public function toString():String
		{
			return String(_content);
		}
		
		public function get content():Array { return _content; }
		
		public function get columns():Array { return _columns; }
		
	}
	
	
}