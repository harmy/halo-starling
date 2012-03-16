package core.anim
{
	/**
	 * 一个角色的某一层的数据
	 */
	public class AniLayer
	{
		public var mLayer:int;			//层序号
		public var mName:String;		//层的名称
		public var mTexEff:int;		//贴图特效
		public var mTexW:int;			//原始贴图宽
		public var mTexH:int;			//原始贴图高
		
		function AniLayer(layer:int, name:String, texW:int, texH:int)
		{
			mLayer = layer;
			mName = name;
			mTexW  = texW;
			mTexH  = texH;
		}
	}
	
	
}