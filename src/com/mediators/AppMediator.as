/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.mediators
{
	import com.events.AppEvent;
	import com.events.CheckLogEvent;
	import com.events.FilesOperateEvent;
	import com.events.CheckResEvent;
	import com.views.FileItem;

	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;

	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class AppMediator extends Mediator
	{
		[Inject]
		public var view:ResChecker;

		public function AppMediator()
		{
			super();
		}

		override public function initialize():void
		{
			super.initialize();

			view.startButton.addEventListener(MouseEvent.CLICK, onStartButtonClickHandler);

			view.dirContainer.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnterHandler);
			view.dirContainer.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDropHandler);

			addContextListener(FilesOperateEvent.FILES_ADDED, onFilesChangedHandler);
			addContextListener(CheckLogEvent.LOG, onCheckLogHandler);
			addContextListener(CheckLogEvent.CHECKING, onCheckLogHandler);
			addContextListener(CheckLogEvent.COMPLETED_CHECK, onCompletedHandler);
		}

		private function onCompletedHandler(e:Event):void
		{
			view.logArea.appendText("\r检查结束");
			_statusFlag = true;
			view.startButton.label = "开始检查";
			view.showStatusBar = false;
		}

		private function onCheckLogHandler(e:CheckLogEvent):void
		{
			if (e.type == CheckLogEvent.LOG)
			{
				view.logArea.appendText("\r"+e.msg);
			}
			else
			{
				view.status = e.msg;
			}
		}

		private function onFilesChangedHandler(e:Event):void
		{
			view.dirContainer.addElement(new FileItem());
			view.validateNow();
		}

		private function onDropHandler(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for each ( var file:File in files)
			{
				dispatch(new FilesOperateEvent(FilesOperateEvent.ADD, file))
			}
		}

		private function onDragEnterHandler(event:NativeDragEvent):void
		{
			if ( event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				NativeDragManager.acceptDragDrop(view.dirContainer);
			}
		}

		private function onStartButtonClickHandler(event:MouseEvent):void
		{
			dispatch(new CheckResEvent(
					_statusFlag ? CheckResEvent.START_CHECK : CheckResEvent.STOP_CHECK,
					view.stageCheckBox.selected,
					view.defCheckBox.selected ? view.defArea.text : ""));

			if ( _statusFlag )
			{
				view.logArea.text = "检查结果......";
				view.showStatusBar = true;
			}
			else
			{
				view.showStatusBar = false;
			}

			_statusFlag = !_statusFlag;

			view.startButton.label = _statusFlag ? "开始检查" : "中止检查";
		}

		private var _statusFlag:Boolean = true;
	}
}
