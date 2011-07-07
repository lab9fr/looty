/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 09/01/2010 20:14
 * @version 0.5
 */

package org.looty.mvc.controller 
{
	import flash.errors.*;
	import org.looty.core.*;
	import org.looty.data.*;
	import org.looty.core.mvc.*;
	import org.looty.log.Looger;
	import org.looty.interactive.*;
	import org.looty.localisation.Text;
	import org.looty.mvc.controller.*;
	import org.looty.mvc.model.*;
	import org.looty.mvc.view.*;
	import org.looty.net.*;
	import org.looty.pool.*;
	import org.looty.sequence.*;
	
	use namespace looty;
	
	
	//TODO : orderUnselectionBeforeSelection Boolean ? an another solution for ordering selection & unselections...
	
	//TODO : selection activated by default (ie : first image already selected in slideshow)
	/*
	 * case : instant selection of first child before displaying
	 * case : stop unselection at a level and append child unselection silentely and instantly
	 */
	
	
	//TODO : instant selection/unselection
	
	
	public class Presenter extends AbstractLayerElement 
	{
		private var _data					:Data;		
		private var _mediator				:Mediator;
		
		private var _parent					:Presenter;		
		private var _selectedChild			:Presenter;
		private var _defaultPreventer		:Presenter;
		
		private var _fragment				:Text;
		
		internal var isGenerated			:Boolean;
		
		private var _children				:Pool;		
		private var _sourceLoad				:XMLLoad;
		
		private var _isInitialised			:Boolean;
		private var _isConfigured			:Boolean;
		private var _isUpdatingToDefault	:Boolean;
		private var _isDisplayed			:Boolean;
		private var _isSelected				:Boolean;
		private var _isSelecting			:Boolean;
		private var _isUnselecting			:Boolean;
		private var _isActive				:Boolean;
		private var _isSelectionEnabled		:Boolean;
		private var _isOrderReversed		:Boolean;
		
		private var _selectables			:List;
		
		private var _onResolveSelection		:Function;
		private var _onResolveUnselection	:Function;
		private var _onResolveComplete		:Function;	
		
		public function Presenter() 
		{
			_isUpdatingToDefault = true;
			_isOrderReversed = false;
			_isSelectionEnabled = true;
			
			//TODO refactor selection system...
			selection.looty::starts.add(looty::onSelectionStart);
			selection.looty::completes.add(looty::onSelectionComplete);
			unselection.looty::starts.add(looty::onUnselectionStart);
			unselection.looty::completes.add(looty::onUnselectionComplete);
			
			_children = new Pool();
			
			_selectables = new List();			
		}		
		
		override final public function configure(xml:XML, presenter:Presenter = null):void
		{
			_parent = presenter;
			
			super.configure(xml, presenter);
			
			if (Boolean(presenter) && Boolean(parent.getChildByName(name))) Looger.error("presenter " + id + " has several children named " + name);
			
			if (xml.@key[0] != undefined) _fragment = new Text(xml.@key[0]);
			else 
			{
				//var gid:String = generateId();
				_fragment = new Text(id + "#" + generateId());
				
				_fragment.fill(0, xml.@fragment[0] != undefined ? xml.@fragment[0] : id);
			}
			
			if (xml.@disabled[0] == "true") disableSelection();
			
			if (xml.src[0] != undefined) looty::loadConfiguration(xml.src[0]);
			else build(xml);
		}
		
		
		looty function loadConfiguration(url:String):void
		{
			_sourceLoad = new XMLLoad(url, true);
			_sourceLoad.onComplete = loadComplete;
			_sourceLoad.start();
		}
		
		private function loadComplete():void
		{		
			var xml:XML = _sourceLoad.content;
			
			_sourceLoad.dispose();
			_sourceLoad = null;			
			if (this is Controller) configure(xml);
			else build(xml);
		}
		
		internal function build(xml:XML, DataType:Class = null, MediatorType:Class = null):void
		{			
			if (DataType == null) DataType = looty::getDataType(type);			
			_data = new DataType();
			
			_data.configure(xml.data[0], this);
			
			if (MediatorType ==  null) MediatorType = looty::getMediatorType(type);			
			_mediator = new MediatorType();
			
			_mediator.configure(xml.mediator[0], this);			
			
			selection.append(_data.selection);			
			selection.append(_mediator.selection);
			
			unselection.append(_data.unselection);		
			unselection.append(_mediator.unselection);
			
			//selection.dump();
			//unselection.dump();
			
			createChildren(xml.presenter);		
			
			_isConfigured = true;
			
			configurationComplete();
		}
		
		looty function createChildren(list:XMLList):void
		{
			_children = new Pool();
			
			var definition:Class;
			var node:XML;
			var presenter:Presenter;
			
			for each (node in list)
			{
				definition = looty::getPresenterType(node.@type[0]);
				presenter = new definition();
				presenter.configure(node, this);
				_children.add(presenter);
			}			
		}	
		
		internal function configurationComplete():void
		{
			controller.configurationComplete();			
		}
		
		public function resolve(...fragments:Array):Array
		{
			Looger.debug("resolve", name, " / [", fragments, "]");
			
			if (_children.length == 0 || !_isSelectionEnabled) return [];
			
			var transitions:Array = [];
			
			var next:Presenter;
			
			if (_children.hasByProperty("fragment", fragments[0])) 
			{
				next = _children.getByProperty("fragment", fragments[0])[0];
				_selectedChild = next;
				controller.pushPathIds(next.id);
			}
			else if (_defaultPreventer == null) 
			{
				next = children[0];				
				_selectedChild = next;
				controller.pushPathIds(next.id);
			}
			else 
			{
				next = _defaultPreventer;
				_selectedChild = null;
			}
			
			if (next == null || !next._isSelectionEnabled) return [];
			
			var childrenTransitions:Array = [];			
			var childUnselections:ISequencable;			
			
			for each (var child:Presenter in _children.getByProperty("isActive", true)) 
			{
				if (child != next) 
				{
					Looger.debug("resolve unselection ", child.name);
					
					if (Boolean(child.onResolveUnselection)) child.onResolveUnselection();
					
					childUnselections = child.unselections;
					
					if (childUnselections == null) continue;
					
					childrenTransitions.push(childUnselections);
				}				
			}
			
			var childrenUnselections:Sequence;
			
			switch(childrenTransitions.length)
			{
				case 0:				
				break;
				
				case 1:
				childrenUnselections = childrenTransitions[0];
				break;
				
				default:
				childrenUnselections = new Sequence(0);
				childrenUnselections.name = "childrenUnselections " + id;
				
				for each (var sequencable:ISequencable in childrenTransitions) childrenUnselections.append(sequencable);
			}
			
			if (next.mediator == null || !next.mediator.isDisplayed)
			{
				if (Boolean(next.onResolveSelection)) next.onResolveSelection();				
				transitions.push(next.selection);
				Looger.debug("resolve selection ", next.name); 
			}
			
			transitions.push.apply(this, next.resolve.apply(this, fragments.slice(1)));
			
			if (childrenUnselections != null) _isOrderReversed ? transitions.push(childrenUnselections) : transitions.unshift(childrenUnselections);
			
			Looger.debug(path, transitions);
			
			return transitions;
		}
		
		public function preventDefaultResolution():void
		{
			_defaultPreventer = new Presenter()
			_defaultPreventer._parent = this;
			_defaultPreventer._fragment = new Text(generateId());
			_defaultPreventer._fragment.fill(0, ""); //TODO...
		}
		
		public function disableSelection():void
		{
			_isSelectionEnabled = false;
		}
		
		public function orderSelectionBeforeUnselection():void
		{
			_isOrderReversed = true;
		}
		
		public function get unselections():ISequencable
		{
			var unselectionsSequence:Sequence = new Sequence();
			unselectionsSequence.name = "unselections container " + id;
			var selectedChilds:Array = _children.getByProperty("isActive", true);
			var child:Presenter;
			
			switch(selectedChilds.length)
			{
				case 0:
				break;
				
				case 1:
				child = selectedChilds[0]
				unselectionsSequence.append(child.unselections);
				if (Boolean(child.onResolveUnselection)) child.onResolveUnselection();
				break;
				
				default:
				var childUnselections:Sequence = new Sequence(0);
				childUnselections.name = "container child unselections " + id;
				for each (child in selectedChilds) 
				{
					childUnselections.append(child.unselections);
					if (Boolean(child.onResolveUnselection)) child.onResolveUnselection();
				}
				unselectionsSequence.append(childUnselections);				
			}
			
			if (unselectionsSequence.length == 0) return unselection;
			
			unselectionsSequence.append(unselection);
			return unselectionsSequence;
		}
		
		looty function onSelectionStart():void
		{
			_selectables.forEach(selectSelectable);
			_isActive = true;
			//for each(var child:Presenter in _parent.children) setNotSelected();
			//_isSelected = true;
		}
		
		internal function setNotSelected():void
		{
			//_isSelected = false;
		}
		
		looty function onSelectionComplete():void
		{
			
		}
		
		looty function onUnselectionStart():void
		{
			_selectables.forEach(unselectSelectable);
		}
		
		looty function onUnselectionComplete():void
		{
			//trace("unselected");
			_isActive = false;
		}	
		
		private function unselectSelectable(selectable:ISelectable):void
		{
			if (selectable.unselection.isProcessing) selectable.unselection.cancel();
			selectable.unselection.start();
		}
		
		private function selectSelectable(selectable:ISelectable):void
		{
			if (selectable.selection.isProcessing) selectable.selection.cancel();
			selectable.selection.start();
		}
		
		internal function get isConfigured():Boolean 
		{
			if (!_isConfigured) return false;
			
			for each (var child:Presenter in _children.content) if (!child.isConfigured) return false;
			
			return true; 
		}
		
		public function getChildByFragment(value:String):Presenter
		{
			return _children.getByProperty("fragment", value)[0];
		}
		
		public function getChildByName(value:String):Presenter
		{
			return _children.getByProperty("name", value)[0];
		}
		
		public function getChildrenByType(value:String):Array
		{
			return _children.getByProperty("type", value);
		}
		
		public function getSibling(offset:int = 1, withSameType:Boolean = false):Presenter
		{
			var siblings:Array = withSameType ? parent.getChildrenByType(type) : parent.children;
			var index:int = siblings.indexOf(this) + offset;
			
			return (index >= 0 && index < siblings.length) ? siblings[index] : null;
		}
		
		public function getIndex(withSameType:Boolean = false):uint
		{
			var siblings:Array = withSameType ? parent.getChildrenByType(type) : parent.children;
			return siblings.indexOf(this);
		}
		
		internal function getCurrentPath():String { return selectedChild != null ? selectedChild.getCurrentPath() : path; }
		
		public function get parent():Presenter { return _parent; }
		
		public function get children():Array { return _children.content/*.getByProperty()"isSelectionEnabled", true)*/; }
		
		public function get fragment():String { return _fragment.content; }
		
		public function get path():String { return _parent.path + "/" + fragment; }	
		
		public function get selectedChild():Presenter { return _selectedChild; }
		
		public function get isSelected():Boolean { return _isSelected; }
		
		public function get isActive():Boolean { return _isActive; }
		
		public function get onResolveSelection():Function { return _onResolveSelection; }
		
		public function set onResolveSelection(value:Function):void 
		{
			_onResolveSelection = value;
		}
		
		public function get onResolveUnselection():Function { return _onResolveUnselection; }
		
		public function set onResolveUnselection(value:Function):void 
		{
			_onResolveUnselection = value;
		}
		
		public function get onResolveComplete():Function { return _onResolveComplete; }
		
		public function set onResolveComplete(value:Function):void 
		{
			if (Boolean(_onResolveComplete)) controller.resolveCompleteList.remove(_onResolveComplete);
			if (Boolean(value)) controller.resolveCompleteList.add(value);
			_onResolveComplete = value;
		}
		
		public function get data():Data { return _data; }
		
		public function get mediator():Mediator { return _mediator; }
		
		public function get isSelectionEnabled():Boolean { return _isSelectionEnabled; }
		
		public function get selectables():List { return _selectables; }
		
	}
	
}