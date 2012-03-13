package game {
	
	//import starling.core.ObjectStats;
	import core.camera.Camera;
	import core.world.World;
	
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	/**
	 * @author hiko
	 */
	public class GameMain extends World {
		
		
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
		public function GameMain() {
			super();
			
			/*
			//flatten();
			for(var idx:int = 0; idx < 6; idx++)
			{
				var _textAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new _atlastextures[idx]()), XML(new _atlasxmls[idx]()));
				//_textures.push(_textAtlas.getTextures("attack_"+String(int(Math.random() * 8))));
				_textures.push(_textAtlas.getTextures("attack_"+0));
			}
			
			for (var i:int = 0; i < 3 * 200; i++) {
				var random_idx:int = Math.random() * 6;
				var textures:Vector.<Texture> = _textures[random_idx];
				var mc:MovieClip = new MovieClip(textures, 8);
				mc.smoothing = "none";
				mc.currentFrame = 0;//Math.random() * 6;
				mc.pivotX = 220;
				mc.pivotY = 180;
				//mc.pivotX = mc.pivotY = 0;
				mc.x = Math.random() * 1280;
				mc.y = Math.random() * 700;
				//mc.x = mc.y = 0;
				addChild(mc);
				//Starling.juggler.add(mc);
				//_mcs.push(mc);
			}
			*/
			
			//sortChildren(compare);
			
			//addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

			this.start();
			this.map.setMapPath("../assets/maps/");
			this.map.load("map.tmx");
			
			onResize(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			
			Starling.current.stage.addEventListener(Event.RESIZE, onResizeEvent);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onResizeEvent(evt:Event):void
		{
			onResize(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
//			var starl:Starling = Starling.current;
//			camera.viewRect = new Rectangle(0, 0, starl.stage.stageWidth, starl.stage.stageHeight);
//			//camera.traceRect = new Rectangle(0, 0, 1536, 1152);
//			camera.traceRect = new Rectangle(0, 0, 8064, 4480);
		}
		
		public function onKeyDown(evt:KeyboardEvent):void
		{
			var STEP:Number = 20;
			if (evt.keyCode == Keyboard.LEFT) {
				camera.traceObject.x -= STEP;
			} else if (evt.keyCode == Keyboard.RIGHT) {
				camera.traceObject.x += STEP;
			} else if (evt.keyCode == Keyboard.UP) {
				camera.traceObject.y -= STEP;
			} else if (evt.keyCode == Keyboard.DOWN) {
				camera.traceObject.y += STEP;
			} else if (evt.keyCode == Keyboard.SPACE) {
				camera.shake(Camera.SHAKE_Y, 6, 700, 100);
			}
		}
		
		private function compare(paraA:DisplayObject,paraB:DisplayObject):int
		{
			//if ( paraA as GameMap || paraB as GameMap ) return 0;
			
			var resultA:int = paraA.y
			var resultB:int = paraB.y;
			if(resultA > resultB) return 1;
			if(resultA < resultB) return -1;
			return 0;
		}
		
		override protected function update(elapse:uint):void
		{
			super.update(elapse);
			
			//trace("进入循环: " + elapse);
			
			// TODO Auto Generated method stub
			//if (exp01.stats) exp01.stats.driverInfo = exp01._starling.context.driverInfo;
			//var draws:uint = ObjectStats.drawNum;
			//var tris:uint = ObjectStats.trisNum;
			//if (exp01.stats) exp01.stats.update(draws, tris);
			
			//this.scaleX -= 0.001;
			//this.scaleY -= 0.001;
			
			//flatten();
		}
	}
}
