package com.ui.controllers {

	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BasicMenuController extends BasicStageController {

		protected var _selectedButton:InteractiveObject;

		public function BasicMenuController($container:Sprite) {
			super($container);
		}

		public function unselectCurrentButton():void {
			if(_selectedButton) {
				enableButton(_selectedButton);
				_selectedButton = null;
				_stage = null;
				_lastStage = null;
			}
		}

		protected function setOverStateButton($button:InteractiveObject):void {
			trace("setOverStateButton");
		}

		protected function setOutStateButton($button:InteractiveObject):void {
			trace("setOutStateButton");
		}

		protected function setPressStateButton($button:InteractiveObject):void {
			trace("setPressStateButton");
		}

		protected function enableButton($button:InteractiveObject, $enable:Boolean = true):void {
			if($button as MovieClip) {
				enableMcButton($button as MovieClip, $enable);
			} else {
				enableSimpleButton($button as SimpleButton, $enable);
			}
		}

		private function enableMcButton($button:MovieClip, $enable:Boolean = true):void {
			$button.buttonMode = $enable;
			$button.useHandCursor = $enable;
			if($enable) {
				setOutStateButton($button);
			}
			addListener($button, MouseEvent.ROLL_OVER, onButtonRollOver, $enable);
		}

		private function enableSimpleButton($button:SimpleButton, $enable:Boolean = true):void {
			setOutStateButton($button);
			addListener($button, MouseEvent.CLICK, onButtonClick);
		}

		protected function onButtonRollOver($event:MouseEvent):void {
			var button:MovieClip = $event.currentTarget as MovieClip;
			addListener(button, MouseEvent.ROLL_OVER, onButtonRollOver, false);
			addListener(button, MouseEvent.ROLL_OUT, onButtonRollOut);
			addListener(button, MouseEvent.CLICK, onButtonClick);
			setOverStateButton(button);
		}

		protected function onButtonRollOut($event:MouseEvent):void {
			var button:MovieClip = $event.currentTarget as MovieClip;
			addListener(button, MouseEvent.ROLL_OUT, onButtonRollOut, false);
			addListener(button, MouseEvent.CLICK, onButtonClick, false);
			addListener(button, MouseEvent.ROLL_OVER, onButtonRollOver);
			setOutStateButton(button);
		}

		protected function onButtonClick($event:MouseEvent):void {
			var button:InteractiveObject = $event.currentTarget as InteractiveObject;
			if(button as MovieClip) {
				addListener(button, MouseEvent.ROLL_OUT, onButtonRollOut, false);
			}
			addListener(button, MouseEvent.CLICK, onButtonClick, false);
			setStageFor(button);
		}

		protected function getButtonID($button:InteractiveObject):String {
			return START;
		}

		protected function setStageFor($mc:InteractiveObject):void {
			if(_selectedButton) {
				enableButton(_selectedButton);
			}
			enableButton($mc, false);
			_selectedButton = $mc;
			setPressStateButton($mc);
			setStage(getButtonID($mc));
		}
	}
}