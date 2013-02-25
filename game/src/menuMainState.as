package 
{
	import flash.display.MovieClip;
	import ru.antkarlov.anthill.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.*;
	
	public class menuMainState extends AntState
	{
		private var _camera:AntCamera;
		
		private var mc:AntActor;
		private var btn:AntButton;
		public var storage:AntStorage = new AntStorage(true);
		public var sharedObj:AntCookie = new AntCookie();
		
		
		protected var _started:Boolean = false;
		
		override public function create():void
		{	
			_camera = new AntCamera(0,0,640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			
			AntG.track(_camera, "TestUI camera");
			

			AntG.debugger.monitor.clear();
			showUI(new main_menu());
			_started = true;
		}
		public function menuMainState()
		{
			super();
	
		}
		
	
		/**
		 * Обработчик события завершения растеризации.
		 */
		private function showUI(m:MovieClip):void
		{
			//
			//_started = false;
			for (var i:int = 0; i < m.numChildren; i++)
             {
              if (m.getChildAt(i) is MovieClip)
              {
                var pObject:* = m.getChildAt(i);
				var strName:String = String(pObject.name).substring(0, 6);
                switch (strName) {
					 case "button":
						btn = new AntButton();
			            btn.addAnimationFromCache(getQualifiedClassName(pObject));
			            btn.x = pObject.x;
			            btn.y = pObject.y;
			            add(btn); 
						
						switch(pObject.name){
						  case "button_play":
							btn.eventClick.add(goToPlayGame);
						  break;
						  case "button_levels":
							btn.eventClick.add(goToLevels);
						  break;
					      default:
						 
						  break;
						 }
				     break;
				    
					 default:
					  mc = new AntActor();
			          mc.addAnimationFromCache(getQualifiedClassName(pObject));
			          add(mc);
					  mc.x = pObject.x;
					  mc.y = pObject.y;
					 break;
					}
				
              }
             }
			
		
			
			_started = true;
	
		}
		
		private function goToLevels(aButton:AntButton):void 
		{
			aButton.eventClick.remove(goToLevels);
			AntG.anthill.switchState(new levelsState());
		}
		
		private function goToPlayGame(aButton:AntButton):void 
		{
			
			//AntG.storage.set("level", this["level1_"+1]());
			aButton.eventClick.remove(goToPlayGame);
			AntG.anthill.switchState(new playGameState());
		}
		
		
		override public function postUpdate():void
		{
			
			super.postUpdate();
		}
		override public function destroy():void
		{
			
			super.destroy();
		}
		
		
		/**
		 * @private
		 */
	

	}

}