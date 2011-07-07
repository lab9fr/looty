/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */
package org.looty.core.net 
{
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import org.looty.core.looty;
	import org.looty.core.sequence.AbstractASynchrone;
	import org.looty.log.Looger;
	import org.looty.Looty;
	import org.looty.sequence.Sequencable;
	
	use namespace looty;
	
	public class AbstractLoad extends Sequencable
	{
		private var _request			:URLRequest;
		private var _urlVariables		:URLVariables;
		
		private var _noCache			:Boolean;
		
		private var _bytes				:ByteArray;
		
		private var _loadType			:int;
		
		use namespace looty;
		
		public function AbstractLoad(url:String, noCache:Boolean) 
		{
			weight = 1000;
			
			_urlVariables			= new URLVariables();
			if (/\?.+=/.test(url))
			{
				var query:Array = url.split("?")
				url = String(query[0]);
				
				var parts:Object;
				
				for each (var element:String in query[1].split("&")) if (/^\S+=\S+$/.test(element))
				{			
					parts = /^(?P<prop>\S+)=(?P<value>\S+)$/.exec(element);
					_urlVariables[parts.prop] = parts.value;				
				}
			}
			
			_request 				= new URLRequest(url);	
			_request.method			= URLRequestMethod.POST;
			
			_noCache 				= noCache;
			protected::useOnce 		= true;
			
			retries = 3;
			
			if (_loadType == 0) _loadType = LoadType.STREAM_LOAD;			
		}
		
		override looty function reset():void
		{
			super.looty::reset();
			
			if (_request != null)
			{
				_request = new URLRequest(_request.url);	
				_request.method	= URLRequestMethod.POST;
			}
			
			
			_bytes = new ByteArray();
		}
		
		override public function start():Boolean
		{
			if (url.length == 0) 
			{
				Looger.error("an url must be specified");
				return false;
			}
			
			if (super.start()) MassLoader.enqueue(this);
			
			return isProcessing;
		}
		
		internal function error():void
		{
			doError();
		}
		
		looty function fillContent(data:* = null):void
		{
			_bytes.length = 0;
			_bytes = null;
			
			doComplete();
		}		
		
		public function get request():URLRequest 
		{
			//var length:uint;
			//for (var name:String in _urlVariables) ++length; 
			
			if (length > 0) _request.data = _urlVariables;
			
			var regExp:RegExp;
			
			if (/\$\{.+\}/.test(_request.url)) for (var id:String in Looty.parameters) 
			{
				regExp = new RegExp("\\$\\{" + id + "\\}");				
				while (regExp.test(_request.url)) _request.url = _request.url.replace(regExp, Looty.parameters[id]);
			}
			
			return _request; 
		}
		
		public function get bytes():ByteArray { return _bytes; }
		
		internal function get loadType():int { return _loadType; }
		
		protected function set loadType(value:int):void
		{
			_loadType = value;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			_urlVariables = null;
			_request = null;
			if (_bytes != null) _bytes.length = 0;
			_bytes = null;
		}
		
		public function get url():String { return _request != null ? _request.url : "disposed"; }
		
		public function get method():String { return _request.method; }
		
		public function set method(value:String):void 
		{
			_request.method = value;
		}
		
		public function get urlVariables():URLVariables { return _urlVariables; }
		
		public function set urlVariables(value:URLVariables):void 
		{
			_urlVariables = value;
		}
		
		public function get noCache():Boolean { return _noCache; }
		
		override public function toString():String 
		{
			return super.toString() + " " + url + "\n";
		}
		
	}
	
}