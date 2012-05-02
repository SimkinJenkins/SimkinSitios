package com.ui.controllers.mvc.userpicture {

	import com.core.config.URLManager;
	import com.ui.controllers.mvc.models.BasicModel;
	import com.ui.controllers.mvc.userpicture.interfaces.IFileReferenceModel;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class BasicFileReferenceModel extends BasicModel implements IFileReferenceModel {

		public static const ON_TERMS_CHANGE:String = "onTermsChange";

		protected var _filename:String;
		protected var _fileUpURL:String;
		protected var _serverUploadURL:String;
		protected var _serverUploadFilename:String = "Filedata";
		protected var _terms:Boolean = true;
		protected var _selectedPhoto:DisplayObject;
		protected var _file:DisplayObject;
		protected var _filesnames:Array;

		public function set filesnames($value:Array):void {
			_filesnames = $value;
		}
		
		public function get filesnames():Array {
			return _filesnames;
		}
		
		public function set file($value:DisplayObject):void {
			_file = $value;
		}
		
		public function get file():DisplayObject {
			return _file;
		}
		
		public function set selectedPhoto($value:DisplayObject):void {
			_selectedPhoto = $value;
		}

		public function get selectedPhoto():DisplayObject {
			return _selectedPhoto;
		}

		public function set filename($value:String):void {
			_filename = $value;
		}

		public function get filename():String {
			return _filename;
		}

		public function set serverUploadURL($value:String):void {
			_serverUploadURL = $value;
		}

		public function get serverUploadURL():String {
			return _serverUploadURL;
		}

		public function set serverUploadFilename($value:String):void {
			_serverUploadFilename = $value;
		}

		public function get serverUploadFilename():String {
			return _serverUploadFilename;
		}

		public function set fileUpURL($value:String):void {
			_fileUpURL = URLManager.getInstance().getPath("serviceBase") + $value;
		}

		public function get fileUpURL():String {
			return _fileUpURL;
		}

		public function set terms($value:Boolean):void {
			_terms = $value;
			dispatchEvent(new Event(ON_TERMS_CHANGE));
		}

		public function get terms():Boolean {
			return _terms;
		}

		public function BasicFileReferenceModel() {
			super();
		}

		override protected function initialize():void {
			super.initialize();
			_currentState = BasicFileReferenceStates.INIT;
		}

		override protected function getErrorPhrase($ID:String):String {
			switch($ID) {
				case "termsError":	return "Error de Terminos y condiciones"; 
			}
			return "Desconocido: " + $ID;
		}

		override public function setState($ID:String):void {
			trace("setState :: " + $ID);
			super.setState($ID);
		}

	}
}