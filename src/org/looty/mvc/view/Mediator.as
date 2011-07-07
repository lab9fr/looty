/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 27/03/2010 17:09
 * @version 0.1
 */

package org.looty.mvc.view 
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import org.looty.core.*;
	import org.looty.core.mvc.AbstractLayerElement;
	import org.looty.display.*;
	import org.looty.log.Looger;
	import org.looty.Looty;
	import org.looty.mvc.controller.*;
	import org.looty.mvc.model.*;
	import org.looty.mvc.view.*;
	
	use namespace looty;
	
	public class Mediator extends AbstractLayerElement
	{
		
		looty var presenter				:Presenter;
		
		private var _isDisplayed		:Boolean;
		
		private var _layerIndex			:Number;
		
		private var _allowDestruction	:Boolean;
		
		private var _isConstructed		:Boolean;
		
		private var _resizables			:Dictionary;
		
		private var _renderables		:Dictionary;
		
		private var _component			:*;
		
		private var _isRendering		:Boolean;
		
		private var _actives			:Dictionary;
		
		private var _presenter			:Presenter;
		
		public function Mediator() 
		{
			_layerIndex = 0;
			_component = new Layer();
			
			_resizables = new Dictionary(true);
			_renderables = new Dictionary(true);
			_actives = new Dictionary(true);
			
			_isRendering = true;
			
			selection.looty::starts.add(startSelection);
			unselection.looty::completes.add(completeUnselection);
		}
		
		override final public function configure(xml:XML, presenter:Presenter = null):void 
		{
			_presenter = presenter;
			
			super.configure(xml, presenter);
			
			if (xml != null)
			{
				if (xml.@layerIndex[0] != undefined) layerIndex = Number(xml.@layerIndex[0]);
			}
		}		
		
		looty function startSelection():void
		{
			if (!_isConstructed) 
			{
				_isConstructed = true;
				construct();
			}
			
			looty::doResize();	
			
			if (!_isDisplayed) display();
			
			Looger.debug("display", presenter.id);
			
			_isDisplayed = true;
		}
		
		public function display():void
		{
			view.looty::addActive(this);//TODO move from display ?
			view.layer.addChild(layer);
			
		}
		
		public function construct():void
		{
			
		}
		
		looty function completeUnselection():void
		{
			if (_isDisplayed) undisplay();	
			
			Looger.debug("undisplay", presenter.id);
			
			_isDisplayed = false;
			
			if (_allowDestruction && _isConstructed)
			{
				destruct();				
			}
		}
		
		public function undisplay():void
		{
			view.looty::removeActive(this);
			view.layer.removeChild(layer);
		}
		
		public function destruct():void
		{
			_isConstructed = false;
		}
		
		looty function addActive(mediator:Mediator):void
		{
			_actives[mediator] = true;
		}
		
		looty function removeActive(mediator:Mediator):void
		{
			_actives[mediator] = null;
			delete _actives[mediator];
		}
		
		public function registerResizable(displayObject:DisplayObject, ratioX:Number = 0, ratioY:Number = 0, offsetX:Number = 0, offsetY:Number = 0, absolute:Boolean = false):Resizable
		{
			if (displayObject == null) throw new IllegalOperationError("can't registerResizable on null");
			var resizable:Resizable = new Resizable(displayObject);
			
			resizable.ratioX = ratioX;
			resizable.ratioY = ratioY;
			resizable.offsetX = offsetX;
			resizable.offsetY = offsetY;
			resizable.absolute = absolute;
			
			return addResizable(resizable);
		}
		
		public function addResizable(resizable:Resizable):Resizable
		{
			_resizables[resizable.displayObject] = resizable;
			return resizable;
		}
		
		public function removeResizable(resizable:Resizable):Resizable
		{
			_resizables[resizable.displayObject] = null;
			delete _resizables[resizable.displayObject];
			return resizable;
		}
		
		looty function doResize():void
		{
			for (var mediator:* in _actives) Mediator(mediator).looty::doResize();
			for each (var resizable:Resizable in _resizables) resizable.update();
			resize();
		}
		
		public function resize():void
		{
			
		}
		
		public function addRenderable(renderable:IRenderable):IRenderable
		{
			if (renderable == null) return null
			_renderables[renderable] = true;
			return renderable;
		}
		
		public function removeRenderable(renderable:IRenderable):IRenderable
		{
			if (renderable == null) return null
			_renderables[renderable] = null;
			delete _renderables[renderable];
			return renderable;
		}
		
		looty function doRender():void
		{
			if (!isRendering) return;
			for (var mediator:* in _actives) Mediator(mediator).looty::doRender();
			for (var renderable:* in _renderables) IRenderable(renderable).render();
			render();
		}
		
		public function render():void
		{
			
		}
		
		public function get isDisplayed():Boolean { return _isDisplayed; }
		
		public function get layerIndex():Number { return _layerIndex; }
		
		public function set layerIndex(value:Number):void 
		{
			_layerIndex = value;
			if (Boolean(layer)) layer.layerIndex = value;
		}
		
		public function get allowDestruction():Boolean { return _allowDestruction; }
		
		public function set allowDestruction(value:Boolean):void 
		{
			_allowDestruction = value;
		}
		
		public function get component():* { return _component; }
		
		public function set component(value:*):void 
		{
			_component = value;
			if (Boolean(layer)) layer.layerIndex = _layerIndex;
		}		
		
		public function get layer():Layer { return Layer(component); }
		
		public function get isRendering():Boolean { return _isRendering; }
		
		public function set isRendering(value:Boolean):void 
		{
			_isRendering = value;
		}
		
		public function get presenter():Presenter { return _presenter; }
		
		public function get data():Data { return _presenter.data; }
		
		public function get stageWidth():Number { return Looty.stage.stageWidth; }
		
		public function get stageHeight():Number { return Looty.stage.stageHeight; }
		
	}
	
}