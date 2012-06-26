package com.etnia.graphic {

	import fl.core.UIComponent;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import net.etnia.engine3d.projection2d.math3d.ComplexPoint;

	public class ResizableDynamicSprite extends MovableDynamicSprite {

		public static const RESIZING:String = "resizing";

		protected var _cornersButtons:Array;
		protected var _buttonSize:Number = 16;
		protected var _resizeCursor:Sprite;
		protected var _deltaReferencePoint:ComplexPoint = new ComplexPoint();

		override public function set bounds($value:Rectangle):void {
			super.bounds = $value;
			updateCornerButtons();
		}

		public function set resizeCursor($value:Sprite):void {
			_resizeCursor = $value;
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

		override protected function initialize():void {
			super.initialize();
			_cornersButtons = new Array();
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
			showResizingCursor(null, false);
			showCursor(null, false);
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

		protected function showResizingCursor($element:InteractiveObject, $over:Boolean):void {
			if($over) {
				Mouse.hide();
				addCursorListeners($element, false);
				showCursor($element, true);
			} else {
				if(_currentAction != INACTIVE) {
					return;
				}
				Mouse.show();
				addCursorListeners($element, true);
				showCursor($element, false);
			}
		}

		protected function showCursor($element:InteractiveObject, $add:Boolean = true):void {
			if(getCurrentAction($element) == RESIZING || (_currentAction == INACTIVE && !$add)) {
				addElement(_resizeCursor, $add, _borderContainer);
			}
		}

		protected function onButtonMouseEvent($event:Event):void {
			if(!_resizeCursor) {
				return;
			}
			if(getCurrentAction($event.currentTarget as InteractiveObject) == RESIZING) {
				showResizingCursor($event.currentTarget as InteractiveObject, $event.type == MouseEvent.MOUSE_OVER);
			}
		}
		
		protected function addCursorListeners($element:InteractiveObject, $over:Boolean = true, $destruct:Boolean = false):void {
			addListener($element, MouseEvent.MOUSE_OVER, onButtonMouseEvent, $over);
			addListener(_resizeCursor, Event.ENTER_FRAME, whileCursorShow, !$over && !$destruct);
			addListener($element, MouseEvent.MOUSE_OUT, onButtonMouseEvent, !$over && !$destruct);
		}

		protected function whileCursorShow($event:Event):void {
			if(_resizeCursor) {
				_resizeCursor.x = this.mouseX;
				_resizeCursor.y = this.mouseY;
			}
		}

		protected function updateCornerButtons():void {
			getButtonAt(0).position = new ComplexPoint(_bounds.x, _bounds.y);
			getButtonAt(1).position = new ComplexPoint(_bounds.right, _bounds.y)
			getButtonAt(2).position = new ComplexPoint(_bounds.right, _bounds.bottom)
			getButtonAt(3).position = new ComplexPoint(_bounds.x, _bounds.bottom);
			_controlsContainer.graphics.lineStyle(1, 0x223344);
			_controlsContainer.graphics.drawRect(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
			_controlsContainer.graphics.beginFill(0x234234);
			_controlsContainer.graphics.drawCircle(_bounds.x + _deltaReferencePoint.x, _bounds.y + _deltaReferencePoint.y, 10);
			_controlsContainer.graphics.endFill();
		}

		protected function getInteractiveButton($type:String):InteractiveObject {
			var btn:BasicDynamicSpriteButton = getButtonInstance($type) as BasicDynamicSpriteButton;
			btn.size = _buttonSize;
//			(btn as ResizableDynamicSpriteButton).resizeCursor = _resizeCursor;
			_cornersButtons.push(btn);
			addDragListeners(btn);
			addCursorListeners(btn);
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
				case ResizableDynamicSpriteButton.TOP_LEFT:			return getButton(ResizableDynamicSpriteButton.BOTTOM_RIGHT).position;
				case ResizableDynamicSpriteButton.TOP_RIGHT:		return getButton(ResizableDynamicSpriteButton.BOTTOM_LEFT).position;
				case ResizableDynamicSpriteButton.BOTTOM_LEFT:		return getButton(ResizableDynamicSpriteButton.TOP_RIGHT).position;
				case ResizableDynamicSpriteButton.BOTTOM_RIGHT:		return getButton(ResizableDynamicSpriteButton.TOP_LEFT).position;
			}
			return new ComplexPoint();
		}
	}

}