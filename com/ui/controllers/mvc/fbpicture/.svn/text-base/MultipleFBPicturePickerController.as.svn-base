package net.interalia.etnia.ui.mvc.fbpicture {
	import com.facebook.events.FacebookEvent;
	
	import net.interalia.etnia.ui.mvc.BasicFormStates;
	import net.interalia.etnia.ui.mvc.interfaces.IModel;
	import net.interalia.etnia.ui.mvc.userpicture.UserPicturePickerStates;
	
	public class MultipleFBPicturePickerController extends BasicFriendsFBPicturePickerController {
		public function MultipleFBPicturePickerController($model:IModel) {
			super($model);
		}
		
		override public function getSelectedAlbumPhotos():void {
			if(!fbPPModel.terms) {
				_model.setError(BasicFBPicturePickerStates.TERMS_ERROR);
				return;
			}
			super.getSelectedAlbumPhotos();
		}
		
		override protected function albumContentLoaded($event:FacebookEvent):void {
			super.albumContentLoaded($event);
			_model.setState(BasicFormStates.FINISHING);
		}
	}
}