package com.etnia.graphic {

	import com.etnia.display.SpriteContainer;

	import net.etnia.engine3d.projection2d.math3d.ComplexPoint;

	public class BasicDynamicSpriteButton extends SpriteContainer {

		protected var _type:String;
		protected var _position:ComplexPoint;
		protected var _size:Number;
		protected var _borderColor:uint = 0x324532;
		protected var _fillColor:uint = 0xADBC34;

		public function set size($value:Number):void {
			_size = $value;
		}
		
		public function get position():ComplexPoint {
			return _position;
		}
		
		public function set position($value:ComplexPoint):void {
			_position = $value;
			drawButton();
		}
		
		public function get type():String {
			return _type;
		}

		public function BasicDynamicSpriteButton($type:String) {
			_type = $type;
		}

		protected function drawButton():void {}

	}
}