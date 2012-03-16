package core.terrain.layers
{
	import halo.display.MovieClip;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.extensions.ParticleDesignerPS;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * 排序层 - 角色、物件、魔法和特效，位于此层，这层对象需要根据Y轴进行排序
	 */
	public class SortLayer extends Layer
	{
		public function SortLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
		}
	
		override public function update(elapse:uint):void
		{
			super.update(elapse);
			
			sortChildren(compare);
		}
		
	}
}