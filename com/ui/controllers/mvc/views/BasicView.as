package com.ui.controllers.mvc.views {

	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	import com.ui.controllers.mvc.models.BasicModel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class BasicView extends Sprite implements IView {

		/**
		 * 	Constante Tipo de evento que se usa principalmente dentro del MovieClip.
		 */
		protected static const ANIMATION_END:String = "on animation end";
		/**
		 *	 Sprite principal a ser controlado.
		 */
		protected var _model:IModel;
		protected var _controller:IController;
		protected var _graphic:Sprite;
		/**
		 * @return 		MovieClip principal a ser controlado.
		 * 
		 */
		public function get graphic():Sprite {
			return _graphic;
		}
		
		protected function get graphicMC():MovieClip {
			return _graphic as MovieClip;
		}

		public function BasicView($model:IModel, $controller:IController = null, $graphic:Sprite = null) {
			_graphic = $graphic;
			_model = $model;
			_controller = $controller;
			initialize();
		}

		public function destructor():void {
			addGraphic(false);
			addListener(_model, Event.CHANGE, stateUpdate, false);
			addListener(_model, BasicModel.ON_ERROR, errorHandler, false);
		}

		protected function initialize():void {
			addGraphic();
			addListener(_model, Event.CHANGE, stateUpdate, true, true);
			addListener(_model, BasicModel.ON_ERROR, errorHandler, true, true);
			addListener(_model, BasicModel.ON_WARNING, warningHandler, true, true);
		}

		protected function addGraphic($add:Boolean = true):void {
			addElement(_graphic, $add, this);
		}

		protected function stateUpdate($event:Event):void {}

		protected function errorHandler($event:ErrorEvent):void {}

		protected function warningHandler($event:ErrorEvent):void {
			trace("Warning: " + $event);
		}
		/**
		 * Registra un eventlistener a un objeto que recibirá la notificación de un evento.
		 *  
		 * @param $dispatcher	Elemento al cual se le registra el evento dado.
		 * @param $type			Tipo del evento.
		 * @param $listener		La función que procesa el evento.
		 * @param $add			Indica si el evento va a ser añadido o removido.
		 * 
		 */
		protected function addListener($dispatcher:IEventDispatcher, $type:String, $listener:Function, $add:Boolean = true, $force:Boolean = false):void {
			if(!$dispatcher) {
				return;
			}
			if($add) {
				if(!$dispatcher.hasEventListener($type) || $force) {
					$dispatcher.addEventListener($type, $listener);
				}
			} else {
				if($dispatcher.hasEventListener($type)) {
					$dispatcher.removeEventListener($type, $listener);
				}
			}
		}

		/**
		 *  Añade un elemento (addChild) al MovieClip controlado (_container),
		 * o a un $container:DisplayObjectContainer proporcionado.
		 * 
		 * @param $element		Elemento gráfico que se va a añadir al $container.
		 * @param $add			Dice si $element será agregado o removido del $container. Por default se agrega.
		 * @param $container	Contenedor en el cual se agrega el $element. Por default es _container.
		 * 
		 */
		protected function addElement($element:DisplayObject, $add:Boolean = true, $container:DisplayObjectContainer = null):void {
			$container = $container == null ? (_graphic == null ? this : _graphic) : $container;
			if(!$element || $element == $container) {
				return;
			}
			if($add) {
				$container.addChild($element);
			} else {
				if($element.parent == $container) {
					$container.removeChild($element);
				}
			}
		}

	}
}