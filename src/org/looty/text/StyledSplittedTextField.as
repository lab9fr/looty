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
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.text.TextRun;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import org.looty.core.looty;
	import org.looty.core.text.BitmapCharacter;
	import org.looty.core.text.CharactersTable;
	import org.looty.core.text.FontManager;
	import org.looty.interactive.ColoredInteraction;
	import org.looty.interactive.Interaction;
	import org.looty.localisation.Text;
	import org.looty.log.Looger;
	import org.looty.Looty;
	import org.looty.text.StyledTextField;
	
	use namespace looty;

	public class StyledSplittedTextField extends StyledBitmapTextField
	{
		
		private var _colorTransform		:ColorTransform;		
		private var _bitmapCache		:Bitmap;
		private var _bitmapCacheData	:BitmapData;
		private var _smoothing			:Boolean;
		private var _letters			:Array;
		private var _line				:TextField;
		
		private var _minLetters			:int;
		
		private var _updatePosition		:Function;
		
		private var _interactions		:Dictionary;
		
		private var _maxHeight			:Number;
		
		public var overColor			:int;
		
		private var _letterContainer	:Sprite;
		
		private var _isSplitted			:Boolean;
		
		public function StyledSplittedTextField(text:Text = null, width:int = 0, height:Number = 0, overColor:int = -1) 
		{
			this.overColor = overColor;			
			
			super(text, width, height);
		}
		
		override protected function initialise():void 
		{
			_maxHeight = 0;
			_letters = [];
			_line = new TextField();
			_line.selectable = false;
			_line.antiAliasType = AntiAliasType.ADVANCED;
			_line.gridFitType = GridFitType.PIXEL;
			_line.multiline = true;
			
			_letterContainer = new Sprite();
			
			super.initialise();
			isSplitted = true;
		}
		
		override public function update():Boolean 
		{
			if (!super.update()) return false;
			
			build();
			
			return true;
		}
		
		override internal function fillOverflow(styled:StyledTextField):void 
		{
			super.fillOverflow(styled);
			
			build();
		}
		
		private function build():void
		{
			
			var letter:BitmapLetter;
			
			while (_letterContainer.numChildren > 0) _letterContainer.removeChildAt(0); 
			_letters = [];		
			
			if (length == 0) return;
			
			_line.embedFonts = public::textField.embedFonts;			
			_line.autoSize = public::textField.autoSize;
			_line.wordWrap = public::textField.wordWrap;
			_line.width = width;
			
			var char:String;
			var table:CharactersTable;
			var character:BitmapCharacter;
			var i:int;
			var l:int;
			
			var bounds:Rectangle;
			
			var beginIndex:int;
			var endIndex:int;
			
			var ln:int;
			var numLines:int =  public::textField.numLines;
			
			var textRun:TextRun;
			var textFormat:TextFormat;
			var metrics:TextLineMetrics;
			var interaction:Interaction;
			
			var bi:int;
			var ei:int;
			
			bounds = public::textField.getCharBoundaries(0);
			
			var baseLine:Number = bounds == null ? 2 : bounds.y;
			
			lineloop:for (ln = 0; ln < numLines; ++ln)
			{
				
				beginIndex = public::textField.getLineOffset(ln);
				endIndex = ln < numLines - 2 ? public::textField.getLineOffset(ln + 2): public::textField.length;
				metrics = public::textField.getLineMetrics(ln);
				
				baseLine += metrics.ascent;				
				
				_line.text = public::textField.text.substring(beginIndex, endIndex);
				
				for each (textRun in public::textField.getTextRuns(beginIndex, endIndex)) 
				{					
					bi = textRun.beginIndex - beginIndex;
					if (bi < 0) bi = 0;
					ei = textRun.endIndex - beginIndex;
					if (ei > endIndex) ei = _line.length;				
					
					_line.setTextFormat(textRun.textFormat, bi, ei);
				}
				
				l = _line.numLines > 1 ? _line.getLineOffset(1) : _line.length;
				
				for (i = 0; i < l; ++i)
				{
					if (isOverflowed && truncateIndex <= beginIndex + i) break lineloop;
					
					char = _line.text.charAt(i);
					
					if (/\s/.test(char)) 
					{
						_letters.push(null);
						continue;
					}
					
					textFormat = _line.getTextFormat(i);
					table = FontManager.getTable(textFormat);
					character = table.getCharacter(char);
					
					if (character == null) 
					{
						_letters.push(null);
						continue;
					}
					
					bounds = _line.getCharBoundaries(i);
					
					if (bounds == null)
					{
						Looger.error("bounds error at Unicode U" + char.charCodeAt().toString(16));
						continue;
					}
					
					letter = new BitmapLetter(character, textFormat, _smoothing);
					
					letter.position.x = letter.x = bounds.x  + bounds.width * .5;
					
					letter.position.y = letter.y = baseLine - letter.character.lineOffset;
					
					if (textFormat.url != "")
					{
						if (_interactions == null) _interactions = new Dictionary();
						if (_interactions[textFormat.url] == null)
						{
							if (overColor != -1)
							{
								interaction = new ColoredInteraction(letter);
								ColoredInteraction(interaction).setColor(Number(textFormat.color), overColor, overColor);
							}
							else interaction = new Interaction(letter);
							
							interaction.url = textFormat.url;
							interaction.window = textFormat.target;
							
							_interactions[textFormat.url] = interaction;
						}
						else
						{
							interaction = _interactions[textFormat.url];
							interaction.addTarget(letter);
							if (interaction is ColoredInteraction) ColoredInteraction(interaction).addColorTarget(letter);
						}
					}
					
					_letters.push(letter);
					_letterContainer.addChild(letter);
				}
				
				baseLine += metrics.descent + metrics.leading;
				
			}
			
		}
		
		override public function resize(width:Number):void 
		{
			super.resize(width);
			
			if (_letters.length == 0) return;
			
			_line.width = width;
			
			var hasUpdate:Boolean = updatePosition != null;
			
			var letter:BitmapLetter;
			
			var char:String;
			var i:int;
			var l:int;
			
			var bounds:Rectangle;
			
			var beginIndex:int;
			var endIndex:int;
			
			var ln:int;
			var numLines:int = public::textField.numLines;
			
			var textRun:TextRun;
			var textFormat:TextFormat;
			var metrics:TextLineMetrics;
			
			var bi:int;
			var ei:int;
			
			bounds = public::textField.getCharBoundaries(0);
			
			var baseLine:Number = bounds == null ? 2 : bounds.y;
			
			lineloop:for (ln = 0; ln < numLines; ++ln)
			{
				beginIndex = public::textField.getLineOffset(ln);
				
				endIndex = ln < numLines - 2 ? public::textField.getLineOffset(ln + 2): length;
				metrics = public::textField.getLineMetrics(ln);
				
				baseLine += metrics.ascent;
				
				_line.text = public::textField.text.substring(beginIndex, endIndex);
				
				for each (textRun in public::textField.getTextRuns(beginIndex, endIndex)) 
				{					
					bi = textRun.beginIndex - beginIndex;
					if (bi < 0) bi = 0;
					ei = textRun.endIndex - beginIndex;
					if (ei > endIndex) ei = _line.length;				
					
					_line.setTextFormat(textRun.textFormat, bi, ei);
				}
				
				l = _line.numLines > 1 ? _line.getLineOffset(1) : _line.length;
				
				for (i = 0; i < l; ++i)
				{
					if (isOverflowed && truncateIndex <= beginIndex + i) break lineloop;
					
					char = _line.text.charAt(i);
					
					if (/\s/.test(char))continue;
					
					textFormat = _line.getTextFormat(i);
					
					bounds = _line.getCharBoundaries(i);
					
					letter = _letters[i + beginIndex];
					
					if (letter == null) continue;
					
					letter.position.x = bounds.x  + bounds.width * .5;					
					letter.position.y = baseLine - letter.character.lineOffset;
					
					if (!hasUpdate)
					{
						letter.x = letter.position.x;
						letter.y = letter.position.y;
					}
				}
				
				baseLine += metrics.descent + metrics.leading;
				
			}
			
		
			if (hasUpdate) updatePosition();
		}
		
		override public function set smoothing(value:Boolean):void 
		{
			if (_smoothing == value) return;
			_smoothing = value;
			
			build();
		}
		
		
		
		public function get letters():Array { return _letters.filter(notNull); }
		
		public function getLetterAt(index:uint):BitmapLetter { return _letters[index]; }
		
		private function notNull(letter:BitmapLetter, index:int, array:Array):Boolean
		{
			return letter != null;
		}
		
		public function get updatePosition():Function { return _updatePosition; }
		
		public function set updatePosition(value:Function):void 
		{
			_updatePosition = value;
		}
		
		public function get isSplitted():Boolean { return _isSplitted; }
		
		public function set isSplitted(value:Boolean):void 
		{
			if (_isSplitted == value) return;
			_isSplitted = value;
			
			_isSplitted ? switchToSplitted() : switchToBitmap();	
		}
		
		private function switchToBitmap():void
		{
			addChild(bitmap);
			removeChild(_letterContainer);
		}
		
		private function switchToSplitted():void
		{
			addChild(_letterContainer);
			removeChild(bitmap);			
		}
		
		private function remove(displayObject:DisplayObject):void
		{
			if (displayObject != null && contains(displayObject)) removeChild(displayObject);
		}
		
	}

}