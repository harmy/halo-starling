package core.pathfinder
{
	import flash.geom.Point;
	
	public class MapBlockModel extends MapModel
	{
		private var m_GetMapDataFunc:Function = null;
		
		public function MapBlockModel(map:Array=null)
		{
			super(map);
		}
		
		public function setMapDataFunc(mapdata:Function):void
		{
			m_GetMapDataFunc = mapdata;
		}
		
		protected override function isBlock(v:Point,cur:Point):Boolean
		{
			return m_GetMapDataFunc(v.x, v.y) == false;
		}
	}
}