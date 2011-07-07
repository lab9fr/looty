/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 22/04/2010 14:55
 * @version 0.1
 */

package org.looty.display
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import org.looty.activable.ActivableSprite;
	import org.looty.activable.IActivable;
	import org.looty.data.List;
	import org.looty.core.looty;
	import org.looty.log.Looger;
	import org.looty.Looty;
	
	//TODO : verify contains && removeChild (is contains true when child is nested ?)
	
	use namespace looty;
	
	public class Layer extends ActivableSprite
	{
		
		static private var _orderers	:Dictionary;
		
		private var _childLayers		:Array;
		
		private var _layerIndex			:Number;
		
		private var _x					:Number;
		private var _y					:Number;
		
		private var _isOrdering			:Boolean;
		
		public function Layer() 
		{
			if (_orderers == null) 
			{
				_orderers = new Dictionary(false);
				Looty.addExitFrame(executeOrderers);
			}
			
			super();
			
			x = 0;
			y = 0;			
			
			
			
			_layerIndex = 0;
			_childLayers = [];
		}	
		
		static private function executeOrderers():void
		{
			
			for (var orderer:* in _orderers) if (orderer is Function) orderer();
			_orderers = new Dictionary(false);
		}		
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			if (child == null)
			{
				Looger.fatal("");
				return child;
			}
			
			
			
			if (child is Layer) addLayer(Layer(child));			
			if (child is IActivable) addActivable(IActivable(child));
			
			order();
			
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			if (child == null)
			{
				Looger.fatal("doesn't contain child");
				return child;
			}
			
			if (child is Layer) addLayer(Layer(child));
			if (child is IActivable) addActivable(IActivable(child));
			
			order();
			
			return super.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject 
		{
			if (child == null || !contains(child))
			{
				Looger.fatal("removeChild does not contain child");
				return null;
			}
			
			if (child is Layer) removeLayer(Layer(child));
			if (child is IActivable) removeActivable(IActivable(child));
			
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject 
		{
			if (index < 0 || index >= numChildren)
			{
				Looger.fatal("has no child at index");
				return null;
			}
			
			var child:DisplayObject = getChildAt(index);
			
			if (child is Layer) removeLayer(Layer(child));
			if (child is IActivable) removeActivable(IActivable(child));
			
			return super.removeChildAt(index);
		}
		
		private function addLayer(layer:Layer):Layer
		{
			if (_childLayers.indexOf(layer) != -1)
			{
				Looger.warn("trying to add a layer already added");
				return null;
			}
			_childLayers.push(layer);
			
			return layer;
		}
		
		private function removeLayer(layer:Layer):Layer
		{
			if (!_childLayers.indexOf(layer) == -1)
			{
				Looger.error("can't remove a layer not present among childLayers");
				return null;
			}
			_childLayers.splice(_childLayers.indexOf(layer), 1);
			
			return layer;
		}		
		
		override protected function doActivate():void 
		{
			if (_isOrdering) order();
		}
		
		public function order():void
		{
			_isOrdering = true;
			if (isActive) _orderers[doOrder] = true;
		}
		
		protected function doOrder():void
		{
			_childLayers.sortOn("layerIndex", Array.NUMERIC);
			
			var layer:Layer;			
			for (var i:int = 0; i < _childLayers.length; ++i) 
			{
				layer = Layer(_childLayers[i]);
				
				if (layer == null || !contains(layer)) 
				{
					_childLayers.splice(i, 1);
					continue;
				}
				
				if (layer.layerIndex < 0) setChildIndex(layer, i);
				else if (layer.layerIndex > 0) setChildIndex(layer, numChildren -1);
			}
			
			_isOrdering = false;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			_childLayers = null;
			_isOrdering = false;
			delete _orderers[doOrder]
		}
		
		public function get layerIndex():Number { return _layerIndex; }
		
		public function set layerIndex(value:Number):void 
		{
			_layerIndex = value;
			if (parent is Layer) Layer(parent).order();
		}
		
		public function get childLayers():Array { return _childLayers; }
		
		override public function get x():Number { return _x; }
		
		override public function set x(value:Number):void 
		{
			_x = value;
			super.x = (value + .4) | 0;
		}
		
		override public function get y():Number { return _y; }
		
		override public function set y(value:Number):void 
		{
			_y = value;
			super.y = (value + .4) | 0;
		}
		
	}
	
}