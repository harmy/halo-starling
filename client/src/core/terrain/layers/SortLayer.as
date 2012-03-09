package core.terrain.layers
{
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * 排序层 - 角色、物件、魔法和特效，位于此层，这层对象需要根据Y轴进行排序
	 */
	public class SortLayer extends Layer
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
		
		private var _mcs:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var _atlasxmls:Vector.<Class> = new <Class>[AtlasXML0_0, AtlasXML0_1, AtlasXML1_0, AtlasXML1_1, AtlasXML101_0, AtlasXML101_1];
		private var _atlastextures:Vector.<Class> = new <Class>[AtlasTexture0_0, AtlasTexture0_1, AtlasTexture1_0, AtlasTexture1_1, AtlasTexture101_0, AtlasTexture101_1];
		private var _textures:Vector.<Vector.<Texture> > = new Vector.<Vector.<Texture> >();
		
		public var m_localPlayer:MovieClip;
		
		
		public function SortLayer(name:String, width:uint, height:uint)
		{
			//TODO: implement function
			super(name, width, height);
			
			for(var idx:int = 0; idx < 6; idx++)
			{
				var _textAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new _atlastextures[idx]()), XML(new _atlasxmls[idx]()));
				//_textures.push(_textAtlas.getTextures("attack_"+String(int(Math.random() * 8))));
				_textures.push(_textAtlas.getTextures("attack_"+0));
			}
			
			// 创建主角
			m_localPlayer = createChar();
			m_localPlayer.color = 0x00FF00;
			
			// 创建其他对象
			for (var i:int = 0; i < 1 * 200; i++) {
				createChar();
			}
			
			
		}
		
		public function createChar():MovieClip
		{
			var random_idx:int = Math.random() * 6;
			var textures:Vector.<Texture> = _textures[random_idx];
			var mc:MovieClip = new MovieClip(textures, 8);
			mc.smoothing = "none";
			mc.currentFrame = 0;
			mc.pivotX = 220;
			mc.pivotY = 180;
			mc.x = Math.random() * 1280;
			mc.y = Math.random() * 700;
			addChild(mc);
			Starling.juggler.add(mc);
			
			return mc;
		}
		
		override public function update(elapse:uint):void
		{
			sortChildren(compare);
		}
		
		private function compare(paraA:DisplayObject,paraB:DisplayObject):int
		{
			var resultA:int = paraA.y
			var resultB:int = paraB.y;
			if(resultA > resultB) return 1;
			if(resultA < resultB) return -1;
			return 0;
		}
		
	}
}