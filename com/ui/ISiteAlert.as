package com.ui {

	import com.interfaces.IDisplayObject;

	import flash.display.Sprite;

	public interface ISiteAlert extends IDisplayObject {

		function set message($message:String):void;
		function get container():Sprite;
		function get content():Sprite;

	}
}