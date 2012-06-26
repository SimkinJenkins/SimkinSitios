package com.graphic {


	import com.geom.ComplexPoint;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ResizableDynamicSprite extends MovableDynamicSprite {

		public static const RESIZING:String = "resizing";

		protected var _cornersButtons:Array;
		protected var _cornerPositions:Array;
		protected var _buttonSize:Number = 16;

		override public function set bounds($value:Rectangle):void {
			super.bounds = $value;
		}

		public function ResizableDynamicSprite() {
			super();
		}

		override public function set scaleX($value:Number):void {
			bounds = new Rectangle(_bounds.x, _bounds.y, _originBounds.width * $value, _bounds.height);
		}

		override public function set scaleY($value:Number):void {
			bounds = new Rectangle(_bounds.x, _bounds.y, _bounds.width, _originBounds.height * $value);
		}

		override public function get scaleX():Number {
			if(_originBounds) {
				return (_bounds.width / _originBounds.width);
			}
			return super.scaleX;
		}

		override public function get scaleY():Number {
			if(_originBounds) {
				return (_bounds.height / _originBounds.height);
			}
			return super.scaleY;
		}

		override public function destruct():void {
			super.destruct();
			destructButtons();
		}

		override protected function updateAfterSetBounds():void {
			updateCornerButtons();
			updateButtonPosition();
			super.updateAfterSetBounds();
		}

		override protected function initialize():void {
			super.initialize();
			_cornersButtons = new Array();
			_cornerPositions = new Array();
		}

		override protected function drawButtons():void {
			super.drawButtons();
			if(_cornersButtons.length == 0) {
				addElement(getInteractiveButton(ResizableDynamicSpriteButton.TOP_LEFT), true, _controlsContainer);
				addElement(getInteractiveButton(ResizableDynamicSpriteButton.TOP_RIGHT), true, _controlsContainer);
				addElement(getInteractiveButton(ResizableDynamicSpriteButton.BOTTOM_RIGHT), true, _controlsContainer);
				addElement(getInteractiveButton(ResizableDynamicSpriteButton.BOTTOM_LEFT), true, _controlsContainer);
			}
		}

		override protected function doCurrentAction():void {
			super.doCurrentAction();
			switch(_currentAction) {
				case RESIZING:		doResize();			break;
			}
		}

		override protected function getCurrentAction($io:InteractiveObject = null):String {
			switch($io) {
				case getButtonAt(0):
				case getButtonAt(1):
				case getButtonAt(2):
				case getButtonAt(3):
								if(($io as ResizableDynamicSpriteButton).currentAction == ResizableDynamicSpriteButton.RESIZE_STATE) {
									return RESIZING;
								}
								break;
			}
			return super.getCurrentAction($io);
		}

		override protected function doInactive():void {
			super.doInactive();
			_currentButton = null;
		}
		override protected function onButtonMouseUp($event:MouseEvent):void {
			addDragListeners(_currentButton, true);
			super.onButtonMouseUp($event);
		}

		override protected function getValidWidth($bounds:Rectangle):Number {
			if(_currentAction == RESIZING) {
				return Math.min(Math.min($bounds.width, _limits.right - $bounds.x), $bounds.right -_limits.left);
			}
			return super.getValidWidth($bounds);
		}

		override protected function getValidHeight($bounds:Rectangle):Number {
			if(_currentAction == RESIZING) {
				return Math.min(Math.min($bounds.height, _limits.bottom - $bounds.y), $bounds.bottom -_limits.top);
			}
			return super.getValidHeight($bounds);
		}

		override protected function showControls($add:Boolean = true):void {
			super.showControls($add);
			for(var i:uint = 0; i < _cornersButtons.length; i++) {
				_cornersButtons[i].alpha = $add && _borderEnabled ? 1 : 0;
			}
			
		}

		protected function updateCornerButtons():void {
			_cornerPositions[0] = new ComplexPoint(_bounds.x, _bounds.y);
			_cornerPositions[1] = new ComplexPoint(_bounds.right, _bounds.y);
			_cornerPositions[2] = new ComplexPoint(_bounds.right, _bounds.bottom);
			_cornerPositions[3] = new ComplexPoint(_bounds.x, _bounds.bottom);
		}

		protected function updateButtonPosition():void {
			for(var i:uint = 0; i < 4; i++) {
				getButtonAt(i).position = _cornerPositions[i];
			}
		}

		protected function getInteractiveButton($type:String):InteractiveObject {
			var btn:BasicDynamicSpriteButton = getButtonInstance($type) as BasicDynamicSpriteButton;
			btn.size = _buttonSize;
			_cornersButtons.push(btn);
			addDragListeners(btn);
			return btn;
		}

		protected function destructButtons():void {
			for(var i:uint = 0; i < _cornersButtons.length; i++) {
				var btn:BasicDynamicSpriteButton = _cornersButtons[i];
				addDragListeners(btn, false, false);
				addElement(btn, false, _controlsContainer);
			}
		}

		protected function getButtonInstance($type:String):InteractiveObject {
			return new ResizableDynamicSpriteButton($type);
		}

		protected function getButton($ID:String):BasicDynamicSpriteButton {
			switch($ID) {
				case ResizableDynamicSpriteButton.TOP_LEFT:			return _cornersButtons[0];
				case ResizableDynamicSpriteButton.TOP_RIGHT:		return _cornersButtons[1];
				case ResizableDynamicSpriteButton.BOTTOM_RIGHT:		return _cornersButtons[2];
				case ResizableDynamicSpriteButton.BOTTOM_LEFT:		return _cornersButtons[3];
			}
			return null;
		}

		protected function doResize():void {
			trace("doResize");
			var referencePoint:ComplexPoint = getReferencePoint((_currentButton as BasicDynamicSpriteButton).type);
			var dragPoint:ComplexPoint = new ComplexPoint(this.mouseX, this.mouseY);
			var currentPosition:ComplexPoint = getCurrentPosition((_currentButton as BasicDynamicSpriteButton).type, Math.abs(dragPoint.x - referencePoint.x), Math.abs(dragPoint.y - referencePoint.y));
			bounds = new Rectangle(currentPosition.x, currentPosition.y, Math.abs(dragPoint.x - referencePoint.x), Math.abs(dragPoint.y - referencePoint.y));
		}

		protected function getButtonAt($index:uint):ResizableDynamicSpriteButton {
			return _cornersButtons[$index];
		}

		protected function getCurrentPosition($type:String, $width:Number, $height:Number):ComplexPoint {
			switch($type) {
				case ResizableDynamicSpriteButton.TOP_LEFT:			return new ComplexPoint(this.mouseX, this.mouseY);
				case ResizableDynamicSpriteButton.TOP_RIGHT:		return (new ComplexPoint(this.mouseX, this.mouseY)).moveToPolar($width, -180);
				case ResizableDynamicSpriteButton.BOTTOM_LEFT:		return (new ComplexPoint(this.mouseX, this.mouseY)).moveToPolar($height, -90);
				case ResizableDynamicSpriteButton.BOTTOM_RIGHT:		return new ComplexPoint(_bounds.x, _bounds.y);
			}
			return new ComplexPoint();
		}

		protected function getReferencePoint($type:String):ComplexPoint {
			switch($type) {
				case ResizableDynamicSpriteButton.TOP_LEFT:			return _cornerPositions[2];
				case ResizableDynamicSpriteButton.TOP_RIGHT:		return _cornerPositions[3];
				case ResizableDynamicSpriteButton.BOTTOM_LEFT:		return _cornerPositions[1];
				case ResizableDynamicSpriteButton.BOTTOM_RIGHT:		return _cornerPositions[0];
			}
			return new ComplexPoint();
		}
	}

}