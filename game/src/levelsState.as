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
		override public function create():void
		{
			_camera = new AntCamera(0, 0, 640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			AntG.track(_camera, "menuCamera");
			showLevelIcons(new level_menu());
			_started = true;
		}	
		
		public function levelsState()
		{
			super();
	
		}
	
		private function showLevelIcons(m:MovieClip):void
		{
			
			var cookies:AntCookie = AntG.storage.get("cookie");
			var arrLevels:* = (cookies.read("levels"));
			var iLevels:int = 0 ;
			for (var i:int = 0; i < m.numChildren; i++)
             {
              if (m.getChildAt(i) is MovieClip)
              {
                var pObject:* = m.getChildAt(i);
				var strName:String = String(pObject.name).substring(0, 6);
				var strName2:String = String(pObject.name).substring(0, 1);
				
			
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
					 
					  
					  if ((strName2 == "i") && (String(pObject.name).length < 5)) {
						  
						  btn = new AntButton();
			            btn.addAnimationFromCache(getQualifiedClassName(pObject));
			            btn.x = pObject.x;
			            btn.y = pObject.y;
					    btn.toggle = true;
			            add(btn); 
						  
						  if(String(pObject.name).length==2)
					   	   iLevels = int(String(pObject.name).substring(1, 2));
						  else 
						   iLevels = int(String(pObject.name).substring(1, 3));	
						   
						   if(arrLevels[iLevels-1]==1){
					        btn.selected = true;
						    AntButton(btn).eventClick.add(goToPlayMenu);
						   }
							
					       if(arrLevels[iLevels-1]==2){
					        btn.selected = true;
							AntButton(btn).eventClick.add(goToPlayMenu);
						   }
						   if(arrLevels[iLevels-1]==0)
					        btn.selected = false;
								
					  }
					  
					  else {
						     mc = new AntActor();
			                 mc.addAnimationFromCache(getQualifiedClassName(pObject));
			                 add(mc);
					         mc.x = pObject.x;
					         mc.y = pObject.y;
						   }
					  
					 break;
					}
				
              }
             }
				
			_started = true;
		}
		
		private function goToPlayMenu(aButton:AntButton):void 
		{
		    
			if(String(aButton.currentAnimation).length==5)
			 AntG.storage.set("currentLevel", int((String(aButton.currentAnimation).substring(4, 5)))-1);
			else 
			  AntG.storage.set("currentLevel", int((String(aButton.currentAnimation).substring(4, 6)))-1);
			
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