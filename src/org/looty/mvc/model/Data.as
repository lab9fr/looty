/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 12/01/2010 01:30
 * @version 0.1
 */

package org.looty.mvc.model
{
	import flash.display.*;
	import flash.net.*;
	import flash.utils.*;
	import org.looty.core.*;
	import org.looty.core.core.*;
	import org.looty.core.mvc.AbstractLayerElement;
	import org.looty.display.*;
	import org.looty.localisation.*;
	import org.looty.log.*;
	import org.looty.mvc.controller.*;
	import org.looty.mvc.model.*;
	import org.looty.mvc.view.*;
	import org.looty.net.*;
	import org.looty.pool.*;
	import org.looty.sequence.*;
	import org.looty.text.*;

	use namespace looty;
	
	public class Data extends AbstractLayerElement
	{
		
		private var _texts				:Dictionary;
		private var _loads				:Dictionary;
		private var _contents			:Dictionary;	
		private var _vars				:Object;
		private var _objects			:Dictionary;
		private var _datas				:Pool;
		
		private var _presenter			:Presenter;
		
		public function Data() 
		{
			
		}
		
		/**
		 * 
		 * @param	xml
		 * @param	presenter
		 */
		final override public function configure(xml:XML, presenter:Presenter = null):void
		{
			_presenter = presenter;
			
			super.configure(xml, presenter);
			
			if (xml == null) return;
			
			parseText(xml.text);
			parseLoad(xml.load);
			parseVar(xml["var"]);
			parseObject(xml.object);
			parseData(xml.data);
			
			parse(xml);
		}
		
		protected function parse(xml:XML):void
		{
			
		}
		
		private function parseText(list:XMLList):void
		{
			if (list == null || list.length == 0) return;
			
			_texts = new Dictionary();
			var text:Text;
			var node:XML;			
			
			for each(node in list) 
			{
				if (node.@id[0] == undefined || String(node.@id[0]).length == 0 || node.@key[0] == undefined || String(node.@key[0]).length == 0) 
				{
					Looger.error("An error occured with id and key registration in xml:\n---------------------\n" + node.@id + "\n" + node+"\n---------------------\n");
					continue;
				}
				
				text = new Text(String(node.@key[0]));
				if (node.@styleName[0] != undefined) text.style = String(node.@styleName[0]);
				if (node.@textTransform[0] != undefined) text.textTransform = TextTransform.getFormater(String(node.@textTransform[0]));
				_texts[String(node.@id[0])] = text;
			}
		}
		
		private function parseLoad(list:XMLList):void
		{
			if (list == null || list.length == 0) return;
			_loads = new Dictionary();
			_contents = new Dictionary();
			var node:XML;
			
			var url:String;
			var extension:String;
			var load:ILoad;
			var nid:String;
			
			
			for each (node in list)
			{				
				load = looty::createLoad(node);
				
				if (load == null) 
				{
					Looger.error("error creating load on " + presenter.path + " | id : " + node.@id[0]);
					continue;
				}
				
				nid = String(node.@id[0]);
				
				load.onCompleteParams = [nid];
				load.onComplete = looty::createContent;
				
				_loads[nid] = load;
				
				switch(String(node.@start[0]))
				{
					case "initialisation":
					initialisation.append(load);
					break;
					
					case "selection":
					selection.append(load);
					break;
					
					case "unselection":
					unselection.append(load);
					break;
				}				
			}
		}
		
		private function parseVar(list:XMLList):void
		{	
			if (list == null || list.length == 0) return;
			
			_vars = new Object();
			var node:XML;
			var value:String;
			
			for each (node in list)
			{
				_vars[String(node.@id[0])] = ObjectParser.typeVar(node);				
			}
		}
		
		private function parseObject(list:XMLList):void
		{
			if (list == null || list.length == 0) return;
			
			_objects = new Dictionary();
			var node:XML;
			
			for each (node in list)
			{
				if (node.@id[0] == undefined || String(node.@id[0]).length == 0) 
				{
					Looger.error("An error occured with id registration in xml:\n---------------------\n" + node.@id + "\n" + node+"\n---------------------\n");
					continue;
				}
				
				_objects[String(node.@id[0])] = ObjectParser.createObject(node.@type[0] != undefined ? String(node.@type[0]) : "", node.@constructor[0] != undefined ? String(node.@constructor[0]) : "", String(node));		
			}
		}
		
		private function parseData(list:XMLList):void
		{
			if (list == null || list.length == 0) return;
			
			_datas = new Pool();
			var node:XML;
			var data:Data;		
			
			for each(node in list) 
			{
				data = new Data();
				data.configure(node, null);
				initialisation.append(data.initialisation);
				selection.append(data.selection);
				unselection.append(data.unselection);
				_datas.add(data);
			}		
			
		}
		
		public function requiredText(value:String):void
		{
			//TODO : verify property exist verify result 
		}
		
		public function requiredVar(value:String):void
		{
			
		}
		
		public function requiredLoad(value:String):void
		{
			//TODO : verify property exist verify result (after load) debug
		}
		
		public function requiredObject(value:String):void
		{
			
		}
		
		looty function createLoad(node:XML):ILoad
		{
			if (!(/\S+/.test(String(node)))) return null;
			
			var url:String = String(node);
			url = url.split("?") [0];
			var extension:String = /^\s*(swf|jpg|png|xml|txt|pbj|3ds)\s*$/i.test(String(node.@type[0])) ? String(node.@type[0]) : url.substring(url.lastIndexOf(".") + 1).toLowerCase();
			
			extension = extension.replace(/^\s*|\s*$/g, "");
			
			switch(extension)
			{
				case "swf":
				return new SWFLoad(url, String(node.@nocache[0]) == "true");					
				break;
				
				case "jpg":
				case "jpeg":
				case "png":
				return new BitmapDataLoad(url, String(node.@nocache[0]) == "true");
				break;
				
				case "xml":
				return new XMLLoad(url, !(String(node.@nocache[0]) == "false"));
				break;
				
				//TODO : perhaps
				
				/*
				case "3ds":
				break;
				
				case "pbj":
				break;
				
				case "mp3":
				case "wav":
				case "iff":
				break;
				
				case "flv":
				case "f4v":
				break;
				*/
				
				default:
				return null;
			}
			
		}
		
		looty function createContent(id:String):void
		{
			var load:ILoad = _loads[id];
			if (load == null) return; 
			
			switch(true)
			{
				case load is SWFLoad :
				_contents[id] = SWFLoad(load).content;
				break;
				
				case load is BitmapDataLoad :
				if (_contents[id] is Bitmap) _contents[id].bitmapData = BitmapDataLoad(load).content;
				else _contents[id] = new Bitmap(BitmapDataLoad(load).content);
				break;
				
				case load is XMLLoad :
				_contents[id] = XMLLoad(load).content;
				break;
			}
			
		}
		
		public function cleanLoad(id:String):void
		{
			var load:ILoad = _loads[id];
			if (load == null) return; 
			
			//load.cancel();
			
			switch(true)
			{
				case load is SWFLoad :
				case load is XMLLoad :
				_contents[id] = null;
				break;
				
				case load is BitmapDataLoad :
				if (_contents[id] is Bitmap) 
				{
					if (_contents[id].bitmapData != null) _contents[id].bitmapData.dispose();
					_contents[id].bitmapData = null;
				}
				else _contents[id] = new Bitmap(BitmapDataLoad(load).content);
				break;
			}
		}
		
		public function hasText(id:String):Boolean { return _texts != null && _texts[id] != null; }
		
		public function getText(id:String):Text { return _texts[id] != null ? _texts[id] : null; }
		
		public function hasSwf(id:String):Boolean { return _contents != null && _contents[id] is MovieClip; }
		
		public function getSwf(id:String):MovieClip 
		{
			if (hasSwf(id)) return _contents[id];
			var wrong:MovieClip = new MovieClip();
			wrong.addChild(new DisplayTest());  
			return wrong; 
		}
		
		public function hasBitmap(id:String):Boolean { return _contents != null && _contents[id] is Bitmap; }
		
		public function getBitmap(id:String):Bitmap { return hasBitmap(id) ? new Bitmap(_contents[id].bitmapData) : new Bitmap(new BitmapData(100, 100, false, 0xFFFFFF * Math.random()));  }
		
		public function hasXml(id:String):Boolean { return  _contents != null && _contents[id] is XML; }
		
		public function getXml(id:String):XML { return hasXml(id)? _contents[id] : new XML(<root></root>);}
		
		public function hasObject(id:String):Boolean { return _objects != null && _objects[id] != null }
		
		public function getObject(id:String):* { return _objects[id] != null ? _objects[id] : { }}
		
		public function hasData(id:String):Boolean { return _datas != null && _datas.hasByProperty("id", id); }//FIXME has data supposed to return by name ?
		
		public function getDataById(id:String):Data { return _datas.getByProperty("id", id)[0]; } //TODO : correction
		
		public function getDataByName(name:String):Data { return _datas.getByProperty("name", name)[0]; }
		
		public function getDatasByType(type:String):Array { return _datas.getByProperty("type", type); }
		
		public function get loads():Dictionary { return _loads; }
		
		public function get contents():Dictionary { return _contents; }
		
		public function get vars():Object { return _vars; }
		
		public function get objects():Dictionary { return _objects; }
		
		public function get datas():Array { return _datas.content; }
		
		public function get texts():Dictionary { return _texts; }
		
		public function get presenter():Presenter { return _presenter; }
		
		public function get mediator():Mediator { return _presenter.mediator; }
		
		public function get progress():Number { return selection.progress; }		
		
		
		
		
		
	}
	
}