package com.core {

	import com.interfaces.IClient;
	import com.net.BasicLoaderEvent;
	import com.net.DataSender;
	import com.net.GraphicLoadManager;
	import com.net.GraphicLoadManagerEventType;
	import com.ui.AlertEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.utils.Dictionary;

	public class Main extends SimpleMain implements IClient {
		// -> Variables
		protected var _currentIDMovie: uint;
		protected var _allowAccess: Boolean = false;
		// -> 
		protected var _graphicsLoader:GraphicLoadManager;
		protected var _currentAlertPressFunction: Function;
		protected var _currentMovieHolder: MovieClip;
		protected var _holder: MovieClip;
		protected var _callbackFunction: Function;
		protected var _alert: DisplayObject;
		// ->
		protected var _totalMovies: Number;
		protected var _currentMovie: Number;
		protected var _percentMovie: Number;
		protected var _trackingEnable:Boolean = false;
		protected var _loadCountriesEnable:Boolean = false;
		/**
		 * Constructor
		 * @param $url
		 */		
		public function Main($url: String="./swf/v1_0/config/localURLSData.xml"){
			super($url);
		}
		/**
		 * Inicializa la carga del cliente
		 */		
		override public function initialize(): void{
			super.initialize();
			showInfinitPreloader(true);
		}
		/**
		 * Termina la carga de los archivos de configuración.
		 */

		protected function onError($event:BasicLoaderEvent): void {
			if(!this._clientReady){
				this.dispatchOnClientReady();
				this._clientReady = true;
			}
		}

		/**
		 * Se ejecuta cuando el cliente esta listo para ser utilizado
		 */		
		override protected function onClientReady(): void{
			super.onClientReady();
			showInfinitPreloader(false);
			loadComponents();
		}
		
		
		// ******************************************************************************
		// Inicia de peliculas esternas
		// ******************************************************************************
		protected function loadComponents(): void{
			trace("Inicia la carga de las peliculas que se utilizaran");
			showProgresivePreloader(true);
			_currentMovie = getCurrentMovie();
			_totalMovies = getTotalMovies();
			_percentMovie = _currentMovie / _totalMovies;
		}
		protected function getCurrentMovie(): Number{
			return 0;
		}
		protected function getTotalMovies(): Number{
			return 1;
		}

		protected function createGraphicsLoaderListeners($create: Boolean): void{
			if($create){
				_graphicsLoader.addEventListener(BasicLoaderEvent.PROGRESS, onProgress);
				_graphicsLoader.addEventListener(GraphicLoadManagerEventType.ON_GRAPHIC_LOADED, onLoadComponent);
				_graphicsLoader.addEventListener(GraphicLoadManagerEventType.ON_GRAPHICS_LOADED, onLoadComponents);
			}else{
				_graphicsLoader.removeEventListener(BasicLoaderEvent.PROGRESS, onProgress);
				_graphicsLoader.removeEventListener(GraphicLoadManagerEventType.ON_GRAPHIC_LOADED, onLoadComponent);
				_graphicsLoader.removeEventListener(GraphicLoadManagerEventType.ON_GRAPHICS_LOADED, onLoadComponents);
			}
		}

		protected function onProgress($event:BasicLoaderEvent): void{
			var percent: Number;
			if(_currentMovie<_totalMovies){
				percent = _percentMovie + ($event.bytesLoaded * 100 ) / (_totalMovies * $event.bytesTotal);
			}else{
				percent = _percentMovie;
			}
			incrementLoader(percent);
		}

		protected function onLoadComponent($event: Event): void{
			_percentMovie = (++_currentMovie / _totalMovies) * 100;
			incrementLoader(_percentMovie);
		}

		protected function onLoadComponents($event: Event): void{
			showProgresivePreloader(false);
			createGraphicsLoaderListeners(false);
		}

		protected function closeAlert($event:AlertEvent):void{}
				
	}
}