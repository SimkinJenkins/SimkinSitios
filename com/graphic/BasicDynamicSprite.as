package com.graphic {

	import com.display.SpriteContainer;
	import com.geom.ComplexPoint;
	import com.ui.controllers.events.StageEvent;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.profiler.showRedrawRegions;

	public class BasicDynamicSprite extends SpriteContainer {

		public static const ON_STATUS_CHANGE:String = "onChange";

		protected static const INACTIVE:String = "inactive";

		protected var _controlsContainer:Sprite;
		protected var _borderContainer:Sprite;
		protected var _bounds:Rectangle = new Rectangle(1, 1, 1, 1);
		protected var _originBounds:Rectangle;
		protected var _registerPoint:ComplexPoint;
		protected var _borderColor:uint = 0x324532;
//		protected var _fillColor:uint = 0xADBC34;
		protected var _currentAction:String = INACTIVE;
		protected var _limits:Rectangle;
		protected var _container:Sprite;
		protected var _registerPointSetted:Boolean = false;

		override public function set filters($value:Array):void {
			_container.filters = $value;
		}

		override public function set x($value:Number):void {
			_bounds.x = $value;
			bounds = _bounds;
		}

		override public function set y($value:Number):void {
			_bounds.y = $value;
			bounds = _bounds;
		}

		override public function get x():Number {
			return _bounds.x;
		}

		override public function get y():Number {
			return _bounds.y;
		}

		override public function get numChildren():int {
			return _container.numChildren;
		}

		public function get controlsContainer():Sprite {
			return _controlsContainer;
		}

		public function set limits($value:Rectangle):void {
			_limits = $value;
			if(_originBounds) {
				bounds = _bounds;
			}
		}

		public function get limits():Rectangle {
			return _limits;
		}

		public function get origin():Rectangle {
			return _originBounds;
		}

		public function set bounds($value:Rectangle):void {
			_bounds = getValidBounds($value);
			if(!_originBounds) {
				_originBounds = _bounds;
			}
			trace("bounds :: " + $value);
			setRegisterPoint();
			updateContainerBounds();
			drawBorder();
		}

		public function get bounds():Rectangle {
			return _bounds;
		}

 		public function BasicDynamicSprite() {
			super();
			initialize();
		}

		override public function addChild($child:DisplayObject):DisplayObject {
			if(!_originBounds) {
				bounds = _originBounds = new Rectangle($child.x, $child.y, $child.width, $child.height);
			}
			return _container.addChild($child);
		}

		override public function removeChild($child:DisplayObject):DisplayObject {
			var child:DisplayObject;
			if(_container == $child.parent) {
				child = _container.removeChild($child);
			}
			if(_container.numChildren == 0) {
				initBounds();
			}
			return child;
		}

		override public function getChildAt($index:int):DisplayObject {
			return _container.getChildAt($index);
		}

		public function destruct():void {
			addContainers(false);
			initBounds();
			_container = null;
			_controlsContainer = null;
			_borderContainer = null;
		}

		protected function doCurrentAction():void {
			switch(_currentAction) {
				case INACTIVE:		doInactive();		break;
			}
		}

		protected function initialize():void {
			_container = new Sprite();
			_controlsContainer = new Sprite();
			_borderContainer = new Sprite();
			addContainers();
		}

		protected function initBounds():void {
			_bounds = new Rectangle(1, 1, 1, 1);
			_originBounds = null;
		}

		protected function addContainers($add:Boolean = true):void {
			if($add) {
				super.addChild(_container);
				super.addChild(_controlsContainer);
			} else {
				super.removeChild(_container);
				super.removeChild(_controlsContainer);
			}
			addElement(_borderContainer, $add, _controlsContainer);
		}

		protected function setCurrentAction($io:InteractiveObject = null):void {
			var newState:String = getCurrentAction($io);
			if(_currentAction != newState) {
				_currentAction = newState;
				dispatchEvent(new StageEvent(ON_STATUS_CHANGE, _currentAction));
			}
		}

		protected function getCurrentAction($io:InteractiveObject = null):String {
			return INACTIVE;
		}

		protected function doInactive():void {
			trace("doInactive");
		}

		protected function drawBorder():void {
			_borderContainer.graphics.clear();
			_borderContainer.graphics.lineStyle(1, _borderColor);
			_borderContainer.graphics.moveTo(_bounds.left, _bounds.top);
			_borderContainer.graphics.lineTo(_bounds.right, _bounds.top);
			_borderContainer.graphics.lineTo(_bounds.right, _bounds.bottom);
			_borderContainer.graphics.lineTo(_bounds.left, _bounds.bottom);
			_borderContainer.graphics.lineTo(_bounds.left, _bounds.top);

			if(_registerPoint) {
				_borderContainer.graphics.beginFill(0x234ABC, 1);
				_borderContainer.graphics.drawCircle(_registerPoint.x, _registerPoint.y, 3);
				_borderContainer.graphics.endFill();
			}
		}

		protected function getValidBounds($bounds:Rectangle):Rectangle {
			if(!_limits) {
				return $bounds;
			}
			$bounds.width = getValidWidth($bounds);
			$bounds.height = getValidHeight($bounds);
			return new Rectangle(getValidX($bounds), getValidY($bounds), $bounds.width, $bounds.height);
		}

		protected function updateContainerBounds():void {
			_container.x = _bounds.x;
			_container.y = _bounds.y;
			_container.scaleX = _bounds.width / _originBounds.width;
			_container.scaleY = _bounds.height / _originBounds.height;
		}

		protected function getValidX($bounds:Rectangle):Number {
			return Math.max(_limits.x, Math.min($bounds.x, _limits.right - $bounds.width));
		}

		protected function getValidY($bounds:Rectangle):Number {
			return Math.max(_limits.y, Math.min($bounds.y, _limits.bottom - $bounds.height));
		}

		protected function getValidWidth($bounds:Rectangle):Number {
			return $bounds.width;
		}

		protected function getValidHeight($bounds:Rectangle):Number {
			return $bounds.height;
		}

		protected function setRegisterPoint($value:ComplexPoint = null):void {
			if($value) {
				_registerPoint = $value;
				_registerPointSetted = true;
			} else {
				if(!_registerPointSetted) {
					_registerPoint = new ComplexPoint(_bounds.x + (_bounds.width / 2), _bounds.y + (_bounds.height / 2));
				}
			}
		}

	}

}