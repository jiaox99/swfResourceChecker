/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.events
{
	import flash.events.Event;
	import flash.filesystem.File;

	public class FilesOperateEvent extends Event
	{
		public static const ADD:String = "Add";
		public static const REMOVE:String = "Remove";
		public static const FILES_ADDED:String = "FilesAdded";

		public static const FILES_REMOVED:String = "FilesRemoved";

		public var file:File;

		public function FilesOperateEvent(type:String, _file:File)
		{
			super(type, false, false);
			this.file = _file;
		}

		override public function clone():Event
		{
			return new FilesOperateEvent(this.type, this.file);
		}
	}
}
