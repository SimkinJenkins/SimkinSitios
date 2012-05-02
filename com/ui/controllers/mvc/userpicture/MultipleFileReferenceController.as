package net.interalia.etnia.ui.mvc.userpicture {
	import com.etnia.core.config.DisplayContainer;
	import com.etnia.core.system.EtniaSystem;
	import com.etnia.utils.graphics.MainDisplayController;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	import net.interalia.etnia.ui.mvc.BasicFormStates;
	import net.interalia.etnia.ui.mvc.interfaces.IModel;
	
	public class MultipleFileReferenceController extends BasicFileReferenceLoaderController {
		protected var _fileReferenceList:FileReferenceList;
		
		public function MultipleFileReferenceController($model:IModel) {
			_fileReferenceList = null;
			super($model);
		}
		
		override protected function selectClickHandler():void {
			createFileReference(_fileFilter);
			createFileReferenceList(_fileFilter);
		}
		
		protected function createFileReferenceList($filter:FileFilter):void {
			if(_fileReferenceList) {
				configureListenersList(_fileReferenceList, false);
				_fileReferenceList = null;
			}
			_fileReferenceList = new FileReferenceList();
			configureListenersList(_fileReferenceList);
			_fileReferenceList.browse($filter ? [$filter] : null);
		}
		
		protected function configureListenersList($dispatcher:FileReferenceList, $enabled:Boolean = true):void {
			addListener($dispatcher, Event.SELECT, selectHandler, $enabled);
			addListener($dispatcher, Event.CANCEL, cancelHandler, $enabled);
			addListener($dispatcher, Event.COMPLETE, completeHandler, $enabled);
			addListener($dispatcher, DataEvent.UPLOAD_COMPLETE_DATA, completeDataHandler, $enabled);
			addListener($dispatcher, ProgressEvent.PROGRESS, progressHandler, $enabled);
			addListener($dispatcher, IOErrorEvent.IO_ERROR, ioErrorHandler, $enabled);
			addListener($dispatcher, SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, $enabled);
		}
		
		override protected function selectHandler($event:Event):void {
			fileReferenceModel.filesnames = new Array();
			var names:String = "";
			for(var i:uint = 0; i < _fileReferenceList.fileList.length; i++){
				names +=_fileReferenceList.fileList[i].name + ", ";
//				fileReferenceModel.filesnames.push(_fileReferenceList.fileList[i]);	
			}
			fileReferenceModel.filename = "";
			_model.setState(BasicFileReferenceStates.FILE_SELECTED);
		}
		protected var _i:uint = 0;
		
		override protected function addClickHandler():void {
			configureListenersList(_fileReferenceList, false);
			if(!fileReferenceModel.terms) {
				_model.setError(BasicFileReferenceStates.TERMS_ERROR);
				return;
			}
			try {
				//for(_i = 0; _i < _fileReferenceList.fileList.length; _i++){
					loadImage();
				//}
			} catch ($error:Error) {
				trace($error);
				_model.setError(BasicFileReferenceStates.UPLOAD_ERROR, $error.toString());
			}
		}
		
		protected function loadImage():void {
			fileReferenceModel.filename = _fileReferenceList.fileList[_i].name;
			_fileReference = _fileReferenceList.fileList[_i];
			configureListeners(_fileReference);
// No subir al repo :P
//			_fileReference.load();
			_model.setState(BasicFileReferenceStates.LOADING_FILE);
		}

		override protected function createFileReference($filter:FileFilter):void {
			if(_fileReference) {
				configureListeners(_fileReference, false);
				_fileReference = null;
			}
			_fileReference = new FileReference();
		}
		
		override protected function configureListeners($dispatcher:FileReference, $enabled:Boolean = true):void {
			addListener($dispatcher, Event.COMPLETE, completeHandler, $enabled);
			addListener($dispatcher, DataEvent.UPLOAD_COMPLETE_DATA, completeDataHandler, $enabled);
			addListener($dispatcher, ProgressEvent.PROGRESS, progressHandler, $enabled);
			addListener($dispatcher, IOErrorEvent.IO_ERROR, ioErrorHandler, $enabled);
			addListener($dispatcher, SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, $enabled);
		}

		override protected function onGetBitmapData($event:Event):void {
			addListener(_loader.contentLoaderInfo, Event.COMPLETE, onGetBitmapData, false);
			_i++;
			if(_i < _fileReferenceList.fileList.length){
				fileReferenceModel.filesnames.push($event.target.content);
				configureListeners(_fileReference, false);
				loadImage();
			}else{
				fileReferenceModel.filesnames.push($event.target.content);
				_model.setState(BasicFormStates.FINISHING);
				_fileReference = null;
				_loader = null;
			}
		}
	}
}