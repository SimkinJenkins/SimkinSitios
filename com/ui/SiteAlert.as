package com.ui {

	import com.ui.theme.SimpleButtonFactory;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class SiteAlert extends Sprite implements ISiteAlert {

		protected var _content:DisplayObject;
		protected var _buttonsList:Array;
		protected var _buttonsLabelsList: Array;
		protected var _closeButton: SimpleButton;
		protected var _initPositionY: Number;
		protected var _container: Sprite;
		protected var _text: TextField;
		protected var _background: DisplayObject;

		public function set message($message: String): void {
			_content["_txt"]["htmlText"] = $message;
			updateTextPosition()
		}
		
		protected function get bottomMarginButton(): Number{
			return 5;
		}

		public function get message():String {
			return _content["_txt"]["text"];
		}

		public function get container(): Sprite{
			return _container as Sprite;
		}

		public function get content():Sprite {
			return _content as Sprite;
		}

		override public function set width($value:Number):void {
			_background.width = $value;
			arrangeElements();
		}

		override public function set height($value:Number):void {
			_background.height = $value;
			arrangeElements();
		}

		protected function arrangeElements():void {
			_text.x  = _background.x + ((_background.width - _text.width)/2);
			updateTextPosition();
			arrangeCloseButton();
			arrangeButtons();
		}

		protected function arrangeCloseButton():void {
			//_closeButton.x = _background.x + _background.width - 26;
			//_closeButton.y = _background.y + 5.3;
		}

		protected function arrangeButtons():void {
			var buttonsWidth:Number = 0;
			for(var j:uint = 0; j < _buttonsList.length; j++) {
				var btn:SimpleButton = _buttonsList[j] as SimpleButton;
				buttonsWidth += btn.width + 10;
			}
			var currentPos:Number = (_background.width - buttonsWidth) / 2;
			for (var i: int = 0; i<_buttonsList.length; i++) {
				var button : SimpleButton = _buttonsList[i] as SimpleButton;
				button.x = currentPos;
				button.y = _content.height - button.height - 5;
				currentPos += button.width + 10;
			}
		}

		public function SiteAlert($message: String = "", $buttonsLabelsList: Array = null) {
			initialize($message, $buttonsLabelsList != null ? $buttonsLabelsList : new Array());
		}

		public function destruct():void {
			_SiteAlert();
		}

		protected function initialize($message: String, $buttonsLabelsList: Array ): void {
			_content = new Alert_mc();
			_container = new Sprite();
			_buttonsList = new Array();
			_background = (_content as MovieClip)._background;
			_text = _content["_txt"];
			_closeButton = (_content as MovieClip).close_btn;
			_initPositionY = (_content as MovieClip)._txt.y - 5;
			_closeButton.addEventListener(MouseEvent.CLICK, onPressButtonClose);
			addChild(_content);
			addChild(_container);
			addButtons($buttonsLabelsList);
			arrangeElements();
			message = $message;
		}

		protected function updateTextPosition(): void{
			var content: MovieClip = _content as MovieClip;
			var textHeight: Number = (content._txt as TextField).textHeight;
			var height: Number = (content._txt as TextField).height;
			if(textHeight < height) {
				(content._txt as TextField).y = _initPositionY + ((height - textHeight) / 2);
			} else {
				(content._txt as TextField).y = _initPositionY;
			}
		}

		protected function addButtons($buttonsLabelsList : Array): void {
			for (var i: int=0; i<$buttonsLabelsList.length; i++) {
				var button: SimpleButton = getButton($buttonsLabelsList[i]);
				_buttonsList.push(button);
				addChild(button);
				button.addEventListener(MouseEvent.CLICK, onPressButton);
			}
		}

		protected function getButton($label: String):SimpleButton {
			return SimpleButtonFactory.getButton($label);
		}
		
		protected function onPressButton($event : MouseEvent): void {
			dispatchEvent(new AlertEvent(AlertEvent.ON_PRESS_ALERT_BUTTON, getID($event.currentTarget.name)));
			_SiteAlert();
		}

		protected function onPressButtonClose($event : MouseEvent):void {
			dispatchEvent(new AlertEvent(AlertEvent.ON_PRESS_CLOSE_BUTTON, -1));
			_SiteAlert();
		}
		
		protected function _SiteAlert():void {
			var i: int;
			if(_buttonsList) {
				for (i=0; i<_buttonsList.length; i++) {
					var button : SimpleButton = _buttonsList[i] as SimpleButton;
					button.removeEventListener(MouseEvent.CLICK, onPressButton);
					removeChild(button);
				}
				for (i=0; i<_buttonsList.length; i++) {
					_buttonsList[i]= null;
				}
				_buttonsList = null;
			}
			var lenght: int = _container.numChildren;
			for(var index: uint = 0 ; index<lenght ; index++){
				_container.removeChild(_container.getChildAt(0));
			}
			if(_content) {
				removeChild(_content);
			}
			_content = null;
		}
		
		protected function getID($currentName : String):uint {
			var i: int;
			for (i=0; i<_buttonsList.length; i++) {
				if (String (_buttonsList[i]["name"]) == $currentName) {
					break;
				}
			}
			return i;
		}
	}
}