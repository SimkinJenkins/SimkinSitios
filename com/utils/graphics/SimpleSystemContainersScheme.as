package com.utils.graphics {

	import com.core.system.System;
	import com.utils.graphics.DisplayContainer;
	import com.utils.graphics.DisplayContainerManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class SimpleSystemContainersScheme extends DisplayContainerManager {
		
		/**
		 * Constructor
		 * @param $parentContainer
		 * @param $depth
		 */		
		public function SimpleSystemContainersScheme($parentContainer: Sprite = null, $depth: int = 0){}

		/**
		 * Agrega un nuevo elemento a un contenedor ya existente
		 * @param $caller Objeto donde se agregara el nuevo contenedor
		 * @param $displayContainer Contenedor que se agregara
		 * @return DisplayContainer
		 */
		override public function addContainerChild($caller:DisplayObjectContainer, $displayContainer:DisplayContainer):DisplayContainer {
			$displayContainer.addChild($caller)
			return  $displayContainer;
		}
		/**
		 * Agrega un elemento a un contenedor en un indice (depth) especifico
		 * @param $caller Objeto donde se agregara el contenedor
		 * @param $displayContainer Contenedor
		 * @param $index Indice
		 * @return DisplayContainer
		 */
		override public function addContainerChildAt($caller:DisplayObjectContainer, $displayContainer:DisplayContainer, $index:uint):DisplayContainer{
			$displayContainer.addChildAt($caller, $index);
			return $displayContainer;
		}
		/**
		 * Quita un contenedor
		 * @param $caller Objeto de donde se quitara el contenedor
		 * @param $displayContainer Contenedor
		 * @return DisplayContainer
		 */
		override public function removeContainerChild($caller:DisplayObjectContainer, $displayContainer:DisplayContainer):DisplayContainer{
			$displayContainer.removeChild($caller);
			return $displayContainer;
		}
		/**
		 * Crea todos los contenedores.
		 */		
		public function createContainers(): void{
			this.createDisplayContainer("alertsContainer", "alerts_container", 0, 0, 0, this);
			this.createDisplayContainer("preloaderContainer", "preloader_container", 0, 0, 0, this);
			this.createDisplayContainer("mainMenuContainer","main_menu_Container", 0, 0, 0, this);
			this.createDisplayContainer("panelContainer","panel_container", 0, 0, 0, this);
			this.createDisplayContainer("mainContainer","main_container",0, 0, 0, this);
			this.createDisplayContainer("backgroundContainer", "background_container",0, 0, 0, this);			
		}
		/**
		 * Añade un contenedor al stage
		 * @param $propertyName
		 * @param $containerName
		 * @param $x
		 * @param $y
		 * @param $depth
		 * @param $parentContainer
		 * @return DisplayContainer
		 */			
		override public function createDisplayContainer($propertyName: String, $containerName: String, $x: uint, $y: uint, $depth: uint, $parentContainer: DisplayObjectContainer): DisplayContainer{
			var displayContainer:DisplayContainer = new DisplayContainer($propertyName, $x, $y, $depth, System.topRoot);
			displayContainer.mouseEnabled = false;
			this.storeContainer(displayContainer);
			$parentContainer.addChildAt(displayContainer, $depth);
			return displayContainer;
		}
	}
}