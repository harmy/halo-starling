package core.resmgr
{
	import flash.display.Stage;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import net.manaca.loaderqueue.LoaderQueue;
	import net.manaca.loaderqueue.LoaderQueueEvent;
	import net.manaca.loaderqueue.adapter.LoaderAdapter;
	import net.manaca.loaderqueue.adapter.URLLoaderAdapter;
	import net.manaca.loaderqueue.inspector.LoaderInspector;

	/**
	 * 游戏资源管理器
	 */
	public class ResMgr
	{
		static private var mLoaderQueue:LoaderQueue;
		static private var loaderInspector:LoaderInspector;
		
		public function ResMgr()
		{
		}
		
		static public function addInspector(stage:Stage):void
		{
			//实例化LoaderInspector，并添加到舞台
			loaderInspector = new LoaderInspector();
			loaderInspector.loaderQueue = mLoaderQueue;
			stage.addChild(loaderInspector);
		}
		
		static public function init(threadLimit:uint = 2, delay:int = 100, jumpQueueIfCached:Boolean = true):void
		{
			mLoaderQueue = new LoaderQueue(threadLimit, delay, jumpQueueIfCached);
		}
		
		/**
		 * 加载二进制文件或xml等
		 * 完成回调函数的格式:
		 * completeCB(event:LoaderQueueEvent):void
		 */
		static public function loadByURLLoader(url:String, completeCB:Function = null, priority:uint = 10, loaderContext:LoaderContext=null):void
		{
			if (mLoaderQueue == null) {
				init();
			}
			
			//使用URLLoader
			var loaderItem:URLLoaderAdapter = new URLLoaderAdapter(priority, new URLRequest(url));
			loaderItem.addEventListener(LoaderQueueEvent.TASK_COMPLETED, completeCB);
			mLoaderQueue.addItem(loaderItem);
		}
		
		/**
		 * 加载swf文件或图片
		 * 完成回调函数的格式:
		 * completeCB(event:LoaderQueueEvent):void
		 */
		static public function loadByLoader(url:String, completeCB:Function = null, priority:uint = 10, loaderContext:LoaderContext=null):void
		{
			if (mLoaderQueue == null) {
				init();
			}
			
			//使用Loader
			var loaderItem:LoaderAdapter = new LoaderAdapter(priority, new URLRequest(url));
			loaderItem.addEventListener(LoaderQueueEvent.TASK_COMPLETED, completeCB);
			mLoaderQueue.addItem(loaderItem);
		}
		
	}
}