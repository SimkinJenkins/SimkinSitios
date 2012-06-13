package com.graphic {

	import com.geom.ComplexPoint;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ResizableDynamicSpriteButton extends BasicDynamicSpriteButton {

		public static const RESIZE_STATE:String = "resize";

		public static const	TOP_LEFT:String = "tl";
		public static const	TOP_RIGHT:String = "tr";
		public static const	BOTTOM_LEFT:String = "bl";
		public static const	BOTTOM_RIGHT:String = "br";

		protected var _resizeBtn:Sprite;
		protected var _currentAction:String;

		override public function set position($value:ComplexPoint):void {
			super.position = $value;
			moveTo($value.x, $value.y);
		}

		public function get currentAction():String {
			return _currentAction;
		}

		public function ResizableDynamicSpriteButton($type:String) {
			super($type);
		}

		public function moveTo($x:Number, $y:Number):void {
			super.x = $x;
			super.y = $y;
		}

		override protected function drawButton():void {
			super.drawButton();
			if(!_resizeBtn) {
				_resizeBtn = new Sprite();
				_resizeBtn.graphics.clear();
				_resizeBtn.graphics.lineStyle(1, _borderColor);
				_resizeBtn.graphics.beginFill(_fillColor);
				_resizeBtn.graphics.drawRect(-_size / 4, -_size / 4, _size / 2, _size / 2);
				_resizeBtn.graphics.endFill();
				addElement(_resizeBtn);
				addListener(_resizeBtn, MouseEvent.ROLL_OVER, onBtnMouseAction);
				addListener(_resizeBtn, MouseEvent.ROLL_OUT, onBtnMouseAction);
			}
		}

		protected function onBtnMouseAction($event:MouseEvent):void {
			if($event.type == MouseEvent.ROLL_OVER) {
				_currentAction = getCurrentAction($event.currentTarget as InteractiveObject);
				trace("onBtnMouseAction :: " + _currentAction);
			} else if($event.type == MouseEvent.ROLL_OUT) {
				_currentAction = "";
			}
		}

		protected function getCurrentAction($io:InteractiveObject):String {
			if($io == _resizeBtn) {
				return RESIZE_STATE;
			}
			return "";
		}

	}

}