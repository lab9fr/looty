/**
 * @project looty
 * @author Bertrand Larrieu - lab9
 * @mail lab9@gmail.fr
 * @version 1.0
 */

package org.looty.core.sequence 
{
	import org.looty.core.looty;
	import org.looty.core.sequence.AbstractASynchrone;
	import org.looty.log.Looger;
	import org.looty.sequence.IASynchrone;
	import org.looty.sequence.ISequencable;
	import org.looty.sequence.Sequencable;
	
	//FIXME : prepend with mvc ?
	
	use namespace looty;
	
	public class AbstractSequence extends Sequencable
	{
		
		private var _threads			:int;
		private var _sequencables		:Array;
		private var _queue				:Array;
		
		public function AbstractSequence() 
		{
			_sequencables = [];
			_queue = new Array();
		}
		
		public function prepend(sequencable:ISequencable):ISequencable
		{
			if (isProcessing)
			{
				Looger.error("prepend not allowed while Sequence is in process");
				return null;
			}
			if (sequencable != null) _sequencables.unshift(sequencable);
			return sequencable
		}
		
		public function append(sequencable:ISequencable):ISequencable
		{
			if (sequencable != null) 
			{
				if (isProcessing) AbstractSequencable(sequencable).reset();
				_sequencables.push(sequencable);
			}
			
			return sequencable
		}
		
		public function remove(sequencable:ISequencable):ISequencable
		{
			if (isProcessing)
			{
				Looger.error("remove not allowed while Sequence is processing");
				return null;
			}
			if (_sequencables.indexOf(sequencable) == -1) 
			{
				Looger.error("error while removing ISequencable from Sequence");
				return null;
			}
			_sequencables.splice(_sequencables.indexOf(sequencable), 1);
			return sequencable;
		}
		
		private function next():void
		{
			if (!isProcessing) return;
			
			var sequencable:AbstractSequencable;
			var isComplete:Boolean = true;
			
			var exiteds:Array;
			
			for each (sequencable in _queue)
			{
				switch(sequencable.state)
				{
					case AbstractSequencable.STANDBY:
					sequencable.looty::setExit(null);
					sequencable.looty::entry();
					if (sequencable.state != AbstractSequencable.EXITED)
					{
						sequencable.looty::setExit(next);
						return;						
					}					
					break;
					
					case AbstractSequencable.ENTERED :
					isComplete = false;
					break;
					
					case AbstractSequencable.EXITED :
					if (exiteds == null) exiteds = [];
					exiteds.push(sequencable);					
					break;
				}
			}
			
			if (isComplete) 
			{
				_queue = [];
				doComplete();
				return;
			}
			
			var index:int;			
			if (exiteds != null)
			{
				if (exiteds.length == _queue.length) _queue = [];
				else for each (sequencable in exiteds)
				{
					index = _queue.indexOf(sequencable);
					if (index != -1) _queue.splice(index, 1);
				}
			}
			
					
		}
		
		override protected function doProgress():void 
		{
			if (_sequencables.length > 0 && isProcessing)
			{
				var sum:Number = 1;
				var asynch:IASynchrone;
			
				for each (var sequencable:AbstractSequencable in _sequencables)
				{
					if (sequencable is IASynchrone) 
					{
						asynch = IASynchrone(sequencable);
						sum += asynch.progress * asynch.weight;
					}
				}
				
				var w:Number = weight;
				
				looty::setProgress(sum / weight);
			}		
			
			super.doProgress();
		}
		
		override public function get weight():Number 
		{
			var sum:Number = 1;
			for each (var sequencable:AbstractSequencable in _sequencables) if (sequencable is IASynchrone) sum += IASynchrone(sequencable).weight;
			
			return sum; 
		}
		
		override public function set weight(value:Number):void 
		{
			super.weight = value;
		}
		
		override looty function reset():void
		{
			super.looty::reset();
		}
		
		override public function start():Boolean 
		{
			if (_sequencables.length > 0)
			{
				
			}
			if (super.start()) 
			{
				_queue = _sequencables.slice();
				
				if (_threads == 0) _threads = _sequencables.length | 1;
				
				for each (var sequencable:AbstractSequencable in _sequencables) sequencable.reset();
				
				var i:int = 0;
				
				while (i < _threads && isProcessing)
				{
					next();
					++i;
				}
			}
			return isProcessing;
		}
		
		override public function cancel():void 
		{
			super.cancel();
			for each (var aSynchrone:IASynchrone in _sequencables) 
			{				
				if (aSynchrone != null && aSynchrone.isProcessing) aSynchrone.cancel();
			}
			
		}
		
		public function get threads():int { return _threads; }
		
		public function set threads(value:int):void 
		{
			_threads = value;
		}
		
		public function get length():uint { return _sequencables != null ? _sequencables.length : 0; }
		
		override public function dispose():void 
		{
			super.dispose();
			_sequencables = null;
		}
		
		public function dump():String
		{
			return getStructure(" ");
		}
		
		internal function getStructure(parenting:String):String
		{
			var local:String = parenting + "└" + name + " {" + _sequencables.length + "} [" + progress + "]\n";
			parenting += " ";
			for each (var sequencable:AbstractSequencable in _sequencables)
			{
				if (sequencable is AbstractSequence) local += AbstractSequence(sequencable).getStructure(parenting);
				else local += parenting + "└" + sequencable.name + (sequencable is AbstractASynchrone ? " [" + AbstractASynchrone(sequencable).progress + "]" : "" ) + "\n";
			}
			
			return local;
		}
		
	}
	
}