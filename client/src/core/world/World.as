package core.world
{
	import core.camera.Camera;
	import core.terrain.Map;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class World extends Sprite
	{
		/**
		 * 游戏当前摄像机
		 */
		protected var mCamera:Camera;
		
		/**
		 * 游戏当前地图
		 */
		protected var mMap:Map;
		
		private var mRunning:Boolean = false;
		private var mLastTick:uint = 0;
		
		public function World()
		{
			mCamera = new Camera;
			mMap = new Map(mCamera);
			
			// 加入地图层
			addChild(mMap);
			
			removeEventListener(Event.ENTER_FRAME,onUpdateFrame);
			addEventListener(Event.ENTER_FRAME,onUpdateFrame);
		}
		
		public function set camera(camera:Camera):void
		{
			mCamera = camera;
		}
		
		public function get camera():Camera
		{
			return mCamera;
		}
		
		public function get map():Map	
		{
			return mMap;
		}
		
		public function onResize(width:uint, height:uint):void
		{
			camera.viewRect = new Rectangle(0, 0, width, height);
			camera.traceRect = new Rectangle(0, 0, mMap.mapWidth, mMap.mapHeight);
		}
		
		/**
		 * 屏幕坐标转为世界坐标(像素)
		 */
		public function screen2World(screenX:int, screenY:int):Point
		{
			return mCamera.screen2World(screenX, screenY);
		}
		
		/**
		 * 世界坐标转为屏幕坐标(像素)
		 */
		public function world2Screen(worldX:uint, worldY:uint):Point
		{
			return mCamera.world2Screen(worldX, worldY);
		}
		
		/**
		 * 启动游戏世界
		 */
		public function start():void
		{
			mLastTick = getTimer();
			mRunning = true;
		}
		
		public function stop():void
		{
			mRunning = false;
		}
		
		private function onUpdateFrame(evt:Event):void
		{
			if (!mRunning) return;
			
			var curTick:uint = getTimer();
			var elapse:uint = curTick - mLastTick;
			
			update(elapse);
			
			mLastTick = getTimer();
		}
		
		/**
		 * 游戏主循环
		 * elapse - 距离上一帧的时间(毫秒)
		 */
		protected function update(elapse:uint):void
		{
			// 优先更新相机
			mCamera.update(elapse);
			
			// 更新地图的相机位置
			mMap.updateCamera(mCamera);
			
			// 更新地图逻辑
			mMap.update(elapse);
		}

		
		
	}
}



