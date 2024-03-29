package com.ui.controllers.mvc.webcam {

	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.models.BasicModel;
	import com.utils.graphics.DisplayContainer;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.media.Camera;
	
	public class BasicWebcamModel extends BasicModel implements IModel {

		protected var _videoContainer:DisplayObjectContainer;
		protected var _automaticStart:Boolean = false;
    	protected var _serverURL:String = null;
    	protected var _fileName:String = null;
    	protected var _capturedImage:DisplayObject;
    	protected var _videoWidth:uint = 320;
    	protected var _videoHeight:uint = 240;
    	protected var _fps:uint = 12;
    	protected var _useCamera:Boolean = false;
        protected var _recordTime:Number;
        protected var _micEnabled:Boolean = true;
		protected var _videoQuality:Number = 90;
		protected var _webCamera:Camera;

		public function set automaticStart($value:Boolean):void {
			_automaticStart = $value;
		}

		public function get automaticStart():Boolean {
			return _automaticStart;
		}

		public function set videoContainer($value:DisplayObjectContainer):void {
			_videoContainer = $value;
		}
		
		public function get videoContainer():DisplayObjectContainer {
			return _videoContainer;
		}

		public function set capturedImage($value:DisplayObject):void {
			_capturedImage = $value;
			if($value) {
				setState(BasicWebcamStates.ON_IMAGE_CAPTURED);
				setState(BasicFormStates.FINISHING);
			}
		}

		public function get capturedImage():DisplayObject {
			return _capturedImage;
		}

		public function set webCamera($value:Camera):void {
			_webCamera = $value;
		}

		public function get webCamera():Camera {
			return _webCamera;
		}

    	/**
    	 * Configura el servidor al que se enviara la conexión
    	 * @param $server
    	 */
    	public function set serverURL($URL:String):void {
    		_serverURL = $URL;
    	}

    	public function get serverURL():String {
    		return _serverURL;
    	}

    	/**
    	 * Configura el nombre que tendra el archivo.
    	 * @param $fileName
    	 */
    	public function set fileName($fileName:String):void {
    		_fileName = $fileName;
    	}

    	public function get fileName():String {
    		return _fileName;
    	}

    	/**
    	 * Configura el ancho del video
    	 * @param $value
    	 */
    	public function set videoWidth($value:Number):void {
			_videoWidth = $value;
		}

		public function get videoWidth():Number {
			return _videoWidth;
		}

		/**
		 * Configura el alto del video
		 * @param $value
		 */
		public function set videoHeight($value:Number):void {
			_videoHeight = $value;
		}

		public function get videoHeight():Number {
			return _videoHeight;
		}

		/**
		 * Configura el número de frames por segundo
		 * @param $value
		 */
		public function set fps($value:uint):void {
			_fps = $value;
		}

		public function get fps():uint {
			return _fps;
		}

		public function set useCamera($value:Boolean):void {
			_useCamera = $value;
		}

		public function get useCamera():Boolean {
			return _useCamera;
		}

		/**
		 * Tiempo de grabación
		 * @param $value
		 */
		public function set recordTime($value:Number):void {
			_recordTime = $value;
		}

		public function get recordTime():Number {
			return _recordTime;
		}

		public function set micEnabled($value:Boolean):void {
			_micEnabled = $value;
		}

		public function get micEnabled():Boolean {
			return _micEnabled;
		}

		public function set videoQuality($value:Number):void {
			_videoQuality = $value;
		}

		public function get videoQuality():Number {
			return _videoQuality;
		}

		public function BasicWebcamModel() {
			super();
		}

		override protected function getErrorPhrase($ID:String):String {
			switch($ID){
				case BasicWebcamStates.ON_CAMERA_ERROR: return "Necesitas webcam para realizar una imagen directa.";
			}
			return "Error de tipo: " + $ID;
		}
	}
}