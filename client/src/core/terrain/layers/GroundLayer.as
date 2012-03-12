package core.terrain.layers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 地表层
	 */
	public class GroundLayer extends Layer
	{
		//[Embed(source='../assets/maps/520.jpg')]
		[Embed(source='../assets/maps/wangcheng.jpg')]
		private static const mapTex:Class;
		
		static public const GROUND_TILE_WIDTH:uint = 512;
		static public const GROUND_TILE_HEIGHT:uint = 512;
		
		public function GroundLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
			
			var mapBmp:Bitmap = new mapTex();
			for (var y:uint=0; y<mapBmp.height; y+=GROUND_TILE_HEIGHT) {
				for (var x:uint=0; x<mapBmp.width; x+=GROUND_TILE_WIDTH) {
					var tileBmp:BitmapData = new BitmapData(GROUND_TILE_WIDTH, GROUND_TILE_HEIGHT, true, 0x00FF00);
					var rectSrc:Rectangle = new Rectangle;
					rectSrc.x = x;
					rectSrc.y = y;
					rectSrc.width = GROUND_TILE_WIDTH;
					rectSrc.height = GROUND_TILE_HEIGHT;
					var ptDest:Point = new Point(0, 0);
					tileBmp.copyPixels(mapBmp.bitmapData, rectSrc, ptDest, null, null, true);
					var tex:Texture = Texture.fromBitmapData(tileBmp, false, false);
					var spr:Image = new Image(tex);
					spr.x = x;
					spr.y = y;
					this.addChild(spr);
				}	
			}
			
			flatten();
			
		}
		
		override public function clip():void
		{
			//this.removeChildren();
			//			var child:DisplayObject;
			//			for (var i:uint=0; i<this.numChildren; ++i) {
			//				child = this.getChildAt(i);
			//				trace(child.width);
			//				child.visible = false;
			//			}
		}
		
	}
}