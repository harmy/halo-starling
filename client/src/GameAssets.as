package
{
	import core.anim.HaloMovieClip;
	
	import starling.extensions.ParticleDesignerPS;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * 测试数据
	 */
	
	public class GameAssets
	{
		[Embed(source='../assets/s_0_0.xml', mimeType='application/octet-stream')]
		private static const AtlasXML0_0:Class;
		[Embed(source='../assets/s_0_0.png')]
		private static const AtlasTexture0_0:Class;
		
		[Embed(source='../assets/s_0_1.xml', mimeType='application/octet-stream')]
		private static const AtlasXML0_1:Class;
		[Embed(source='../assets/s_0_1.png')]
		private static const AtlasTexture0_1:Class;
		
		[Embed(source='../assets/s_1_0.xml', mimeType='application/octet-stream')]
		private static const AtlasXML1_0:Class;
		[Embed(source='../assets/s_1_0.png')]
		private static const AtlasTexture1_0:Class;
		
		[Embed(source='../assets/s_1_1.xml', mimeType='application/octet-stream')]
		private static const AtlasXML1_1:Class;
		[Embed(source='../assets/s_1_1.png')]
		private static const AtlasTexture1_1:Class;
		
		[Embed(source='../assets/s_101_0.xml', mimeType='application/octet-stream')]
		private static const AtlasXML101_0:Class;
		[Embed(source='../assets/s_101_0.png')]
		private static const AtlasTexture101_0:Class;
		
		[Embed(source='../assets/s_101_1.xml', mimeType='application/octet-stream')]
		private static const AtlasXML101_1:Class;
		[Embed(source='../assets/s_101_1.png')]
		private static const AtlasTexture101_1:Class;
		
		// 粒子系统测试
		[Embed(source="../assets/particle/Particle.pex", mimeType="application/octet-stream")]
		private static const _particleConfig:Class;
		
		[Embed(source="../assets/particle/ParticleTexture.png")]
		private static const _particlePng:Class;
		
		
		private static var _atlasxmls:Vector.<Class> = new <Class>[AtlasXML0_0, AtlasXML0_1, AtlasXML1_0, AtlasXML1_1, AtlasXML101_0, AtlasXML101_1];
		private static var _atlastextures:Vector.<Class> = new <Class>[AtlasTexture0_0, AtlasTexture0_1, AtlasTexture1_0, AtlasTexture1_1, AtlasTexture101_0, AtlasTexture101_1];
		private static var _textures:Vector.<Vector.<Texture> > = new Vector.<Vector.<Texture> >();
		
		static public function initGameRes():void
		{
			for(var idx:int = 0; idx < 6; idx++)
			{
				var _textAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new _atlastextures[idx]()), XML(new _atlasxmls[idx]()));
				//_textures.push(_textAtlas.getTextures("attack_"+String(int(Math.random() * 8))));
				_textures.push(_textAtlas.getTextures("attack_"+0));
			}
		}
		
		static public function createChar():HaloMovieClip
		{
			var random_idx:int = Math.random() * 6;
			var textures:Vector.<Texture> = _textures[random_idx];
			var mc:HaloMovieClip = new HaloMovieClip(textures, 8);
			mc.smoothing = "none";
			mc.currentFrame = 0;
			//mc.x = Math.random() * 1280;
			//mc.y = Math.random() * 700;
			//mc.x = mc.y = 0;
			
			//addChild(mc);
			//Starling.juggler.add(mc);
			return mc;
		}
		
		static public function createParticle():ParticleSystem
		{
			// 创建粒子
			var psconfig:XML = new XML(new _particleConfig());
			var psTexture:Texture = Texture.fromBitmap(new _particlePng());
			var _particleSystem:ParticleDesignerPS = new ParticleDesignerPS(psconfig, psTexture);
			_particleSystem.start();
			//_particleSystem.x = Math.random() * 1280;
			//_particleSystem.y = Math.random() * 700;
			
			//addChild(_particleSystem);
			//Starling.juggler.add(_particleSystem);
			return _particleSystem;
		}
		
	}
}


