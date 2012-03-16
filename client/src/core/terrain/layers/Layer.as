package core.terrain.layers
{
	import core.camera.Camera;
	import core.object.GameObject;
	
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
		protected var mProps:Dictionary;
		
		/**
		 * 存储裁剪掉的对象
		 */
		protected var mChildrenClip:Dictionary = new Dictionary;	// DisplayObject

		
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
		
		override public function removeChildAt(index:int, dispose:Boolean=false):void
		{
			var child:DisplayObject = getChildAt(index);
			if (child == null) return;
			
			delete mChildrenClip[child];
			
			super.removeChildAt(index, dispose);
		}
		
		/**
		 * 对象进行裁剪
		 */
		public function clip(camera:Camera):void
		{
			// 处理裁剪掉的对象
			var child:GameObject;
			for each(child in mChildrenClip) {
				if ( child.inViewport(camera) ) {
					super.addChild(child);
					delete mChildrenClip[child];
				}
			}
			
			// 处理容器内的对象
			for (var i:uint=0; i<numChildren; ++i) {
				child = this.getChildAt(i) as GameObject;
				if (child == null) continue;
				 if ( !child.inViewport(camera) ) {
					 mChildrenClip[child] = child;
					 super.removeChildAt(i);
				 }
			}
			
			//trace("对象数： " + numChildren);
		}
		
		/**
		 * 根据摄像机更新位置
		 */
		public function updateCamera(camera:Camera):void
		{
			this.x = -camera.x;
			this.y = -camera.y;
			
			// 根据相机位置，进行裁剪
			clip(camera);
		}
		
		public function update(elapse:uint):void
		{
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