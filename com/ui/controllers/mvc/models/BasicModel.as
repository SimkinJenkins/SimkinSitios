package com.ui.controllers.mvc.models {

	import com.ui.controllers.mvc.interfaces.IModel;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class BasicModel extends EventDispatcher implements IModel {

		public static const	ON_ERROR:String = "onError";
		public static const	ON_WARNING:String = "onWarning";

		protected var _currentState:String;
		protected var _currentError:String;
		protected var _currentWarning:String;
		protected var _currentMessage:String;

		public function get currentState():String {
			return _currentState;
		}

		public function get currentError():String {
			return _currentError;
		}

		public function get currentWarning():String {
			return _currentError;
		}

		public function BasicModel() {
			super();
			initialize();
		}

		public function setState($ID:String):void {
			_currentState = $ID;
			trace("Set State :: " + $ID);
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function setError($ID:String, $message:String = ""):void {
			_currentError = $ID;
			_currentMessage = $message;
			trace("_currentError::"+$ID+" _currentMessage::"+$message);
			dispatchEvent(new ErrorEvent(ON_ERROR, false, false, $message == "" ? getErrorPhrase($ID) : $message));
		}

		public function setWarning($ID:String, $message:String = ""):void {
			_currentError = $ID;
			_currentWarning = $message;
			trace("_currentWarning::"+$ID+" _currentMessage::"+$message);
			dispatchEvent(new ErrorEvent(ON_WARNING, false, false, $message == "" ? getWarningPhrase($ID) : $message));
		}

		protected function initialize():void {}

		protected function getWarningPhrase($ID:String):String {
			return "Warning: " + $ID;
		}

		protected function getErrorPhrase($ID:String):String {
			return "Error de tipo: " + $ID;
		}

	}
}