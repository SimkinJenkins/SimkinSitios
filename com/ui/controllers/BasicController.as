package com.ui.controllers {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * Clase base para cualquier controlador de un MovieClip.
	 * 
	 * @author Simkin
	 * patricio.bravo@interalia.net
	 * patricio.bravoc@gmail.com
	 */
	public class BasicController extends EventDispatcher {
		/**
		 * 	Constante Tipo de evento que se usa principalmente dentro del MovieClip.
		 */
		protected static const ANIMATION_END:String = "on animation end";
		/**
		 *	 Sprite principal a ser controlado.
		 */
		protected var _container:Sprite;
		/**
		 * @return 		MovieClip principal a ser controlado.
		 * 
		 */
		public function get container():Sprite {
			return _container;
		}
		
		protected function get containerMC():MovieClip {
			return _container as MovieClip;
		}
		
		public function BasicController($container:Sprite) {
			_container = $container;
			initialize();
		}

		protected function initialize():void {}
		/**
		 * Registra un eventlistener a un objeto que recibirá la notificación de un evento.
		 *  
		 * @param $dispatcher	Elemento al cual se le registra el evento dado.
		 * @param $type			Tipo del evento.
		 * @param $listener		La función que procesa el evento.
		 * @param $add			Indica si el evento va a ser añadido o removido.
		 * 
		 */
		protected function addListener($dispatcher:IEventDispatcher, $type:String, $callback:Function, $add:Boolean = true, $force:Boolean = false):void {
			if(!$dispatcher) {
				return;
			}
			if($add) {
				if(!$dispatcher.hasEventListener($type) || $force) {
					$dispatcher.addEventListener($type, $callback);
				}
			} else {
				if($dispatcher.hasEventListener($type)) {
					$dispatcher.removeEventListener($type, $callback);
				}
			}
		}

		/**
		 *  Añade un elemento (addChild) al MovieClip controlado (_container),
		 * o a un $container:DisplayObjectContainerproporcionado.
		 * 
		 * @param $element		Elemento gráfico que se va a añadir al $container.
		 * @param $add			Dice si $element será agregado o removido del $container. Por default se agrega.
		 * @param $container	Contenedor en el cual se agrega el $element. Por default es _container.
		 * 
		 */
		protected function addElement($element:DisplayObject, $add:Boolean = true, $container:DisplayObjectContainer = null):void {
			$container = $container == null ? _container : $container;
			if(!$element) {
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