/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 11/12/2009 08:28
 * @version 0.1
 */

package org.looty.form 
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import org.looty.core.form.DisplayObjectFiltersHandler;
	import org.looty.core.form.IFormErrorDisplay;
	import org.looty.core.form.IFormItem;
	
	public class FormErrorFilters implements IFormErrorDisplay
	{
		
		static private var _filters		:Array;
		private var _handlers			:Array;
		
		
		public function FormErrorFilters(displayObjects:Array) 
		{
			_handlers = [];
			for each (var displayObject:DisplayObject in displayObjects) _handlers.push(new DisplayObjectFiltersHandler(displayObject));			
		}
		
		static public function configure(filters:Array = null):void
		{
			_filters = filters;
		}
		
		public function showError(code:String = ""):void
		{
			for each(var handler:DisplayObjectFiltersHandler in _handlers) handler.applyFilters(_filters);
		}
		
		public function hideError():void
		{
			for each(var handler:DisplayObjectFiltersHandler in _handlers) handler.recoverFilters();
		}
		
	}
	
}