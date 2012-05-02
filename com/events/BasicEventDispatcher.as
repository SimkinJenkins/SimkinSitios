package com.events {

	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class BasicEventDispatcher extends EventDispatcher implements IEventDispatcher {

		public function BasicEventDispatcher($target:IEventDispatcher = null) {
			super($target);
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

	}
}