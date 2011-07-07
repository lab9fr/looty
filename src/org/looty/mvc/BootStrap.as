/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.5
 */

package org.looty.mvc 
{
	import flash.display.*;
	import flash.errors.*;
	import flash.events.*;
	import org.looty.*;
	import org.looty.core.*;
	import org.looty.core.mvc.*;
	import org.looty.data.*;
	import org.looty.log.*;
	import org.looty.mvc.controller.*;
	import org.looty.mvc.model.*;
	import org.looty.mvc.plugin.*;
	import org.looty.mvc.view.*;
	import org.looty.net.*;
	import org.looty.sequence.*;
	import org.looty.utils.*;
	
	use namespace looty;
	
	//TODO : bootstrap start to be refactored
	
	public class BootStrap extends Sprite
	{
		
		AbstractLayerElement.looty::ModelType = Model;
		AbstractLayerElement.looty::ViewType = View;
		AbstractLayerElement.looty::ControllerType = Controller;
		
		private var _controller			:Controller;
		
		private var _isStarted			:Boolean;
		private var _isAddedToStage		:Boolean;
		
		private var _configuration		:String;
		
		private var _plugins			:Array;
		
		private var _command			:DistantCommand;
		
		static public const COMMAND_ID	:String = "org.looty.mvc.BootStrap";
		
		static private var _instance	:BootStrap;
		
		public function BootStrap(configuration:String = "./xml/configuration.xml") 
		{
			_instance = this;
			
			_configuration = configuration;
			
			_command = DistantCommand.getCommand(COMMAND_ID);
			_command.register(COMMAND_ID + "_start", start);
			
			addedToStage();
		}
		
		public function start():void
		{
			if (_isStarted) return;
			_isStarted = true;
			
			if (_isAddedToStage) doStart();
		}
		
		
		private function addedToStage(e:Event = null):void 
		{
			if (Looty.isInitialised) _isAddedToStage = true
			
			if (_isAddedToStage) return;
				
			if (super.stage == null) 
			{
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
				return;
			}		
			
			if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			_isAddedToStage = true;
			
			if (!Looty.isInitialised) Looty.initialise(super.stage);
			if (_isStarted) doStart();
		}
		
		private function doStart():void
		{
			Looger.info("bootstrap initialising");
			if (Looty.parameters.configuration != null) _configuration = Looty.parameters.configuration;
			initialise();
		}
		
		public function registerModel(ModelType:Class):void
		{
			if (!ClassUtils.compare (ModelType, Model)) throw new IllegalOperationError ("ModelType class has to extends org.looty.mvc.model.Model");
			AbstractLayerElement.looty::ModelType = ModelType;
		}
		
		public function registerView(ViewType:Class):void
		{
			if (!ClassUtils.compare (ViewType, View)) throw new IllegalOperationError ("ViewType class has to extends org.looty.mvc.view.View");
			AbstractLayerElement.looty::ViewType = ViewType;
		}
		
		public function registerController(ControllerType:Class):void
		{
			if (!ClassUtils.compare (ControllerType, Controller)) throw new IllegalOperationError ("ControllerType class has to extends org.looty.mvc.controller.Controller");
			AbstractLayerElement.looty::ControllerType = ControllerType;
		}
		
		public function registerType(type:String, DataType:Class = null, MediatorType:Class = null, PresenterType:Class = null):void
		{
			if (DataType != null && !ClassUtils.compare (DataType, Data)) throw new IllegalOperationError ("Data class has to extends org.looty.mvc.model.Data");
			if (MediatorType != null && !ClassUtils.compare (MediatorType, Mediator)) throw new IllegalOperationError ("MediatorType class has to extends org.looty.mvc.view.Mediator");
			if (PresenterType != null && !ClassUtils.compare (PresenterType, Presenter)) throw new IllegalOperationError ("PresenterType class has to extends org.looty.mvc.controller.Presenter");
			
			AbstractLayerElement.looty::register(type, DataType, MediatorType, PresenterType);
		}
		
		public function configure(xml:XML = null):void
		{
			_controller = new AbstractLayerElement.looty::ControllerType();
			controller.looty::plugins = _plugins;
			if (xml != null) _controller.configure(xml);
			else _controller.looty::loadConfiguration(_configuration);
		}
		
		public function addPlugin(plugin:IPlugin):void
		{
			if (_plugins == null) _plugins = [];
			_plugins.push(plugin);
		}
		
		public function initialise():void
		{			
			configure();
		}
		
		override public function get stage():Stage { return Looty.stage; }
		
		public function get controller():Controller { return _controller; }
		
		public function get model():Model { return _controller.model; }
		
		public function get view():View { return _controller.view; }
		
		public function get command():DistantCommand { return _command; }
		
		static public function get instance():BootStrap { return _instance; }
		
	}
	
}