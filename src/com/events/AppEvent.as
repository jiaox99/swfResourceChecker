/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.events
{
	import flash.events.Event;

	public class AppEvent extends Event
	{
		public static const APP_STARTUP:String = "AppStartup";

		public function AppEvent(type:String)
		{
			super(type, false, false);
		}
	}
}
