/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.events
{
	import flash.events.Event;

	public class CheckLogEvent extends Event
	{
		public static const LOG:String = "Log";
		public static const CHECKING:String = "Checking";
		public static const COMPLETED_CHECK:String = "CompletedCheck";

		public var msg:String;

		public function CheckLogEvent(type:String, msg:String="")
		{
			super(type, false, false);

			this.msg = msg;
		}

		override public function clone():Event
		{
			return new CheckLogEvent(this.type, this.msg);
		}
	}
}
