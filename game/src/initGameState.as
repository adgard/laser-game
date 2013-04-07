package 
{
	import flash.display.MovieClip;
	import nape.callbacks.CbType;
	import ru.antkarlov.anthill.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.*;
	
	public class initGameState extends AntState
	{
		
		
		 [Embed(source="sounds/button.mp3" )]
           public var button_snd:Class;
		   
		 [Embed(source="sounds/kill.mp3" )]
           public var kill_snd:Class;  
		   
		 [Embed(source="sounds/fail.mp3" )]
           public var failed_snd:Class;  
		   
		  [Embed(source="sounds/balloon.mp3" )]
           public var balloon_snd:Class;   
		   
		  [Embed(source="sounds/beetle.mp3" )]
           public var beetle_snd:Class;    
		   
		   [Embed(source="sounds/game_button.mp3" )]
           public var game_button_snd:Class; 
		   
		   [Embed(source="sounds/click_button.mp3" )]
           public var click_button_snd:Class;      
		   
		   
		
		private var _camera:AntCamera;
			private var mcForRasterization:Vector.<Class> = new Vector.<Class>; 
		private var mmenu:AntActor;
		private var btn:AntButton;
		public var storage:AntStorage = new AntStorage(true);
		public var sharedObj:AntCookie = new AntCookie();
	    private var levelNumber:int = 0; 

		private var mcArrayFromLevel:Array = [];
		private var loader:AntAssetLoader = new AntAssetLoader();
		private var cookie:AntCookie;	
		protected var _started:Boolean = false;
		private var cashMovie:MovieClip = new backCashing();
		private var aAnim:AntAnimation =  new AntAnimation();
		private var aActor:AntActor =  new AntActor();
		private var levelNumberArray:Array = [];
		
		public function initGameState()
		{
			super();
		}
		
		override public function create():void
		{
			
			createLevels();
			
			_started = false;
			
			new fakeClass();
			//createNapeSpace();
			aAnim.makeFromMovieClip(cashMovie)
            aActor.addAnimation(aAnim);
            add(aActor);
            		
			 //sharedObj.open("mutation");
			 loadDataToStorage();
			 
			_camera = new AntCamera(0,0,640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			
			AntG.track(_camera, "menuCamera");
			AntG.storage.set("currentLevel",0);
			
			
			var cookie:AntCookie = new AntCookie();
            cookie.open("goldBeatles1");
			
			var arrLevels:*  = (cookie.read("levels"));
			
			if (arrLevels == null) {
				arrLevels = [];
			 for (var n:int = 0; n < 28; n++ )
			  (arrLevels as Array).push(0); 
			  
			  arrLevels[0] = 1;
			  
			  cookie.write("levels", arrLevels);
			  trace("levels inited");
				  
			}
			else {
				  trace("levels loaded");
				  cookie.write("levels", arrLevels);
				 }
			
			AntG.storage.set("cookie",cookie);
			
			
			//Добавляем классы клипов которые необходимо растеризировать.
			startCashing();
			
			super.create();
			
			
		
			loader.addClips(mcForRasterization); 
			loader.addClips(new <Class>[leverImg,jointForMouse,arrows,iceBoom11,iceBoom12,iceBoom14,boom,boomBallons,boom4]);
			loader.addClips(new <Class>[node1, node2, balloon1,mc_node,hero1_a1,hero1_a2,hero2_a1,hero2_a2,hero3_a2,hero4_a0,hero4_a2,hero4_a2_2,bugAnimation,starAnimation]); 
			
			
			//AntG.sounds.baseURL = "sounds/";
			AntG.sounds.addEmbedded(button_snd, "button");
			AntG.sounds.addEmbedded(kill_snd, "kill");
			AntG.sounds.addEmbedded(failed_snd, "failed");
			AntG.sounds.addEmbedded(ballon_snd, "balloon");
			AntG.sounds.addEmbedded(beetle_snd, "beetle");
			AntG.sounds.addEmbedded(game_button_snd, "gButton");
			AntG.sounds.addEmbedded(click_button_snd, "cButton");
			
			
			// Добавляем обработчик для завершения процесса растеризации.
			loader.eventComplete.add(onCacheComplete);
			loader.start();
			// Запускаем процесс растеризации клипов.
			
			initcbTypes();
		}
		
		private function createLevels():void 
		{
		//level 1
		levelNumberArray.push(26);
		// level 2
		levelNumberArray.push(2);
		// level 3
		levelNumberArray.push(27);
		// level 4
		levelNumberArray.push(3);
		
		// level 5
		levelNumberArray.push(4);
		
		// level 6
		levelNumberArray.push(24);
		
		// level 7
		levelNumberArray.push(6);
		
		// level 8
		levelNumberArray.push(14);
		
		// level 9
		levelNumberArray.push(13);
		
		// level 10
		levelNumberArray.push(12);
		
		// level 11
		levelNumberArray.push(8);
		
		// level 12
		levelNumberArray.push(28);
		
		// level 13
		levelNumberArray.push(5);
		
		// level 14
		levelNumberArray.push(18);
		
		// level 15
		levelNumberArray.push(17);
		
		// level 16
		levelNumberArray.push(16);
		
		// level 17
		levelNumberArray.push(22);
		
		// level 18
		levelNumberArray.push(23);
		
		// level 19
		levelNumberArray.push(7);
		
		// level 20
		levelNumberArray.push(9);
		
		// level 21
		levelNumberArray.push(18);
		
		// level 22
		levelNumberArray.push(20);
		
		
		// level 23
		levelNumberArray.push(19);
		
		// level 23
		levelNumberArray.push(15);
		
		// level 24
		levelNumberArray.push(1);
		
		// level 25
		levelNumberArray.push(25);
		
		// level 26
		levelNumberArray.push(11);
		
		// level 27
		levelNumberArray.push(10);
		
		// level 28
		levelNumberArray.push(21);
		
		AntG.storage.set("levelNumbers",levelNumberArray);
		 
		
		}
		
		private function startCashing():void 
		{
		 var mm:MovieClip =  new main_menu();
		 var lm:MovieClip = new level_menu();
		 var pm:MovieClip = new play_menu ();
		 var gc:MovieClip = new gCompleted();
		 var lc:MovieClip = new lCompleted();
		 var cf:MovieClip = new creditForm();
		 var ff:MovieClip = new level_failed();
		 
		 
		 
		parseLevel(mm);
		parseLevel(lm);
        parseLevel(pm)
		parseLevel(lc);
		parseLevel(gc);
		parseLevel(cf); 
		parseLevel(ff); 
		
		 	
		 for (var i:int = 1; i < 29; i++ ){
		 	var levelName:String = String("lev" + i);
			var levelBG:String = String("level" + (i-1));
			
			var refLevel:Class = getDefinitionByName(levelName) as Class;
			var refLevelBG:Class = getDefinitionByName(levelBG) as Class;
			
			
			var currentLevel:MovieClip =  (new refLevel() as MovieClip); 
           // var currentBG:MovieClip =  (new refLevelBG() as MovieClip); //тащим мувиклип с левелом из библиотеки
            
			parseLevel(currentLevel);
		//	parseLevel(currentBG);
			
		 }
		 
		
		
		
		
		mm = null;
		lm = null;
		pm = null;
		gc = null;
		lc = null;
		cf = null;
		ff = null;
		
		}
		
		
		
		private function initcbTypes():void 
		{
			 var buttonCbType:CbType = new CbType();
		     var spikeCbType:CbType = new CbType();
		     var dynamicCbType:CbType = new CbType();
			 var movesensorCbType:CbType = new CbType();
			 var moveableCbType:CbType = new CbType();
			 var iceCbType:CbType = new CbType();
			 
			 var hero4CbType:CbType = new CbType();
			 var hero3CbType:CbType = new CbType();
			 var hero2CbType:CbType = new CbType();
			 var hero1CbType:CbType = new CbType();
			
			 var balloonCbType:CbType = new CbType();
			 var collectCbType:CbType = new CbType();
			 var magnetCbType:CbType = new CbType();
			 var magnetStatCbType:CbType = new CbType();
			 
			 
			AntG.storage.set("buttonCBT", buttonCbType);
			AntG.storage.set("spikeCBT", spikeCbType);
			AntG.storage.set("dynamicCBT", dynamicCbType);
			AntG.storage.set("moveableCBT", moveableCbType);
			AntG.storage.set("movesensorCBT", movesensorCbType);
			AntG.storage.set("iceCBT", iceCbType);
			AntG.storage.set("hero4CBT", hero4CbType);
			AntG.storage.set("hero3CBT", hero3CbType);
			AntG.storage.set("hero2CBT", hero2CbType);
			AntG.storage.set("hero1CBT", hero1CbType);
			AntG.storage.set("spikeCBT", spikeCbType);
			AntG.storage.set("balloonCBT", balloonCbType);
			AntG.storage.set("collectCBT", collectCbType);
			AntG.storage.set("magnetCBT", magnetCbType);
			AntG.storage.set("magnetStatCBT", magnetStatCbType);
			
		}
	
		private function parseLevel(_currentLevel:MovieClip):void 
		{
			for (var i:int = 0; i < _currentLevel.numChildren; i++)
             {
              if (_currentLevel.getChildAt(i) is MovieClip)
              {
                var pObject:*=_currentLevel.getChildAt(i);
                mcArrayFromLevel.push(pObject);
                trace(pObject);
              }
             }
			 
			 for each (var obj:* in mcArrayFromLevel) {	
				// var testd:String = getQualifiedClassName(MovieClip(obj));
			  if(mcForRasterization.indexOf(getDefinitionByName(getQualifiedClassName(MovieClip(obj))) as Class)==-1){
				mcForRasterization.push(getDefinitionByName(getQualifiedClassName(MovieClip(obj))) as Class);
			 }
			}
		}
		private function loadDataToStorage():void 
		{
			storage.set("levelArray", sharedObj.read("levelArray"));
			storage.set("lastLevel", sharedObj.read("lastLevel"));
		}
		
		
		
		/**
		 * Обработчик события завершения растеризации.
		 */
		private function onCacheComplete(aLoader:AntAssetLoader):void
		{
			loader.eventComplete.remove(onCacheComplete);
			aLoader.destroy();
			
			AntG.anthill.switchState(new menuMainState());
			_started = true;
			
			
		}
		
		private function goToPlayGame(aButton:AntButton):void 
		{
			remove(aActor);
			AntG.anthill.switchState(new playGameState());
		}
		
		
		override public function postUpdate():void
		{
			
			super.postUpdate();
		}
		override public function destroy():void
		{
			AntG.removeCamera(_camera);
			super.destroy();
		}
		
		
		/**
		 * @private
		 */
	

	}

}