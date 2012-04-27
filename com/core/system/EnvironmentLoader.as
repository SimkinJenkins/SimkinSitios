package com.core.system {
	
	import com.core.Main;
	import com.interfaces.IClient;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class EnvironmentLoader extends SimpleEnvironmentLoader {

		public function EnvironmentLoader() {
			super();
			init();
		}

		override protected function createMain():void {
			try {
				_mainClient = getMain();
				_mainClient.addEventListener(SimpleSystemLoader.ON_CLIENT_READY, onClientReady);
				_mainClient.initialize();
				addChild(_mainClient as DisplayObject);
			} catch ($error:Error) {
				graphics.beginFill(0x112233)
				graphics.drawCircle(100, 100, 100);
				var text:TextField = new TextField();
				text.text = "URL :_: " + $error;
				addChild(text);
				onCreateMainError($error);	
			}
		}

		protected function onCreateMainError($error:Error):void {
			trace("Error", $error.message);
		}

		protected function getMain():IClient {
			return new Main(_environment.initConfigPath + _environment.URLSData);
		}

		protected function onClientReady($event:Event):void {
			trace("APP Main Client Ready");
		}

	}
}