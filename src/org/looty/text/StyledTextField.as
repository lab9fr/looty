/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.text 
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.*;	
	import flash.errors.IllegalOperationError;
	import flash.geom.ColorTransform;	
	import flash.utils.Dictionary;
	import org.looty.core.looty;
	import org.looty.core.text.FontManager;
	import org.looty.core.text.IStylable;
	import org.looty.font.FontEmbed;
	import org.looty.localisation.Text;
	import org.looty.Looty;
	import org.looty.net.CSSLoad;
	
	//FIXME get different styles...
	//FIXME other properties with update...
	//TODO right align reposition.
	
	use namespace looty;

	public class StyledTextField extends Sprite implements IStylable
	{
		
		private var _textField					:TextField;
		private var _textFieldContainer			:Sprite; //hack for fp9 not drawing textfield directly
		private var _backgroundColor			:uint;
		
		private var _htmlText					:String;
		private var _truncated					:String;
		private var _richText					:String;
		private var _text						:Text;	
		
		private var _isOverflowingAtNewLine		:Boolean;
		private var _isOverflowed				:Boolean;
		private var _overflowRichText			:String;
		private var _overflowIndex				:uint;
		private var _truncateIndex				:uint;
		
		private var _textVars					:Dictionary;
		private var _hasTextVars				:Boolean;				
		
		public var adjust						:Function;
		public var updateVars					:Function;
		
		private var _styleSheet					:StyleSheet;	
		
		private var _width						:uint;
		private var _height						:uint;		
		private var _maxLines					:uint;
		private var _minChars					:uint;
		
		private var _linkedStyled				:StyledTextField;
		
		public function StyledTextField(text:Text = null, width:int = 0, height:Number = 0) 
		{
			StyleManager.looty::addStylable(this);
			
			_width = width;
			_height = height;
			
			initialise();
			
			if (text != null) this.text = text;			
		}
		
		protected function initialise():void
		{
			_backgroundColor = 0x00000000;
			_htmlText = "";
			_overflowRichText = "<flashrichtext version=\"1\"/>";
			_maxLines = 0;
			_minChars = 1;
			_overflowIndex = 0;
			_truncateIndex = 0;
			
			createContainer();			
			protected::textField = new TextField();			
		}
		
		protected function hack():void
		{
			/**
			 * Sometimes textField properties aren't accessible at their proper values (like getCharBoundaries and getLineMetrics).
			 * Drawing the textfield in a bitmapdata seems to make it work properly at some occurence. Not a reliable workaround anyway, what's bugging is that it actually works most of the time...
			 */
			
			var bmd:BitmapData = new BitmapData(1,1);
			bmd.draw(_textFieldContainer);
		}
		
		protected function createContainer():void
		{
			textFieldContainer = this;
		}
		
		protected function applyProperties():void
		{
			_textField.text = "";
			
			_textField.multiline = true;
			_textField.wordWrap = _width != 0;		
			_textField.autoSize = (_width == 0 || _height == 0) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
			
			if (_width != 0)
			{
				_textField.width = _width;
				if (_height != 0)_textField.height = _height;
			}		
			
		}
		
		protected function applyHtml():void
		{
			applyProperties();
			_isOverflowed = false;
			_textField.styleSheet = _styleSheet;
			_textField.htmlText = _hasTextVars ? replaceVars(_htmlText) : _htmlText;
			
			testEmbed();
			
			hack();
			
			if (_width != 0 && (_height != 0 || _maxLines != 0)) retrieveOverflow();
		}
		
		protected function applyRichText():void
		{
			applyProperties();
			_textField.styleSheet = null;
			_textField.text = "";
			_textField.insertXMLText(0, String(XML(_richText)).length, _richText);
			
			hack();
			
			if (_width != 0 && (_height != 0 || _maxLines != 0)) retrieveOverflow();
		}
		
		protected function testEmbed():void
		{
			var textRun:TextRun;
			var textRuns:Array = _textField.getTextRuns();
			var isEmbed:Boolean = true;
			
			while ((textRun = textRuns.shift()) != null && isEmbed) isEmbed &&= FontManager.testEmbed(textRun.textFormat);
			
			_textField.embedFonts = isEmbed || !Looty.useDeviceFonts;
		}
		
		protected function retrieveOverflow():void
		{
			_richText = _textField.getXMLText();
			var lastLine:int = _textField.bottomScrollV;
			_overflowIndex = length;
			
			if (_overflowIndex == 0) return;		
			
			if (_maxLines != 0 && _maxLines < lastLine) lastLine = _maxLines;
			else if (lastLine == _textField.numLines)
			{
				_truncated = _textField.getXMLText();
				_overflowRichText = "<flashrichtext version=\"1\"/>";
				_isOverflowed = false;
				_overflowIndex = 0;
				_truncateIndex = 0;
				return;
			}
			
			var lastIndex:uint = _textField.getLineOffset(lastLine);
			_overflowIndex = lastIndex;
			var endIndex:int;
			var text:String = _textField.text;			
			
			if (_isOverflowingAtNewLine)
			{
				endIndex = text.substr(0, lastIndex).lastIndexOf(String.fromCharCode(13));
				if (endIndex == -1) endIndex = lastIndex;
				_overflowIndex = endIndex;
				while (/\s/.test(text.charAt(endIndex - 1))) --endIndex;
				
				lastLine = _textField.getLineIndexOfChar(endIndex) + 1;
				_isOverflowed = true;
				_truncateIndex = endIndex;
			}
			
			if ((!_isOverflowingAtNewLine) || endIndex < _minChars)
			{
				endIndex = lastIndex;
				_truncateIndex = lastIndex;
				_overflowIndex = lastIndex;
				while (!(/\s/.test(text.charAt(endIndex))) && endIndex < text.length) ++endIndex;
				_isOverflowed = endIndex < text.length;
				
			}
			
			while (/\s/.test(text.charAt(_overflowIndex)) && _overflowIndex < length) _overflowIndex++;
			
			_overflowRichText = _textField.getXMLText(_overflowIndex);			
			
			_truncated = _textField.getXMLText(0, endIndex);
			
			var i:int;
			
			var b:Rectangle = _textField.getCharBoundaries(0);//still happens to bug even with hack
			var h:Number = b != null ? b.y * 2 : 4;//workaround as generaly the gutter has a vale of 2
			for (i = 0; i < lastLine; ++i) h += _textField.getLineMetrics(i).height;
			_textField.autoSize = TextFieldAutoSize.NONE;			
			_textField.height = h;
			
			if (_isOverflowed)
			{
				_textField.text = "";
				_textField.styleSheet = null;
				_textField.insertXMLText(0, String(XML(_truncated)).length, _truncated);
				
				if (_textField.getTextFormat(length - 1).align == TextFormatAlign.JUSTIFY)
				{				
					var etc:String = "";
					for (i = _overflowIndex; i < endIndex; ++i) etc += "…";
					_textField.appendText(etc);
				}
				
				if (_linkedStyled != null) _linkedStyled.fillOverflow(this);
			}		
			
		}
		
		public function update():Boolean
		{			
			if (!isReady) return false;
			
			applyHtml();			
			
			if (adjust != null) adjust();
			
			return true;
		}
		
		internal function fillOverflow(styled:StyledTextField):void
		{
			if (styled == null)
			{
				_richText = "<flashrichtext version=\"1\"/>";
				applyRichText();
			}
			else
			{
				_richText = styled._overflowRichText;
				_textField.embedFonts = styled._textField.embedFonts;
				applyRichText();
			
				if (adjust != null) adjust();
				
			}
		}
		
		public function get text():Text { return _text; }
		
		public function set text(value:Text):void 
		{		
			if (_text != null) _text.looty::onChange = null;
			_text = value;
			if (_text != null) _text.looty::onChange = change;
			change();
		}
		
		public function change():void
		{
			if (_text == null) return;
			htmlText = _text.styledContent;
		}
		
		public function get textField():TextField { return _textField; }
		
		protected function set textField(value:TextField):void 
		{
			if (value == null || value == _textField) return;
			if (_textField != null && _textFieldContainer.contains(_textField)) _textFieldContainer.removeChild(_textField);
			
			_textField = value;
			_textField.selectable = false;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.gridFitType = GridFitType.PIXEL;			
			_textFieldContainer.addChild(_textField);			
			
			if (_text != null || _htmlText != "") update();
		}
		
		public function get htmlText():String { return _htmlText; }
		
		public function set htmlText(value:String):void 
		{
			_htmlText = value;
			
			update();
		}
		
		public function get content():String { return _textField.text; }
		
		private function replaceVars(value:String):String
		{
			if (updateVars != null) updateVars();
			
			if ((/\$\{\w+\}/.test(value))) for (var textVar:String in _textVars) 
			{
				value = value.replace("${" + textVar  +"}", _textVars[textVar]);		
			}
			return value;
		}
		
		public function setTextvar(id:String, value:String):void
		{
			if (!_hasTextVars) 
			{
				_hasTextVars = true;
				_textVars = new Dictionary();
			}
			
			_textVars[id] = value;
			
			update();
		}
		
		override public function set x(value:Number):void 
		{
			super.x = value |0;
		}
		
		override public function set y(value:Number):void 
		{
			super.y = value |0;
		}
		
		override public function get width():Number { return (_textField.width + .96) | 0; }
		
		override public function set width(value:Number):void 
		{
			_width = int(value + .96);
			update();
		}
		
		override public function get height():Number { return (_textField.height + .96) | 0; }
		
		override public function set height(value:Number):void 
		{
			_height = int(value + .96);
			update();
		}
		
		public function resize(width:Number):void
		{			
			_textField.autoSize = TextFieldAutoSize.LEFT;
			
			if (_isOverflowed) while (/…$/.test(_textField.text)) _textField.replaceText(length - 1, length, "");
			
			_textField.width = width;
			
			_textField.height;
		}
		
		public function get backgroundColor():uint { return _backgroundColor; }
		
		public function set backgroundColor(value:uint):void 
		{
			_backgroundColor = value;
			
			//TODO
		}
		
		
		protected function get textFieldContainer():Sprite { return _textFieldContainer; }
		
		protected function set textFieldContainer(value:Sprite):void 
		{
			_textFieldContainer = value;
		}
		
		protected function get isReady():Boolean { return _textField != null && _styleSheet != null; }
		
		
		//FIXME : bug...
		public function wrap(tf:TextField):StyledTextField
		{
			var tfParent:DisplayObjectContainer = tf.parent;
			tfParent.addChildAt(this, tfParent.getChildIndex(tf));	
			this.transform = tf.transform;
			tf.transform.matrix = new Matrix();
			tfParent.removeChild(tf);
			protected::textField = tf;
			
			return this;
		}
		
		public function get styleSheet():StyleSheet
		{
			return _styleSheet;
		}
		
		public function set styleSheet(value:StyleSheet):void
		{
			_styleSheet = value;
			update();
		}
		
		public function get maxLines():uint { return _maxLines; }
		
		public function set maxLines(value:uint):void 
		{
			_maxLines = value;
			update();
		}
		
		public function get length():uint { return _textField != null ? _textField.length : 0; }
		
		public function get isOverflowingAtNewLine():Boolean { return _isOverflowingAtNewLine; }
		
		public function set isOverflowingAtNewLine(value:Boolean):void 
		{
			_isOverflowingAtNewLine = value;
			update();			
		}
		
		public function get linkedStyled():StyledTextField { return _linkedStyled; }
		
		public function set linkedStyled(value:StyledTextField):void 
		{
			if (_linkedStyled == value) return;
			if (_linkedStyled != null) _linkedStyled.fillOverflow(null);
			_linkedStyled = value;
			_linkedStyled.fillOverflow(this);
		}
		
		public function get overflowIndex():uint { return _overflowIndex; }
		
		public function get isOverflowed():Boolean { return _isOverflowed; }
		
		public function get overflowRichText():String { return _overflowRichText; }
		
		public function get minChars():uint { return _minChars; }
		
		public function set minChars(value:uint):void 
		{
			_minChars = value;
		}
		
		protected function get truncateIndex():uint { return _truncateIndex; }
		
	}

}