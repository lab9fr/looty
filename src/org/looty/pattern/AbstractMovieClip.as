/**
 * Copyright © 2009 looty
 * @link http://code.google.com/p/looty/
 * @link http://www.looty.org
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.pattern
{
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	public class AbstractMovieClip extends MovieClip
	{
		
		public function AbstractMovieClip() 
		{
			makeAbstract (AbstractMovieClip);
		}
		
		protected function makeAbstract (abstractClass:Class):void
		{
			if (getQualifiedClassName (this) == getQualifiedClassName (abstractClass)) throw new IllegalOperationError ("an Abstract Class can't be directly instancied. Use it through inheritance and overwrite the proper methods.");
		}
		
	}
	
}