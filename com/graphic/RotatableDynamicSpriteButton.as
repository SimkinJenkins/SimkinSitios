package com.graphic {

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class RotatableDynamicSpriteButton extends ResizableDynamicSpriteButton {

		public static const ROTATE_STATE:String = "rotate";

		protected var _rotateBtn:Sprite;

		public function RotatableDynamicSpriteButton($type:String) {
			super($type);
		}

		override protected function drawButton():void {
			if(!_rotateBtn) {
				_rotateBtn = new Sprite();
				_rotateBtn.graphics.clear();
				_rotateBtn.graphics.lineStyle(1, _borderColor);
				_rotateBtn.graphics.beginFill(_fillColor, 0);
				switch(_type) {
					case TOP_LEFT:			_rotateBtn.graphics.drawRect(-_size * .75 , -_size * .75, _size, _size);		break;
					case TOP_RIGHT:			_rotateBtn.graphics.drawRect(-_size * .25 , -_size * .75, _size, _size);		break;
					case BOTTOM_LEFT:		_rotateBtn.graphics.drawRect(-_size * .75 , -_size * .25, _size, _size);		break;
					case BOTTOM_RIGHT:		_rotateBtn.graphics.drawRect(-_size * .25 , -_size * .25, _size, _size);		break;
				}
				_rotateBtn.graphics.endFill();
				addElement(_rotateBtn);
				_rotateBtn.name = "rotate";
				addListener(_rotateBtn, MouseEvent.ROLL_OVER, onBtnMouseAction);
				addListener(_rotateBtn, MouseEvent.ROLL_OUT, onBtnMouseAction);
			}
			super.drawButton();
		}

		override protected function getCurrentAction($io:InteractiveObject):String {
			var state:String = super.getCurrentAction($io);
			if($io == _rotateBtn && state == "") {
				return ROTATE_STATE;
			}
			return state;
		}

	}
}