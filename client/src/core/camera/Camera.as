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
		
		protected var mPt:Point = new Point;
		protected var mViewRect:Rectangle;		// 窗口大小(像素)
		protected var mTraceRect:Rectangle;	// 地图大小(像素)
		protected var mTraceObject:DisplayObject;
		
		
		protected var mShakeLastTick:uint;	
		protected var mShakeStartTick:uint;
		protected var mShakeCurSpan:Number;
		protected var mShakeOffset:Point = new Point;
		
		protected var mShakeDir:uint;			// 震动方向(SHAKE_X,SHAKE_Y,SHAKE_XY)
		protected var mShakeSpan:Number;		// 震动幅度(像素)
		protected var mShakeFrequency:Number;	// 震动频率(毫秒)
		protected var mShakeTime:uint;		// 持续时间(毫秒)
		
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
			mShakeOffset.x = mShakeOffset.y = 0;
			mShakeDir = dir;
			mShakeSpan = span;
			mShakeTime = time;
			mShakeFrequency = frequency;
			
			mShakeCurSpan = span;
			mShakeStartTick = getTimer();
			mShakeLastTick = getTimer();
		}
		
		public function get traceObject():DisplayObject
		{
			return mTraceObject;
		}
		
		public function set traceObject(value:DisplayObject):void
		{
			mTraceObject = value;
		}
		
		/**
		 * 在世界坐标系内的可视区域
		 */
		private var mViewRectInWorld:Rectangle = new Rectangle;
		public function get viewRectInWorld():Rectangle
		{
			mViewRectInWorld.x = mPt.x;
			mViewRectInWorld.y = mPt.y;
			mViewRectInWorld.width = mViewRect.width;
			mViewRectInWorld.height = mViewRect.height;
			//trace("viewRectInWorld: " + mViewRectInWorld.left + "," + mViewRectInWorld.top + "," + mViewRectInWorld.right + "," + mViewRectInWorld.bottom);
			return mViewRectInWorld;
		}
		
		public function get viewRect():Rectangle
		{
			return mViewRect;
		}
		
		public function set viewRect(rect:Rectangle):void
		{
			mViewRect = rect;
		}
		
		public function get traceRect():Rectangle
		{
			return mTraceRect;
		}
		
		public function set traceRect(rect:Rectangle):void
		{
			mTraceRect = rect;
		}
		
		public function get x():Number
		{
			return mPt.x;
		}
		
		public function set x(value:Number):void
		{
			mPt.x = value;
		}
		
		public function get y():Number
		{
			return mPt.y;
		}
		
		public function set y(value:Number):void
		{
			mPt.y = value;
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
			if (curTick - mShakeLastTick > mShakeFrequency) {
				mShakeLastTick = curTick;
				
				if (curTick - mShakeStartTick < mShakeTime) {
					// 根据时间，计算出当前的振幅
					var percent:Number = 1 - (curTick - mShakeStartTick) / mShakeTime;
					//trace("percent: " + percent);
					mShakeCurSpan = mShakeSpan * percent;
					//trace("m_shakeCurSpan: " + m_shakeCurSpan);
					
					if (mShakeDir == SHAKE_X) {
						// 更新X轴振幅
						if (mShakeOffset.x >= 0) {
							mShakeOffset.x = uint(mShakeCurSpan);
						} else {
							mShakeOffset.x = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.x = -mShakeOffset.x;
						mShakeOffset.y = 0;
					} else if (mShakeDir == SHAKE_Y) {
						// 更新Y轴振幅
						if (mShakeOffset.y >= 0) {
							mShakeOffset.y = uint(mShakeCurSpan);
						} else {
							mShakeOffset.y = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.x = 0;
						mShakeOffset.y = -mShakeOffset.y;
						//trace("shakeOffsetY: " + m_shakeOffset.y);
					} if (mShakeDir == SHAKE_XY) {
						// 更新X轴振幅
						if (mShakeOffset.x >= 0) {
							mShakeOffset.x = uint(mShakeCurSpan);
						} else {
							mShakeOffset.x = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.x = -mShakeOffset.x;
						
						// 更新Y轴振幅
						if (mShakeOffset.y >= 0) {
							mShakeOffset.y = uint(mShakeCurSpan);
						} else {
							mShakeOffset.y = -uint(mShakeCurSpan);
						}
						// 震动
						mShakeOffset.y = -mShakeOffset.y;
					}
				} else {
					// 震动结束
					mShakeOffset.x = mShakeOffset.y = 0;
				}
			}
		}
		
		public function update(elapse:uint):void
		{
			if (mTraceObject != null) {
				// 时刻跟踪的摄像机
				x = mTraceObject.x;
				y = mTraceObject.y;
			}
			
			if (mTraceRect != null) {
				// 限制在地图之内
				x -= mViewRect.width>>1;
				y -= mViewRect.height>>1;
				if (x < 0) x = 0;
				if (y < 0) y = 0;
				var sizeX:uint = mTraceRect.width - mViewRect.width;
				var sizeY:uint = mTraceRect.height - mViewRect.height;
				if (x > sizeX) x = sizeX;
				if (y > sizeY) y = sizeY;
			}
			
			// 震屏算法
			updateShake();
			
			// 计算震动效果的偏移
			x = x + mShakeOffset.x;
			y = y + mShakeOffset.y;
			
			
			var e:Rectangle = viewRectInWorld;
		}
		
		
	}
}

