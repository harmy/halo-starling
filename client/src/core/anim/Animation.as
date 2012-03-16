package core.anim
{	
	import core.resmgr.ResMgr;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import net.manaca.loaderqueue.LoaderQueueEvent;
	
	public class Animation	extends EventDispatcher
	{		
		public var mSeqFrame:Array;		//帧
		public var mName:String;			//动作名称
		public var mTexId:Array;			//动作编号
		public var mIsLoad:Boolean;
		public var mMaxFrameTime:uint;
		public var mFullPath:String;

		function Animation(Root:String, fn:String)
		{
			mIsLoad = false;
			mName = fn;
			mMaxFrameTime = 0;
			
			
			//LoadBin(Root,fn);
			loadXml(Root,fn);
		}
		
		//LoadXml
		private function loadXml(Root:String,fn:String):void
		{
			mFullPath = Root + fn + ".xml";
			ResMgr.loadByURLLoader(mFullPath, onLoadXmlFinish);
			
//			var request:URLRequest = LibSetting.CreateRequestHeader(mFullPath);
//			loader = new URLLoader;
//			loader.addEventListener(Event.COMPLETE, onLoadXmlFinish);
//			loader.addEventListener(IOErrorEvent.IO_ERROR, onMissingXmlFile);
//			loader.load(request);
		}
		
//		private function disposeXml():void
//		{
//			loader.removeEventListener(Event.COMPLETE, onLoadXmlFinish);
//			loader.removeEventListener(IOErrorEvent.IO_ERROR, onMissingXmlFile);
//			loader = null;
//		}
		
//		private function onMissingXmlFile(evt:IOErrorEvent):void
//		{
//			trace(evt.text);
//			disposeXml();
//			dispatchEvent(new Event(Event.COMPLETE));
//		}
		
		//private function onLoadXmlFinish(evt:Event):void
		private function onLoadXmlFinish(event:LoaderQueueEvent):void
		{
			var xmldata:XML = new XML(event.target.data);
			var texLayerList:XMLList = xmldata.Texture.Layer;
			mTexId=[];
			
			for each(var tlidx:XML in texLayerList) {
				mTexId.push(tlidx.@TexID);
			}
			
			
			var AnmList:XMLList = xmldata.Animation;
//			trace(AnmList.length());
			
			mSeqFrame=[];
			var nLen:int = AnmList.length();
			var aidx:int = 0;
			while( aidx < nLen) {
				mSeqFrame[aidx]=[];
				
				var Frmlist:XMLList = xmldata.Animation[aidx].Frame;
				var DelayFrm:int = Frmlist.@DelayFrame;
				
				for each(var fidx:XML in Frmlist) 	{
					var AniSeqFrm:AniSeqFrame = new AniSeqFrame;
					AniSeqFrm.mDelayFrame = fidx.@DelayFrame;
					var FrmClplist:XMLList = fidx.Part;
					
					for each(var fcidx:XML in FrmClplist) 	{
						AniSeqFrm.append(fcidx.@Layers,	fcidx.@Resource,fcidx.@PosX,fcidx.@PosY);
					}

					mSeqFrame[aidx].push(AniSeqFrm);
				}
				aidx++;
			}
			
			//disposeXml();
			
			mIsLoad=true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		/*
		public function LoadBin(Root:String,fn:String):void
		{
			if (fn == null || fn == "null")
				return;
			
			fullpath = Root + fn + ".abc";
			//trace("加载动作文件：" + fullpath);
			fullpath = FileVersion.getFileName(fullpath);
			var request:URLRequest = new URLRequest(fullpath);
			loader = new URLLoader;
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onLoadBinFinish);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onMissingBinFile);
			loader.load(request);
		}
		
		private function disposeBin():void
		{
			loader.removeEventListener(Event.COMPLETE, onLoadBinFinish);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onMissingBinFile);
			loader = null;
		}
		
		private function onMissingBinFile(evt:IOErrorEvent):void
		{
		trace(evt.text);
		disposeBin();
		dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onLoadBinFinish(evt:Event):void
		{
			var content:ByteArray = evt.target.data as ByteArray;
			content.endian=Endian.LITTLE_ENDIAN;
			content.uncompress();
			
			var texlcnt:int = content.readByte();
			vTexId=[];
			var i:int = 0;
			while( i < texlcnt)
			{
				var tid:int = content.readShort();
				vTexId.push(tid);
				i++;
			}
			
			var nDirCnt:int = content.readByte();
			var nlayCnt:int = content.readByte();

			vSeqFrame=[];
			var di:int =0;
			while( di<nDirCnt)
			{
				var frmCnt:int = content.readByte();	//总帧数
				vSeqFrame[di]=[];

				MaxFrameTime=0;
				var fi:int =0;
				while( fi < frmCnt)
				{
					var AniSeqFrm:AniSeqFrame = new AniSeqFrame;
					vSeqFrame[di][fi] = AniSeqFrm;
					AniSeqFrm.iDelayFrame = content.readByte();
					MaxFrameTime+=AniSeqFrm.iDelayFrame+1;
					
					var ly:int=0 ;
					while( ly < nlayCnt)
					{
						var ilay:int = content.readByte();
						var iRes:int = content.readByte();
						var iX:int = content.readByte();
						var iY:int = content.readByte();
						
						//AniSeqFrm.vFramePart.push(new AnimFramePart( ilay, iRes ,iX,iY ));
						AniSeqFrm.Append( ilay, iRes ,iX,iY );
						
						ly++;
					}
					fi++;
				}
				di++;
			}
			
			disposeBin();
			
			IsLoad=true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		*/
		
	}
}