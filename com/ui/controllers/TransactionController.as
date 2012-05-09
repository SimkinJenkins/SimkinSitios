package com.ui.controllers {

	import com.net.BasicLoaderEvent;
	import com.ui.AlertEvent;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class TransactionController extends BasicTransactionController {

		public static const ON_ERROR_ALERT_CLOSE:String = "onErrorAlertClose";

		protected var _ioErrorPhrase:String = "Error de conexión con el servidor. Intenta más tarde.";
		protected var _securityErrorPhrase:String = "Ha ocurrido un error de seguridad. Intenta más tarde.";
		protected var _unknownError:String = "Error en el sistema #: ";
		protected var _unknownError1:String = ". Favor de reportarlo.";

		protected var _errorList:Dictionary;

		public function TransactionController($container:Sprite) {
			super($container);
		}

		override protected function initialize():void {
			super.initialize();
			_errorList = new Dictionary();
		}

		override protected function onRequestError($event:BasicLoaderEvent):void {
			super.onRequestError($event);
			SiteAlertManager.getInstance().showAlert(getMessage($event), ["OK"], onErrorAlertClose);
		}

		protected function getMessage($event:BasicLoaderEvent):String {
			switch($event.type) {
				case BasicLoaderEvent.IO_ERROR:						return _ioErrorPhrase;
				case BasicLoaderEvent.SECURITY_ERROR:				return _securityErrorPhrase;
				case BasicTransactionController.XML_DATA_ERROR:
						if($event.serverResponse[_errorsArrayConstant]) {
							return ($event.serverResponse[_errorsArrayConstant] as Array).join(". ");
						} else if(_errorList && _errorList[$event.serverResponse[_errorConstant]]) {
							return _errorList[$event.serverResponse[_errorConstant]];
						} else {
							return _unknownError + $event.serverResponse[_errorConstant] + _unknownError1;
						}
			}
			return _unknownError + "000000";
		}

		protected function onErrorAlertClose($event:AlertEvent):void {
			dispatchEvent(new AlertEvent(ON_ERROR_ALERT_CLOSE, $event.ID));
		}

	}
}