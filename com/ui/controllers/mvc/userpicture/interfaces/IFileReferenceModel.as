package com.ui.controllers.mvc.userpicture.interfaces {

	import com.ui.controllers.mvc.interfaces.IModel;

	import flash.display.DisplayObject;

	public interface IFileReferenceModel extends IModel {

		function set filename($value:String):void;
		function get filename():String;
		function set fileUpURL($value:String):void;
		function get fileUpURL():String;
		function set file($value:DisplayObject):void;
		function get file():DisplayObject;
		function set terms($value:Boolean):void;
		function get terms():Boolean;
		function set serverUploadURL($value:String):void;
		function get serverUploadURL():String;
		function set serverUploadFilename($value:String):void;
		function get serverUploadFilename():String;
		function set filesnames($value:Array):void;
		function get filesnames():Array;
		
	}
}