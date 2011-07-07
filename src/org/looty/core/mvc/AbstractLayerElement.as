/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 19/04/2010 19:03
 * @version 0.1
 */

package org.looty.core.mvc 
{
	import flash.errors.*;
	import flash.utils.*;
	import org.looty.core.*;
	import org.looty.data.*;
	import org.looty.log.*;
	import org.looty.mvc.controller.*;
	import org.looty.mvc.model.*;
	import org.looty.mvc.view.*;
	import org.looty.pattern.*;
	import org.looty.sequence.*;
	
	use namespace looty;
	
	public class AbstractLayerElement extends Abstract
	{
		
		static looty var ControllerType		:Class;
		static looty var ModelType			:Class;
		static looty var ViewType			:Class;
		
		static private var _dataTypes		:Dictionary = new Dictionary();
		static private var _mediatorTypes	:Dictionary = new Dictionary();		
		static private var _presenterTypes	:Dictionary = new Dictionary();
		
		static private var _model			:Model;
		static private var _view			:View;
		static private var _controller		:Controller;
		
		static looty var datas				:Dictionary = new Dictionary();
		static looty var mediators			:Dictionary = new Dictionary();
		static looty var presenters			:Dictionary = new Dictionary();
		
		static private var _idCount			:uint = 12960;
		
		private var _id						:String;
		private var _name					:String;
		private var _type					:String;
		
		private var _initialisation			:Sequence;
		private var _selection				:Sequence;
		private var _unselection			:Sequence;
		
		private var _command				:Command;
		
		public function AbstractLayerElement() 
		{
			makeAbstract(AbstractLayerElement);
			
			_id = "";
			
			_initialisation = new Sequence(this is Data ? 0 : 1);
			_initialisation.looty::starts.add(initialise);
			
			switch(true)
			{
				case this is Model:
				_model = Model(this);
				break;
				
				case this is View:
				_view = View(this);
				break;
				
				case this is Controller:
				_controller = Controller(this);
				break;
				
				case this is Data:
				_model.initialisation.append(_initialisation);
				break;
				
				case this is Mediator:
				_view.initialisation.append(_initialisation);
				break;
				
				case this is Presenter:
				_controller.initialisation.append(_initialisation);
				break;
			}
			
			_selection = new Sequence();			
			_unselection = new Sequence();
		}
		
		private function registerError():void
		{
			var msg:String = "id of layer element must be unique. duplicated id : " + _id;
			Looger.error(msg);
			throw new IllegalOperationError(msg);
		}
		
		protected function generateId():String 
		{ 
			++_idCount;
			return "looty@ID#" + String(_idCount.toString(36)); 
		}
		
		looty function setId(value:String):void
		{
			_id = value;
		}
		
		public function configure(xml:XML, presenter:Presenter = null):void
		{
			switch(true)
			{
				case xml != null && xml.@id[0] != undefined :
				_id = xml.@id[0];
				break;
				
				case this is Data:
				case this is Mediator:
				if (presenter != null) _id = presenter.id;
				break;
				
				default:
				_id = generateId();
			}
			
						
			
			switch(true)
			{
				case this is Model:
				case this is View:				
				case this is Controller:
				break;
				
				case this is Data:
				if (Boolean(looty::datas[_id])) 
				{
					Looger.error("id of Data must be unique. duplicated id : " + _id);
					_id = generateId();
				}
				looty::datas[_id] = this;
				break;
				
				case this is Mediator:
				if (Boolean(looty::mediators[_id]))
				{
					Looger.error("id of Mediator must be unique. duplicated id : " + _id);
					_id = generateId();
				}
				looty::mediators[_id] = this;
				break;
				
				case this is Presenter:
				if (Boolean(looty::presenters[_id]))
				{
					Looger.error("id of Data must be unique. duplicated id : " + _id);
					_id = generateId();
				}
				looty::presenters[_id] = this;
				break;
			}
			
			
			_name = xml != null && xml.@name[0] != undefined ? xml.@name[0] : _id;
			_type = xml != null && xml.@type[0] != undefined ? xml.@type[0] : "";
			
			switch(true)
			{
				case this is Data :
				case this is Mediator :				
					if (Boolean(presenter))
					{
						_id = presenter.id;
						_name = presenter.name;
						_type = presenter.type;
						
						break;
					}
				
				case this is Presenter :
					
				break;
			} 
			
			var className:String = getQualifiedClassName(this);
			
			_initialisation.name = "initialisation " + className + " " + _id;
			_selection.name = "selection " + className + " " + _id;	
			_unselection.name = "unselection " + className + " " + _id;
			
		}
		
		/**
		 * Method to be overriden at initialisation
		 */
		public function initialise():void
		{
			//
		}
		
		final public function get id():String { return _id; }
		
		final public function get name():String { return _name; }
		
		final public function get type():String { return _type; }
		
		final public function get initialisation():Sequence { return _initialisation; }
		
		final public function get selection():Sequence { return _selection; }
		
		final public function get unselection():Sequence { return _unselection; }
		
		final public function get isSelecting():Boolean { return _selection.isProcessing; }		
		
		final public function get isUnselecting():Boolean { return _unselection.isProcessing; }
		
		final public function get model():Model { return _model; }
		
		final public function get view():View { return _view; }
		
		final public function get controller():Controller { return _controller; }
		
		final public function get command():Command 
		{
			if (_command == null) _command = new Command();
			return _command; 
		}
		
		static looty function register(type:String, DataType:Class = null, MediatorType:Class = null, PresenterType:Class = null):void
		{
			_dataTypes[type] = DataType;
			_mediatorTypes[type] = MediatorType;
			_presenterTypes[type] = PresenterType;		
		}
		
		looty function getDataType(type:String):Class { return _dataTypes[type] || Data; }	
		
		looty function getMediatorType(type:String):Class { return _mediatorTypes[type] || Mediator; }
		
		looty function getPresenterType(type:String):Class { return _presenterTypes[type] || Presenter; }
		
		static public function getController():Controller { return _controller; }
		static public function getModel():Model { return _model; }
		static public function getView():View { return _view; }
		
	}
	
}