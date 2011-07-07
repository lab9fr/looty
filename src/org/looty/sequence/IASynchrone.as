/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @version 0.1
 */

package org.looty.sequence
{
	
	public interface IASynchrone extends ISequencable
	{		
		function get onComplete():Function;
		function set onComplete(value:Function):void;
		function get onCompleteParams():Array;
		function set onCompleteParams(value:Array):void;
		
		function get onStart():Function;
		function set onStart(value:Function):void;
		function get onStartParams():Array;
		function set onStartParams(value:Array):void;
		
		function get onCancel():Function;
		function set onCancel(value:Function):void;
		function get onCancelParams():Array;
		function set onCancelParams(value:Array):void;
		
		function get onError():Function;
		function set onError(value:Function):void;
		function get onErrorParams():Array;
		function set onErrorParams(value:Array):void;
		
		function get onFailure():Function;
		function set onFailure(value:Function):void;
		function get onFailureParams():Array ;
		function set onFailureParams(value:Array):void;	
		
		function get onProgress():Function;
		function set onProgress(value:Function):void;
		function get onProgressParams():Array;
		function set onProgressParams(value:Array):void;	
		
		function get progress():Number;		
		function get isComplete():Boolean;
		function get isFailed():Boolean;
		function get weight():Number;
		function set weight(value:Number):void;
	}
	
}