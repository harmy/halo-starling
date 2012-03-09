package core.cursor
{
//	import Client.Setting;
//	
//	import Lib.Texture.SWFSafeLoader;
//	import Lib.Version.FileVersion;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	//import mx.managers.CursorManager;
	
	public class NativeCursor
	{
		static public const LEFT_TOP:uint = 0;	// 左上角
		static public const CENTER:uint = 1;		// 中心点
		static public const TOP_CENTER:uint = 2;	// 上面的中心
		
		//static private var m_safeLoader:SWFSafeLoader = new SWFSafeLoader(); 
		static private var m_domain:ApplicationDomain;
		static private var m_isLoaded:Boolean = false;
		
		public function NativeCursor()
		{
			
		}
		
		/**
		 * 加载并初始化鼠标文件
		 */
		static public function Init():void
		{
			// 加载新手引导的flash文件
			//var url:String = Setting.Assets_Path + "mouse.swf";
			//url = FileVersion.getFileName(url);
			//m_safeLoader = new SWFSafeLoader;
			//m_safeLoader.safeLoad(url, OnLoadSwfFinish, errorHandler);
		}
		
		static private function OnLoadSwfFinish(evt:Event):void
		{
//			if (m_safeLoader.contentLoaderInfo != null) {
//				m_domain = m_safeLoader.contentLoaderInfo.applicationDomain;
//				InitMouseCursor();
//				m_isLoaded = true;
//				UseNormalMouse();
//			}
		}
		
		static private function InitMouseCursor():void
		{
			createMouseData("nomove", "nomove");
			createMouseData("sell", "sell");
			createMouseData("talk", "talk");
			createMouseData("attack", "attack");
			createMouseData("noattack", "noattack");
			createMouseData("pick", "pick");
			createMouseData("nopick", "nopick");
			createMouseData("repair", "repair", TOP_CENTER);
			createMouseData("norepair", "norepair", TOP_CENTER);
			createMouseData("normal", "normal");
			createMouseData("splite", "splite");
			createMouseData("nosplite", "nosplite");
		}
		
		/**
		 * 通过名字指定当前鼠标
		 */
		static public function SetCursor(name:String):void
		{
			if (!m_isLoaded) return;
			
			Mouse.cursor = name;
		}
		
		/**
		 * 无法捡取
		 */
		static public function UseNoPickMouse():void
		{
			SetCursor("nopick");
		}
		
		/**
		 * 无法移动
		 */
		static public function UseNoMoveMouse():void
		{
			SetCursor("nomove");
		}
		
		/**
		 * 可以出售
		 */
		static public function UseSellMouse():void
		{
			SetCursor("sell");
		}
		
		/**
		 * NPC对话
		 */
		static public function UseTalkMouse():void
		{
			SetCursor("talk");
		}
		
		/**
		 * 可以攻击
		 */
		static public function UseAttackMouse():void
		{
			SetCursor("attack");
		}
		
		/**
		 * 可以捡取
		 */
		static public function UsePickMouse():void
		{
			SetCursor("pick");
		}
		
		/**
		 * 可以修理
		 */
		static public function UseRepairMouse():void
		{
			SetCursor("repair");
		}
		
		/**
		 * 无法修理
		 */
		static public function UseNoRepairMouse():void
		{
			SetCursor("norepair");
		}
		
		/**
		 * 正常鼠标
		 */
		static public function UseNormalMouse():void
		{
			//SetCursor(MouseCursor.AUTO);
			SetCursor("normal");
		}
		
		/**
		 * 拆分物品
		 */
		static public function UseSpliteMouse():void
		{
			SetCursor("splite");
		}
		
		/**
		 * 无法拆分物品
		 */
		static public function UseNoSpliteMouse():void
		{
			SetCursor("nosplite");
		}

		/**
		 * 创建鼠标动画组
		 */
		static private function createMouseData(name:String, className:String, hotSpot:uint = LEFT_TOP):void
		{
			var cursorData:MouseCursorData = new MouseCursorData();
			var vecBitmap:Vector.<BitmapData> = new Vector.<BitmapData>();
			var cursorClass:Class;
			var cursorBitmap:BitmapData;
			var classFullName:String;
			var imgW:uint;
			var imgH:uint;
			
			// 创建鼠标动画组
			for (var i:uint=1; i<=10; ++i) {
				classFullName = className + "_" + i;
				cursorClass = getClass(classFullName);
				if (cursorClass == null) break;
				cursorBitmap = new cursorClass();
				vecBitmap.push(cursorBitmap);
				imgW = cursorBitmap.width;
				imgH = cursorBitmap.height;
			}
			
			if (vecBitmap.length == 0) {
				cursorData = null;
				vecBitmap = null;
				return;
			}
			
			cursorData.data = vecBitmap;
			
			if (hotSpot == LEFT_TOP) {
				cursorData.hotSpot = new Point(0,0)
			} else if (hotSpot == CENTER) {
				cursorData.hotSpot = new Point(imgW/2,imgH/2)
			}
			
			Mouse.registerCursor(name, cursorData)
		}
		
		static private function errorHandler(evt:IOErrorEvent):void
		{
			
		}
		
		static private function getClass(name:String):Class
		{
			if(m_domain == null)
				return null;
			
			var assetClass:* = null;
			try {
				assetClass = m_domain.getDefinition(name);	
			} catch(error:Error) {
				trace(error.message);
				return null;
			}
			
			return assetClass;
		}
		
	}
}