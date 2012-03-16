package core.anim
{	
	public class AniSeqFrame
	{
		public var mLayer:Array;		//层号			(范围 0~255)
		public var mResource:Array;	//源图片ID		(范围 0~255)
		public var mPosX:Array;		//位置X			(范围 -128~127)
		public var mPosY:Array;		//位置Y			(范围 -128~127)
		
		
		public var mDelayFrame:int;
		public var mLen:int;
		
		public function AniSeqFrame()
		{
			mLayer		=	[];		//层号			(范围 0~255)
			mResource	=	[];		//源图片ID		(范围 0~255)
			mPosX		=	[];		//位置X			(范围 -128~127)
			mPosY		=	[];		//位置Y			(范围 -128~127)
		
			
			mDelayFrame = 1;
			
			mLen		=	0;
		}
			
		public function clear():void
		{
			mLayer.length = 0;
			mResource.length = 0;
			mPosX.length = 0;
			mPosY.length = 0;
			mLen		=	0;
		}
		
		public function append(layer:int,resource:int,posX:int,posY:int):void
		{
			mLayer.push(layer);
			mResource.push(resource);
			mPosX.push(posX);
			mPosY.push(posY);
			mLen++;
		}
	}
}