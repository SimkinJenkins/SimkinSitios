package com.ui.controllers.mvc.fbpicture {

	import com.ui.controllers.mvc.interfaces.IModel;

	public interface IPhotoPicker extends IModel {

		function set albums($uid:Array):void;
		function get albums():Array;
		function set photos($aid:Array):void;
		function get photos():Array;
		function set uid($user:String):void;
		function get uid():String;
		function set aid($album:String):void;
		function get aid():String;
		function set needLogin($value:Boolean):void;
		function get needLogin():Boolean;

	}
}