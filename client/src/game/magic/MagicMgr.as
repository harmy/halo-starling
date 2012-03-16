package game.magic
{
	import core.anim.HaloMovieClip;
	import core.terrain.layers.Layer;
	
	import game.GameMain;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.extensions.ParticleDesignerPS;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public final class MagicMgr
	{		
		private static var _instance:MagicMgr;
		
		[Embed(source='../assets/magic/jiguang.xml', mimeType='application/octet-stream')]
		private static const jiguang_xml:Class;
		
		[Embed(source='../assets/magic/jiguang.png')]
		private static const jiguang_png:Class;
		
		[Embed(source='../assets/magic/xiaohuoqiu.xml', mimeType='application/octet-stream')]
		private static const xiaohuoqiu_xml:Class;
		
		[Embed(source='../assets/magic/xiaohuoqiu.png')]
		private static const xiaohuoqiu_png:Class;
		
		public static function instance():MagicMgr
		{
			if(_instance == null)
			{
				_instance = new MagicMgr;
			}
			
			return _instance;
		}		
		
		public function test_magic():void
		{
			var jiguang_atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new jiguang_png), XML(new jiguang_xml));
			var jiguang_2:Vector.<Texture> = jiguang_atlas.getTextures("jiguang2");
			var player:MovieClip = new HaloMovieClip(jiguang_2, 10);
			var magiclayer:Layer = GameMain.instace().map.getLayer("magic_before");
			magiclayer.addChild(player);
			Starling.juggler.add(player);			
		}
	
		public function update():void
		{
			
		}		
	}
}

