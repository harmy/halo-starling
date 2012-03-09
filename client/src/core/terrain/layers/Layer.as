package core.terrain.layers
{
	import core.camera.Camera;
	
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;

	/**
	 * 层的基类
	 */
	public class Layer extends Sprite
	{
		/**
		 * 层的名字
		 */
		protected var m_name:String;
		
		/**
		 * 层的宽度(格子数)
		 */
		protected var m_width:uint;
		
		/**
		 * 层的高度(格子数)
		 */
		protected var m_height:uint;
		
		/**
		 * 该层包含的属性键值对
		 */
		protected var m_props:Dictionary;
		
		public function Layer(name:String, width:uint, height:uint)
		{
			m_name = name;
			m_width = width;
			m_height = height;
		}
		
		public function get layerName():String
		{
			return m_name;
		}
		
		public function get layerWidth():uint
		{
			return m_width;
		}
		
		public function get layerHeight():uint
		{
			return m_height;
		}
		
		public function updateCamera(camera:Camera):void
		{
			this.x = camera.x;
			this.y = camera.y;
		}
		
		public function update(elapse:uint):void
		{
			
		}
	}
}