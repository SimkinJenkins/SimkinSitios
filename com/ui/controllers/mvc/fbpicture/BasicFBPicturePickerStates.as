package com.ui.controllers.mvc.fbpicture {

	public class BasicFBPicturePickerStates {

		//Estados para botones clickHandler
		public static const MY_ALBUMS_BTN:String = "myAlbumBtn";
		public static const FRIENDS_ALBUMS_BTN:String = "friendsAlbumBtn";
		public static const SELECT_BTN:String = "selectBtn";
		public static const TERMS:String = "terms";

		//Errores
		public static const FB_SESSION_ERROR:String = "fbSessionError";
		public static const FB_ERROR:String = "fbError";
		public static const FRIEND_ALBUMS_ERROR:String = "friendAlbumsError";
		public static const TERMS_ERROR:String = "termsError";

		//Loading
		public static const LOADING_ALBUMS:String = "loadingAlbums";
		public static const LOADING_COVER:String = "loadingCover";


		//Eventos
		public static const ON_ALBUM_PHOTOS_DATA_UPDATE:String = "onAPDUpdate";

		public static const FRIEND_SELECTED:String = "friendSelected";
		public static const PHOTOS_DATA_LOADED:String = "photosDataLoaded";

		// Initial State Photo Picker
		public static const INIT:String = "init";
		public static const EXIT:String = "exit";
		
		// Friends Request
		public static const FRIENDS_UID_LOADED:String = "friendsUidLoaded";
		public static const FRIENDS_LOADING:String = "friendsLoading";
		public static const FRIENDS_LOADED:String = "friendsLoaded";
		public static const FRIENDS_LOADED_EMPTY:String = "friendsLoadedEmpty";
		public static const FRIEND_ALBUM_SELECTED:String = "friendAlbumSelected";
		public static const FRIEND_ALBUM_LOADING:String = "friendsAlbumLoading";
		public static const FRIEND_ALBUM_LOADED:String = "friendAlbumLoaded";
		public static const FRIEND_PHOTOS_LOADED:String = "friendPhotosLoaded";
		
		// Albums Request
		public static const ALBUMS_LOADED:String = "albumsLoaded";
		public static const ALBUMS_LOADED_EMPTY:String = "albumsLoadEmpty";
		public static const ALBUMS_LOAD_ERROR:String = "albumsLoadError";
		public static const ALBUMS_RELOAD:String = "albumsReload";
		
		// Single Album
		public static const ALBUM_SELECTED:String = "albumSelected";
		public static const ALBUM_DESELECTED:String = "albumDeselected";
		
		// Photos Request
		public static const PHOTOS_LOADED:String = "photosLoaded";
		public static const PHOTOS_LOADING:String = "photosLoading";
		public static const PHOTOS_LOADED_EMPTY:String = "photosLoadedEmpty";
		public static const PHOTOS_LOAD_ERROR:String = "photosLoadError";
		public static const PHOTOS_RELOAD:String = "photosReload";
		
		// Single Photo
		public static const PHOTO_SELECTED:String = "photoSelected";
		public static const PHOTO_DESELECTED:String = "photoDeselected";
		public static const PHOTO_UPLOADING:String = "photoUploading";
		public static const PHOTO_UPLOAD:String = "photoUpload";
		
		public function BasicFBPicturePickerStates(){}
	}
}