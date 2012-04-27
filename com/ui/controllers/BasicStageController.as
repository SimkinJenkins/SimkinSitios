package com.ui.controllers {


	import com.ui.controllers.events.StageEvent;
	
	import flash.display.Sprite;

	public class BasicStageController extends BasicController {

		public static const ON_STAGE_CHANGE:String = "on stage change";

		public static const START:String = "start";

		protected var _stage:String = START;
		protected var _lastStage:String;
		protected var _buttons:Array;

		public function get currentStage():String {
			return _stage;
		}

		public function BasicStageController($container:Sprite) {
			super($container);
		}

		public function setStage($ID:String):void {
			if(_stage == $ID) {
				return;
			}
			_lastStage = _stage;
			_stage = $ID;
			doStageTransition($ID);
			dispatchEvent(new StageEvent(ON_STAGE_CHANGE, $ID));
		}

		protected function doStageTransition($ID:String):void {
			trace("Do Stage Transition To ::: " + $ID);
		}

	}
}