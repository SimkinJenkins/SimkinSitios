package com.ui.controllers.mvc.controllers {

	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.interfaces.IFormController;
	import com.ui.controllers.mvc.interfaces.IModel;

	public class BasicMVCFormController extends BasicMVCController implements IFormController {

		public function BasicMVCFormController($model:IModel) {
			super($model);
		}

		public function clickHandler($ID:String):void {
			switch($ID) {
				case BasicFormStates.ON_FINISH_BTN:		onFinishRequest();		break;
				case BasicFormStates.ON_CANCEL_BTN:		onCancelRequest();		break;
			}
		}

		override public function destructor():void {
			if(_model.currentState == BasicFormStates.CANCELING) {
				_model.setState(BasicFormStates.CANCELED);
			} else if(_model.currentState == BasicFormStates.FINISHING) {
				_model.setState(BasicFormStates.FINISHED);
			}
			super.destructor();
		}

		protected function onFinishRequest():void {
			_model.setState(BasicFormStates.FINISHING);
		}

		protected function onCancelRequest():void {
			_model.setState(BasicFormStates.CANCELING);
		}

	}
}