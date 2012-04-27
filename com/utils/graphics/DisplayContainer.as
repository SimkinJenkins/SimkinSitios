package com.utils.graphics {

	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	/**
	 * Clase que sirve como contenedor de display objects. Puede contener a su vez otros displayContainers.
	 * @author Pérez Rivera Adrián Alfonso
	 * @see flash.display.MovieClip
	 */
	public class DisplayContainer extends Sprite {

		private var _container:DisplayObjectContainer;
		private var _depth:uint;
		/**
		 * Constructor
		 * 
		 * @param $name Nombre del contenedor. Sirve como identificador unico del display container.
		 * @param $x Posicion X inicial
		 * @param $y Posicion Y inicial
		 * @param $depth Posicion con respecto al eje Z
		 * @param $parentContainer Contenedor padre.
		 * 
		 */		
		public function DisplayContainer($name:String, $x:uint, $y:uint, $depth:uint, $parentContainer:DisplayObjectContainer) {
			super();
			super.name = $name;
			super.x = $x;
			super.y = $y;
			_depth = $depth;
			_container = $parentContainer;
		}

		/**
		 * Propiedad que indica cual es su contenedor padre.
		 * @return 
		 * 
		 */

		public function get parentContainer():DisplayObjectContainer {
			return _container;
		}

		public function set parentContainer($parent:DisplayObjectContainer):void {
			_container = $parent;
		}

		public function get depth():uint {
			return _depth;
		}

		public function set depth($depth:uint):void {
			_depth = $depth;
		}

	}
}