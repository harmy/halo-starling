package core.world
{
	import core.camera.Camera;
	import core.terrain.Map;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class World extends Sprite
	{
		/**
		 * 游戏当前摄像机
		 */
		protected var m_camera:Camera;
		
		/**
		 * 游戏当前地图
		 */
		protected var m_map:Map;
		
		private var m_running:Boolean = false;
		private var m_lastTick:uint = 0;

		public function World()
		{
			m_camera = new Camera;
			m_map = new Map(m_camera);
			
			// 加入地图层
			addChild(m_map);
			
			removeEventListener(Event.ENTER_FRAME,onUpdateFrame);
			addEventListener(Event.ENTER_FRAME,onUpdateFrame);
		}
		
		public function set camera(camera:Camera):void
		{
			m_camera = camera;
		}
		
		public function get camera():Camera
		{
			return m_camera;
		}
		
		public function get map():Map	
		{
			return m_map;
		}
		
		/**
		 * 屏幕坐标转为世界坐标(像素)
		 */
		public function screen2World(screenX:int, screenY:int):Point
		{
			return m_camera.screen2World(screenX, screenY);
		}
		
		/**
		 * 世界坐标转为屏幕坐标(像素)
		 */
		public function world2Screen(worldX:uint, worldY:uint):Point
		{
			return m_camera.world2Screen(worldX, worldY);
		}
		
		/**
		 * 启动游戏世界
		 */
		public function start():void
		{
			m_lastTick = getTimer();
			m_running = true;
		}
		
		public function stop():void
		{
			m_running = false;
		}
		
		private function onUpdateFrame(evt:Event):void
		{
			if (!m_running) return;
			
			var curTick:uint = getTimer();
			var elapse:uint = curTick - m_lastTick;
			
			update(elapse);
			
			m_lastTick = getTimer();
		}
		
		/**
		 * 游戏主循环
		 * elapse - 距离上一帧的时间(毫秒)
		 */
		protected function update(elapse:uint):void
		{
			// 优先更新相机
			m_camera.update(elapse);
			
			// 更新地图的相机位置
			m_map.updateCamera(m_camera);
			
			// 更新地图逻辑
			m_map.update(elapse);
		}

		
		
	}
}



