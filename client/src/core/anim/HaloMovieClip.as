package core.anim
{
	import starling.display.MovieClip;
	import starling.textures.Texture;

	public class HaloMovieClip extends MovieClip
	{
		public function HaloMovieClip(textures:Vector.<Texture>, fps:Number=12)
		{
			super(textures, fps);
			
			pivotX = 256;
			pivotY = 256;
		}
		
		override public function advanceTime(passedTime:Number):void
		{
			super.advanceTime(passedTime);
			
			// TODO
		}
		
		public function get frameWidth():uint
		{
			return texture.width;
		}
		
		public function get frameHeight():uint
		{
			return texture.height;
		}
	}
}