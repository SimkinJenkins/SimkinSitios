package com.etnia.graphic {

	import com.etnia.core.system.EtniaSystem;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import net.etnia.engine3d.projection2d.math3d.ComplexPoint;
	import net.etnia.utils.MathUtils;

	public class MovableDynamicSprite extends BasicDynamicSprite {

		public static const MOVING:String = "moving";

		protected static const MOVEABLE_AREA:Number = .9;
		protected static const FADE_TIMER_DELAY:Number = 400;

		protected var _borderEnabled:Boolean = true;
		protected var _moveButton:Sprite;
		protected var _startingPoint:ComplexPoint;
		protected var _lastBounds:Rectangle;
		protected var _currentButton:InteractiveObject;
		protected var _fadeTimer:Timer;
		protected var _controlsAutoHide:Boolean = true;

		override public function set bounds($value:Rectangle):void {
			super.bounds = $value;
			updateMoveButton();
		}

		public function set controlsAutoHide($value:Boolean):void {
			_controlsAutoHide = $value;
		}

		public function set borderEnabled($value:Boolean):void {
			_borderEnabled = $value;
			showControls($value);
		}
		
		public function get borderEnabled():Boolean {
			return _borderEnabled;
		}

		public function MovableDynamicSprite() {
			super();
			drawButtons();
			if(_controlsAutoHide) {
				showControls(false);
			}
		}

		override public function destruct():void {
			super.destruct();
			showMoveButton(false);
			addHideListeners(false, false);
			destructTimer();
		}

		override protected function doCurrentAction():void {
			super.doCurrentAction();
			switch(_currentAction) {
				case MOVING:		doMove();			break;
			}
		}

		override protected function doInactive():void {
			super.doInactive();
			_startingPoint = null;
			_lastBounds = null;
			_currentButton = null;
		}

		override protected function getCurrentAction($io:InteractiveObject = null):String {
			switch($io) {
				case _moveButton:		return MOVING;
			}
			return super.getCurrentAction($io);
		}

		protected function drawButtons():void {
			showMoveButton();
			addHideListeners();
		}

		protected function updateMoveButton():void {
			drawMoveButton();
			_moveButton.x = _bounds.x + (_bounds.width -_moveButton.width) / 2;
			_moveButton.y = _bounds.y + (_bounds.height - _moveButton.height) / 2;
		}

		protected function drawMoveButton():void {
			_moveButton.graphics.clear();
			_moveButton.graphics.beginFill(0x546456, 0);
			_moveButton.graphics.drawRect(0, 0, _bounds.width * MOVEABLE_AREA, _bounds.height * MOVEABLE_AREA);
			_moveButton.graphics.endFill();
		}

		protected function showMoveButton($add:Boolean = true):void {
			if(!_moveButton) {
				_moveButton = new Sprite();
				updateMoveButton();
			}
			addElement(_moveButton, $add, _controlsContainer);
			addDragListeners(_moveButton, $add);
		}

		protected function onButtonMouseDown($event:MouseEvent):void {
			_currentButton = $event.currentTarget as InteractiveObject;
			addDragListeners(_currentButton, false);
			addHideListeners(true, true);
			setCurrentAction(_currentButton);
			setStartingPoint();
			doCurrentAction();
		}

		protected function setStartingPoint():void {
			_startingPoint = new ComplexPoint(this.mouseX, this.mouseY);
			_lastBounds = _bounds;
		}

		protected function whileButtonPress($event:Event):void {
			trace("whileButtonPress");
			doCurrentAction();
		}

		protected function onButtonMouseUp($event:MouseEvent):void {
			addDragListeners(_moveButton, true);
			addHideListeners(false);
			doCurrentAction();
			setCurrentAction();
			doCurrentAction();
		}

		protected function doMove():void {
			this.bounds = new Rectangle(_lastBounds.x - (_startingPoint.x - this.mouseX),
										_lastBounds.y - (_startingPoint.y - this.mouseY),
										_lastBounds.width, _lastBounds.height);
		}

		protected function onMouseOver($event:MouseEvent):void {
			addHideListeners(false);
			showControls();
		}

		protected function whileOver($event:Event):void {
			if(!(MathUtils.isValueBetween(this.mouseX, _bounds.left - 30, _bounds.right + 60) &&
				MathUtils.isValueBetween(this.mouseY, _bounds.top - 30, _bounds.bottom + 60))) {
				addHideListeners();
				initTimer();
			}
		}

		protected function initTimer():void {
			destructTimer();
			_fadeTimer = new Timer(FADE_TIMER_DELAY, 1);
			addListener(_fadeTimer, TimerEvent.TIMER_COMPLETE, onFadeTimerComplete);
			_fadeTimer.start();
		}

		protected function destructTimer():void {
			if(_fadeTimer) {
				if(_fadeTimer.running) {
					_fadeTimer.stop();
				}
				addListener(_fadeTimer, TimerEvent.TIMER_COMPLETE, onFadeTimerComplete, false);
				_fadeTimer = null;
			}
		}

		protected function showControls($add:Boolean = true):void {
			if(_borderContainer) {
				_borderContainer.alpha = $add && _borderEnabled ? 1 : 0;
			}
		}

		protected function onFadeTimerComplete($event:TimerEvent):void {
			showControls(false);
		}

		protected function addDragListeners($element:InteractiveObject, $down:Boolean = true, $destruct:Boolean = false):void {
			addListener($element, MouseEvent.MOUSE_DOWN, onButtonMouseDown, $down && !$destruct);
			addListener(_controlsContainer, Event.ENTER_FRAME, whileButtonPress, !$down && !$destruct, true);
			addListener(EtniaSystem.stageRoot.root, MouseEvent.MOUSE_UP, onButtonMouseUp, !$down && !$destruct, true);
		}

		protected function addHideListeners($over:Boolean = true, $destruct:Boolean = false):void {
			if(_controlsAutoHide) {
				addListener(this, MouseEvent.MOUSE_OVER, onMouseOver, $over && !$destruct, true);
				addListener(_container, Event.ENTER_FRAME, whileOver, $destruct ? false : !$over, true);
			}
		}

	}
}