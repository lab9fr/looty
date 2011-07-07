/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 10/12/2009 05:39
 * @version 0.1
 */

package org.looty.text 
{
	import flash.errors.IllegalOperationError;
	import flash.text.*;
	import org.looty.core.disposable.IDisposable;
	import org.looty.core.looty;
	import org.looty.core.text.*;
	import org.looty.data.*;
	import org.looty.font.*;
	
	use namespace looty;
	
	public class TextInput implements IDisposable
	{
		
		private var _focusIns		:MethodList;
		private var _focusOuts		:MethodList;
		private var _textChanges	:MethodList;
		
		private var _onFocusIn		:Function;
		private var _onFocusOut		:Function;
		private var _onTextChange	:Function;
		
		private var _isFocused		:Boolean;
		private var _hasContent		:Boolean;
		
		private var _target			:TextField;
		
		private var _label			:String;
		
		static private const CONTAINER	:TextInputContainer = new TextInputContainer();
		
		public function TextInput(target:TextField, fontName:String="", size:uint = 12, color:uint = 0xFFFFFF, bold:Boolean = false, italic:Boolean = false, multiline:Boolean = false, align:String = "left") 
		{
			if (target == null) throw new IllegalOperationError("TextField target can't have a null value");
			_target = target;
			
			_label = "";
			
			switch(align)
			{
				case TextFormatAlign.LEFT:
				case TextFormatAlign.CENTER:
				case TextFormatAlign.RIGHT:
				case TextFormatAlign.JUSTIFY:
				break;
				
				default:
				align = TextFormatAlign.LEFT;
			}
			
			var textFormat:TextFormat = new TextFormat(fontName, size, color, bold, italic, null, null, null, align);
			
			_target.selectable = true;
			_target.type = TextFieldType.INPUT;			
			_target.embedFonts = FontManager.testEmbed(textFormat);
			_target.antiAliasType = AntiAliasType.ADVANCED;
			_target.gridFitType = GridFitType.PIXEL;
			_target.defaultTextFormat = textFormat;
			_target.multiline = multiline;
			
			CONTAINER.register(_target, this);
		}
		
		public function focusIn():void 
		{
			if (_focusIns != null) _focusIns.call();
			if (_onFocusIn != null) _onFocusIn();
			
			_isFocused = true;
			if (!_hasContent) _target.text = "";
		}
		
		public function focusOut():void 
		{ 
			if (_focusOuts != null) _focusOuts.call();
			if (_onFocusOut != null) _onFocusOut();
			
			_isFocused = false;
			if (/\S/.test(_target.text)) _hasContent = true;
			else _target.text = _label;
		}
		public function textChange():void 
		{ 
			if (_textChanges != null) _textChanges.call();
			if (_onTextChange != null) _onTextChange();
		}
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			_label = value;
			
			if (!_hasContent && !_isFocused) _target.text = _label;
		}
		
		public function get text():String 
		{
			return _target.text != _label ? _target.text : ""; 
		}
		
		public function get hasContent():Boolean { return _hasContent; }
		
		public function get isFocused():Boolean { return _isFocused; }
		
		public function get target():TextField { return _target; }
		
		looty function get focusIns():MethodList 
		{
			if (_focusIns == null) _focusIns = new MethodList();
			return _focusIns; 
		}
		
		looty function get focusOuts():MethodList 
		{
			if (_focusOuts == null) _focusOuts = new MethodList();
			return _focusOuts; 
		}
		
		looty function get textChanges():MethodList 
		{
			if (_textChanges == null) _textChanges = new MethodList();
			return _textChanges; 
		}
		
		public function get onFocusIn():Function { return _onFocusIn; }
		
		public function set onFocusIn(value:Function):void 
		{
			_onFocusIn = value;
		}
		
		public function get onFocusOut():Function { return _onFocusOut; }
		
		public function set onFocusOut(value:Function):void 
		{
			_onFocusOut = value;
		}
		
		public function get onTextChange():Function { return _onTextChange; }
		
		public function set onTextChange(value:Function):void 
		{
			_onTextChange = value;
		}
		
		public function dispose():void
		{
			_target = null;
			
			if (_focusIns != null) _focusIns.dispose();
			_focusIns = null;
			if (_focusOuts != null) _focusOuts.dispose();
			_focusOuts = null;
			if (_textChanges != null) _textChanges.dispose();
			_textChanges = null;
			
			_onFocusIn = null;
			_onFocusOut = null;
			_onTextChange = null;
			
			
		}
		
	}
	
}