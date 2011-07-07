/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 11/12/2009 08:48
 * @version 0.1
 */

package org.looty.core.form 
{
	import flash.display.DisplayObject;
	
	public class DisplayObjectFiltersHandler 
	{
		
		private var _displayObject		:DisplayObject;
		private var _filters			:Array;
		
		private var _areApplied			:Boolean;
		
		public function DisplayObjectFiltersHandler(displayObject:DisplayObject) 
		{
			_displayObject = displayObject;
		}
		
		public function applyFilters(filters:Array):void
		{
			if (_areApplied) return;
			
			if (_displayObject.filters != null)
			{
				_filters = _displayObject.filters.slice();
				_displayObject.filters = _filters.concat(filters);
			}
			else
			{
				_filters = null;
				_displayObject.filters = filters;
			}
			
			_areApplied = true;
		}
		
		public function recoverFilters():void
		{
			if (!_areApplied) return;
			
			_displayObject.filters = _filters != null ? _filters.slice() : null;
			
			_areApplied = false;
		}
		
		public function get displayObject():DisplayObject { return _displayObject; }
		
	}
	
}