package com.ui.controllers.mvc.views {

	import com.ui.AlertEvent;
	import com.ui.controllers.SiteAlertManager;
	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IFormController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	import com.ui.theme.SimpleButtonFactory;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BasicFormView extends BasicView implements IView {

		public static const ALERT_ERROR_CLOSE:String = "alertErrorClose";

		protected var _finishButton:InteractiveObject;
		protected var _cancelButton:InteractiveObject;

		protected function get cancelButton():InteractiveObject {
			return _cancelButton;
		}

		protected function get finishButton():InteractiveObject {
			return _finishButton;
		}

		protected function get formController():IFormController {
			return _controller as IFormController;
		}

		public function BasicFormView($model:IModel, $controller:IController = null, $graphic:Sprite = null) {
			super($model, $controller, $graphic);
		}

		override public function destructor():void {
			buttonDestructor(_finishButton);
			buttonDestructor(_cancelButton);
			formController.destructor();
			super.destructor();
		}

		override protected function initialize():void {
			super.initialize();
			initGraphic();
		}

		override protected function stateUpdate($event:Event):void {
			switch(_model.currentState) {
				case BasicFormStates.CANCELING:	onCanceled();	break;
				case BasicFormStates.FINISHING:	onFinishing();	break;
			}
			super.stateUpdate($event);
		}

		override protected function errorHandler($event:ErrorEvent):void {
			SiteAlertManager.getInstance().showAlert($event.text, ["Ok"], onAlertClose);
		}

		protected function onAlertClose($event:AlertEvent):void {
			_model.setWarning(ALERT_ERROR_CLOSE);
		}

		protected function initGraphic():void {}

		protected function getButton($text:String, $x:Number, $y:Number, $show:Boolean = true, $clickHandler:Function = null):SimpleButton {
			var button:SimpleButton = SimpleButtonFactory.getButton($text);
			button.x = $x;
			button.y = $y;
			addListener(button, MouseEvent.CLICK, $clickHandler == null ? clickHandler : $clickHandler);
			addElement(button, $show);
			return button;
		}

		protected function buttonDestructor($button:InteractiveObject, $container:DisplayObjectContainer = null, $clickHandler:Function = null):void {
			addListener($button, MouseEvent.CLICK, $clickHandler == null ? clickHandler : $clickHandler, false);
			addElement($button, false, $container);
		}

		protected function clickHandler($event:MouseEvent):void {
			trace("clickHandler :: " + getButtonID($event.currentTarget as InteractiveObject));
			formController.clickHandler(getButtonID($event.currentTarget as InteractiveObject));
		}

		protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case finishButton:			return BasicFormStates.ON_FINISH_BTN;
				case cancelButton:			return BasicFormStates.ON_CANCEL_BTN;
			}
			return $button.name;
		}

		protected function onCanceled():void {
			destructor();
		}

		protected function onFinishing():void {
			destructor();
		}

	}
}