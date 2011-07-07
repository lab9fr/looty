/**
 * Copyright © 2010 looty
 * @link http://www.looty.org
 * @link http://code.google.com/p/looty/
 * @author lab9 - Bertrand Larrieu
 * @mail lab9.fr@gmail.com
 * @created 19/04/2010 19:47
 * @version 0.1
 */

package org.looty.core.mvc 
{
	import org.looty.data.*;
	import org.looty.mvc.controller.*;
	import org.looty.mvc.model.*;
	import org.looty.mvc.view.*;
	import org.looty.sequence.*;
	
	public interface ILayerElement 
	{
		function configure(xml:XML, presenter:Presenter = null):void
		function get command():Command;
		
		function get initialisation():Sequence;	
		function get selection():Sequence;		
		function get unselection():Sequence;		
		
		function get isSelecting():Boolean;		
		function get isUnselecting():Boolean;
		
		function get type():String;
		function get id():String;
		function get name():String;
		
		function get model():Model;
		function get view():View;
		function get controller():Controller;		
	}
	
}