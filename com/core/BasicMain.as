package com.core {

	import com.core.config.URLManager;
	import com.interfaces.IClient;
	import com.net.BasicLoaderEvent;
	import com.net.GraphicLoadManager;
	import com.net.GraphicLoadManagerEventType;
	import com.utils.graphics.DisplayContainer;
	import com.utils.graphics.MainDisplayController;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.LocalConnection;
	
	public class BasicMain extends Main implements IClient {

		protected var _currentArchive:int = -1;
		protected var _fbEnabled:Boolean = true;

		public function BasicMain($url:String="./swf/v1_0/config/localURLSData.xml") {
			super($url);
		}

		override protected function onClientReady():void {
			super.onClientReady();
			showInfinitPreloader(true);
			loadPreloader();
		}

		protected function loadPreloader():void {
			_graphicsLoader = new GraphicLoadManager();
			_graphicsLoader.graphicsDirPath = URLManager.getInstance().getPath("moviesDir");
			setPreloadMovies();
			addListener(_graphicsLoader, GraphicLoadManagerEventType.ON_GRAPHICS_LOADED, onPreloadedLoaded);
			_graphicsLoader.startLoad();
		}

		protected function onPreloadedLoaded($event:Event):void {
			addListener(_graphicsLoader, GraphicLoadManagerEventType.ON_GRAPHICS_LOADED, onPreloadedLoaded, false);
			addElement(_graphicsLoader.library.index, true, backgroundContainer);
			loadGraphics();
		}

		protected function setPreloadMovies():void {
			_graphicsLoader.loadRequest("index", "index.swf");
		}

		protected function loadGraphics():void {
			if((new LocalConnection()).domain == "localhost" && _fbEnabled) {
//				_graphicsLoader.loadRequest("fbLogin", "FbLogin.swf");
			}
			_currentArchive = -1;
			addListener(_graphicsLoader, BasicLoaderEvent.PROGRESS, onGraphicLoadProgress);
			addListener(_graphicsLoader, GraphicLoadManagerEventType.ON_GRAPHIC_LOADED, onGraphicLoad);
			addListener(_graphicsLoader, GraphicLoadManagerEventType.ON_GRAPHICS_LOADED, onGraphicsLoaded);
			_graphicsLoader.startLoad();
		}

		protected function onGraphicLoadProgress($event:BasicLoaderEvent):void {
//			var eachPercent:Number = 1 / 3;
//			var currentPercent:Number = eachPercent * _currentArchive;
//			var archivePercent:Number = ($event.bytesLoaded / $event.bytesTotal) * eachPercent;
		}

		protected function onGraphicLoad($event:Event):void {
			trace(_currentArchive);
			_currentArchive++;
		}

		protected function onGraphicsLoaded($event:Event):void {
			showInfinitPreloader(false);
			addListener(_graphicsLoader, BasicLoaderEvent.PROGRESS, onGraphicLoadProgress, false);
			addListener(_graphicsLoader, GraphicLoadManagerEventType.ON_GRAPHIC_LOADED, onGraphicLoad, false);
			addListener(_graphicsLoader, GraphicLoadManagerEventType.ON_GRAPHICS_LOADED, onGraphicsLoaded, false);
		}

		protected function get backgroundContainer():DisplayContainer {
			return MainDisplayController.getInstance().displayContainer.getStoredContainer("backgroundContainer");
		}

		protected function get mainMenuContainer():DisplayContainer {
			return MainDisplayController.getInstance().displayContainer.getStoredContainer("mainMenuContainer");
		}
		
		protected function get mainContainer():DisplayContainer {
			return MainDisplayController.getInstance().displayContainer.getStoredContainer("mainContainer");
		}

		protected function get panelContainer():DisplayContainer {
			return MainDisplayController.getInstance().displayContainer.getStoredContainer("panelContainer");
		}

		protected function get alertsContainer():DisplayContainer {
			return MainDisplayController.getInstance().displayContainer.getStoredContainer("alertsContainer");
		}

		protected function addMainContainerElement($element:DisplayObject, $add:Boolean = true):void {
			addElement($element, $add, mainContainer);
		}

	}
}