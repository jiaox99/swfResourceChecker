/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.events
{
	import flash.events.Event;

	public class CheckResEvent extends Event
	{
		public static const START_CHECK:String = "StartCheck";
		public static const STOP_CHECK:String = "StopCheck";

		public var stageCheck:Boolean;

		public var defCheck:String;

		public function CheckResEvent(type:String, stageCheck:Boolean=true, defCheck:String="")
		{
			super(type, false, false);

			this.stageCheck = stageCheck;
			this.defCheck = defCheck;
		}
	}
}
