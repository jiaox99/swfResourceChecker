/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.commands
{
	import com.events.CheckResEvent;
	import com.models.FilesToCheckModel;
	import com.services.ResCheckService;

	import robotlegs.bender.bundles.mvcs.Command;

	public class StartCheckResCommand extends Command
	{
		[Inject]
		public var model:FilesToCheckModel;

		[Inject]
		public var checkService:ResCheckService;

		[Inject]
		public var event:CheckResEvent;

		public function StartCheckResCommand()
		{
			super();
		}

		override public function execute():void
		{
			super.execute();
			checkService.doCheck(model.files, event.stageCheck, event.defCheck);
		}
	}
}
