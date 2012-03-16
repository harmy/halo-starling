package core.object
{
	import core.anim.HaloMovieClip;
	import core.camera.Camera;
	import core.data.CoreConst;
	
	import flash.filters.GlowFilter;
	
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class Charactor extends GameObject
	{
		static private var count:uint = 1;
		
		protected var mLooks:CharLooks;
		protected var mView:HaloMovieClip;
		
		
		public function Charactor(looks:CharLooks)
		{
			mLooks = looks;
			
			mId = count++;
		}
		
		public function set charView(value:HaloMovieClip):void
		{
			mView = value;
			removeChild(value);
			addChild(value);
		}
		
		public function get charView():HaloMovieClip
		{
			return mView;
		}
		
		override public function get width():Number
		{
			return mView.frameWidth;
		}
		
		override public function get height():Number
		{
			return mView.frameHeight;
		}
		
		override public function inViewport(camera:Camera):Boolean
		{
//			if (camera.x > x + 128)
//				return false;
//			
//			if (camera.y > y + 128)
//				return false;
//			
//			if (camera.right < (x - 128))
//				return false;
//			
//			if (camera.bottom < (y - 128))
//				return false;
			
			if (camera.x > x + width/2)
				return false;
			
			if (camera.y > y + height)
				return false;
			
			if (camera.right < (x - width/2))
				return false;
			
			if (camera.bottom < (y - height))
				return false;
			
			return true;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}

