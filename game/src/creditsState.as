package 
{
	import flash.display.MovieClip;
	import ru.antkarlov.anthill.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.*;
	
	public class creditsState extends AntState
	{
		private var _camera:AntCamera;
		
		private var mc:AntActor;
		private var btn:AntButton;
		
		
		protected var _started:Boolean = false;
		
		override public function create():void
		{	
			_camera = new AntCamera(0,0,640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			
			AntG.track(_camera, "TestUI camera");
			
			AntG.debugger.monitor.clear();
			showUI(new creditForm());
			_started = true;
		}
		public function creditsState()
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
						  
						  
						  case "button_cMenu":
							btn.eventClick.add(goToMenu);
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
		
		private function goToMenu(aButton:AntButton):void 
		{
			aButton.eventClick.remove(goToMenu);
			AntG.anthill.switchState(new menuMainState());
			AntG.sounds.play("button");
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