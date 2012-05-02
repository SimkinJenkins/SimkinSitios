package net.interalia.etnia.ui.mvc.userpicture {
	import com.etnia.utils.GraphicUtils;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import net.interalia.etnia.ui.mvc.BasicFormStates;
	import net.interalia.etnia.ui.mvc.fbpicture.MultipleFBPicturePickerController;
	import net.interalia.etnia.ui.mvc.interfaces.IModel;
	
	public class MultipleUserPicturePickerController extends UserPicturePickerController {
		protected var _loadImages:Array;
		protected var _i:uint = 0;
		
		public function MultipleUserPicturePickerController($model:IModel) {
			super($model);
		}
		
		override protected function setFBPicMode():void {
			_i = 0;
			modelUPP.selectFileController = new MultipleFBPicturePickerController(modelUPP.fbPicModel);
			addListener(modelUPP.fbPicModel, Event.CHANGE, onModelChange, true, true);
		}
		
		override protected function setUserFileMode():void {
			modelUPP.selectFileController = new MultipleFileReferenceController(modelUPP.userFileModel);
			addListener(modelUPP.userFileModel, Event.CHANGE, onModelChange, true, true);
		}
		
		override protected function onFBMode():void {
			modelUPP.userPhotos = new Array;
			loadImage(modelUPP.fbPicModel.photos[_i].URL);
		}
		
		override protected function onModelFinished($model:IModel):void {
			switch(modelUPP.selectedType) {
				case UserPicturePickerStates.FB_PICTURE_MODE:	onFBMode();			return;
				case UserPicturePickerStates.WEB_CAM_MODE:		onWebCamMode();		break;	
				case UserPicturePickerStates.USER_FILE_MODE:
					
					if (modelUPP.userFileModel.filesnames) {
						modelUPP.userPhotos = modelUPP.userFileModel.filesnames;
						break;
					} else {
						loadImage(modelUPP.userFileModel.fileUpURL);
						return;
					}
			}
			_model.setState(BasicFormStates.FINISHED);
		}
		
		override protected function onLoadImage($event:Event):void {
			createLoadImageListeners(false);
			switch(modelUPP.selectedType) {
				case UserPicturePickerStates.FB_PICTURE_MODE:	onFBModeFinish();			break;
				case UserPicturePickerStates.USER_FILE_MODE:	onUserFileModeFinish();		break;
			}
			if(_i == modelUPP.fbPicModel.photos.length){
				_model.setState(UserPicturePickerStates.PHOTO_LOADED);
				_model.setState(BasicFormStates.FINISHED);
			}
		}
		
		
		override protected function onFBModeFinish():void {
			if(_i < modelUPP.fbPicModel.photos.length){
				modelUPP.userPhotos.push(_loader);
				_model.setState(UserPicturePickerStates.PHOTO_LOADED);
				loadImage(modelUPP.fbPicModel.photos[_i].URL);
			}else{
				modelUPP.userPhotos.push(_loader);
			}
			_i++;
		}
		
	}
}