package com.ui.controllers.mvc.userpicture.views {

	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	import com.ui.controllers.mvc.webcam.BasicWebcamStates;
	import com.ui.controllers.mvc.webcam.BasicWebcamView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Video;
	
	public class StandardWebcamView extends BasicWebcamView implements IView {

		protected var _preview:Sprite;
		protected var _previewMask:Sprite;
		protected var _webCamContainerPosition:Point;
		protected var _webCamPreviewPosition:Point;
		
		public function set webCamContainerPosition($value:Point):void {
			_webCamContainerPosition = $value;
		}
		
		public function set webCamPreviewPosition($value:Point):void {
			if($value) {
				_webCamPreviewPosition = $value;
			}
		}

		public function set previewMask($value:Sprite):void {
			_previewMask = $value;
		}

		override protected function get cancelButton():InteractiveObject {
			return graphicMC.cancelButton;
		}

		override protected function get finishButton():InteractiveObject {
			return graphicMC.finishButton;
		}

		override protected function get captureImageButton():InteractiveObject {
			return graphicMC.captureImageButton;
		}

		protected function get videoMask():DisplayObject {
			return graphicMC.videoMask;
		}

		protected function get videoContainer():DisplayObjectContainer {
			return graphicMC.videoContainer;
		}

		protected function get backText():InteractiveObject {
			return graphicMC.backText;
		}

		protected function get backButton():InteractiveObject {
			return graphicMC.backButton;
		}

		protected function get webcamConfButton():InteractiveObject {
			return graphicMC.webcamButton;
		}

		protected function get privacyButton():InteractiveObject {
			return graphicMC.privacyButton;
		}

		public function StandardWebcamView($model:IModel, $controller:IController = null, $graphic:Sprite=null) {
			super($model, $controller, $graphic);
		}

		public function init():void {
			formController.clickHandler(BasicWebcamStates.ON_CAMERA_STARTING);
		}

		override protected function addGraphic($add:Boolean = true):void {}

		override public function destructor():void {
			addButtonListeners(false);
			if(_preview) {
				_preview.mask = null;
				addElement(_preview, false);
			}
			super.destructor();
			addListener(_model, Event.CHANGE, stateUpdate, false);
		}

		override protected function initialize():void {
			_webCamContainerPosition = new Point();
			_webCamPreviewPosition = new Point(100, 100);
			super.initialize();
		}

		override protected function initGraphic():void {
			addButtonListeners();
		}

		override protected function addVideo($video:Video, $add:Boolean = true):void {
			super.addVideo($video, $add);
		}

		override protected function onCaptureAgain():void {
			super.onCaptureAgain();
			if(_preview) {
				addElement(wcModel.capturedImage, false, (_preview as MovieClip).content);
			} else if(videoContainer) {
				addElement(wcModel.capturedImage, false, videoContainer);
			} else {
				addElement(wcModel.capturedImage, false);
			}	
			if(_previewMask){
				wcModel.capturedImage.mask = _previewMask;
			}else{
				wcModel.capturedImage.mask = null;
			}
			addVideo(_video);
		}

		override protected function onImageCaptured():void {
			formController.clickHandler(BasicFormStates.ON_FINISH_BTN);
			return;
			super.onImageCaptured();
			_video.visible = false;
			if(_preview) {
				wcModel.capturedImage.x = _webCamContainerPosition.x;
				wcModel.capturedImage.y = _webCamContainerPosition.y;
				if(_preview as MovieClip) {
					addElement(wcModel.capturedImage, true, (_preview as MovieClip).content);
				} else {
					addElement(wcModel.capturedImage, true, _preview);
				}
				if(_previewMask){
					wcModel.capturedImage.mask = _previewMask;
				}else{
					wcModel.capturedImage.mask = (_preview as MovieClip).content._mask;
				}
			} else if(videoContainer) {
				wcModel.capturedImage.x = 0;
				wcModel.capturedImage.width = _video.width;
				wcModel.capturedImage.height = _video.height;
				addElement(wcModel.capturedImage, true, videoContainer);
				if(_previewMask){
					videoContainer.mask = _previewMask;
				}else{
					videoContainer.mask = videoMask;
				}
			} else {
				addElement(wcModel.capturedImage);
				wcModel.capturedImage.x = _webCamContainerPosition.x;
				wcModel.capturedImage.y = _webCamContainerPosition.y;
			}
		}

		override protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case backButton:			return BasicFormStates.ON_CANCEL_BTN;
				case webcamConfButton:		return BasicWebcamStates.ON_CAMERA_SETTINGS;
				case privacyButton:			return BasicWebcamStates.ON_PRIVACY_SETTINGS;
			}
			return super.getButtonID($button);
		}

		override protected function showCaptureMenu($add:Boolean = true):void {
			super.showCaptureMenu($add);
		}

		override protected function showFinishMenu($add:Boolean = true):void {
			super.showFinishMenu($add);
			addElement(cancelButton, !$add);
			addElement(backText, $add);
			addElement(backButton, $add);
		}

		override protected function showVideo($add:Boolean = true):void {
			super.showVideo($add);
		}

		override protected function onCaptureRequest($event:MouseEvent):void {
			_video.mask = null;
			super.onCaptureRequest($event);
		}

		protected function addButtonListeners($add:Boolean = true):void {
			addListener(backButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(finishButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(cancelButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(captureImageButton, MouseEvent.CLICK, onCaptureRequest, $add);
			addListener(privacyButton, MouseEvent.CLICK, clickHandler, $add);
			addListener(webcamConfButton, MouseEvent.CLICK, clickHandler, $add);
		}

	}
}