package 
{
	
	import flash.display.MovieClip;
	import ru.antkarlov.anthill.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.*;
	
	
	public class levelsState extends AntState
	{
		private var _camera:AntCamera;
		private var backGround:AntActor; 
		private var mc:AntActor;
		private var btn:AntButton;
		public var storage:AntStorage = new AntStorage(true);
		public var sharedObj:AntCookie = new AntCookie();
		public var mcIconArray:Array = [];
		public var mcIconArrayName:Array = [];
		
	    
	
		private var i:int = 0 ;
		protected var _started:Boolean = false;
		
		
		public function levelsState()
		{
			super();
			
			_started = false;
			 
			_camera = new AntCamera(640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			addChild(_camera);
			AntG.track(_camera, "menuCamera");
			showLevelIcons(new level_menu());
			
		}
	
		private function showLevelIcons(m:MovieClip):void
		{
			
			
			for (var i:int = 0; i < m.numChildren; i++)
             {
              if (m.getChildAt(i) is MovieClip)
              {
                var pObject:* = m.getChildAt(i);
				var strName = String(pObject.name).substring(0, 6);
			
				switch (strName) {
					 case "button":
						btn = new AntButton();
			            btn.addAnimationFromCache(getQualifiedClassName(pObject));
			            btn.x = pObject.x;
			            btn.y = pObject.y;
			            add(btn); 
						
						switch(pObject.name){
						  case "button_lsound":
							trace("sound");//btn.eventClick.add(goToPlayGame);
						  break;
						  case "button_lmenu":
							btn.eventClick.add(goToMenu);
						  break;
						  
						  
					      default: 
						   btn.eventClick.add(goToPlayMenu);
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
		
		private function goToPlayMenu(aButton:AntButton):void 
		{
		    AntG.storage.set("currentLevel", int((String(aButton.currentAnimation).substring(4,5))));
			aButton.eventClick.remove(goToPlayMenu);
			AntG.anthill.switchState(new playGameState());	
		}
		
		private function goToMenu(aButton:AntButton):void 
		{
			aButton.eventClick.remove(goToMenu);
			AntG.anthill.switchState(new menuMainState());
		}
		
		private function goToPlayGame(aButton:AntButton):void 
		{
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