/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.mediators
{
	import com.events.FilesOperateEvent;
	import com.models.FilesToCheckModel;
	import com.views.FileItem;

	import flash.events.MouseEvent;

	import flash.filesystem.File;

	import robotlegs.bender.bundles.mvcs.Mediator;

	import spark.components.Group;

	import spark.components.SkinnableContainer;

	public class FileItemMediator extends Mediator
	{
		[Inject]
		public var view:FileItem;

		[Inject]
		public var model:FilesToCheckModel;

		public function FileItemMediator()
		{
			super();
		}

		override public function initialize():void
		{
			super.initialize();

			_file = model.files[model.files.length-1];

			view.fileLabel.text = _file.nativePath;
			view.toolTip = _file.nativePath;

			view.delButton.addEventListener(MouseEvent.CLICK, onDelButtonClickHandler);
		}

		private function onDelButtonClickHandler(event:MouseEvent):void
		{
			dispatch(new FilesOperateEvent(FilesOperateEvent.REMOVE, _file));

			Group(view.parent).removeElement(view);
		}

		private var _file:File;
	}
}
