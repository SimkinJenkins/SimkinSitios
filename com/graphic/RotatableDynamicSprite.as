package com.graphic {

	import com.geom.ComplexPoint;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.globalization.LastOperationStatus;

	public class RotatableDynamicSprite extends ResizableDynamicSprite {

		public static const ROTATING:String = "rotating";

		protected var _rotationSprite:Sprite;
		protected var _rotation:Number = 0;
		protected var _lastRotation:Number = 0;
		protected var _startingAngle:Number = 0;

		protected var _rotatePoint:ComplexPoint;
		protected var _updateRotateContainer:Boolean = true;
		protected var _lastContainerDelta:ComplexPoint = new ComplexPoint();
		protected var _lastRotationContainer:Number = 0;

		override public function get rotation():Number {
			return _rotation;
		}

		override public function set rotation($value:Number):void {
			_updateRotateContainer = true;
			_currentAction = ROTATING;
			_rotation = $value - _lastRotationContainer;
			bounds = _bounds;
		}

		public function set rotateRegister($value:ComplexPoint):void {
			_rotatePoint = $value;
		}

		public function RotatableDynamicSprite() {
			super();
		}

		public function endManualRotation():void {
			_lastAction = ROTATING;
			_currentAction = INACTIVE;
			endRotation();
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
			_updateRotateContainer = true;
			if(_currentAction == ROTATING) {
				_updateRotateContainer = true;
				var currentButtonPosition:ComplexPoint = (_currentButton as BasicDynamicSpriteButton).position;
				_lastRotation = _rotation;
				_startingAngle = currentButtonPosition.getAngle(getRotationPoint());
			}
		}

		override protected function drawBorder():void {
			if(_cornerPositions && _cornerPositions.length > 1) {
				_borderContainer.graphics.clear();
				_borderContainer.graphics.lineStyle(3, 0x000000, .5);
				_borderContainer.graphics.moveTo(_cornerPositions[0].x, _cornerPositions[0].y);
				_borderContainer.graphics.lineTo(_cornerPositions[1].x, _cornerPositions[1].y);
				_borderContainer.graphics.lineTo(_cornerPositions[2].x, _cornerPositions[2].y);
				_borderContainer.graphics.lineTo(_cornerPositions[3].x, _cornerPositions[3].y);
				_borderContainer.graphics.lineTo(_cornerPositions[0].x, _cornerPositions[0].y);
			} else {
				super.drawBorder();
			}
		}

		override protected function updateCornerButtons():void {
			super.updateCornerButtons();
			for(var i:uint = 0; i < 4; i++) {
				if(_currentAction == ROTATING) {
					_cornerPositions[i] = (_cornerPositions[i] as ComplexPoint).rotateAxisPoint(-_rotation, getRotationPoint());
				} else {
					_cornerPositions[i] = (_cornerPositions[i] as ComplexPoint).rotateAxisPoint(-_rotation, _registerPoint);
				}
			}
		}

		override protected function updateButtonPosition():void {
			super.updateButtonPosition();
			for(var i:uint = 0; i < 4; i++) {
				getButtonAt(i).rotation = _rotation;
			}
		}

		override protected function doInactive():void {
			super.doInactive();
			_startingAngle = 0;
			_lastRotation = 0;
		}

		override protected function updateContainerBounds():void {
			super.updateContainerBounds();
			_container.rotation = _rotation + _lastRotationContainer;
			if(_cornerPositions && _cornerPositions.length > 1) {
				var register:ComplexPoint = new ComplexPoint(_cornerPositions[0].x  + ((_cornerPositions[2].x - _cornerPositions[0].x) / 2),
					_cornerPositions[0].y  + ((_cornerPositions[2].y - _cornerPositions[0].y) / 2));
				var position:ComplexPoint = (_cornerPositions[0] as ComplexPoint).rotateAxisPoint(-_lastRotationContainer, register);
				_lastContainerDelta = new ComplexPoint(position.x - _container.x, position.y - _container.y);
				_container.x = position.x;
				_container.y = position.y;
			}
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
			var referencePoint:ComplexPoint = getReferencePoint((_currentButton as BasicDynamicSpriteButton).type);
			var dragPoint:ComplexPoint = new ComplexPoint(this.mouseX, this.mouseY);
			var referencePointR:ComplexPoint = referencePoint.rotateAxisPoint(_rotation, _registerPoint);
			var dragPointR:ComplexPoint = dragPoint.rotateAxisPoint(_rotation, _registerPoint);
			var currentPosition:ComplexPoint = getCurrentPosition((_currentButton as BasicDynamicSpriteButton).type, Math.abs(dragPointR.x - referencePointR.x), Math.abs(dragPointR.y - referencePointR.y));
			var newBounds:Rectangle = new Rectangle(currentPosition.x, currentPosition.y, Math.abs(dragPointR.x - referencePointR.x), Math.abs(dragPointR.y - referencePointR.y));
			var newReference:ComplexPoint = (new ComplexPoint(newBounds.x + (newBounds.width / 2), newBounds.y + (newBounds.height / 2)));
			var newPosition:ComplexPoint = getBoundsCorner(newBounds, (_currentButton as BasicDynamicSpriteButton).type).rotateAxisPoint(-_rotation, newReference);
			var delta:ComplexPoint = newPosition.clonePoint().minus(dragPoint);
			bounds = new Rectangle(newBounds.x - delta.x, newBounds.y - delta.y, newBounds.width, newBounds.height);
		}

		override protected function onButtonMouseUp($event:MouseEvent):void {
			super.onButtonMouseUp($event);
			endRotation();
		}

		protected function endRotation():void {
			if(_rotatePoint) {
				if(_lastAction == ROTATING) {
					correctBounds();
				}
			}
		}

		protected function correctBounds():void {
			var register:ComplexPoint = new ComplexPoint(_cornerPositions[0].x  + ((_cornerPositions[2].x - _cornerPositions[0].x) / 2),
														_cornerPositions[0].y  + ((_cornerPositions[2].y - _cornerPositions[0].y) / 2));
			var correctedPos:ComplexPoint = (_cornerPositions[0] as ComplexPoint).rotateAxisPoint(_rotation, register);
			bounds = new Rectangle(correctedPos.x, correctedPos.y, _bounds.width, _bounds.height);
			_lastRotationContainer = _container.rotation;
			_rotation = 0;
			_updateRotateContainer = false;
		}

		protected function drawPoint($point:ComplexPoint, $color:uint):void {
			_controlsContainer.graphics.lineStyle(3, $color);
			_controlsContainer.graphics.drawCircle($point.x, $point.y, 5);
			_controlsContainer.graphics.endFill();
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
			var mousePoint:ComplexPoint = new ComplexPoint(this.mouseX, this.mouseY);
			_rotation = _lastRotation - (_startingAngle - mousePoint.getAngle(getRotationPoint()));
			bounds = _bounds;
		}

		protected function getRotationPoint():ComplexPoint {
			return _rotatePoint ? _rotatePoint : _registerPoint;
		}

	}
}