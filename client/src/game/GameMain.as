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
		
		public function GameMain() {
			super();
		
			this.start();
			this.map.setMapPath("../assets/maps/");
			this.map.load("map.tmx");
			
			onResizeEvent(null);
			
			Starling.current.stage.addEventListener(Event.RESIZE, onResizeEvent);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onResizeEvent(evt:Event):void
		{
			trace("gamemain改变大小: " + Starling.current.stage.stageWidth + "," + Starling.current.stage.stageHeight);
			onResize(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
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
