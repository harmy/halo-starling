package core.object
{
	import core.camera.Camera;
	import core.controller.Controller;
	import core.data.CoreConst;
	import core.resmgr.ResMgr;
	
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 游戏对象： 玩家、NPC、怪物、宠物、等等
	 */
	public class GameObject extends Sprite
	{
		/**
		 * 唯一ID
		 */
		protected var mId:uint;
		
		/**
		 * 逻辑控制单元
		 */
		protected var mController:Controller;
		
		/**
		 * 方向
		 */
		protected var mDir:uint;
		
		/**
		 * 是否显示名字
		 */
		protected var mIsShowName:Boolean = true;
		
		/**
		 * 显示的名字
		 */
		protected var mTFName:HaloTextField = new HaloTextField(256, 32, "我的名字");
		
		/**
		 * 高度
		 */
		protected var mHeight:uint = 0;
		

		
		public function GameObject()
		{
			mTFName.x = -mTFName.width / 2 - (mTFName.text.length) / 2 * mTFName.fontSize;
			mTFName.y = -107;
			mTFName.color = 0xFFFFFF;
			mTFName.filter = CoreConst.GLOW_FILTER1;
			mTFName.autoScale = false;
			mTFName.kerning = false;

			addChild(mTFName);
		}
		
		
		public function set id(value:uint):void
		{
			mId = value;
		}
		
		public function get id():uint
		{
			return mId;
		}

		public function set controller(ctrl:Controller):void
		{
			mController = ctrl;
		}
		
		public function get controller():Controller
		{
			return mController;
		}
		
		public function updateController():void
		{
			if (mController) mController.update()
		}
		
		public function set dir(value:uint):void
		{
			mDir = value;
		}
		
		public function get dir():uint
		{
			return mDir;
		}
		
		/**
		 * 更新内部逻辑
		 */
		public function update():void
		{
			//trace("font: " + mTFName.width + "," + mTFName.height);
		}
		
		
		/**
		 * 判断物体是否在摄像机的可是范围内
		 */
		public function inViewport(camera:Camera):Boolean
		{
			return false;
		}
	}
}