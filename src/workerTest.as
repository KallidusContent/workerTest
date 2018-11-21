package
{
	import com.distriqt.extension.mediaplayer.MediaPlayer;
	import com.myflashlabs.utils.worker.WorkerManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.WorkerState;
	
	import workers.Worker1;
	
	public class workerTest extends Sprite
	{
		private var _myWorker:WorkerManager;
		public function workerTest()
		{
			init();
		}
		private function init():void {
			
			// adding the Media player causes the worker to terminate
			try
			{
				trace( "MediaPlayer Supported: " + MediaPlayer.isSupported );
				if (MediaPlayer.isSupported)
				{
					trace( "MediaPlayer Version:   " + MediaPlayer.service.version );
				}
			}
			catch (e:Error)
			{
				trace( e.message );
			}
			//****************************
			
			_myWorker = new WorkerManager(workers.Worker1, loaderInfo.bytes, this);
			
			// listen to your worker state changes
			_myWorker.addEventListener(Event.WORKER_STATE, onWorkerState);
			
			// fire up the Worker
			_myWorker.start();
		}
		private function onWorkerState(e:Event):void
		{
			trace("worker state = " + _myWorker.state)
			
			// if the worker state is 'running', you can start communicating
			if (_myWorker.state == WorkerState.RUNNING)
			{
				// create your own commands in your worker class, Worker1, i.e "forLoop" in this sample and pass in as many parameters as you wish
				_myWorker.command("forLoop", onProgress, onResult, 10000);
			}
		}
		private function onProgress($progress:Number):void
		{
			trace("$progress = " + $progress);
		}
		
		private function onResult($result:Number):void
		{
			trace("$result = " + $result);
			
			// terminate the worker when you're done with it.
			_myWorker.terminate();
		}
	}
}