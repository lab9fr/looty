/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.display
{
	import org.looty.mvc.view.Component;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.BitmapViewport3D;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.Viewport3D;
	
	public class LayeredPapervision extends Component
	{
		
		private var _viewport			:Viewport3D;
		private var _layer				:ViewportLayer;
		private var _scene				:Scene3D;
		private var _camera				:Camera3D;
		private var _cameraTarget		:DisplayObject3D;
		private var _engine				:BasicRenderEngine;
		private var _light				:PointLight3D;
		
		private var _isRenderingLayers	:Boolean;
		private var _layers				:Array;
		
		public function LayeredPapervision(width:Number, height:Number, autoScale:Boolean = false) 
		{
			super();
			
			_viewport 			= new Viewport3D(width, height, autoScale);
			_scene 				= new Scene3D();
			_camera				= new Camera3D();
			_engine				= new BasicRenderEngine();
			_light				= new PointLight3D();
			_cameraTarget		= new DisplayObject3D();
			
			_scene.addChild(_cameraTarget);
			_camera.target 		= _cameraTarget;
			
			_layer				= new ViewportLayer(_viewport, null);
			_viewport.containerSprite.addLayer(_layer);
			_layer.sortMode = ViewportLayerSortMode.INDEX_SORT;
			_layer.layerIndex = 0;
			addChild(_viewport);
			
			_layers				= new Array();
			
			_camera.z 			= - 1500;
			_camera.zoom 		= 3;
			_camera.focus 		= 500;
			
			_light.z 			= -330;
			_light.y 			= 100;
			
			isRenderingLayers 	= false;
		}
		
		public function get viewport():Viewport3D { return _viewport; }
		
		public function get scene():Scene3D { return _scene; }
		
		public function get layer():ViewportLayer { return _layer; }
		
		public function get camera():Camera3D { return _camera; }
		
		public function get engine():BasicRenderEngine { return _engine; }
		
		public function get isRenderingLayers():Boolean { return _isRenderingLayers; }
		
		public function set isRenderingLayers(value:Boolean):void 
		{
			_isRenderingLayers 	= value;
		}
		
		public function get light():PointLight3D { return _light; }
		
		public function get layers():Array { return _layers; }
		
		public function get cameraTarget():DisplayObject3D { return _cameraTarget; }
		
		override public function render():void 
		{
			if (!_isRenderingLayers) _engine.renderScene(_scene, _camera, _viewport);
			else _engine.renderLayers(_scene, _camera, _viewport, _layers);	
		}
		
	}
	
}