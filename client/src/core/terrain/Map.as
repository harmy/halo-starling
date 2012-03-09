package core.terrain
{
	import core.camera.Camera;
	import core.data.CoreConst;
	import core.resmgr.ResMgr;
	import core.terrain.layers.BlockLayer;
	import core.terrain.layers.GroundLayer;
	import core.terrain.layers.Layer;
	import core.terrain.layers.ParallaxLayer;
	import core.terrain.layers.SkyLayer;
	import core.terrain.layers.SortLayer;
	
	import flash.utils.Dictionary;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;
	
	import starling.display.Sprite;

	public class Map extends Sprite
	{
		/**
		 * 地图单个格子的宽(像素)
		 */
		static public var TileWidth:uint = 64;
		
		/**
		 * 地图单个格子的高(像素)
		 */
		static public var TileHeight:uint = 32;
		
		
		/**
		 * 存放地图的路径
		 */
		private var m_mapPath:String;
		
		private var m_layers:Vector.<Layer> = new Vector.<Layer>();
		private var m_layerDic:Dictionary = new Dictionary;	// Layer
		
		/**
		 * 地图的跟节点
		 */
		//private var m_container:Sprite;
		
		private var m_camera:Camera;
		
		private var m_width:uint;
		private var m_height:uint;
		
		public function Map(camera:Camera)
		{
			m_camera = camera;
		}
		
		/**
		 * 设置地图文件的存放路径
		 */
		public function setMapPath(path:String):void
		{
			m_mapPath = path;
		}
		
		public function load(url:String):void
		{
			var mapUrl:String = m_mapPath + "/" + url;
			ResMgr.loadByURLLoader(mapUrl, onComplete, CoreConst.PRIORITY_MAP);
		}
		
		public function update(elapse:uint):void
		{
			for (var i:uint=0; i<m_layers.length; ++i) {
				m_layers[i].update(elapse);
			}
			
		}
		
		public function addLayer(layer:Layer):void
		{
			this.addChild(layer);
			m_layers.push(layer);
			m_layerDic[layer.name] = layer;
		}
		
		public function getLayer(name:String):Layer
		{
			return m_layerDic[name];
		}
		
		public function updateCamera(camera:Camera):void
		{
			this.x = -camera.x;
			this.y = -camera.y;
		}
		
		private function onComplete(event:LoaderQueueEvent):void
		{
			// 根据地图文件，创建地图层次
			// TODO
			
			// --------- 创建测试用的图层 ----------
			
			var layer:Layer;
			
			// 创建悬空地表
			layer = new ParallaxLayer("parallax",24,32);
			addLayer(layer);
			
			// 创建地表
			layer = new GroundLayer("ground",24,32);
			addLayer(layer);
			
			// 创建排序层
			var sortlayer:SortLayer = new SortLayer("sort",24,32);
			addLayer(sortlayer);
			m_camera.traceObject = sortlayer.m_localPlayer; 
			
			// 创建阻挡层
			layer = new BlockLayer("block",24,32);
			addLayer(layer);
			
			// 创建天空层
			layer = new SkyLayer("sky",24,32);
			addLayer(layer);
			
			// ------------------------------------
		}
	}
}