package core.anim
{	
//	import Lib.LibSetting;
//	import Lib.Texture.TbeImageDict;
//	import Lib.Texture.TexDict;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	// 动画管理器
	// 
	public class AnimMgr 
	{	
		private var mAniPath:String;
		private var mModelPath:String;
		private var mModelDict:Dictionary;		//专门管理模型(Model)
		private var mAnimDict:Dictionary;		//专门管理动画(Animation)
		//private var mTbeDict:TbeImageDict;		//贴图
		
		public function AnimMgr(aniPath:String, modelPath:String)
		{
			mAniPath = aniPath;
			mModelPath = modelPath;
			
			mModelDict = new Dictionary;
			mAnimDict = new Dictionary;		//专门管理动画
			//mTbeDict  = new TbeImageDict(LibSetting.CHAR_PATH);
		}
		
//		public function GetTbeMgr():TbeImageDict
//		{
//			return mTbeDict;
//		}
//		
//		public function dispose():void
//		{
//			mTbeDict.dispose();
//		}
		
		public function getModel(name:String):Model
		{
			var model:Model;
			if (mModelDict[name] == null) {
				var url:String = mModelPath + name + ".xml";
				mModelDict[name] = new Model( name, url );
			}
			
			return mModelDict[name];
		}
	
		
		public function getAnim(name:String,onLoadFinishCB:Function = null):Animation
		{
			if (name == null) return null;
			
			name = name.toLocaleLowerCase();
			if(	mAnimDict[name]==null ) {
				mAnimDict[name] = new Animation(mAniPath, name);
				if (onLoadFinishCB != null) {
					mAnimDict[name].addEventListener(Event.COMPLETE,onLoadFinishCB);
				}
				return mAnimDict[name];
			}
			
			if(onLoadFinishCB!=null)
				onLoadFinishCB(new Event(Event.COMPLETE));
				
			return mAnimDict[name];
		}
		
		
		
	}
	
	
}