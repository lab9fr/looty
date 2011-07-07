/**
 * @project looty
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @version 1.0
 */

package org.looty.sequence 
{
	
	import org.looty.notifier.Notifier;
	
	public class SequencableNotifier extends Sequencable
	{
		
		private var _notifier			:Notifier
		private var _parameters			:Array;
		
		public function SequencableNotifier(type:String, ...parameters:Array) 
		{
			_notifier = new Notifier(type);
			_parameters = parameters;
			setEntry(doNotification);
			
		}
		
		private function doNotification():void
		{
			_notifier.notify.apply(this, _parameters);
			doComplete();
		}
		
		public function get channels():Array { return _notifier.channels; }
		
		public function set channels(value:Array):void 
		{
			_notifier.channels = value;
		}
		
		public function get persist():Boolean { return _notifier.persist; }
		
		public function set persist(value:Boolean):void 
		{
			_notifier.persist = value;
		}
		
		public function get strict():Boolean { return _notifier.strict; }
		
		public function set strict(value:Boolean):void 
		{
			_notifier.strict = value;
		}
		
	}
	
}