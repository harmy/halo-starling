package game.magic
{
	import halo.display.MovieClip;
	import halo.display.Image;
	import core.terrain.layers.Layer;	
	import game.GameMain;	
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
		private var magicArr:Array = new Array;
		
		public static function instance():MagicMgr
		{
			if(_instance == null)
			{
				_instance = new MagicMgr;
			}
			
			return _instance;
		}		
		
		public function init():void
		{
			test_magic();
		}
		
		public function test_magic():void
		{
			var jiguang_atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new jiguang_png), XML(new jiguang_xml));
			var jiguang_2:Vector.<Texture> = jiguang_atlas.getTextures("jiguang2");
			var magiclayer:Layer = GameMain.instace().map.getLayer("magic_before");
			var movie_player:MovieClip = new MovieClip(jiguang_2, 10);
			movie_player.scaleX = 2;
			movie_player.scaleY = 2;
			movie_player.blendMode = "add";
			magiclayer.addChild(movie_player);		
			Starling.juggler.add(movie_player);	
			magicArr.push(movie_player);
		}
	
		public function update():void
		{
			for each(var magicUnit:MovieClip in magicArr)
			{
				magicUnit.x = GameMain.instace().camera.traceObject.x;
				magicUnit.y = GameMain.instace().camera.traceObject.y;
			}			
		}		
	}
}

