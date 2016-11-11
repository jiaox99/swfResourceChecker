/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.commands
{
	import com.events.FilesOperateEvent;
	import com.models.FilesToCheckModel;

	import flash.events.IEventDispatcher;

	import robotlegs.bender.bundles.mvcs.Command;

	public class RemoveFilesToCheckCommand extends Command
	{
		[Inject]
		public var event:FilesOperateEvent;

		[Inject]
		public var model:FilesToCheckModel;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function RemoveFilesToCheckCommand()
		{
			super();
		}

		override public function execute():void
		{
			for ( var i:int=0, len:int=model.files.length; i<len; i++)
			{
				if (model.files[i].nativePath == event.file.nativePath)
				{
					model.files.splice(i, 1);
					eventDispatcher.dispatchEvent(new FilesOperateEvent(FilesOperateEvent.FILES_REMOVED, event.file));
					return;
				}
			}
		}
	}
}
