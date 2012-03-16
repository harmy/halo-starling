package core.anim
{	
	import core.resmgr.ResMgr;
	import net.manaca.loaderqueue.LoaderQueueEvent;

	/**
	 * 一个角色用到的模型
	 * 模型有一个名称
	 * 一个模型会包含很多个部件，比如衣服，武器，盾，等。这个就是mLayers
	 */
	public class Model
	{
		public var mName:String;
		public var mLayers:Vector.<AniLayer> = new Vector.<AniLayer>();
		public var mIsLoad:Boolean = false;
		
		function Model(name:String, url:String)
		{
			mName = name;
			ResMgr.loadByURLLoader(url, onComplete);
		}
		
		private function onComplete(event:LoaderQueueEvent):void
		{
			mLayers.length = 0;
	
			var xmldata:XMLList = new XMLList(event.target.data);
			var lay:XMLList = xmldata.Layer;
			for each( var lid:XML in lay) 	{
				mLayers.push(new AniLayer(lid.@ID,lid.@Name,lid.@TexW,lid.@TexH));
			}
			
			mIsLoad = true;
		}
		
	}
	
	
}