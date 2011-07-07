/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 27/01/2010 21:24
 * @version 0.1
 */

package org.looty.interactive 
{
	import flash.display.*;
	import flash.errors.*;
	import org.looty.core.looty;
	import org.looty.log.Looger;
	
	//TODO : FrameTweenToggleInteraction
	
	use namespace looty;
	
	public class FrameToggleInteraction extends ToggleInteraction
	{
		public var frameOn			:uint;
		public var frameOff			:uint;
		
		public function FrameToggleInteraction(target:MovieClip, frameOff:uint = 1, frameOn:uint = 2) 
		{
			super(target);
			
			if (frameOff == 0 || frameOn == 0) throw new IllegalOperationError("frame count begins at 1");
			this.frameOn = frameOn;
			this.frameOff = frameOff;
		}
		
		override public function addTarget(target:InteractiveObject):InteractiveObject 
		{
			if (!(target is MovieClip)) 
			{
				Looger.error("FrameToggleInteraction only works with MovieClips");
				return null;
			}
			return super.addTarget(target);
		}
		
		override public function stateOn():void 
		{
			super.stateOn();
			for (var target:* in looty::targets) target.gotoAndStop(frameOn);
		}
		
		override public function stateOff():void 
		{
			super.stateOff();
			for (var target:* in looty::targets) target.gotoAndStop(frameOff);
		}
		
		override public function on():void 
		{
			super.on();			
			for (var target:* in looty::targets) target.gotoAndStop(frameOn);			
		}
		
		override public function off():void 
		{
			super.off();
			for (var target:* in looty::targets) target.gotoAndStop(frameOff);
		}
		
	}
	
}