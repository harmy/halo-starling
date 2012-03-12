package core.terrain.layers
{
	import core.camera.Camera;
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	/**
	 * 层的基类
	 */
	public class Layer extends Sprite
	{
		/**
		 * 层的名字
		 */
		protected var mLayerName:String;
		
		/**
		 * 层的宽度(格子数)
		 */
		protected var mLayerWidth:uint;
		
		/**
		 * 层的高度(格子数)
		 */
		protected var mLayerHeight:uint;
		
		/**
		 * 该层包含的属性键值对
		 */
		protected var m_props:Dictionary;
		
		public function Layer(name:String, width:uint, height:uint)
		{
			mLayerName = name;
			mLayerWidth = width;
			mLayerHeight = height;
		}
		
		public function get layerName():String
		{
			return mLayerName;
		}
		
		public function get layerWidth():uint
		{
			return mLayerWidth;
		}
		
		public function get layerHeight():uint
		{
			return mLayerHeight;
		}
		
		/**
		 * 对象进行裁剪
		 */
		public function clip():void
		{
//			this.removeChildren();
//			var child:DisplayObject;
//			for (var i:uint=0; i<this.numChildren; ++i) {
//				child = this.getChildAt(i);
//				trace(child.width);
//				child.visible = false;
//			}
		}
		
		/**
		 * 根据摄像机更新位置
		 */
		public function updateCamera(camera:Camera):void
		{
			this.x = -camera.x;
			this.y = -camera.y;
		}
		
		public function update(elapse:uint):void
		{
			// 先进行裁剪,屏幕之外的移出队列
			clip();
			
			// 再进行排序
			// 有的层不一定需要排序，所以留给子类处理
		}
		
		/**
		 * 层内对象的默认排序规则
		 * 根据Y轴行进排序
		 */
		protected function compare(paraA:DisplayObject,paraB:DisplayObject):int
		{
			var resultA:int = paraA.y
			var resultB:int = paraB.y;
			if(resultA > resultB) return 1;
			if(resultA < resultB) return -1;
			return 0;
		}
	}
}