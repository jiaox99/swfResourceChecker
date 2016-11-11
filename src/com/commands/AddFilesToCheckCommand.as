/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.commands
{
	import com.events.AppEvent;
	import com.events.FilesOperateEvent;
	import com.models.FilesToCheckModel;

	import flash.events.IEventDispatcher;
	import flash.filesystem.File;

	import robotlegs.bender.bundles.mvcs.Command;

	public class AddFilesToCheckCommand extends Command
	{
		[Inject]
		public var event:FilesOperateEvent;

		[Inject]
		public var model:FilesToCheckModel;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function AddFilesToCheckCommand()
		{
			super();
		}

		override public function execute():void
		{
			super.execute();

			for each (var file:File in model.files)
			{
				if ( file.nativePath == event.file.nativePath)
				{
					return;
				}
			}
			model.files.push(event.file);

			eventDispatcher.dispatchEvent(new FilesOperateEvent(FilesOperateEvent.FILES_ADDED, event.file));
		}
	}
}
