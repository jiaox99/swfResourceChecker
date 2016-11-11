/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package com.commands
{
	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class AppStartupCommand implements ICommand
	{
		public function AppStartupCommand()
		{
		}

		public function execute():void
		{
			trace("App Startup");
		}
	}
}
