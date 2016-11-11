/**
 * Created by Jiao Zhongxiao on 2016/11/10.
 */
package
{
	import com.commands.AddFilesToCheckCommand;
	import com.commands.AppStartupCommand;
	import com.commands.RemoveFilesToCheckCommand;
	import com.commands.StartCheckResCommand;
	import com.commands.StopCheckResCommand;
	import com.events.AppEvent;
	import com.events.FilesOperateEvent;
	import com.events.CheckResEvent;
	import com.mediators.AppMediator;
	import com.mediators.FileItemMediator;
	import com.models.FilesToCheckModel;
	import com.services.ResCheckService;
	import com.views.FileItem;

	import flash.events.IEventDispatcher;

	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	public class ResCheckerConfig implements IConfig
	{
		[Inject]
		public var commandMap:IEventCommandMap;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		[Inject]
		public var injector:IInjector;

		public function ResCheckerConfig()
		{
		}

		public function configure():void
		{
			// Map models
			injector.map(FilesToCheckModel).asSingleton();

			// Map services
			injector.map(ResCheckService).asSingleton();

			// Map events to commands
			commandMap.map(AppEvent.APP_STARTUP).toCommand(AppStartupCommand);

			commandMap.map(CheckResEvent.START_CHECK).toCommand(StartCheckResCommand);
			commandMap.map(CheckResEvent.STOP_CHECK).toCommand(StopCheckResCommand);

			commandMap.map(FilesOperateEvent.ADD).toCommand(AddFilesToCheckCommand);
			commandMap.map(FilesOperateEvent.REMOVE).toCommand(RemoveFilesToCheckCommand);

			// Map views to mediators
			mediatorMap.map(ResChecker).toMediator(AppMediator);
			mediatorMap.map(FileItem).toMediator(FileItemMediator);

			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.APP_STARTUP));
		}
	}
}
