/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.5
 */

package org.looty.mvc.controller
{
	import flash.errors.IllegalOperationError;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import org.looty.core.*;
	import org.looty.core.net.*;
	import org.looty.data.*;
	import org.looty.log.*;
	import org.looty.Looty;
	import org.looty.mvc.controller.*;
	import org.looty.mvc.plugin.IPlugin;
	import org.looty.sequence.*;
	
	use namespace looty;
	
	public class Controller extends Presenter
	{
		
		private var _transitionSequence				:Sequence;
		
		private var _pathIds						:Array;
		
		internal var resolveCompleteList			:MethodList;
		
		private var _loaderUnselection				:Sequence;
		
		private var _isPathLocked					:Boolean;
		
		private var _unlockedPath					:String;
		
		looty var plugins							:Array;
		
		looty var addressPlugin						:IPlugin;		
		looty var langPlugin						:IPlugin;
		looty var trackingPlugins					:Dictionary;
		
		private var _loaderCommand					:DistantCommand;
		
		public function Controller() 
		{
			resolveCompleteList = new MethodList();	
			
			_transitionSequence = new Sequence();
		}
		
		override internal function build(xml:XML, DataType:Class = null, MediatorType:Class = null):void
		{
			for each (var plugin:IPlugin in looty::plugins) plugin.configure(xml);
			super.build(xml, looty::ModelType, looty::ViewType);
		}
		
		override internal function configurationComplete():void 
		{
			if (isConfigured) 
			{
				Looger.info("configuration complete");
				
				looty::applyPlugins();
				
				initialisation.append(model.initialisation);
				initialisation.append(view.initialisation);
				
				_loaderCommand = DistantCommand.getCommand("org.looty.net.ExternalLoader");
				
				
				if (_loaderCommand.has("org.looty.net.ExternalLoader_setMainProgress")) initialisation.onProgress = setInitialisationProgress;
				if (_loaderCommand.execute("org.looty.net.ExternalLoader_getUnselection") != null) 
				{					
					initialisation.append(_loaderCommand.execute("org.looty.net.ExternalLoader_getUnselection"));
				}
				
				initialisation.onComplete = initialisationComplete;
				initialisation.start();
			}
		}
		
		looty function applyPlugins():void
		{
			for each (var plugin:IPlugin in looty::plugins)
			{
				switch(plugin.id)
				{
					case "SWFAddressPlugin":
					if (looty::addressPlugin != null) continue;
					looty::addressPlugin = plugin;
					initialisation.prepend(looty::addressPlugin.initialisation);
					break;
					
					case "StaticLangPlugin":
					if (looty::langPlugin != null) throw new IllegalOperationError("a lang plugin has already been added");
					looty::langPlugin = plugin;
					initialisation.prepend(looty::langPlugin.initialisation);
					break;
					
					case "DynamicLangPlugin":
					if (looty::langPlugin != null) throw new IllegalOperationError("a lang plugin has already been added");
					looty::langPlugin = plugin;
					initialisation.prepend(looty::langPlugin.initialisation);
					break;
					
					case "GoogleAnalyticsPlugin":
					addTrackingPlugin(plugin);
					break;
					
					case "WordPressPlugin":
					//TODO...
					break;
				}
			}
			
			if (looty::addressPlugin != null && looty::langPlugin != null && looty::langPlugin.id == "DynamicLangPlugin")
			{
				looty::addressPlugin.vars.dynamicLang = true;
			}
			
		}
		
		private function addTrackingPlugin(plugin:IPlugin):void
		{
			if (looty::trackingPlugins == null) looty::trackingPlugins = new Dictionary();
			if (looty::trackingPlugins[plugin.id] != undefined) return;
			looty::trackingPlugins[plugin.id] = plugin;			
			initialisation.prepend(plugin.initialisation);
		}
		
		private function setInitialisationProgress():void
		{
			_loaderCommand.execute("org.looty.net.ExternalLoader_setMainProgress", model.initialisation.progress);
		}
		
		looty function initialisationComplete():void
		{
			view.command.execute("start");
			
			if (looty::addressPlugin != null) looty::addressPlugin.command.execute("start");
			else change();			
			
			Looger.info("start application");
			startApplication();
		}
		
		public function startApplication():void
		{
			
		}	
		
		public function lockPath():void
		{
			_isPathLocked = true;
			_unlockedPath = "";
		}
		
		public function unlockPath():void
		{
			_isPathLocked = false;
			if (_unlockedPath != "") writePath(_unlockedPath);
		}
		
		public function change(path:String = ""):void 
		{
			if (_isPathLocked)
			{
				_unlockedPath = path;
				return;
			}
			
			_transitionSequence.cancel();
			_transitionSequence = new Sequence();
			_transitionSequence.name = "transitionSequence";
			
			path = path.replace(/^\//, "");			
			if (!(/\/$/g.test(path))) path = path + "/";
			
			var previousPath:String = currentPath;
			
			var transitions:Array = resolve.apply(this, path.split("/"));		
			
			resolveCompleteList.call();
			
			if (looty::trackingPlugins != null && previousPath != currentPath)
			{
				for each (var plugin:IPlugin in looty::trackingPlugins)
				{
					plugin.command.execute("trackPageView", currentPath);
				}
			}
			
			for each (var transition:ISequencable in transitions) _transitionSequence.append(transition);
			
			Looger.info("transition structure :\n" + _transitionSequence.dump());
			
			_transitionSequence.start();			
		}	
		
		override public function resolve(...fragments:Array):Array 
		{
			Looger.info("update path : #/" + (fragments.join("/")));
			
			_pathIds = [];
			
			return super.resolve.apply(this, fragments);
		}
		
		
		public function getPresenterById(id:String):Presenter
		{
			return looty::presenters[id];
		}
		
		public function writePathById(id:String):void 
		{
			var presenter:Presenter = looty::presenters[id];
			if (Boolean(presenter)) writePath(presenter.path);
		}
		
		public function rewriteCurrentPath():void
		{
			writePath(currentPath);
		}
		
		
		public function writePath(path:String):void 
		{
			if (looty::addressPlugin != null) 
			{
				looty::addressPlugin.vars.path = path;
				looty::addressPlugin.command.execute("update");
			}
			else change(path);
		}
		
		public function writeUrlVariable(prop:String, value:String, delayed:Boolean = false):void
		{
			if (looty::addressPlugin == null) 
			{
				Looger.fatal("missing SWFAddressPlugin to write URLVariable");
				return;
			}
			
			looty::addressPlugin.vars.urlVariables[prop] = value;
			if (!delayed) looty::addressPlugin.command.execute("update");
		}
		
		public function get urlVariables():URLVariables { return looty::addressPlugin != null ? looty::addressPlugin.vars.urlVariables : null; }
		
		public function pushPathIds(id:String):void
		{
			_pathIds.push(id);
		}
		
		//TODO : one day it will be done
		public function bypassSelection(startId:String, endId:String, sequence:Sequence):void
		{
			
		}
		
		public function bypassUnselection(startId:String, endId:String, sequence:Sequence):void
		{
			
		}
		
		public function trackPageView(value:String):void
		{
			for each (var plugin:IPlugin in looty::trackingPlugins) plugin.command.execute("trackPageView", value);
		}
		
		public function trackEvent(category:String, label:String, value:Number = NaN):void
		{
			for each (var plugin:IPlugin in looty::trackingPlugins) plugin.command.execute("trackEvent", category, label, value);
		}
		
		override public function get path():String { return ""; }
		
		public function get currentPath():String { return getCurrentPath(); }
		
		public function get pathIds():Array { return _pathIds; }
		
		public function get isPathLocked():Boolean { return _isPathLocked; }
		
		public function dump():void
		{
			for each (var presenter:Presenter in looty::presenters) Looger.info(presenter + ", id : " + presenter.id + ", type : " + presenter.type + ", fragment : " + presenter.fragment );
		}
		
		
	}
	
}