package net.interalia.etnia.ui.mvc.userpicture.graphics {

	import com.etnia.graphics.gallery.IThumbnail;
	import com.etnia.graphics.gallery.IThumbnailData;
	import com.etnia.graphics.gallery.Thumbnail;
	import com.etnia.graphics.gallery.ThumbnailEventType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import net.interalia.etnia.ui.mvc.fbpicture.FbUserThumbnailData;
	import net.interalia.etnia.ui.mvc.fbpicture.ThumbnailAlbumData;

	public class BigAlbumThumbnail extends Thumbnail implements IThumbnail {

		protected var _loader:MovieClip;
//		protected var _loaderClass:Class;
		
		override public function set loaderClass($class:Class):void {
			_loaderClass = $class;
		}

		public function BigAlbumThumbnail($ID:String, $background:DisplayObject, $imageUrl:String = "", $title:TextField = null) {
			super($ID, $background, $imageUrl, $title);
			_title = _background["infoAlbumTxt"] as TextField;
			_title.text = "cualquier";
		}

		override public function set data($value:IThumbnailData):void {
			super.data = $value;
			if(!(_data.thumbnailURL != "" && _data.thumbnailURL != null)) {
				setImage(new SWCNoPhoto());
				dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
			}
			if($value is ThumbnailAlbumData) {
				var photoPicker:ThumbnailAlbumData = $value as ThumbnailAlbumData;
			} else if($value is FbUserThumbnailData) {
				_title.text = ($value as FbUserThumbnailData).imageName;
				return;
			}
			if(photoPicker) {
				var fotoWord:String = photoPicker.size == 1 ? " foto" : " fotos";
				_title.text = ($value as ThumbnailAlbumData).size + fotoWord;
			} 
		}
		
		override protected function setPosition(): void{
			try {
				var thumbImg:Sprite = _background["thumbImg"] as Sprite;
				_image.x = thumbImg.x;
				_image.y = thumbImg.y;
			} catch ($error:Error) {}
		}

		override protected function setSizeImage(): void{
			try {
				if(_adjustImage){
					var thumbImg:Sprite = _background["thumbImg"] as Sprite;
					_image.width = thumbImg.width;
					_image.height = thumbImg.height;
				}
			} catch ($error:Error) {}
		}

		override protected function onLoadImage($event:Event):void {
			createLoadImageListeners(false);
			var thumbRaw:Bitmap = _imageLoader.content as Bitmap;
			var cropArea:Number = 0;
			if(thumbRaw.width > thumbRaw.height) {
				cropArea = thumbRaw.height;
			} else {
				cropArea = thumbRaw.width;
			}
			var thumbCrop:Bitmap = crop(0, 0, cropArea, cropArea * .84375, thumbRaw);
			setImage(thumbCrop);
			showLoader(false);
			dispatchEvent(new Event(ThumbnailEventType.ON_THUMBNAIL_READY));
		}

		override protected function arrangeTitle():void {}

		override protected function loadImage($imageURL:String):void {
			super.loadImage($imageURL);
			showLoader();
		}

		protected function showLoader($add:Boolean = true):void {
			if(!_loader) {
				(_loaderClass) ? _loader = new _loaderClass() : _loader = new GraphicInfinitLoader();
				_loader.scaleX = _loader.scaleY = .5;
				_loader.x = 60;
				_loader.y = 40;
//				_loader.transform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
			}
			addElement(_loader, $add);
		}

		protected function crop( _x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject = null):Bitmap {
			var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( (DisplayObject!=null) ? displayObject : stage, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
			return croppedBitmap;
		}
		
	}
}