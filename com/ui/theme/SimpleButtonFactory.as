package com.ui.theme {

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextFieldAutoSize;

	public class SimpleButtonFactory {

		public function SimpleButtonFactory() {}

		static public function getButton($text:String):SimpleButton {
			var overButton:MovieClip = setButtonSize(new AlertGeneralButtonOver_mc(), $text);
			var hitButton:MovieClip = new AlertGeneralButtonHit_mc();
			hitButton.width = overButton.width;
			var button:SimpleButton = new SimpleButton(setButtonSize(new AlertGeneralButtonUp_mc(), $text), overButton,
														setButtonSize(new AlertGeneralButtonDown_mc(), $text), hitButton);
			return button;
		}

		static protected function setButtonSize($button:MovieClip, $text:String):MovieClip {
			var currentButton:MovieClip = $button;
			currentButton._txt.multiline = false;
			currentButton._txt.wordWrap = false;
			currentButton._txt.autoSize = TextFieldAutoSize.CENTER;
			currentButton._txt.text = $text;
			if(currentButton.back && currentButton._txt.width > currentButton.back.width) {
				currentButton.back.width = currentButton._txt.width + 20;
				currentButton._txt.x = (currentButton.back.width - currentButton._txt.width) / 2;
			}
			return currentButton;
		}
	}
}