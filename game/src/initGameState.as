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
			private var mcForRasterization:Vector.<Class> = new Vector.<Class>; 
		private var mmenu:AntActor;
		private var btn:AntButton;
		public var storage:AntStorage = new AntStorage(true);
		public var sharedObj:AntCookie = new AntCookie();
	    private var levelNumber:int = 0; 

		private var mcArrayFromLevel:Array = [];
		private var loader:AntAssetLoader = new AntAssetLoader();
			
		protected var _started:Boolean = false;
		
		public function initGameState()
		{
			super();
		}
		
		override public function create():void
		{
			
			
			_started = false;
			
			new fakeClass();
			//createNapeSpace();
			
			
			 sharedObj.open("mutation");
			 loadDataToStorage();
			 
			_camera = new AntCamera(0,0,640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			
			AntG.track(_camera, "menuCamera");
			AntG.storage.set("currentLevel",1);
			
			
			//Добавляем классы клипов которые необходимо растеризировать.
			startCashing();
			
			super.create();
			
			
		
			loader.addClips(mcForRasterization); 
			loader.addClips(new <Class>[clockOrange,leverImg,jointForMouse]);
			loader.addClips(new <Class>[node1, node2, balloon1,mc_node]); 
			
			// Добавляем обработчик для завершения процесса растеризации.
			loader.eventComplete.add(onCacheComplete);
			loader.start();
			// Запускаем процесс растеризации клипов.
			
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
		 	
		 for (var i:int = 1; i < 26; i++ ){
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