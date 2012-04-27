package com.ui.controllers.events {

	import flash.events.Event;

	public class StageEvent extends Event {

		protected var _currentStage:String;

		public function get currentStage():String {
			return _currentStage;
		}

		public function StageEvent($type:String, $currentStage:String, $bubbles:Boolean=false, $cancelable:Boolean=false) {
			super($type, $bubbles, $cancelable);
			_currentStage = $currentStage;
		}

	}
}