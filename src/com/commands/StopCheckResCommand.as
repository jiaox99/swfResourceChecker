/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.commands
{
	import com.services.ResCheckService;

	import robotlegs.bender.bundles.mvcs.Command;

	public class StopCheckResCommand extends Command
	{
		[Inject]
		public var service:ResCheckService;

		public function StopCheckResCommand()
		{
			super();
		}

		override public function execute():void
		{
			super.execute();
			service.stopCheck();
		}
	}
}
