package com.ui.controllers {

	import com.core.system.System;
	import com.ui.AlertEvent;
	import com.ui.ISiteAlert;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SiteAlertManager extends EventDispatcher{
		
		protected static var _instance: SiteAlertManager;
		protected var _container: Sprite;
		protected var _alertClass: Class;
		protected var _alert:ISiteAlert;
		protected var _alertCallbackFunction: Function;
		protected var _background: SimpleButton;
		protected var _autoClose: Boolean;
		protected var _dimension: Point;
		protected var _messageMc: MovieClip;
		
		public function set alertClass($class:Class):void {
			_alertClass = $class;
		}

		public function set autoClose($value:Boolean):void {
			_autoClose = $value;
		}

		public function get externalContainer():ISiteAlert {
			return _alert;
		}

		public function get dimension():Point {
			return _dimension;
		}

		public function set dimension(value:Point):void {
			_dimension = value;
			if(_alert) {
				_alert.x = _dimension.x;
				_alert.y = _dimension.y;
			}
		}

		public function SiteAlertManager($container: Sprite = null, $newCall: Function = null) {
			if ($newCall != SiteAlertManager.getInstance) {
				throw new Error("SiteAlertManager");
			}
			if (_instance != null) {
				throw new Error("SiteAlertManager");
			}			
			init($container);
		}
		/**
		 * Método para obtener la instacia del singleton.
		 * @return
		 */
		public static function getInstance($container: Sprite = null): SiteAlertManager {
			if (_instance == null)	{
				_instance = new SiteAlertManager($container, arguments.callee);
			}
			return _instance;
		}

		protected function init($container: Sprite): void {
			_container = $container;
			_autoClose = false;
//			_background = getBackground();
		}
		
		protected function getBackground(): SimpleButton{
			var upFace: Sprite = getFace(System.stageRoot.stageWidth, System.stageRoot.stageHeight, 0xFFFFFF, 0.3);
			var overFace: Sprite = getFace(System.stageRoot.stageWidth, System.stageRoot.stageHeight, 0xFFFFFF, 0.3);
			var downFace: Sprite = getFace(System.stageRoot.stageWidth, System.stageRoot.stageHeight, 0xFFFFFF, 0.3);
			var hitFace: Sprite = getFace(System.stageRoot.stageWidth, System.stageRoot.stageHeight, 0xFFFFFF, 0.3);
			return new SimpleButton(upFace, overFace, downFace, hitFace);
		}
		
		protected function getFace($width: Number = 100, $height: Number = 100, $color: Number = 0x000000, $alpha: Number = 1): Sprite{
			var face: Sprite = new Sprite();
			face.graphics.beginFill($color, $alpha);
			face.graphics.drawRect(0,0,$width, $height);
			face.graphics.endFill();
			return face;
		}
		
		public function showAlert($message: String, $buttonsList: Array, $callbackFunction: Function, $message_mc:MovieClip = null):void {
			var dimension: Point = _dimension;
			if(_autoClose)
				closeAlert();
			_alert = getAlert($message, $buttonsList);
			if(dimension){
				_alert.x = _dimension.x;
				_alert.y = _dimension.y;
//				_alert.x = (dimension.x - _alert.width)/2;
//				_alert.y = (dimension.y - _alert.height)/2;
			}else{
				_alert.x = (System.stageRoot.stageWidth - _alert.width)/2;
				_alert.y = ((System.stageRoot.stageHeight - _alert.height)/2) - 60;
			}
			_alertCallbackFunction = $callbackFunction;
			createAlertListeners(true, $callbackFunction);
			_container.addChild(_alert as DisplayObject);
			if($message_mc){
				_messageMc = $message_mc;
				_messageMc.x = _alert.x;
				_messageMc.y = _alert.y;
				_container.addChild(_messageMc);
			}
		}
		
		protected function getAlert($message: String, $buttonsList: Array): ISiteAlert{
			if(_alertClass != null){
				return new _alertClass($message, $buttonsList);
			}else{
				throw new Error("SiteAlertManager->Alert class undefined");
			}
		}
		
		protected function createAlertListeners($create: Boolean, $callbackFunction: Function): void{
			if($create){
				(_alert as Sprite).addEventListener(AlertEvent.ON_PRESS_ALERT_BUTTON, $callbackFunction);
				(_alert as Sprite).addEventListener(AlertEvent.ON_PRESS_CLOSE_BUTTON, $callbackFunction);
				(_alert as Sprite).addEventListener(AlertEvent.ON_PRESS_CLOSE_BUTTON, onCloseClick);
			}else{
				(_alert as Sprite).removeEventListener(AlertEvent.ON_PRESS_ALERT_BUTTON, $callbackFunction);
				(_alert as Sprite).removeEventListener(AlertEvent.ON_PRESS_CLOSE_BUTTON, $callbackFunction);
				(_alert as Sprite).removeEventListener(AlertEvent.ON_PRESS_CLOSE_BUTTON, onCloseClick);
			}
		}
		/**
		 * Forza a cerrar la alerta actual
		 * @param $event
		 */		
		public function closeAlert(): void{
			if(_alert) {
				createAlertListeners(false, _alertCallbackFunction);
				_container.removeChild(_alert as Sprite);
				_alertCallbackFunction = null;
				_alert = null;
				_dimension = null;
			}
		}
		
		protected function onCloseClick($event:MouseEvent):void {
			(_messageMc)? _container.removeChild(_messageMc) : "";
		}
	}
}