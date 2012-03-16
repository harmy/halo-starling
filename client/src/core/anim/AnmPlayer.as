package core.anim
{
	/*
		动画播放
	*/
	import Client.Define.GameDefine;
	
	import Lib.Texture.TbeFrameInfo;
	import Lib.Texture.TbeImageDict;
	import Lib.Texture.TbeImageLoader;
	import Lib.Texture.TexInstance;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	public class AnmPlayer
	{
		public static var FLANIMFPS:Number = 50;

		
		protected var m_vModel:Model;			//模型
		protected var m_vAnim:Animation;		//动画
		
		protected var m_iCurFrame:int;		//当前
		protected var m_iCurFrameDelay:int;	//当前延迟
		protected var m_iCurDir:int;			//当前方向
		protected var m_AnDelayFrame:Number;		//当前延迟
		
		protected var m_LayerTex:Array;
		protected var m_bReload:Boolean;
		protected var m_texDict:TbeImageDict;
		
		
		
		
		protected var m_bPlaying:Boolean;			//播放
		
		//public var m_nItemNo:Array = [1,1,1,1,1,0,0,0,0];
		public var m_nItemNo:Array = [-1,-1,-1,-1,-1,0,0,0,0];
		
		protected var m_AnimCB:Function;		//动画回调函数
		// function(int)
		
		
		protected var m_BoundBox:Rectangle=new Rectangle;
		
		public static var ENTER_FRAME:int = 0x1;
		public static var END_REACHED:int = 0x2;
		
		protected var SrcRc:Rectangle = new Rectangle;
		protected var Drc:Point= new Point;
		
		/**
		 * 绘制特效相关
		 */
		private var m_effectColor:ColorTransform;
		
		/**
		 * 换色区绘制优化
		 */
		private var m_matrix:Matrix = new Matrix;
		private var m_clpRc:Rectangle = new Rectangle;
		
		/**
		 * 冲撞动作的残影数量 
		 */
		private static var collideNum:int = 2;
		private static var offPos:Point = new Point;
			
		public function AnmPlayer(itexDict:TbeImageDict)
		{
			m_iCurDir = 0;
			m_iCurFrame = 0;		//当前
			m_iCurFrameDelay = 0;	//当前延迟
			m_iCurDir = 0;			//当前方向
			m_AnDelayFrame = 0;		//当前延迟
			
			m_bReload = false;
			m_LayerTex = [];
			
			m_texDict = itexDict;
			
			m_bPlaying = false;		//停止
			m_AnimCB = null;
			
			// 中毒+隐身效果
//			m_effectColor.alphaOffset = -100;
//			m_effectColor.redOffset = -255;
//			m_effectColor.blueOffset = -255;
		}
		
		public function setRenderEffect(colorTrans:ColorTransform):void
		{
			m_effectColor = colorTrans;
		}
		
		public function SetCallBack(cbFunc:Function):void
		{
			m_AnimCB = cbFunc;
		}
		
		public function Stop():void
		{
			m_bPlaying = false;
		}
		public function SetAnimation(iAnim:Animation):void
		{
			m_vAnim = iAnim;
			m_bPlaying = true;
		}
		
		public function SetModel(iModel:Model):void
		{
			m_vModel=iModel;
		}
		
		public function SetDir(nDir:int):void
		{
			m_iCurDir = nDir;
		}
		
		public function GetDir():int
		{
			return m_iCurDir;
		}
		
		public function GetBoundBox():Rectangle
		{
			return m_BoundBox;
		}
		
		public function SetCurFrame(iFrame:int,iLimit:int):int
		{
			if(iFrame > iLimit)
				iFrame = iLimit-1;
				
			if(iFrame<0)
				iFrame = 0;
				
			m_iCurFrame = iFrame;
			

			return m_iCurFrame;
		}
		
		public function ResetTime():void
		{
			m_AnDelayFrame =0;
			m_iCurFrame = -1;
			
		}
		
		public function GetMaxFrameTime():int
		{
			return m_vAnim.MaxFrameTime;
		}
		
		public function AddDeltaTime(deltaTime:Number):void
		{
			if(m_vAnim==null)
				return;
				
			if(m_vAnim.IsLoad==false)
				return;
				
			if(m_bPlaying==false)
				return;
				
			var fDeltaTime:Number = deltaTime * AnmPlayer.FLANIMFPS;
			
			if(m_AnDelayFrame<=0)
			{
				var m_AnCurFrame:int = m_iCurFrame;
				var nMaxFrame:int = m_vAnim.vSeqFrame[m_iCurDir].length;
				
//				while (m_iCurFrame < nMaxFrame) {
//					if (!IsEmptyFrame(m_iCurDir, m_iCurFrame+1)) {
//						break;
//					} 
//					
//					m_iCurFrame++;
//					// 如果下一帧是空帧，就直接跳过
//				}
					
				if(m_AnCurFrame>=nMaxFrame-1)
				{
					if(m_AnimCB!=null)
					{
						m_AnimCB(END_REACHED);
					}

					m_AnCurFrame = -1;
				}
				
				
				SetCurFrame(m_AnCurFrame+1 , nMaxFrame);
				
				if(m_vAnim.vSeqFrame==null)
					return;
					
				var pSeqFrame:AniSeqFrame = m_vAnim.vSeqFrame[m_iCurDir][m_iCurFrame];
				
				if(pSeqFrame)
				{
					m_AnDelayFrame = pSeqFrame.iDelayFrame + 1;
				}
				else
				{
					m_AnDelayFrame =0;
				}
			}
			else
			{
				m_AnDelayFrame -=fDeltaTime;
			}
		}
		
		public function GetFrameCount():int
		{
			if(m_vAnim==null)
				return 0;
				
			if(m_vAnim.IsLoad==false)
				return 0;
				
			if(m_iCurDir<0)
				return 0;
				
			return m_vAnim.vSeqFrame[m_iCurDir].length;
		}
		
		public function GetCurFrame():int
		{
			return m_iCurFrame;
		}
		
		public function Update(deltaTime:Number):void
		{
			AddDeltaTime(deltaTime);
			
			if(m_bReload == false)
			{
				
				var bLoadAnim:Boolean = false;
				var bLoadModel:Boolean = false;
			
				if(m_vAnim)
				{
					if(m_vAnim.IsLoad==true)
					{
						bLoadAnim =true;
					}
				}
			
				if(m_vModel)
				{
					if(m_vModel.IsLoad==true)
					{
						bLoadModel = true;
					}	
				}

				if(bLoadAnim && bLoadModel)
				{
					ReloadTexture();
				}
			}
		}
		
		public function GenerateTexName(iLayerID:int,iItemID:int,iImgID:int,pExt:String=null):String
		{
			var ret:String = "";
			ret+=int(iLayerID/10);
			ret+=iLayerID%10;
			//ret+="_";
			ret+=int(iItemID/1000) % 10;
			ret+=int(iItemID/100) % 10;
			ret+=int(iItemID/10) % 10;
			ret+=iItemID % 10;
			//ret+="_";
			ret+=int(iImgID/100) % 10;
			ret+=int(iImgID/10) % 10;
			ret+=iImgID % 10;
			if(pExt!=null)
				ret+=pExt;
			return ret;
		}
	
		public function PreloadAllTexture():void
		{
			//var pImageName:String = GenerateTexName(m_vModel.vLayers[i].iLayer, m_nItemNo[i] ,m_vAnim.vTexId[i]);
			//m_texDict.LoadImage( m_vModel.Name+"/texcom/"+pImageName );
		}
		
		public function ReloadTexture():void
		{
			m_LayerTex =null;
			if(m_vModel==null)
				return;
				
			if(m_vModel.IsLoad==false)
				return;
			
			if(m_vAnim==null)
				return;
				
			m_LayerTex = [];
			var forlen:int = m_vModel.vLayers.length;
			for(var i:int = 0 ; i < forlen; i++)
			{
				if(m_vAnim.vTexId==null)
					return;
				
				if (m_vModel.vLayers[i].iLayer != 0 && m_nItemNo[i] == 0)
					continue;

				var pImageName:String = GenerateTexName(m_vModel.vLayers[i].iLayer, m_nItemNo[i] ,m_vAnim.vTexId[i]);
				m_LayerTex[i] = m_texDict.LoadImage( m_vModel.Name+"/texcom/"+pImageName );
			}
			
			m_bReload = true;
		}
		
		public function GetLayerImage(nLayer:int):TbeImageLoader
		{
			return nLayer < m_LayerTex.length?m_LayerTex[nLayer]:null;
		}
		
		private function InitAnim():Boolean{
			if(m_vAnim==null)
				return false;
			
			if(m_vAnim.IsLoad==false)
				return false;
			
			if (this.m_iCurDir == -1){
				this.m_iCurDir = 4;
			}
			
			if (this.m_iCurDir > this.m_vAnim.vSeqFrame.length){
				this.m_iCurDir = 0;
			}
			
			if (this.m_vAnim.vSeqFrame[this.m_iCurDir].length == 0){
				return false;
			}
			
			if (this.m_iCurFrame >= this.m_vAnim.vSeqFrame[this.m_iCurDir].length){
				this.m_iCurFrame = (this.m_vAnim.vSeqFrame[this.m_iCurDir].length - 1);
			}
			
			if (this.m_iCurFrame < 0){
				this.m_iCurFrame = 0;
			}
			
			m_BoundBox.x=0xffff;
			m_BoundBox.y=0xffff;
			m_BoundBox.width=0;
			m_BoundBox.height=0;
			
			return true;
		}
		
		public function RenderCollide(target:BitmapData,cx:int,cy:int):void{
			if(!InitAnim())
				return;
			
			m_iCurFrame = m_vAnim.vSeqFrame[m_iCurDir].length - 2;
			var vFramePartList:AniSeqFrame = m_vAnim.vSeqFrame[m_iCurDir][m_iCurFrame];
			if(vFramePartList==null)
			{
				Render(target, cx, cy);
				return;
			}
			
			var genBoundBox:Boolean = true;
			var alpha:Array = [1, 0.8, 0.5];
			for(var i:int=0; i<=collideNum; i++)
			{
				RenderChar(target, cx, cy, vFramePartList, genBoundBox, alpha[i]);
				if(genBoundBox)
				{
					genBoundBox = false;
					GetCollideOffsetPos();
				}
				cx += offPos.x + i*3;
				cy += offPos.y + i*2;
			}
			
		}
		
		/**
		 * 由于图片问题，不同方向上需要偏移一定距离，
		 * 以免各个方向上的影子间距不一样
		 * 
		 */		
		private function GetCollideOffsetPos():void{
			switch(m_iCurDir)
			{
				case 0:
				{
					offPos.x = 0;
					offPos.y = m_BoundBox.height - 10;
					break;
				}
				case 1:
				{
					offPos.x = -m_BoundBox.width;
					offPos.y = m_BoundBox.height / 2;
					break;
				}
				case 2:
				{
					offPos.x = -m_BoundBox.width - 10;
					offPos.y = 0;
					break;
				}
				case 3:
				{
					offPos.x = -m_BoundBox.width + 10;
					offPos.y = -m_BoundBox.height / 2;
					break;
				}
				case 4:
				{
					offPos.x = 0;
					offPos.y = -m_BoundBox.height / 2 - 15;
					break;
				}
				case 5:
				{
					offPos.x = m_BoundBox.width;
					offPos.y = -m_BoundBox.height / 2 - 15;
					break;
				}
				case 6:
				{
					offPos.x = m_BoundBox.width;
					offPos.y = 0;
					break;
				}
				case 7:
				{
					offPos.x = m_BoundBox.width - 10;
					offPos.y = m_BoundBox.height / 2;
					break;
				}
			}
		}
		
		private function RenderChar(target:BitmapData,cx:int,cy:int, vFramePartList:AniSeqFrame, genBoundBox:Boolean, alpha:Number):void{
			//将透明度换算成16进制的字符
			var alphaValue:int =alpha*255;
//			var alphaStr:String = alphaValue.toString(16);
//			alphaStr = "0x"+alphaStr+"000000";
			
			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				if(pSurface == null)
					continue;
				if(pSurface.IsLoad==false)
					continue;
				
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = m_vModel.vLayers[vFramePartList.iLayer[i]];
				if(info==null)
					continue;
				
				SrcRc.x = info.x;
				SrcRc.y = info.y;
				SrcRc.width = info.width;
				SrcRc.height = info.height;
				
				Drc.x=vFramePartList.iPosX[i] - (Lay.iTexW >>1) + cx + info.iOffsetX;
				Drc.y=vFramePartList.iPosY[i] - (Lay.iTexH >>1) + cy + info.iOffsetY;
				
				var layNo:int = Lay.iLayer;
				if(pSurface.Img.GetBitmapData()) {
					var colorTrans:ColorTransform;
					var colorTransTemp:ColorTransform = new ColorTransform;
					if(layNo == 3) continue;
					m_matrix.identity();
					m_matrix.tx = (-(SrcRc.x) + Drc.x);
					m_matrix.ty = (-(SrcRc.y) + Drc.y);
					m_clpRc.x = Drc.x;
					m_clpRc.y = Drc.y;
					m_clpRc.width = SrcRc.width;
					m_clpRc.height = SrcRc.height;
					if (layNo == 1 || layNo == 2) {
						// 头发和衣服设置颜色调制
						if (layNo == 1) {
							colorTrans = GameDefine.COLOR_TABLE.GetHairColor(5);
						} else if (layNo == 2) {
							colorTrans = GameDefine.COLOR_TABLE.GetBodyColor(0, 5);
						}
						colorTransTemp.alphaMultiplier = colorTrans.alphaMultiplier;// * alpha;
						colorTransTemp.redMultiplier = colorTrans.redMultiplier;
						colorTransTemp.greenMultiplier = colorTrans.greenMultiplier;
						colorTransTemp.blueMultiplier = colorTrans.blueMultiplier; 
					} 
					var alphaOffset:Number = 255 - alphaValue;	// 设置透明度偏移值
					colorTransTemp.alphaOffset = -alphaOffset;
					if (m_effectColor != null) {
						// 使用特效绘制
						colorTransTemp.redOffset = m_effectColor.redOffset;
						colorTransTemp.greenOffset = m_effectColor.greenOffset;
						colorTransTemp.blueOffset = m_effectColor.blueOffset;
						colorTransTemp.alphaOffset = m_effectColor.alphaOffset - alphaOffset;
					}
					target.draw(pSurface.Img.GetBitmapData(), m_matrix, colorTransTemp, BlendMode.NORMAL, m_clpRc, false);
				}
				
				if(genBoundBox)
				{
					m_BoundBox.x 		= Math.min(m_BoundBox.x,Drc.x);
					m_BoundBox.y 		= Math.min(m_BoundBox.y,Drc.y);	
					m_BoundBox.right	= Math.max(m_BoundBox.right,Drc.x+SrcRc.width);
					m_BoundBox.bottom	= Math.max(m_BoundBox.bottom,Drc.y+SrcRc.height);
				}
			}
		}
		
		// 判断贴图是否已加载完成
		public function IsTextureLoaded():Boolean
		{
			var pSurface:TbeImageLoader = GetLayerImage(0);
			if (pSurface == null)
				return false;
			if (pSurface.Img == null)
				return false;
			if (pSurface.Img.GetBitmapData() == null)
				return false;
			
			return true;
		}
		
		
		// 是否是空的帧
		public function IsEmptyFrame(dir:uint, frame:uint):Boolean
		{
			if(!InitAnim())
				return true;
			
			var isEmpty:Boolean = true;			
			var vFramePartList:AniSeqFrame = m_vAnim.vSeqFrame[dir][frame];
			if (vFramePartList == null) return true;
			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				
				if(pSurface == null)
					continue;
				
				if(pSurface.IsLoad==false)
					continue;
				
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = m_vModel.vLayers[vFramePartList.iLayer[i]];
				
				if(info==null)
					continue;
				
				if (info.width > 1 && info.height > 1)
					isEmpty = false;
			}
			
			return isEmpty;
		}
		
		
		static private var colorTransTemp:ColorTransform = new ColorTransform;
		
		public function Render(target:BitmapData,cx:int,cy:int):void
		{
			if(!InitAnim())
				return;
		
			var vFramePartList:AniSeqFrame = m_vAnim.vSeqFrame[m_iCurDir][m_iCurFrame];

			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				
				if(pSurface == null)
					continue;
					
				if(pSurface.IsLoad==false)
					continue;
		
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = m_vModel.vLayers[vFramePartList.iLayer[i]];
				
				if(info==null)
					continue;
				
				SrcRc.x = info.x;
				SrcRc.y = info.y;
				SrcRc.width = info.width;
				SrcRc.height = info.height;
				
				Drc.x=vFramePartList.iPosX[i] - (Lay.iTexW >>1) + cx + info.iOffsetX;
				Drc.y=vFramePartList.iPosY[i] - (Lay.iTexH >>1) + cy + info.iOffsetY;

				var layNo:int = Lay.iLayer;
				
				if(pSurface.Img && pSurface.Img.GetBitmapData()) {
					m_matrix.identity();
					m_matrix.tx = (-(SrcRc.x) + Drc.x);
					m_matrix.ty = (-(SrcRc.y) + Drc.y);
					m_clpRc.x = Drc.x;
					m_clpRc.y = Drc.y;
					m_clpRc.width = SrcRc.width;
					m_clpRc.height = SrcRc.height;
					var useDraw:Boolean = false;
					var colorTrans:ColorTransform;
					// 初始化数据
					colorTransTemp.redMultiplier = 1;
					colorTransTemp.greenMultiplier = 1;
					colorTransTemp.blueMultiplier = 1;
					colorTransTemp.alphaMultiplier = 1;
					colorTransTemp.redOffset = 0;
					colorTransTemp.greenOffset = 0;
					colorTransTemp.blueOffset = 0;
					colorTransTemp.alphaOffset = 0;
					if (layNo == 1 || layNo == 2) {
						// 头发和衣服设置颜色调制
						if (layNo == 1) {
							colorTrans = GameDefine.COLOR_TABLE.GetHairColor(5);
						} else if (layNo == 2) {
							colorTrans = GameDefine.COLOR_TABLE.GetBodyColor(0, 5);
						}
						colorTransTemp.redMultiplier = colorTrans.redMultiplier;
						colorTransTemp.greenMultiplier = colorTrans.greenMultiplier;
						colorTransTemp.blueMultiplier = colorTrans.blueMultiplier; 
						useDraw = true;
					}
					if (m_effectColor != null) {
						// 使用特效绘制
						colorTransTemp.redOffset = m_effectColor.redOffset;
						colorTransTemp.greenOffset = m_effectColor.greenOffset;
						colorTransTemp.blueOffset = m_effectColor.blueOffset;
						colorTransTemp.alphaOffset = m_effectColor.alphaOffset;
						useDraw = true;
					}
					
					if (useDraw) {
						target.draw(pSurface.Img.GetBitmapData(), m_matrix, colorTransTemp, BlendMode.NORMAL, m_clpRc, false);	
					} else {
						target.copyPixels(pSurface.Img.GetBitmapData(), SrcRc, Drc, null, null, true);
					}
				}
				
				m_BoundBox.x 		= Math.min(m_BoundBox.x,Drc.x);
				m_BoundBox.y 		= Math.min(m_BoundBox.y,Drc.y);	
				m_BoundBox.right	= Math.max(m_BoundBox.right,Drc.x+SrcRc.width);
				m_BoundBox.bottom	= Math.max(m_BoundBox.bottom,Drc.y+SrcRc.height);
			}
		}
		
		public function GetClipRect(outrc:Rectangle,pSurface:TexInstance,nClipW:int,nClipH:int,inno:int):void
		{
			var nx:int = pSurface.GetBitmapData().width  / nClipW;
			var ny:int = pSurface.GetBitmapData().height / nClipH;
			
			var cx:int = inno % nx;
			var cy:int = inno / nx % ny;

			outrc.left=cx * nClipW;
			outrc.top=cy * nClipH;

			outrc.right=outrc.left + nClipW;
			outrc.bottom = outrc.top + nClipH;
		}

		public function MouseIntersect2(rx:int,ry:int,cx:int,cy:int):Boolean
		{
			if (m_vAnim.vSeqFrame == null) return false;
			
			var vFramePartList:AniSeqFrame = m_vAnim.vSeqFrame[m_iCurDir][m_iCurFrame];
			if(vFramePartList==null)
				return false;
			
			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				
				if(pSurface == null)
					continue;
				
				if(pSurface.IsLoad==false)
					continue;
				
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = m_vModel.vLayers[vFramePartList.iLayer[i]];
				
				if(info==null)
					continue;
				
				SrcRc.x = info.x;
				SrcRc.y = info.y;
				SrcRc.width = info.width;
				SrcRc.height = info.height;
				
				Drc.x=vFramePartList.iPosX[i] - (Lay.iTexW >>1) + cx + info.iOffsetX;
				Drc.y=vFramePartList.iPosY[i] - (Lay.iTexH >>1) + cy + info.iOffsetY;
				
				var layNo:int = Lay.iLayer;
				
				var bmd:BitmapData =pSurface.Img.GetBitmapData();
				if(bmd ==null) continue;
				var tu:int = rx - Drc.x + SrcRc.x;
				var tv:int = ry - Drc.y + SrcRc.y;
				var pixelValue:uint = bmd.getPixel32(tu,tv);
				var alphaValue:uint = pixelValue >> 24 & 0xFF;
				
				if(alphaValue!=0)
					return true;
			}
			
			return false;
		}
		
		public function MouseIntersect(rx:int,ry:int):Boolean
		{
			if(m_vAnim==null)
				return false;
				
			if(m_vAnim.IsLoad==false)
				return false;
			
			if(m_iCurDir==-1)
				m_iCurDir=4;
			
			if(m_iCurFrame >= m_vAnim.vSeqFrame[m_iCurDir].length || m_iCurFrame < 0)
				return false;

			var vFramePartList:AniSeqFrame = m_vAnim.vSeqFrame[m_iCurDir][m_iCurFrame];

			var forlen:int = vFramePartList.nLen;
			for(var i:int=0; i < forlen ; i+=1 )
			{
				var pSurface:TbeImageLoader = GetLayerImage(vFramePartList.iLayer[i]);
				
				if(pSurface == null)
					continue;
					
				if(pSurface.IsLoad==false)
					continue;
		
				var info:TbeFrameInfo = pSurface.GetInfo(vFramePartList.iResource[i]);
				var Lay:AniLayer = m_vModel.vLayers[vFramePartList.iLayer[i]];
				
				if(info==null)
					continue;
					
				SrcRc.x = info.x;
				SrcRc.y = info.y;
				SrcRc.width = info.width;
				SrcRc.height = info.height;

				Drc.x=vFramePartList.iPosX[i] - (Lay.iTexW >>1) + info.iOffsetX;
				Drc.y=vFramePartList.iPosY[i] - (Lay.iTexH >>1) + info.iOffsetY;

				var bmd:BitmapData =pSurface.Img.GetBitmapData();
				
				if(bmd ==null)
					continue;
				
				var tu:int = rx - Drc.x + SrcRc.x;
				var tv:int = ry - Drc.y + SrcRc.y;
				
				if(SrcRc.width < rx)
					continue;
				
				if(SrcRc.height < ry)
					continue;
				
				var pixelValue:uint = bmd.getPixel32(tu,tv);
				var alphaValue:uint = pixelValue >> 24 & 0xFF;
				
				if(alphaValue!=0)
					return true;

			}
			
			
			return false;
		}
	}
	
	
}
