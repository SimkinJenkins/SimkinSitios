package com.core {

	import com.core.system.SimpleSystemLoader;
	import com.interfaces.IClient;
	import com.ui.AlertEvent;
	import com.ui.SiteAlert;
	import com.ui.controllers.SiteAlertManager;
	import com.utils.graphics.DisplayContainer;
	import com.utils.graphics.DisplayContainerManager;
	import com.utils.graphics.MainDisplayController;
	import com.utils.graphics.SimpleSystemContainersScheme;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class SimpleMain extends SimpleSystemLoader implements IClient {
		// -> Contendores
		protected var _displayContainerManager: DisplayContainerManager;
		
		public function SimpleMain($url:String){
			super($url);
		}
		/**
		 * Inicializa los elementos básicos del cliente
		 * 
		 */		
		override public function initialize():void {
			super.initialize();
			if(!MainDisplayController.getInstance().displayContainer) {
				_displayContainerManager = this.getDisplayContainerManager();
				MainDisplayController.getInstance().displayContainer = _displayContainerManager;
				addChild(_displayContainerManager as Sprite);
			}
			configureAlertManager();
		}
		/**
		 * Obtiene el contenedor principal.
		 * @return DisplayContainerManager
		 * 
		 */
		protected function getDisplayContainerManager(): DisplayContainerManager {
			var scheme: SimpleSystemContainersScheme = new SimpleSystemContainersScheme();
			scheme.createContainers();
			return scheme;
		}
		/**
		 * Configura el singleton de la alerta
		 * 
		 */		
		protected function configureAlertManager(): void{
			SiteAlertManager.getInstance(getAlertContainer());
			SiteAlertManager.getInstance().alertClass = getAlert();
		}
		/**
		 * Obtiene la clase que se usara como alerta
		 * @return 
		 * 
		 */		
		protected function getAlert(): Class{
			return SiteAlert;
		}
		/**
		 * Obtiene el contenedor de la alerta
		 * @return 
		 * 
		 */		

		protected function getAlertContainer(): DisplayContainer {
			var displayContainer: SimpleSystemContainersScheme = _displayContainerManager as SimpleSystemContainersScheme;
			var container: DisplayContainer = displayContainer.getStoredContainer("alertsContainer");
			return container;
		}

		// ******************************************************************************
		// Visualizadores de los cargadores
		// ******************************************************************************

		protected function showInfinitPreloader($show:Boolean = true):DisplayObject {
//			return showLoader($show, SiteLoaderManager.INFINIT_LOADER, "");
			return new Sprite();
		}

		protected function showProgresivePreloader($show:Boolean = true):DisplayObject {
//			return showLoader($show, SiteLoaderManager.PERCENT_LOADER, "");
			return new Sprite();
		}

		protected function showPrincipalLoader($show: Boolean): void{
//			showLoader($show, SiteLoaderManager.PRINCIPAL_LOADER, LanguageManager.getInstance().getPhrase("801"));
		}

		protected function showLoader($show:Boolean, $type:String, $text:String = ""):DisplayObject {
			return new Sprite();
		}
		
		protected function incrementLoader($value:Number):void {
			//trace("Percent: " + $value);
		}
		// ******************************************************************************
		// Alert
		// ******************************************************************************
		protected function showAlert($message: String, $onPressCallback: Function, $buttonsNamesList: Array = null): void{
			SiteAlertManager.getInstance().showAlert($message, $buttonsNamesList, $onPressCallback);
		}

		protected function onPressAlertButton($event:AlertEvent):void {
			if($event.ID != -1){
				// Acciones que se quieran generar con el boton de la alerta
			}else{
				// Se Presionó el boton close
			}
		}
	}
}