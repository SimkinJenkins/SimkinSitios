package com.ui.controllers.mvc.controllers {

	import com.events.BasicEventDispatcher;
	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;

	public class BasicMVCController extends BasicEventDispatcher implements IController {

		protected var _model:IModel;

		public function BasicMVCController($model:IModel) {
			super();
			_model = $model;
			initialize();
		}

		public function destructor():void {}

		protected function initialize():void {}
	}
}