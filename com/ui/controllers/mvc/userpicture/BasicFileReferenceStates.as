package com.ui.controllers.mvc.userpicture {

	public class BasicFileReferenceStates {
		//View Request
		public static const SELECT:String = "onSelect";
		public static const CHANGE:String = "onChange";
		public static const ADD:String = "onAdd";
		public static const TERMS:String = "terms";
		//Model State
		public static const INIT:String = "init";
		public static const FILE_SELECTED:String = "fileSelected";
		public static const FILE_LOADED:String = "fileloaded";
		public static const FILE_UPLOADED:String = "fileUploaded";
		public static const LOADING_FILE:String = "loadingFile";
		public static const PROCESING_FILE:String = "procesingFile";
		//Errors
		public static const TERMS_ERROR:String = "termsError";
		public static const UPLOAD_ERROR:String = "serverError";
	}
}