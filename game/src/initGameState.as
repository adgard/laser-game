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
		private var _camera:AntCamera;
			private var mcForRasterization:Array = []; 
		private var mmenu:AntActor;
		private var btn:AntButton;
		public var storage:AntStorage = new AntStorage(true);
		public var sharedObj:AntCookie = new AntCookie();
	    private var levelNumber:int = 0; 

		private var mcArrayFromLevel:Array = [];
		
		protected var _started:Boolean = false;
		
		
		public function initGameState()
		{
			super();
			
			_started = false;
			
			new fakeClass();
			//createNapeSpace();
			
			
			 sharedObj.open("mutation");
			 loadDataToStorage();
			 
			_camera = new AntCamera(640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			addChild(_camera);
			AntG.track(_camera, "menuCamera");
			AntG.storage.set("currentLevel",1);
			
			
			//Добавляем классы клипов которые необходимо растеризировать.
			startCashing();
			AntG.cache.addClips(mcForRasterization); 
			AntG.cache.addClips([clockOrange]);
			AntG.cache.addClip(jointForMouse); 
			AntG.cache.addClips([node1,node2,balloon1]); 
			// Добавляем обработчик для завершения процесса растеризации.
			AntG.cache.eventComplete.add(onCacheComplete);
			
			// Запускаем процесс растеризации клипов.
			AntG.cache.cacheClips();
			initcbTypes();
		}
		
		private function startCashing():void 
		{
		 var mm:MovieClip =  new main_menu();
		 var lm:MovieClip = new level_menu();
		 var pm:MovieClip = new play_menu ();
		 var gc:MovieClip = new gCompleted ();
		 var lc:MovieClip = new lCompleted ();
		 var cf:MovieClip = new creditForm ();
		 
		parseLevel(mm);
		parseLevel(lm);
        parseLevel(pm)
		parseLevel(lc);
		parseLevel(gc);
		parseLevel(cf); 
		 	
		 for (var i:int = 1; i < 5; i++ ){
		 	var levelName:String = String("lev" + i);
			var levelBG:String = String("level" + (i-1));
			
			var refLevel:Class = getDefinitionByName(levelName) as Class;
			var refLevelBG:Class = getDefinitionByName(levelBG) as Class;
			
			
			var currentLevel:MovieClip =  (new refLevel() as MovieClip); //тащим мувиклип с левелом из библиотеки
            var currentBG:MovieClip =  (new refLevelBG() as MovieClip); //тащим мувиклип с левелом из библиотеки
            
			parseLevel(currentLevel);
			parseLevel(currentBG);
			
		 }
		 
		
		
		
		
		mm = null;
		lm = null;
		pm = null;
		gc = null;
		lc = null;
		cf = null;
		
		}
		
		
		
		private function initcbTypes():void 
		{
			 var buttonCbType:CbType = new CbType();
		     var spikeCbType:CbType = new CbType();
		     var dynamicCbType:CbType = new CbType();
			 var movesensorCbType:CbType = new CbType();
			 var moveableCbType:CbType = new CbType();
			 var iceCbType:CbType = new CbType();
			 var hero3CbType:CbType = new CbType();
			 var hero2CbType:CbType = new CbType();
			 var hero1CbType:CbType = new CbType();
			
			 var balloonCbType:CbType = new CbType();
			 var collectCbType:CbType = new CbType();
			 
			 
			AntG.storage.set("buttonCBT", buttonCbType);
			AntG.storage.set("spikeCBT", spikeCbType);
			AntG.storage.set("dynamicCBT", dynamicCbType);
			AntG.storage.set("moveableCBT", moveableCbType);
			AntG.storage.set("movesensorCBT", movesensorCbType);
			AntG.storage.set("iceCBT", iceCbType);
			AntG.storage.set("hero3CBT", hero3CbType);
			AntG.storage.set("hero2CBT", hero2CbType);
			AntG.storage.set("hero1CBT", hero1CbType);
			AntG.storage.set("spikeCBT", spikeCbType);
			AntG.storage.set("balloonCBT", balloonCbType);
			AntG.storage.set("collectCBT", collectCbType);
			
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
			//storage = storage;
			
		}
		
		
		
		/**
		 * Обработчик события завершения растеризации.
		 */
		private function onCacheComplete():void
		{
			//
			AntG.cache.eventComplete.remove(onCacheComplete);
			
			/*mmenu = new AntActor();
			mmenu.addAnimationFromCache("clockOrange");
			add(mmenu);
			*/
			AntG.anthill.switchState(new menuMainState());
			_started = true;
			
			
		}
		
		private function goToPlayGame(aButton:AntButton):void 
		{
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