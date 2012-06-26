package com.etnia.graphic {

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import net.etnia.engine3d.projection2d.math3d.ComplexPoint;

	public class RotatableDynamicSprite extends ResizableDynamicSprite {

		public static const ROTATING:String = "rotating";

		protected var _rotationSprite:Sprite;
		protected var _rotation:Number = 0;
		protected var _lastRotation:Number = 0;
		protected var _startingAngle:Number = 0;
		protected var _rotateCursor:Sprite;
		protected var _initButtonPos:ComplexPoint;

		override public function get rotation():Number {
			return _rotation;
		}

		override public function set rotation($value:Number):void {
			_rotation = $value;
			bounds = _bounds;
		}

		public function set rotateCursor($value:Sprite):void {
			_rotateCursor = $value;
		}

		public function RotatableDynamicSprite() {
			super();
		}

		override protected function initialize():void {
			super.initialize();
			_rotationSprite = new Sprite();
			addElement(_rotationSprite, true, _controlsContainer);
		}

		override protected function getCurrentAction($io:InteractiveObject = null):String {
			switch($io) {
				case getButtonAt(0):
				case getButtonAt(1):
				case getButtonAt(2):
				case getButtonAt(3):
					var action:String = ($io as ResizableDynamicSpriteButton).currentAction;
					if(($io as ResizableDynamicSpriteButton).currentAction == RotatableDynamicSpriteButton.ROTATE_STATE) {
						return ROTATING;
					}
					break;
			}
			return super.getCurrentAction($io);
		}

		override protected function getButtonInstance($type:String):InteractiveObject {
			return new RotatableDynamicSpriteButton($type);
		}

		override protected function doCurrentAction():void {
			super.doCurrentAction();
			switch(_currentAction) {
				case ROTATING:		doRotate();			break;
			}
		}

		override protected function setStartingPoint():void {
			super.setStartingPoint();
			if(_currentAction == ROTATING) {
				var currentButtonPosition:ComplexPoint = (_currentButton as BasicDynamicSpriteButton).position;
				_lastRotation = _rotation;
				_startingAngle = currentButtonPosition.getAngle(_registerPoint);
			}
		}


		override protected function drawBorder():void {
			if(getButtonAt(0) && getButtonAt(0).position) {
				_borderContainer.graphics.clear();
				_borderContainer.graphics.lineStyle(3, 0x000000, .5);
				var p0:ComplexPoint = (new ComplexPoint(_bounds.left, _bounds.top)).rotateAxisPoint(-_rotation, _registerPoint);
				var p1:ComplexPoint = (new ComplexPoint(_bounds.right, _bounds.top)).rotateAxisPoint(-_rotation, _registerPoint);
				var p2:ComplexPoint = (new ComplexPoint(_bounds.right, _bounds.bottom)).rotateAxisPoint(-_rotation, _registerPoint);
				var p3:ComplexPoint = (new ComplexPoint(_bounds.left, _bounds.bottom)).rotateAxisPoint(-_rotation, _registerPoint);
				_borderContainer.graphics.moveTo(p0.x, p0.y);
				_borderContainer.graphics.lineTo(p1.x, p1.y);
				_borderContainer.graphics.lineTo(p2.x, p2.y);
				_borderContainer.graphics.lineTo(p3.x, p3.y);
				_borderContainer.graphics.lineTo(p0.x, p0.y);
			} else {
				super.drawBorder();
			}
		}

		override protected function updateCornerButtons():void {
			super.updateCornerButtons();
			for(var i:uint = 0; i < 4; i++) {
				var button:BasicDynamicSpriteButton = getButtonAt(i);
				button.position = button.position.rotateAxisPoint(-_rotation, _registerPoint);
				button.rotation = _rotation;
			}
		}

		override protected function doInactive():void {
			super.doInactive();
			_startingAngle = 0;
			_lastRotation = 0;
			_initButtonPos = null;
		}

		override protected function updateContainerBounds():void {
			super.updateContainerBounds();
			_container.rotation = _rotation;
			var containerPos:ComplexPoint = (new ComplexPoint(_bounds.x, _bounds.y)).rotateAxisPoint(-_rotation, _registerPoint);
			_container.x = containerPos.x;
			_container.y = containerPos.y;
		}

		override protected function getCurrentPosition($type:String, $width:Number, $height:Number):ComplexPoint {
			switch($type) {
				case ResizableDynamicSpriteButton.TOP_LEFT:			return new ComplexPoint(this.mouseX, this.mouseY).rotateAxisPoint(_rotation, _registerPoint);
				case ResizableDynamicSpriteButton.TOP_RIGHT:		return (new ComplexPoint(this.mouseX, this.mouseY)).rotateAxisPoint(_rotation, _registerPoint).moveToPolar($width, -180);
				case ResizableDynamicSpriteButton.BOTTOM_LEFT:		return (new ComplexPoint(this.mouseX, this.mouseY)).rotateAxisPoint(_rotation, _registerPoint).moveToPolar($height, -90);
				case ResizableDynamicSpriteButton.BOTTOM_RIGHT:		return new ComplexPoint(_bounds.x, _bounds.y);
			}
			return new ComplexPoint();
		}

		override protected function doResize():void {
			trace("doResize");
			var referencePoint:ComplexPoint = getReferencePoint((_currentButton as BasicDynamicSpriteButton).type);
			var dragPoint:ComplexPoint = new ComplexPoint(this.mouseX, this.mouseY);
			var referencePointR:ComplexPoint = referencePoint.rotateAxisPoint(_rotation, _registerPoint);
			var dragPointR:ComplexPoint = dragPoint.rotateAxisPoint(_rotation, _registerPoint);
			var currentPosition:ComplexPoint = getCurrentPosition((_currentButton as BasicDynamicSpriteButton).type, Math.abs(dragPointR.x - referencePointR.x), Math.abs(dragPointR.y - referencePointR.y));
			var newBounds:Rectangle = new Rectangle(currentPosition.x, currentPosition.y, Math.abs(dragPointR.x - referencePointR.x), Math.abs(dragPointR.y - referencePointR.y));
			var newReference:ComplexPoint = (new ComplexPoint(newBounds.x + (newBounds.width / 2), newBounds.y + (newBounds.height / 2)));
			var newPostion:ComplexPoint = getBoundsCorner(newBounds, (_currentButton as BasicDynamicSpriteButton).type).rotateAxisPoint(-_rotation, newReference);
			var delta:ComplexPoint = newPostion.clonePoint().minus(dragPoint);
			bounds = new Rectangle(newBounds.x - delta.x, newBounds.y - delta.y, newBounds.width, newBounds.height);;
		}

		override protected function onButtonMouseEvent($event:Event):void {
			super.onButtonMouseEvent($event);
			if(!_rotateCursor) {
				return;
			}
			if(getCurrentAction($event.currentTarget as InteractiveObject) == ROTATING) {
				showResizingCursor($event.currentTarget as InteractiveObject, $event.type == MouseEvent.MOUSE_OVER);
			}
		}

		override protected function whileCursorShow($event:Event):void {
			super.whileCursorShow($event);
			if(_rotateCursor) {
				_rotateCursor.x = this.mouseX;
				_rotateCursor.y = this.mouseY;
			}
		}

		override protected function showCursor($element:InteractiveObject, $add:Boolean = true):void {
			super.showCursor($element, $add);
			if(getCurrentAction($element) == ROTATING || (_currentAction == INACTIVE && !$add)) {
				addElement(_rotateCursor, $add, _borderContainer);
			}
		}

		override protected function onButtonMouseUp($event:MouseEvent):void {
			if(_currentAction == ROTATING) {
				_deltaReferencePoint = getButtonAt(0).position.clonePoint().minus(new ComplexPoint(_bounds.x, _bounds.y));
				trace("_deltaReferencePoint ::: " + _deltaReferencePoint);
			}
			super.onButtonMouseUp($event);
		}

		protected function getBoundsCornerByIndex($bounds:Rectangle, $index:uint):ComplexPoint {
			switch($index) {
				case 0:		return getBoundsCorner($bounds, ResizableDynamicSpriteButton.TOP_LEFT);
				case 1:		return getBoundsCorner($bounds, ResizableDynamicSpriteButton.TOP_RIGHT);
				case 2:		return getBoundsCorner($bounds, ResizableDynamicSpriteButton.BOTTOM_RIGHT);
				case 3:		return getBoundsCorner($bounds, ResizableDynamicSpriteButton.BOTTOM_LEFT);
			}
			return new ComplexPoint();
		}

		protected function getBoundsCorner($bounds:Rectangle, $type:String):ComplexPoint {
			switch($type) {
				case ResizableDynamicSpriteButton.TOP_LEFT:			return new ComplexPoint($bounds.left, $bounds.top);
				case ResizableDynamicSpriteButton.TOP_RIGHT:		return new ComplexPoint($bounds.right, $bounds.top);
				case ResizableDynamicSpriteButton.BOTTOM_LEFT:		return new ComplexPoint($bounds.left, $bounds.bottom);
				case ResizableDynamicSpriteButton.BOTTOM_RIGHT:		return new ComplexPoint($bounds.right, $bounds.bottom);
			}
			return new ComplexPoint();
		}

		protected function doRotate():void {
			trace("doRotate");
			var mousePoint:ComplexPoint = new ComplexPoint(this.mouseX, this.mouseY);
			_rotation = _lastRotation - (_startingAngle - mousePoint.getAngle(_registerPoint));
			bounds = _bounds;
		}

	}
}