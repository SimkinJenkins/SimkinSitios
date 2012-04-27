package com.ui {

	import flash.events.MouseEvent;

	public class AlertEvent extends MouseEvent {

		public static const ON_PRESS_ALERT_BUTTON :String	= "on press alert button";
		public static const ON_PRESS_CLOSE_BUTTON : String = "on press close button";
		
		private var _ID : Number;
		
		public function AlertEvent(type:String, $ID:Number){
			super(type);
			_ID = $ID;
		}
		
		public function set ID($ID:Number):void{
			this._ID = $ID;
		}
		
		public function get ID():Number{
			return _ID;
		}
	}
}