package com.ui.controllers.mvc.webcam {

	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	import com.ui.controllers.mvc.views.BasicFormView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	
	public class BasicWebcamView extends BasicFormView implements IView {

		protected var _video:Video;
		protected var _startButton:InteractiveObject;
		protected var _captureImageButton:InteractiveObject;

		protected function get startButton():InteractiveObject {
			return _startButton;
		}

		protected function get captureImageButton():InteractiveObject {
			return _captureImageButton;
		}

		protected function get wcModel():BasicWebcamModel {
			return _model as BasicWebcamModel;
		}

		protected function get wcController():BasicWebcamController {
			return _controller as BasicWebcamController;
		}

		public function BasicWebcamView($model:IModel, $controller:IController = null, $graphic:Sprite = null) {
			super($model, $controller, $graphic);
		}

		override public function destructor():void {
			addListener(startButton, MouseEvent.CLICK, clickHandler, false);
			addListener(captureImageButton, MouseEvent.CLICK, onCaptureRequest, false);
			addElement(wcModel.capturedImage, false);
			addElement(startButton, false);
			showCaptureMenu(false);
			showFinishMenu(false);
			showVideo(false);
			destructVideo();
			super.destructor();
		}

		override protected function initGraphic():void {
			super.initGraphic();
			_startButton = getButton("Empezar Camara", 100, 100);
			_captureImageButton = getButton("Captura tu foto", 350, 150, false, onCaptureRequest);
			_captureImageButton.visible = false;
			_finishButton = getButton("Elegir esta imagen", 350, 150, false);
			_finishButton.visible = false;
			_cancelButton = getButton("Regresar", 350, 180, false);
			_cancelButton.visible = false;
		}

		override protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case startButton:			return BasicWebcamStates.ON_CAMERA_STARTING;
			}
			return super.getButtonID($button);
		}

		override protected function stateUpdate($event:Event):void {
			switch(_model.currentState) {
				case BasicWebcamStates.ON_CAMERA_READY:		onCameraReady();	break;
				case BasicWebcamStates.ON_IMAGE_CAPTURED:	onImageCaptured();	break;
				case BasicWebcamStates.ON_CAPTURE_AGAIN:	onCaptureAgain();	break;
			}
			super.stateUpdate($event);
		}

		protected function onCaptureAgain():void {
			addElement(wcModel.capturedImage, false);
			showFinishMenu(false);
			showCaptureMenu(true);
		}

		protected function onCameraReady():void {
			addElement(startButton, false);
			showVideo();
			showFinishMenu(false);
			showCaptureMenu();
		}

		protected function onImageCaptured():void {
			addElement(wcModel.capturedImage);
			showCaptureMenu(false);
			showFinishMenu();
		}

		protected function onCaptureRequest($event:MouseEvent):void {
			var photoWidth:Number = 320;
			var photoHeight:Number = 240;
			var rec:Rectangle = new Rectangle(0, 0, photoWidth, photoHeight);
			var bitmapData:BitmapData = new BitmapData(photoWidth, photoHeight);
			bitmapData.draw(_video, null, null, null, rec, false);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmap.scaleX = -1;
			bitmap.x = bitmap.width;
			wcController.setCaptureImage(bitmap);
		}

		protected function showCaptureMenu($add:Boolean = true):void {
			addElement(captureImageButton, $add);
			addElement(cancelButton, $add);
		}

		protected function showFinishMenu($add:Boolean = true):void {
			addElement(finishButton, $add);
			addElement(cancelButton, $add);
		}

		protected function showVideo($add:Boolean = true):void {
			if(!_video) {
				_video = new Video(wcModel.videoWidth, wcModel.videoHeight);
				_video.scaleX = -1;
				_video.x = _video.width;
				_video.y = 0;
				_video.attachCamera(wcModel.webCamera);
			}
			addVideo(_video, $add);
		}

		protected function addVideo($video:Video, $add:Boolean = true):void {
			addElement($video, $add);
		}

		protected function destructVideo():void {
			if(_video) {
				_video.attachCamera(null);
			}
		}

	}
}