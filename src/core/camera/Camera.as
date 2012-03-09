package core.camera
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	/**
	 * 摄像机基础 
	 */
	public class Camera
	{
		static public const SHAKE_X:uint = 1;		// X方向震动
		static public const SHAKE_Y:uint = 2;		// Y方向震动
		static public const SHAKE_XY:uint = 3;	// XY方向震动
		
		protected var m_pt:Point = new Point;
		protected var m_veiwRect:Rectangle;	// 窗口大小(像素)
		protected var m_traceRect:Rectangle;	// 地图大小(像素)
		protected var m_traceObject:DisplayObject;
		
		
		protected var m_shakeLastTick:uint;
		protected var m_shakeStartTick:uint;
		protected var m_shakeCurSpan:Number;
		protected var m_shakeOffset:Point = new Point;
		
		protected var m_shakeDir:uint;			// 震动方向(SHAKE_X,SHAKE_Y,SHAKE_XY)
		protected var m_shakeSpan:Number;		// 震动幅度(像素)
		protected var m_shakeFrequency:Number;	// 震动频率(毫秒)
		protected var m_shakeTime:uint;		// 持续时间(毫秒)
		
		public function Camera()
		{
		}
		
		/**
		 * dir - 震动方向(SHAKE_X,SHAKE_Y,SHAKE_XY)
		 * span - 震动幅度(像素)
		 * time - 持续时间(毫秒)
		 * frequency - 震动频率(毫秒),表示多少时间处理一次
		 */
		public function shake(dir:uint, span:uint, time:uint, frequency:uint=100):void
		{
			m_shakeOffset.x = m_shakeOffset.y = 0;
			m_shakeDir = dir;
			m_shakeSpan = span;
			m_shakeTime = time;
			m_shakeFrequency = frequency;
			
			m_shakeCurSpan = span;
			m_shakeStartTick = getTimer();
			m_shakeLastTick = getTimer();
			//m_shakeOffset.y = span;
		}
		
		public function get traceObject():DisplayObject
		{
			return m_traceObject;
		}
		
		public function set traceObject(value:DisplayObject):void
		{
			m_traceObject = value;
		}
		
		public function get viewRect():Rectangle
		{
			return m_veiwRect;
		}
		
		public function set viewRect(rect:Rectangle):void
		{
			m_veiwRect = rect;
		}
		
		public function get traceRect():Rectangle
		{
			return m_traceRect;
		}
		
		public function set traceRect(rect:Rectangle):void
		{
			m_traceRect = rect;
		}
		
		public function get x():Number
		{
			return m_pt.x;
		}
		
		public function set x(value:Number):void
		{
			m_pt.x = value;
		}
		
		public function get y():Number
		{
			return m_pt.y;
		}
		
		public function set y(value:Number):void
		{
			m_pt.y = value;
		}
		
		
		/**
		 * 世界坐标转为屏幕坐标(像素)
		 * @param	worldX
		 * @param	worldY
		 * @return
		 */
		public function world2Screen(worldX:uint, worldY:uint):Point
		{
			return new Point(worldX - x, worldY - y);
		}
		
		/**
		 * 屏幕坐标转为世界坐标(像素)
		 * @param	screenX
		 * @param	screenY
		 * @return
		 */
		public function screen2World(screenX:uint, screenY:uint):Point
		{
			return new Point(screenX + x, screenY + y);
		}
		
		protected function updateShake():void
		{
			// 处理震屏
			var curTick:uint = getTimer();
			if (curTick - m_shakeLastTick > m_shakeFrequency) {
				m_shakeLastTick = curTick;
				
				if (curTick - m_shakeStartTick < m_shakeTime) {
					// 根据时间，计算出当前的振幅
					var percent:Number = 1 - (curTick - m_shakeStartTick) / m_shakeTime;
					//trace("percent: " + percent);
					m_shakeCurSpan = m_shakeSpan * percent;
					//trace("m_shakeCurSpan: " + m_shakeCurSpan);
					
					if (m_shakeDir == SHAKE_X) {
						// 更新X轴振幅
						if (m_shakeOffset.x >= 0) {
							m_shakeOffset.x = uint(m_shakeCurSpan);
						} else {
							m_shakeOffset.x = -uint(m_shakeCurSpan);
						}
						// 震动
						m_shakeOffset.x = -m_shakeOffset.x;
						m_shakeOffset.y = 0;
					} else if (m_shakeDir == SHAKE_Y) {
						// 更新Y轴振幅
						if (m_shakeOffset.y >= 0) {
							m_shakeOffset.y = uint(m_shakeCurSpan);
						} else {
							m_shakeOffset.y = -uint(m_shakeCurSpan);
						}
						// 震动
						m_shakeOffset.x = 0;
						m_shakeOffset.y = -m_shakeOffset.y;
						//trace("shakeOffsetY: " + m_shakeOffset.y);
					} if (m_shakeDir == SHAKE_XY) {
						// 更新X轴振幅
						if (m_shakeOffset.x >= 0) {
							m_shakeOffset.x = uint(m_shakeCurSpan);
						} else {
							m_shakeOffset.x = -uint(m_shakeCurSpan);
						}
						// 震动
						m_shakeOffset.x = -m_shakeOffset.x;
						
						// 更新Y轴振幅
						if (m_shakeOffset.y >= 0) {
							m_shakeOffset.y = uint(m_shakeCurSpan);
						} else {
							m_shakeOffset.y = -uint(m_shakeCurSpan);
						}
						// 震动
						m_shakeOffset.y = -m_shakeOffset.y;
					}
				} else {
					// 震动结束
					m_shakeOffset.x = m_shakeOffset.y = 0;
				}
			}
		}
		
		public function update(elapse:uint):void
		{
			if (m_traceObject != null) {
				// 时刻跟踪的摄像机
				x = m_traceObject.x;
				y = m_traceObject.y;
			}
			
			if (m_traceRect != null) {
				// 限制在地图之内
				x -= m_veiwRect.width>>1;
				y -= m_veiwRect.height>>1;
				if (x < 0) x = 0;
				if (y < 0) y = 0;
				var sizeX:uint = m_traceRect.width - m_veiwRect.width;
				var sizeY:uint = m_traceRect.height - m_veiwRect.height;
				if (x > sizeX) x = sizeX;
				if (y > sizeY) y = sizeY;
			}
			
			// 震屏算法
			updateShake();
			
			// 计算震动效果的偏移
			x = x + m_shakeOffset.x;
			y = y + m_shakeOffset.y;
		}
		
	}
}

