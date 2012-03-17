package game.magic
{
	/*
	魔法配置说明 (暂时备注在这里)
	1.魔法层: 人前 人后
	2.释放位置: 自身 飞行 目标
	3.结束判断: 播放完 持续一段时间 持续到收到指令 飞行到目标点 飞行出屏幕
	4.声音
	5.选项：是否跟随飞行 播放到最后一帧时保持 飞行速度 动画速度 offx offy 持续时间 放大倍数 blend
	*/
	
	public final class MagicUnit
	{
		private var _id:uint				= 0;		//唯一id		
		private var _layer:uint			= 0;		//0人前，1人后
		private var _type:uint				= 0;		//0自身，1飞行，2目标
		private var _end:uint				= 0;		//0播放完，1持续一段时间，2持续至收到指令，3飞行至目标，4飞出屏幕
		private var _sound:uint			= 0;		//声音暂不实现
		private var _opt:uint				= 0;		//其他选项
		
		public function MagicUnit()
		{
		}
	}
}