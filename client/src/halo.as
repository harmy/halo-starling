package
{
	//import com.sociodox.theminer.TheMiner;
	
	import com.sociodox.theminer.TheMiner;
	
	import core.resmgr.ResMgr;
	
	import de.dev_lab.logging.Logger;
	import de.dev_lab.logging.publisher.MultiPublisher;
	import de.dev_lab.logging.publisher.SOSPublisher;
	import de.dev_lab.logging.publisher.TextFieldPublisher;
	import de.dev_lab.logging.publisher.TracePublisher;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import game.GameMain;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	//[SWF(width="960", height="600", frameRate="60")]
	public class halo extends Sprite
	{
		private var mStats:Stats = new Stats();
		private var mStarling:Starling;
		
		public function halo()
		{
			stage.frameRate = 60;
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			addEventListener(Event.ADDED_TO_STAGE, onAddStage);
		}
		
		private function onAddStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddStage);
		
			ResMgr.init();
			//ResMgr.addInspector(stage);
			
			//Logger.publisher = new MultiPublisher( [ new TracePublisher , new SOSPublisher ] );
			Logger.publisher = new MultiPublisher( [ new SOSPublisher ] );
			
			Logger.info("初始化starling引擎");
			mStarling = new Starling(GameMain, stage);
			mStarling.enableErrorChecking = false;
			mStarling.start();
			
			Logger.info("添加性能分析图例");
			addChild( mStats );
			mStats.x = 5;
			mStats.y = 22;
			
			var miner:TheMiner = new TheMiner;
			//addChild(miner);
			
			stage.addEventListener(Event.RESIZE, onResize);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onResize(evt:Event):void
		{
			trace("改变大小: " + stage.stageWidth + "," + stage.stageHeight);
			mStarling.stage.stageWidth = stage.stageWidth;
			mStarling.stage.stageHeight = stage.stageHeight;
			mStarling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

		}
		
		private function onEnterFrame(evt:Event):void
		{
			if (mStarling.context == null) return;
			
			mStats.driverInfo = mStarling.context.driverInfo;
			mStats.update(0, 0);
		}
		
	}
}