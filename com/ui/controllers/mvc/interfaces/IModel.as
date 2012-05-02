package com.ui.controllers.mvc.interfaces {

	import flash.events.IEventDispatcher;

	public interface IModel extends IEventDispatcher {

		function get currentWarning():String;
		function get currentState():String;
		function get currentError():String;

		function setState($ID:String):void;
		function setError($ID:String, $message:String = ""):void;
		function setWarning($ID:String, $message:String = ""):void;

	}
}