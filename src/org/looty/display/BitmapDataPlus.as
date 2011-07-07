/**
 * Copyright © 2009 lab9 - larrieu bertrand
 * @link http://code.google.com/p/lab9
 * @link http://www.lab9.fr
 * @mail lab9.fr@gmail.com
 * @version 1.0
 */

package org.looty.display 
{
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.*;
	import flash.display.*;
	
	public class BitmapDataPlus extends BitmapData
	{
		
		static public const GRAY_MATRIX			:Array = [	0.3, 0.59, 0.11, 0, 0,
															0.3, 0.59, 0.11, 0, 0,
															0.3, 0.59, 0.11, 0, 0,
															0, 0, 0, 1, 0];
		
		private const ALGO_LIM		:Number		= 2;
		private const ALGO_INV		:Number		= 1 / ALGO_LIM;
		
		public function BitmapDataPlus(width:int, height:int, transparent:Boolean = true, fillColor:uint = 0x00FFFFFF) 
		{
			super(width, height, transparent, fillColor);
		}
		
		override public function draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false):void 
		{
			if (source is BitmapData) smoothing = true;
			
			if (!(matrix.a > ALGO_LIM || matrix.a < ALGO_INV || matrix.d > ALGO_LIM || matrix.d < ALGO_INV))
			{
				super.draw(source, matrix, colorTransform, blendMode, clipRect, smoothing);
				return;
			}
			
			//FIXME:currently not working....
			//UPDATE: seems to work... test cases
			
			var m:Matrix;
			var bmd:BitmapData;
			switch (true)
			{
				case source is BitmapData: bmd = (source as BitmapData).clone(); break;
				case source is DisplayObject: bmd = new BitmapData (getDrawableWidth(source), getDrawableHeight(source), true, 0xFFFFFF); bmd.draw (source); break;
			}
			var bmd2:BitmapData;
			
			while (matrix.a > ALGO_LIM || matrix.a < ALGO_INV || matrix.d > ALGO_LIM || matrix.d < ALGO_INV)
			{
				m = new Matrix();
				
				if (matrix.a > ALGO_LIM) { m.a = ALGO_LIM; matrix.a *= ALGO_INV;}
				if (matrix.a < ALGO_INV) { m.a = ALGO_INV; matrix.a *= ALGO_LIM;}
				if (matrix.d > ALGO_LIM) { m.d = ALGO_LIM; matrix.d *= ALGO_INV;}
				if (matrix.d < ALGO_INV) { m.d = ALGO_INV; matrix.d *= ALGO_LIM; }
				
				bmd2 = new BitmapData (bmd.width * m.a, bmd.height * m.d, bmd.transparent, 0x00FFFFFF);
				bmd2.draw (bmd, m, null, null, null, true);
				
				bmd = bmd2;
			}
			
			super.draw(bmd, matrix, colorTransform, blendMode, clipRect, true);			
		}
		
		public function fitAndCrop (source:IBitmapDrawable, softEdges:int = 0, offsetX:Number = 0.5, offsetY:Number = 0.5):void
		{
			var bw				:Number			= width - softEdges;
			var bh				:Number			= height - softEdges;			
			var destRatio		:Number 		= bw / bh;
			var sWidth			:Number			= getDrawableWidth(source);
			var sHeight			:Number			= getDrawableHeight(source);
			var sourceRatio		:Number 		= sWidth / sHeight;
			var w				:Number			= bw / sWidth ;
			var h				:Number			= bh / sHeight;
			var matrix			:Matrix;
			
			if (destRatio > sourceRatio)
			{
				matrix 							= new Matrix (w, 0, 0, w, softEdges * .5, (height - (w * sHeight)) * offsetY);
			}
			else
			{
				matrix 							= new Matrix (h, 0, 0, h, (width - (h * sWidth)) * offsetX, softEdges * .5);
			}
			
			draw (source, matrix, null, null, null, true);
			
			if (softEdges > 0)
			{
				applyFilter(this, new Rectangle(0, 0, width, softEdges), new Point(0, 0), new BlurFilter(0, softEdges, 1));
				applyFilter(this, new Rectangle(0, height - softEdges, width, softEdges), new Point(0, height - softEdges), new BlurFilter(0, softEdges, 1));
				applyFilter(this, new Rectangle(0, 0, softEdges, height), new Point(0, 0), new BlurFilter(softEdges, 0, 1));
				applyFilter(this, new Rectangle(width - softEdges, 0, softEdges, height), new Point(width - softEdges, 0), new BlurFilter(softEdges, 0, 1));
			}
			
		}
		
		protected function getDrawableWidth(source:IBitmapDrawable):Number
		{
			switch (true)
			{
				case source is BitmapData: return BitmapData(source).width; break;
				case source is Stage: return Stage(source).stageWidth; break;
				case source is DisplayObject: return DisplayObject(source).width; break;
			}
			
			return 0
		}
		
		protected function getDrawableHeight(source:IBitmapDrawable):Number
		{
			switch (true)
			{
				case source is BitmapData: return BitmapData(source).height; break;
				case source is Stage: return Stage(source).stageHeight; break;
				case source is DisplayObject: return DisplayObject(source).height; break;
			}
			
			return 0
		}
		
		public function grayscale():void
		{
			applyFilter (this, null, null, new ColorMatrixFilter(GRAY_MATRIX));
		}
		
	}
	
}