package com.utils.graphics {

	import flash.display.Sprite;

	public class MainDisplayController {

		private static var _instance:MainDisplayController;

		protected var _displayContainer:DisplayContainerManager;

		public function get displayContainer():DisplayContainerManager {
			return _displayContainer;
		}

		public function set displayContainer($value:DisplayContainerManager):void {
			_displayContainer = $value;
		}

		public function MainDisplayController($newCall:Function = null, $parentContainer:Sprite = null, $depth:int = 0) {
			if ($newCall != MainDisplayController.getInstance) {
				throw new Error("MainDisplayController");
			}
			if (_instance != null) {
				throw new Error("MainDisplayController");
			}
		}

		public static function getInstance($parentContainer:Sprite = null, $depth:int = 0):MainDisplayController {
			if (_instance == null) {
				_instance = new MainDisplayController(arguments.callee, $parentContainer, $depth);
			}
			return _instance;
		}
	}
}