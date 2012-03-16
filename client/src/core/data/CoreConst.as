package core.data
{
	import flash.filters.GlowFilter;

	/**
	 * 核心库用到的全局常量
	 */
	public class CoreConst
	{
		/**
		 * 地图文件的加载优先级别
		 */
		static public const PRIORITY_MAP:uint = 1; 
		
		/**
		 * 黑色描边
		 */
		static public const GLOW_FILTER1:GlowFilter = new GlowFilter(0x111111, 1, 3, 3, 16);
	}
}