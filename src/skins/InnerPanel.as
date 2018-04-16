package skins
{
	import flash.geom.Matrix;
	
	import mx.skins.ProgrammaticSkin;

	public class InnerPanel extends ProgrammaticSkin
	{
		public function InnerPanel()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
//			var gradrientMatrix:Matrix = new Matrix();
//			graphics.drawRect();
//			gradrientMatrix.createGradientBox(unscaledWidth, unscaledHeight);
		}
	}
}