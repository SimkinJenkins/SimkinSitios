package com.utils.graphics {

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	//import com.etnia.exceptions.AbstractClassException;
	
	/**
	 * Clase base que sirve para administrar la creacion de Display Containers. Define los metodos basicos que se
	 * pueden utilizar para utilizar DisplayContainer.
	 * @author Pérez Rivera Adrian Alfonso
	 * @see com.etnia.core.config.DisplayContainer
	 */
	public class DisplayContainerManager extends Sprite	{
		private var _displayContainers:Dictionary = new Dictionary();
		
		/**
		 * @private
		 */
		public function DisplayContainerManager()
		{
			if(String(this) == "[object DisplayContainerManager]")
			{
				throw new Error("DisplayContainerManager");
			}
		}
		
		/**
		 * Crea nuevos Display Containers vacios. La propiedad debe estar creada previamente dentro de la clase debido a que
		 * no es una clase dinamica.
		 * @param $propertyName Nombre de la propiedad
		 * @param $containerName Nombre del contenedor
		 * @param $x Posicion x
		 * @param $y Posicion y
		 * @param $depth Posicion z
		 * @param $parentContainer Contanedor padre
		 * @return 
		 * 
		 */
		public function createDisplayContainer($propertyName:String, $containerName:String, $x:uint, $y:uint, $depth:uint, $parentContainer:DisplayObjectContainer):DisplayContainer
		{
			return new DisplayContainer($containerName,$x, $y, $depth, $parentContainer)
		}
		
		/**
		 * Agrega un nuevo contenedor
		 * @param $caller Objeto donde se agregara el nuevo contenedor
		 * @param $displayContainer Contenedor que se agregara
		 * @return 
		 * 
		 */
		public function addContainerChild($caller:DisplayObjectContainer, $displayContainer:DisplayContainer):DisplayContainer
		{
			return $displayContainer
		}
		
		/**
		 * Agrega un contenedor en un indice (depth) especifico
		 * @param $caller Objeto donde se agregara el contenedor
		 * @param $displayContainer Contenedor
		 * @param $index Indice
		 * @return 
		 * 
		 */
		public function addContainerChildAt($caller:DisplayObjectContainer, $displayContainer:DisplayContainer, $index:uint):DisplayContainer
		{
			return $displayContainer
		}		
		
		/**
		 * Quita un contenedor
		 * @param $caller Objeto de donde se quitara el contenedor
		 * @param $displayContainer Contenedor
		 * @return 
		 * 
		 */
		public function removeContainerChild($caller:DisplayObjectContainer, $displayContainer:DisplayContainer):DisplayContainer
		{
			return $displayContainer
		}		
		
		/**
		 * Almacena un contenedor
		 * @param $displayContainer Contenedor
		 * 
		 */
		public function storeContainer($displayContainer:DisplayContainer):void
		{
			_displayContainers[$displayContainer.name] = $displayContainer
		}
		
		/**
		 * Obtiene un contenedor almacenado
		 * @param $containerName Nombre del contenedor
		 * @return 
		 * 
		 */
		public function getStoredContainer($containerName:String):DisplayContainer
		{
			return _displayContainers[$containerName]
		}
		
		public function getContainerName($container: DisplayContainer): String
		{
			var property: String = "";
			for(property in _displayContainers){
				if(_displayContainers[property] == $container)
					return property;
			}
			return property;
		}
	}
}