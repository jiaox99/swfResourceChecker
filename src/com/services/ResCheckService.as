/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.services
{
	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.data.SWFSymbol;
	import com.codeazur.as3swf.events.SWFProgressEvent;
	import com.codeazur.as3swf.tags.ITag;
	import com.codeazur.as3swf.tags.TagPlaceObject;
	import com.codeazur.as3swf.tags.TagPlaceObject2;
	import com.codeazur.as3swf.tags.TagPlaceObject3;
	import com.codeazur.as3swf.tags.TagPlaceObject4;
	import com.codeazur.as3swf.tags.TagShowFrame;
	import com.codeazur.as3swf.tags.TagSymbolClass;
	import com.events.CheckLogEvent;

	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class ResCheckService
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function ResCheckService()
		{
		}

		private function onLoadedHandler(event:Event):void
		{
			var fileStream:FileStream = event.target as FileStream;
			var byteArray:ByteArray = new ByteArray();
			fileStream.readBytes(byteArray, 0, fileStream.bytesAvailable);
			fileStream.close();

			var swf:SWF = new SWF();
			swf.loadBytesAsync(byteArray);
			swf.addEventListener(SWFProgressEvent.COMPLETE, onParseSWFFileCompletedHandler);
		}


		private function onParseSWFFileCompletedHandler(event:SWFProgressEvent):void
		{
			var swf:SWF = event.target as SWF;
			for each (var tag:ITag in swf.tags )
			{
				if ( tag is TagSymbolClass )
				{
					for each (var symbol:SWFSymbol in TagSymbolClass(tag).symbols)
					{
						_allDef.push( symbol.name );
					}
				}
				else if ( tag is TagPlaceObject || tag is TagPlaceObject2 || tag is TagPlaceObject3 || tag is TagPlaceObject4 )
				{
					_stageIsEmpty = false;
				}
			}

			checkCurSWFFile();
		}

		private function checkCurSWFFile():void
		{
			var fileName:String = _curFileName;

			if ( _stageCheck && !_stageIsEmpty)
			{
				eventDispatcher.dispatchEvent(new CheckLogEvent(CheckLogEvent.LOG,
						"Stage not null -> " + fileName));
			}

			if ( _defCheck )
			{
				for each ( var def:String in _defCheck)
				{
					if ( _allDef.indexOf(def) != -1 )
					{
						eventDispatcher.dispatchEvent(new CheckLogEvent(CheckLogEvent.LOG,
								"Find def $ -> @".replace( "$", def).replace( "@", fileName)));
					}
				}
			}

			nextFile();
		}

		public function doCheck(files:Vector.<File>, stageCheck:Boolean, defCheck:String=""):void
		{
			for each (var file:File in files)
			{
				_files.push(file);
			}

			_stageCheck = stageCheck;
			_defCheck = defCheck.split(",");
			if ( stageCheck || defCheck )
			{
				nextFile();
			}
			else
			{
				eventDispatcher.dispatchEvent(new CheckLogEvent(CheckLogEvent.COMPLETED_CHECK));
			}
		}

		private function nextFile():void
		{
			_stageIsEmpty = true;
			_allDef.length = 0;

			if ( _files.length > 0 )
			{
				var file:File = _files.pop();
				if ( file.isDirectory )
				{
					for each ( file in file.getDirectoryListing())
					{
						_files.push(file);
					}
					nextFile();
				}
				else if (file.extension != "swf")
				{
					nextFile();
				}
				else
				{
					var fileStream:FileStream = new FileStream();
					fileStream.addEventListener(Event.COMPLETE, onLoadedHandler);
					fileStream.openAsync(file, FileMode.READ);
					var fileName:String = file.url.split("/").pop();
					_curFileName = fileName;
					eventDispatcher.dispatchEvent(new CheckLogEvent(CheckLogEvent.CHECKING,
							"Checking -> " + fileName));
				}
			}
			else
			{
				eventDispatcher.dispatchEvent(new CheckLogEvent(CheckLogEvent.COMPLETED_CHECK));
			}
		}

		public function stopCheck():void
		{
			_files.length = 0;
		}

		private var _files:Array = [];

		private var _stageCheck:Boolean;

		private var _defCheck:Array;

		private var _curFileName:String;

		private var _stageIsEmpty:Boolean = true;

		private var _allDef:Array = [];
	}
}
