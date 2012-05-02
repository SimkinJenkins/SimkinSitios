package com.ui.controllers.mvc.webcam {

	public class BasicWebcamStates {

		public static const ON_CAMERA_SETTINGS:String = "onCamSet";
		public static const ON_PRIVACY_SETTINGS:String = "onPrivacySet";

		public static const ON_CAMERA_STARTING:String = "onCamStarting";
		public static const ON_IMAGE_CAPTURED:String = "onImageCaptured";
		public static const ON_CAPTURE_AGAIN:String = "onCaptureAgain";

    	public static const ON_CAMERA_READY: String = "onCamReady";
    	public static const ON_CAMERA_REJECTED: String = "onCamRejected";
    	public static const ON_CAMERA_ERROR: String = "onCamError";
    	public static const ON_CONNECTION_READY: String = "onConnectionReady";

    	public static const ON_RECORD_START: String = "onRecordStart";
    	public static const ON_RECORD_STOP: String = "onRecordTimeout";
    	public static const ON_PLAYER_START:String = "onPlayerStart";
    	public static const ON_PLAYER_STOP: String = "onPlayerTimeout";
    	public static const ON_PLAYER_END: String = "onPlayerEnd";
    	public static const ON_CAMERA_ADD_STAGE:String = "onCameraAddStage";
    	public static const ON_CAMERA_DESTROY_FINISH:String = "onCameraDestroyFinish";
    	public static const PLAYING_PROGRESS:String = "playingProgress";

		//Errores.//
		public static const ON_CONNECTION_ERROR: String = "onConnectionError";

	}
}