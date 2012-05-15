package com.ui.controllers {
	
	import com.net.BasicLoaderEvent;
	import com.net.DataSender;
	import com.net.DataSenderFormat;
	
	import flash.display.Sprite;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	/**
	 * Clase base para controladores dentro de los cuales se requiera hacer llamadas
	 * POST o GET, a un servidor que responde con un xml en formato XML_DATA_MANAGER.
	 * 
	 * @author Simkin
	 * patricio.bravo@interalia.net
	 * patricio.bravoc@gmail.com
	 * 
	 */
	public class BasicTransactionController extends BasicController {
		/**
		 *	Evento lanzado al encontrar un Error en la respuesta del servidor. 
		 */
		public static const XML_DATA_ERROR:String = "xml data error";
		
		/**
		 *	Constante default para _errorConstant.
		 * 	Que indica el nombre de la variable error dentro de una respuesta valida.
		 */
		public static const DEFAULT_ERROR_ID:String = "error";
		/**
		 *	Constante para _errorConstant en un server de etnia.
		 */
		public static const JAVA_ERROR_ID:String = "js_error";
		/**
		 *	Constante para cuando mandan un arreglo de errores. 
		 */
		public static const ETNIA_ERROR_ID:String = "ia_error";
		/**
		 *	Constante para cuando mandan un arreglo de errores. 
		 */
		public static const	ERRORS_ARRAY_ID:String = "errors";
		
		protected var _dataFormat:String = DataSenderFormat.XML_DATA_MANAGER;
		protected var _dataEncode:String = "";
		
		/**
		 *	Indica si se esta realizando una petición actualmente. Ayuda para controles de stress.
		 */
		protected var _onDataRequest:Boolean = false;
		/**
		 *  Función registrada para llamar en caso de tener una respuesta valida.
		 */
		protected var _onComplete:Function;
		/**
		 *  Función registrada para llamar en caso de tener un error en la petición. Su default es
		 * 	la función interna onRequestError.
		 */
		
		protected var _currentErrorID:String;
		
		protected var _onError:Function;
		/**
		 *  Constante que indica el nombre de la variable error dentro de una respuesta valida.
		 * 	El default es la constante DEFAULT_ERROR_ID.
		 */
		protected var _errorConstant:String = DEFAULT_ERROR_ID;
		/**
		 *	Constante que indica el nombre de la variable errores dentro de una respuesta valida.
		 * 	El default es la constante ERRORS_ARRAY_ID.
		 */
		protected var _errorsArrayConstant:String = ERRORS_ARRAY_ID;
		
		protected var _lastDataSender:DataSender;
		protected var _headers:URLRequestHeader;
		protected var _onCompleteTypeEvent:String = "";
		protected var _onErrorTypeEvent:String = "";
		
		public function get onDataRequest():Boolean {
			return _onDataRequest;
		}
		
		public function BasicTransactionController($container: Sprite) {
			super($container);
		}
		/**
		 *	Realiza una petición a servidor.
		 * 
		 * Ejemplo GET.
		 * 	var data:Dictionary = new Dictionary();
		 data.page = _page;
		 sendRequest(URLManager.getInstance().getPath("captureServiceDir") + "secuencias.xml", data, onDataLoaded, null, URLRequestMethod.GET);
		 * 
		 * Ejemplo POST.
		 var data:Dictionary = new Dictionary();
		 data.video = _videoName;
		 data.nombre = _userDataForm.nameTxf.text;
		 data.email = _userDataForm.mailTxf.text;
		 if(EtniaSystem.loaderInfoRoot.parameters.fecha_nacimiento) {
		 data.fecha_nacimiento = EtniaSystem.loaderInfoRoot.parameters.fecha_nacimiento;
		 }
		 sendRequest(URLManager.getInstance().getPath("captureClipDir") + _selectedStep + "/add/", data, onAddVideoComplete);
		 * 
		 * @param $url			URL de la petición.
		 * @param $vars			Variables que serán enviadas en la petición.
		 * @param $onComplete	Función que será registrada para el caso de que se obtenga una respuesta valida.
		 * @param $onError		Función que será registrada para el caso de que exista un error.
		 * 						Éstos pueden ser de tipo EtniaLoaderEvent.IO_ERROR, EtniaLoaderEvent.SECURITY_ERROR o
		 * 						un error contenido en el XML_DATA obtenido en la respuesta (XML_DATA_ERROR). 
		 * @param $method		Es el metodo por el cual será enviada la petición URLRequestMethod.POST o URLRequestMethod.GET.
		 * 						el default es URLRequestMethod.POST.
		 * @return 				En caso de que esté controlador esté haciendo otra petición
		 * 						éste regresa false, en caso de ser exitoso regresa true.
		 * 
		 */
		protected function sendRequest($url:String, $vars:Dictionary, $onComplete:Function, $onError:Function = null, $method:String = URLRequestMethod.POST):Boolean {
			if(_onDataRequest) {
				return false;
			}
			cleanVars();
			_onDataRequest = true;
			_onComplete = $onComplete;
			_onError = $onError == null ? onRequestError : $onError;
			doRequest($url, $vars, $method);
			return true;
		}
		
		protected function sendEventRequest($url:String, $vars:Dictionary, $onCompleteEventType:String, $onErrorType:String = "", $method:String = URLRequestMethod.POST):Boolean {
			if(_onDataRequest) {
				return false;
			}
			cleanVars();
			_onDataRequest = true;
			_onCompleteTypeEvent = $onCompleteEventType;
			_onErrorTypeEvent = $onErrorType == "" ? XML_DATA_ERROR : $onErrorType;
			doRequest($url, $vars, $method);
			return true;
		}
		
		protected function doRequest($url:String, $vars:Dictionary, $method:String):void {
			var dataSender:DataSender = getDataSender($vars, $method);
			dataSender.headers = _headers;
			dataSender.dataFormat = _dataFormat;
			dataSender.dataEncode = _dataEncode;
			addDataSenderListeners(dataSender);
			_lastDataSender = dataSender;
			dataSender.send($url);
		}
		
		protected function cleanVars():void {
			_onError = _onComplete = null;
			_onCompleteTypeEvent = _onErrorTypeEvent = "";
		}
		
		/**
		 *	Obtiene un EtniaDataSender nuevo, para realizar la siguiente petición.
		 *  
		 * @param $vars		Variables que serán enviadas en la petición.
		 * @param $method	Es el metodo por el cual será enviada la petición URLRequestMethod.POST o URLRequestMethod.GET.
		 * 					el default es URLRequestMethod.POST.
		 * @return 			Un EtniaDataSender nuevo, para realizar la siguiente petición.
		 * 
		 */
		protected function getDataSender($vars:Dictionary, $method:String = URLRequestMethod.POST):DataSender {
			var eds:DataSender = new DataSender($vars);
			eds.autocast = false;
			eds.method = $method;
			eds.dataFormat = DataSenderFormat.XML_DATA_MANAGER;
			return eds;
		}
		/**
		 *	Función registrada para todos los eventos del DataSender y llamar las
		 * funciones registradas para cada tipo de evento.
		 * 
		 * @param $event	Evento del DataSender, éste puede ser de los tipos EtniaLoaderEvent.COMPLETE,
		 * 					EtniaLoaderEvent.IO_ERROR, EtniaLoaderEvent.SECURITY_ERROR.
		 * 
		 */
		protected function onSendRequestResponse($event:BasicLoaderEvent):void {
			addDataSenderListeners($event.target as DataSender, false);
			_onDataRequest = false;
			switch($event.type) {
				case BasicLoaderEvent.COMPLETE:			onSendRequestComplete($event);	break;
				case BasicLoaderEvent.IO_ERROR:			
				case BasicLoaderEvent.SECURITY_ERROR:	doOnErrorResponse($event);				break;
			}
		}
		/**
		 *	Función llamada cuando el DataSender responde un evento EtniaLoaderEvent.COMPLETE,
		 * 	se revisa el XML_DATA para validar que no exista un mensaje de error en la respuesta.
		 * 
		 * @param $event Evento del DataSender.
		 * 
		 */
		protected function onSendRequestComplete($event:BasicLoaderEvent):void {
			if($event.serverResponse[_errorConstant] != null || $event.serverResponse[_errorsArrayConstant] != null) {
				if($event.serverResponse[_errorConstant] != 0 && $event.serverResponse[_errorConstant] != "False") {
					var event:BasicLoaderEvent = new BasicLoaderEvent(_onErrorTypeEvent != "" ? _onErrorTypeEvent : XML_DATA_ERROR,
						$event.url, $event.retry, $event.bytesLoaded,
						$event.bytesTotal, $event.item, $event.serverResponse,
						$event.data);
					_currentErrorID = $event.serverResponse[_errorConstant];
					doOnErrorResponse(event);
					return;
				}
			}
			doOnCompleteResponse($event);
		}
		
		protected function doOnErrorResponse($event:BasicLoaderEvent):void {
			if(_onErrorTypeEvent != "") {
				dispatchEvent($event);
			} else {
				_onError($event);
			}
		}
		
		protected function doOnCompleteResponse($event:BasicLoaderEvent):void {
			if(_onCompleteTypeEvent != "") {
				dispatchEvent(new BasicLoaderEvent(_onCompleteTypeEvent, $event.url, $event.retry, $event.bytesLoaded, $event.bytesTotal,
					$event.item, $event.serverResponse, $event.data));
			} else {
				_onComplete($event);
			}
		}
		
		/**
		 * 	Añade o quita los listeners correspondientes al DataSender
		 * 
		 * @param $dataSender		Objeto DataSender al que se le van a añadir los listeners.
		 * @param $add				En caso de ser true, se añaden los listeners; en caso contrario, se quitan.
		 * 							El default es true.
		 * 
		 */
		protected function addDataSenderListeners($dataSender:DataSender, $add:Boolean = true):void {
			addListener($dataSender, BasicLoaderEvent.COMPLETE, onSendRequestResponse, $add);
			addListener($dataSender, BasicLoaderEvent.IO_ERROR, onSendRequestResponse, $add);
			addListener($dataSender, BasicLoaderEvent.PROGRESS, onSendRequestProgress, $add);
			addListener($dataSender, BasicLoaderEvent.SECURITY_ERROR, onSendRequestResponse, $add);
		}
		/**
		 *	Función por default a ser llamada en caso de tener un error en la petición.
		 * 
		 * @param $event	Evento del DataSender.
		 * 
		 */
		protected function onRequestError($event:BasicLoaderEvent):void {
			trace("onRequestError ::: " + $event.url);
		}
		
		protected function onSendRequestProgress($event:BasicLoaderEvent):void {
			trace("onSendRequestProgress ::: " + $event);
		}
		
		protected function getEmptyData():Dictionary {
			var data:Dictionary = new Dictionary();
			data.p = 1;
			return data;			
		}
		
	}
}