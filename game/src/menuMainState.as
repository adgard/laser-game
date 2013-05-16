package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
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
		
		
		protected var _started:Boolean = false;
		
		override public function create():void
		{	
			_camera = new AntCamera(0,0,640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			AntG.antSpace = this;
			AntG.track(_camera, "TestUI camera");
			if(!AntG.sounds.isPlaying("loop"))
			AntG.sounds.play("loop",null,false,1000);

			AntG.debugger.monitor.clear();
			if (isUrl(["","bestphysics.com", "fgl.com", "flashgamelicense.com"])) {
			 showUI(new main_menu());
			}
			else 
			 trace("sitelocked");
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
						  
					     case "button_msound":
							 var s:MovieClip =  new soundZone();
							 s.x = btn.x;
							 s.y = btn.y;
							 
						     AntG.antSpace.addChild(s);
							 remove(btn);
							 
							 if (AntG.sounds.mute == true){
							    s.gotoAndStop(2);
							   }
							  else 
							    s.gotoAndStop(1);
							  
							 
							  s.addEventListener(MouseEvent.CLICK, goToSound);
							break;
						  
					      
						  case "button_levels":
							btn.eventClick.add(goToLevels);
						  break;
						  
						  case "button_credits":
							btn.eventClick.add(goToCredits);
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
		
	private function goToSound(e:MouseEvent):void 
		{
			
			AntG.sounds.play("button");
			if (AntG.sounds.mute == false){
			 AntG.sounds.mute = true;
			  AntG.sounds.pause();
			  MovieClip(e.currentTarget).gotoAndStop(2);
			   //aButton.selected = true;
			}
			
			else {
			  AntG.sounds.mute = false;
			  AntG.sounds.resume();
			  MovieClip(e.currentTarget).gotoAndStop(1);
			  //aButton.selected = false;
			}
		}
		
		public function isUrl(urls:Array):Boolean 
  {
   var url:String = loaderInfo.loaderURL;
   var urlStart:Number = url.indexOf("://")+3;
   var urlEnd:Number = url.indexOf("/", urlStart);
   var domain:String = url.substring(urlStart, urlEnd);
   var LastDot:Number = domain.lastIndexOf(".")-1;
   var domEnd:Number = domain.lastIndexOf(".", LastDot)+1;
   domain = domain.substring(domEnd, domain.length);
   for (var i:int = 0; i < urls.length; i++) 
    if (domain == urls[i]) return true;

    return false;
  }
		private function goToCredits(aButton:AntButton):void 
		{
		    aButton.eventClick.remove(goToCredits);
			AntG.anthill.switchState(new creditsState());
			AntG.sounds.play("button");	
		}
		
		private function goToLevels(aButton:AntButton):void 
		{
			aButton.eventClick.remove(goToLevels);
			AntG.anthill.switchState(new levelsState());
			AntG.sounds.play("button");
		}
		
		private function goToPlayGame(aButton:AntButton):void 
		{
			
			//AntG.storage.set("level", this["level1_"+1]());
			aButton.eventClick.remove(goToPlayGame);
			AntG.anthill.switchState(new playGameState());
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