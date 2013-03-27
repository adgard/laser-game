package 
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.*;
	import nape.callbacks.*;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.constraint.AngleJoint;
	import nape.constraint.MotorJoint;
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.dynamics.InteractionFilter;
	
	import ru.antkarlov.anthill.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import nape.geom.*;
    import nape.phys.*;
    import nape.shape.*;
    import nape.space.*;
    import nape.util.*;
	
	
	public class playGameState extends AntState
	{
		private var currentRay:rays;
		private var rayCastArray:Array = [];
		private var raysForDelete:Array = [];
		
		private var an:AntAnimation =  new AntAnimation();
		private var run:Boolean = false;
		private var rayMC:MovieClip = new MovieClip();
		private var rayActor:AntActor = new AntActor();
		
		private var starCounter:int = 3;
		private var lcompl:AntActor = new AntActor();
		private var gcompl:AntActor = new AntActor();
		private var lFailed:AntActor = new AntActor();
		
		private var actorForDelete:Array = [];
		private var _space:Space;
        private var _timeStep:Number = 1/30.0;
        private var _velocityIterations:int = 10;
        private var _positionIterations:int = 10;
		private var _camera:AntCamera;
		private var levelNumber:int = 0; 
		private var bg:AntActor;
		private var act:AntActor = new AntActor();
		private var btn:AntButton;
		private var mc:AntActor;
		
		protected var _started:Boolean = false;
		private var backGround:AntActor; 
		
		private var eventLoad:AntEvent = new AntEvent();
		private var actorArray:Array = [];
		private var mcArrayFromLevel:Array = [];
		private var mcForRasterization:Array = []; 
		private var mcForPhysics:Array = []; 
		private var mcForDecoration:Array = []; 
		
		private var mcComplexForPhysics:Array = []; 
		private var mcForJoints:Array = [];
	
		
		private var mouseJoint:PivotJoint = null;
		private var mouseJointBody:actorBox = null;
		private var redactorEnabled:Boolean = false;
		
		override public function create():void
		{
		  levelNumber = AntG.storage.get("currentLevel");
			var levelBG:String = String("level" + (levelNumber-1));
			var levelName:String = String("lev" + levelNumber);
			var refLevel:Class = getDefinitionByName(levelName) as Class;
			var refBG:Class = getDefinitionByName(levelBG) as Class;
			
			var currentLevel:MovieClip =  (new refLevel() as MovieClip); //тащим мувиклип с левелом из библиотеки
			var currentBG:MovieClip =  (new refBG() as MovieClip); //тащим мувиклип с левелом из библиотеки
			
			AntG.storage.set("actorForDelete", actorForDelete);
			AntG.storage.set("rays", rayCastArray);
			AntG.storage.set("gameStatus", "none");
			
			
			
			
			//var currentLevel:MovieClip =  new lev3();
			createNapeSpace();//
            parseLevel(currentLevel);
			
			 
			_camera = new AntCamera(0,0,640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			
			AntG.addCamera(_camera);
			
			AntG.track(_camera, "gameCamera");
			
			//showUI(currentBG ,null,0);	
			
			
			createPhysObject();
			checkRefferences();
			
			createJoints();
		
			
			new contacts();
		    
			
			showUI(new play_menu(), null, 0);
			lcompl.tag = 200;
			
			showUI(new lCompleted(), lcompl,200);
			gcompl.tag = 200;
			
			showUI(new level_failed(), lFailed, 201);
			lFailed.tag = 201;
			
			showUI(new gCompleted(), gcompl,202);
			defGroup.sort("tag");
			
		    //add(lcompl);
			
			_started = true;
			run = true;
			
			
				
		}
		
		public function playGameState()
		
		{
			new fakeClass();
			super();
		}
		
		
		
		private function createNapeSpace():void 
		{
			_space = new Space(new Vec2(0, 400), Broadphase.SWEEP_AND_PRUNE);
			AntG.space = _space;
			AntG.antSpace = this;
			
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
				if((obj is componentClass)||(obj is componentJoint)){ 
				switch(obj.name2) {
					case "rectangle":
						if(mcForPhysics.indexOf(getQualifiedClassName(MovieClip(obj)))==-1)
				         mcForPhysics.push(obj);
					break;
					
				
					
					
					case "circle":
						if(mcForPhysics.indexOf(getQualifiedClassName(MovieClip(obj)))==-1)
				         mcForPhysics.push(obj);
					break;
					
					
					
					
					
				    case "joint":
					 mcForJoints.push(obj);
				    break;	
					
					case "complex":
					 if(mcComplexForPhysics.indexOf(getQualifiedClassName(MovieClip(obj)))==-1){
						 mcComplexForPhysics.push([obj,getPointForComplex(obj)]);
					 }
				    break;	
					
					
				   default:
					
				   break;
				}
				
				
		       
			 }
			 else {
				    if(mcForDecoration.indexOf(getQualifiedClassName(MovieClip(obj)))==-1)
				         mcForDecoration.push(obj);
				  }
				  
			/* if(mcForRasterization.indexOf(getDefinitionByName(getQualifiedClassName(MovieClip(obj))) as Class)==-1){
				mcForRasterization.push(getDefinitionByName(getQualifiedClassName(MovieClip(obj))) as Class);
			 }
			*/
			}
		}
		
		private function createPhysObject():void 
		{
			actorArray = [];
			     var currentActor:actor;
				 var currentAnimation:AntAnimation;
				 var c:componentClass;
				 var currentAntActor:AntActor = new AntActor();
				
				for each(var m:MovieClip in mcForDecoration) {
				  //currentAnimation.destroy();
				  currentAntActor = new AntActor();
				  currentAntActor.x = m.x;
				  currentAntActor.y = m.y;
				  currentAntActor.angle = m.rotation * Math.PI / 180;
				  currentAntActor.addAnimationFromCache(getQualifiedClassName(MovieClip(m)));
				  currentAntActor.tag = defGroup.numChildren;
				  add(currentAntActor);
				}	 
				 
				 
			for each(c in mcForPhysics) {
				 // currentAnimation.destroy();
				  currentAntActor = new AntActor();
				  currentAntActor.x = c.x;
				  currentAntActor.y = c.y;
				  currentAntActor.angle = c.rotation * Math.PI / 180;
				  currentAntActor.addAnimationFromCache(getQualifiedClassName(MovieClip(c)));
				  currentAntActor.tag = defGroup.numChildren;
				  add(currentAntActor);
				 switch (c.name2) {
					
					 case "rectangle":
					 if (c.refType != "lever") {
						
					   currentActor = new actorBox(currentAntActor, new Vec2(c.x, c.y), c.rotation * Math.PI / 180, c.bodyType, c.shapeType, [c.density,c.dynamicFriction,c.elasticity,c.rollingFriction,c.staticFriction],c.materialType,[],c.name2,c.isSensor,new Vec2(c.velx,c.vely),c.isMoveable,c.isMoveableSensor,c.refNumber,c.refType,c.typeElement,c.rayType,c.isStatic);
		   
					   _space.bodies.add(currentActor._body);
					   
					   if (c.arrowType != "none") {
						 var comArr:componentIcon = componentIcon(c.getChildByName("a")) 	 
						  if(comArr){
						     currentAntActor = new AntActor();
				             currentAntActor.x = comArr.x;
				             currentAntActor.y = comArr.y;
				             currentAntActor.angle = comArr.rotation * Math.PI / 180;
				             currentAntActor.addAnimationFromCache("arrows");
							  actorBox(currentActor).addArrow(currentAntActor,c.arrowType);
						  }
						 }
					    
					   actorArray.push(currentActor);
					 }
					 else 
					  createLever(c);
					 break;
				      
					   
					  case "circle":
					   currentActor = new actorCircle(currentAntActor, new Vec2(c.x, c.y), c.rotation * Math.PI / 180, c.bodyType, c.shapeType, [c.density,c.dynamicFriction,c.elasticity,c.rollingFriction,c.staticFriction],c.materialType,c.name2,c.isSensor,new Vec2(c.velx,c.vely),c.isMoveable,c.isMoveableSensor,c.refNumber,c.refType,c.typeElement,c.rayType,c.isStatic);
					   _space.bodies.add(currentActor._body);
					   actorArray.push(currentActor);
					  break;

					  
				      default:
					   trace('nothing for physics');
					  break;
					 }
				  //currentActor = new 
				}
				
			for each(var a:Array in mcComplexForPhysics) {
				 c = a[0];
				  //currentAnimation.destroy();
				  currentAntActor = new AntActor();
				  currentAntActor.x = c.x;
				  currentAntActor.y = c.y;
				  currentAntActor.angle = c.rotation * Math.PI / 180;
				  currentAntActor.addAnimationFromCache(getQualifiedClassName(MovieClip(c)));
				  currentAntActor.tag = defGroup.numChildren;
				  add(currentAntActor);
				 switch (c.name2) {
					
					  
				  case "complex":
					  getPointForComplex(c);
					   currentActor = new actorBox(currentAntActor, new Vec2(c.x, c.y), c.rotation * Math.PI / 180, c.bodyType, c.shapeType, [c.density,c.dynamicFriction,c.elasticity,c.rollingFriction,c.staticFriction],c.materialType,a[1],c.name2,false,new Vec2(c.velx,c.vely),c.isMoveable,c.isMoveableSensor,c.refNumber,c.refType,c.typeElement,c.rayType,c.isStatic);
					  _space.bodies.add(currentActor._body);
					   actorArray.push(currentActor);
					  break;
					  
					  
				      default:
					   trace('nothing for physics');
					  break;
					 }
				  //currentActor = new 
				}
				

		}
		
		private function createLever(c:componentClass):void 
		{
	
			 var currentAntActor:AntActor = new AntActor();
				 
				 var currentLever:actorBox;
				
				 
				 var pJoint:PivotJoint;
				  var aJoint:AngleJoint;
				
				 var b2:Body;
			     var b2List:BodyList = _space.bodiesUnderPoint(new Vec2(c.x, c.y));
			     if (b2List.length > 0 ){
				  b2 =  b2List.at(0);
 
				  currentAntActor.x = c.x;
				  currentAntActor.y = c.y;
				  currentAntActor.angle = 0;
				  currentAntActor.addAnimationFromCache("leverImg");      
				  add(currentAntActor);
				   currentAntActor.tag = defGroup.numChildren;
				  currentLever = new actorBox(currentAntActor, new Vec2(c.x, c.y-20), c.rotation * Math.PI / 180, c.bodyType, c.shapeType, [c.density,c.dynamicFriction,c.elasticity,c.rollingFriction,c.staticFriction],c.materialType,[],c.name2,c.isSensor,new Vec2(c.velx,c.vely),c.isMoveable,c.isMoveableSensor,c.refNumber,c.refType,c.typeElement,c.rayType,c.isStatic); 
				  _space.bodies.add(currentLever._body);
				  
				  actorArray.push(currentLever);

				  pJoint = new PivotJoint(currentLever._body, b2, currentLever._body.worldPointToLocal(new Vec2(c.x, c.y)), b2.worldPointToLocal(new Vec2(c.x, c.y)));
				  pJoint.ignore = true;
				//  pJoint.maxForce = 1000;
				 _space.constraints.add(pJoint);
				 
				   aJoint = new AngleJoint( b2,currentLever._body,-Math.PI/4,Math.PI/4,1);
				  aJoint.ignore = true;
				//  aJoint.maxForce = 1000;
				 _space.constraints.add(aJoint);
				 
				 trace("lever"); 
				 }
				
		}
		
		private function getPointForComplex(com:MovieClip):Array
		{
			var m:*;
			
			 var  pointArrayForComplex:Array  = [];
			for (var i:int = 0; i < com.numChildren; i++)
             {
				 m = com.getChildByName("i"+i);
              if (com.getChildAt(i) is MovieClip)
              {
                var pObject:*=com.getChildAt(i);
                pointArrayForComplex.push(new Vec2(pObject.x,pObject.y));
                //trace(pObject);
              }
             }
			 
			 return pointArrayForComplex;
		}
		
		
		
		/**
		 * Обработчик события завершения растеризации.
		 */
		
		private function showUI(m:MovieClip,_a:AntActor,_tag:int):void
		{
			//
			var a:AntActor = _a;
            
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
						btn.tag = defGroup.numChildren + _tag;;
			            if(a!=null)
						 a.add(btn); 
						else 
						 add(btn);
						switch(pObject.name){
						  case "button_pmenu":
							btn.eventClick.add(goToMenu);
						  break;
						  case "button_prestart":
							btn.eventClick.add(goToRestart);
						  break;
						  
						   case "button_frestart":
							btn.eventClick.add(goToRestart);
						  break;
						  case "button_fsolution":
							trace("solution");//btn.eventClick.add(goToRestart);
						  break;
						  case "button_flevels":
							btn.eventClick.add(goToMenu);
						  break;
						  
						  
						  case "button_psolution":
							trace("solution");//btn.eventClick.add(goToRestart);
						  break;
						  
						  case "button_psound":
							trace("sound");//btn.eventClick.add(goToRestart);
						  break;
						  
						  
						  case "button_lrestart":
							btn.eventClick.add(goToRestart);
						  break;
						  case "button_llevels":
							btn.eventClick.add(goToMenu);
						  break;
						  case "button_lnext":
							btn.eventClick.add(goToNext);
						  break;
						  
						  case "button_glevels":
							btn.eventClick.add(goToMenu);
						  break;
						  case "button_gnext":
							btn.eventClick.add(goToNext);
						  break;
						  
					      default:
						 
						  break;
						 }
				     break;
				    
					 default:
					  mc = new AntActor();
			          mc.addAnimationFromCache(getQualifiedClassName(pObject));
			          mc.x = pObject.x;
					  mc.y = pObject.y;
					  
					  if(a!=null){
					   a.add(mc);
					   mc.tag = defGroup.numChildren  +_tag;
					   } 
						else {
						 add(mc);
						 mc.tag = defGroup.numChildren + _tag;
						}
					 break;
					}
				
              }
             }
			
		
			
			_started = true;
	
		} 
		
		private function goToNext(aButton:AntButton):void 
		{
			aButton.eventClick.remove(goToNext);
			AntG.storage.set("currentLevel",levelNumber+1);
			AntG.anthill.switchState(new playGameState());
			
			lcompl.kill();
			gcompl.kill();
			
		}
	
		
		
		private function checkRefferences():void 
		{
			var currentNodeRefference:actor;
			var buttonNode:actor;
			var bList:BodyList;
			
			var buttonNodePoint:Vec2;
			for each (var a:* in actorArray) {
				 if (a._type == "button") {
					
					 bList = _space.bodiesUnderPoint(a._body.position);
					 if(bList.length > 1){
					   if(bList.at(0).userData.act.type =="button" ){
						 a.buttonNode = bList.at(1).userData.act;
						 bList.at(1).userData.act.buttonNodePoint =  bList.at(1).worldPointToLocal(a._body.position);
					   } 
					   else 
					   {
						 a.buttonNode = bList.at(0).userData.act;
						 bList.at(0).userData.act.buttonNodePoint = bList.at(0).worldPointToLocal(a._body.position);
					   } 
					 }
					 currentNodeRefference = a;
			          for each (var b:actor in actorArray) {
					   if ((b._refType!="none")&&(b._refNumber == currentNodeRefference._refNumber)&&(b._refType!="button")) {
						    currentNodeRefference.refArray.push(b);
						    b.refArray.push(currentNodeRefference);
						   }
					  }
				}
		     }
		}
		private function mouseUpListener():void 
		{
			trace("up");
			if (mouseJoint != null) {
				_space.constraints.remove(mouseJoint);
				 mouseJointBody.removeActor();
				 mouseJoint = null; 
				}
		}
		

		
		private function mouseDownListener():void 
		{
			trace("down");
			if(run){
			var bL:BodyList;
			
			if(redactorEnabled){ 
			 if (mouseJoint == null) {
				bL = _space.bodiesUnderPoint(new Vec2(AntG.mouse.x,AntG.mouse.y))
			
			if((bL)&&(bL.length>0)&&(bL.at(0).isDynamic())){
			     
				 var currentAnimation:AntAnimation;
				 var currentAntActor:AntActor = new AntActor();
				  currentAntActor.x = AntG.mouse.x;
				  currentAntActor.y = AntG.mouse.y;
				  currentAntActor.angle = 0;
				  currentAntActor.addAnimationFromCache("jointForMouse");      
				  mouseJointBody = new actorBox(currentAntActor, new Vec2(AntG.mouse.x,AntG.mouse.y), 0, "kinematic", "width_height", [0,0,0,0,0],"steel",[],"rectangle",false,new Vec2(0,0),false,false,0,"none","none", "pass",false);
				  _space.bodies.add(mouseJointBody._body);
				  //actorArray.push(currentActor);
				  //bList.at(0).worldPointToLocal(jointPoint), bList.at(1).worldPointToLocal(jointPoint)
				  mouseJoint = new PivotJoint(mouseJointBody._body, bL.at(0), mouseJointBody._body.worldPointToLocal(new Vec2(AntG.mouse.x, AntG.mouse.y)), bL.at(0).worldPointToLocal(new Vec2(AntG.mouse.x, AntG.mouse.y)));
				  mouseJoint.ignore = true;
				  mouseJoint.maxForce = 1000;
				  mouseJoint.space = _space;
			}
		 }
		 else {
			   
				//trace(mouseJointBody._body.position.x );
				//trace(mouseJointBody._body.position.y );
				
			  }
			}
			
			else {
				   bL = _space.bodiesUnderPoint(new Vec2(AntG.mouse.x, AntG.mouse.y));
				   if ((bL.length ==1)) {
				    switch (actor(Body(bL.at(0)).userData.act)._type) {
					 case "hero1":
						if (!bL.at(0).userData.act.ropeEnabled) {
						 if(!bL.at(0).userData.act.balloonEnabled){
						  //createBalloon(new Vec2(AntG.mouse.x, AntG.mouse.y), bL.at(0));
						  //Body(bL.at(0)).userData.act.balloonEnabled = true;
						   bL.at(0).gravMass = -bL.at(0).gravMass; 
						  }
						 }
						  else{ 
					           actorForDelete.push(bL.at(0).userData.act.ropeComp);
					           bL.at(0).userData.act.ropeComp =  null;
					           bL.at(0).userData.act.ropeEnabled = false;
							  //bL.at(0).gravMass = -bL.at(0).gravMass;
					          }
					 break;
				     
				    case "hero2":
						
					 if (!bL.at(0).userData.act.ropeEnabled) {
							
						
					    if(!Body(bL.at(0)).userData.act.jumpRayEnabled){
						 addJumpRays(Body(bL.at(0)));
						 
						}
						if(Body(bL.at(0)).userData.act.canJump)
					     heroJump(bL.at(0));
						else 
						 trace("in flying");
						 
					 }	
					 else{ 
					   actorForDelete.push(bL.at(0).userData.act.ropeComp);
					   bL.at(0).userData.act.ropeComp =  null;
					   bL.at(0).userData.act.ropeEnabled = false;
					 }
					 
					 	 //createBalloon(new Vec2(AntG.mouse.x,AntG.mouse.y),bL.at(0));
					/*	 if (Body(bL.at(0)).userData.act.contactCounterIce > 0) {
							     
							     removeIceUnderHero2(Body(bL.at(0)).userData.act.iceUnderHero);   
							   }*/
					 break;
					 
				 case "hero3":
					 
					  if (bL.at(0).userData.act.ropeEnabled) {
						  actorForDelete.push(bL.at(0).userData.act.ropeComp);
					      bL.at(0).userData.act.ropeComp =  null;
					      bL.at(0).userData.act.ropeEnabled = false;
						  } 
					     
						  createExplosion(bL.at(0));
						  actorForDelete.push(bL.at(0).userData.act);
						 
						 
						// gameCompleted();
					 break;
				    
				 case "hero4":
					 if(!bL.at(0).userData.act.ropeEnabled)
					   recreateHero(bL.at(0));
					 else{ 
					   actorForDelete.push(bL.at(0).userData.act.ropeComp);
					   bL.at(0).userData.act.ropeComp =  null;
					   bL.at(0).userData.act.ropeEnabled = false;
					 }
				 break; 
					
			 case "button": 
				 if(bL.at(0).userData.act.refType == "buttonClick"){
				  if (bL.at(0).userData.act.bClickEnabled) {
					 bL.at(0).userData.act.bClickEnabled = false;
					 AntActor(bL.at(0).userData.graphic).gotoAndStop(1);
					 bL.at(0).userData.act.disableRefference();
					 
					}   
				else {
					   bL.at(0).userData.act.bClickEnabled = true;
					   AntActor(bL.at(0).userData.graphic).gotoAndStop(2);
					   bL.at(0).userData.act.enableRefference();
					 }
				 }
				 break; 
				 
				  case "attraction":
					  if(bL.at(0).userData.act.rayEnabled == false){
					   currentRay =  new rays(bL.at(0), new Vec2(-10,0), 0,"attraction",400);
				       rayCastArray.push(currentRay);
					   bL.at(0).userData.act.rayEnabled = true;
					   bL.at(0).userData.act.rayArray.push(currentRay);
					   AntActor(bL.at(0).userData.graphic).gotoAndStop(2);
					  }
					  else 
					    {
						 bL.at(0).userData.act.rayEnabled = false;	
						 AntActor(bL.at(0).userData.graphic).gotoAndStop(1);
						 for  each (var r:rays in bL.at(0).userData.act.rayArray){
						  raysForDelete.push(r);
						  r.clear();
						 }
						 
						 bL.at(0).userData.act.rayArray = [];
						}
				 break;
				 
				 case "emitter":
					  if(bL.at(0).userData.act.rayEnabled == false){
					   currentRay =  new rays(bL.at(0), new Vec2(-10,0), 0,"emitter",640);
				       rayCastArray.push(currentRay);
					   bL.at(0).userData.act.rayEnabled = true;
					   bL.at(0).userData.act.rayArray.push(currentRay);
					   AntActor(bL.at(0).userData.graphic).gotoAndStop(2);
					  }
					  else 
					    {
						 bL.at(0).userData.act.rayEnabled = false;	
						 AntActor(bL.at(0).userData.graphic).gotoAndStop(1);
						 for  each (var r:rays in bL.at(0).userData.act.rayArray){
						  raysForDelete.push(r);
						  r.clear();
						 }
						 
						 bL.at(0).userData.act.rayArray = [];
						}
				 break;
				 
				  case "killer":
					  if(bL.at(0).userData.act.rayEnabled == false){
					   currentRay =  new rays(bL.at(0), new Vec2(-10,0), 0,"killer",400);
				       rayCastArray.push(currentRay);
					   bL.at(0).userData.act.rayEnabled = true;
					   bL.at(0).userData.act.rayArray.push(currentRay);
					   AntActor(bL.at(0).userData.graphic).gotoAndStop(2);
					  }
					  else 
					    {
						 bL.at(0).userData.act.rayEnabled = false;	
						 AntActor(bL.at(0).userData.graphic).gotoAndStop(1);
						 for  each (var r:rays in bL.at(0).userData.act.rayArray){
						  raysForDelete.push(r);
						  r.clear();
						 }
						 
						 bL.at(0).userData.act.rayArray = [];
						}
				 break;
				  case "repulsion":
					  if(bL.at(0).userData.act.rayEnabled == false){
					   currentRay =  new rays(bL.at(0), new Vec2(-10,0), 0,"repulsion",400);
				       rayCastArray.push(currentRay);
					   bL.at(0).userData.act.rayEnabled = true;
					   bL.at(0).userData.act.rayArray.push(currentRay);
					   AntActor(bL.at(0).userData.graphic).gotoAndStop(2);
					  }
					  else 
					    {
						 bL.at(0).userData.act.rayEnabled = false;	
						 AntActor(bL.at(0).userData.graphic).gotoAndStop(1);
						 for  each (var r:rays in bL.at(0).userData.act.rayArray){
						  raysForDelete.push(r);
						  r.clear();
						 }
						 
						 bL.at(0).userData.act.rayArray = [];
						}
				 break;
				 
				 
				  case "fan":
					currentRay =  new rays(bL.at(0), new Vec2( -10, -10), 0, "fan",400);
					rayCastArray.push(currentRay);
					currentRay =  new rays(bL.at(0), new Vec2( -10, 0), 0, "fan",400);
					rayCastArray.push(currentRay);
					currentRay =  new rays(bL.at(0), new Vec2( -10, 10), 0, "fan",400);
					rayCastArray.push(currentRay);
					
					
				  break;
				
					 
					 default:
					  trace("default");
					 break;
						 
					} 
				   }
                  else {
					       if ((bL.length > 1)) {
							    for (var i:int = 0; i < bL.length ; i++ ) {
									var b:Body = Body(bL.at(i));
								trace(actor(Body(bL.at(i)).userData.act)._type);	
				              switch (actor(Body(bL.at(i)).userData.act)._type) {
								  
							    case "button":
								 if(bL.at(i).userData.act.refType == "buttonClick"){
				                  if (bL.at(i).userData.act.bClickEnabled) {
					               bL.at(i).userData.act.bClickEnabled = false;
					               AntActor(bL.at(i).userData.graphic).gotoAndStop(1);
					               bL.at(i).userData.act.disableRefference();
					              }   
				                 else {
					                   bL.at(i).userData.act.bClickEnabled = true;
					                   AntActor(bL.at(i).userData.graphic).gotoAndStop(2);
					                   bL.at(i).userData.act.enableRefference();
					              }
								 }
								break;
								default:
								break;
							  }
							 }
						   }
					   }
				 }
			}
		}
		
		private function heroJump(b:Body):void 
		{
			var imp:Vec2 = new Vec2(0, -400);
			b.applyImpulse(imp, b.position);
			b.userData.act.canJump = false;
			
		}
		
		private function recreateHero(b:Body):void 
		{
			if(b.userData.act.polygon.sensorEnabled == true){
			 b.userData.act.polygon.sensorEnabled = false;
			 b.userData.act.circle.sensorEnabled = true;
			 AntActor(b.userData.graphic).gotoAndStop(1);
			}
			else {
			       b.userData.act.polygon.sensorEnabled = true;
			       b.userData.act.circle.sensorEnabled = false;
			       AntActor(b.userData.graphic).gotoAndStop(2);	
				 }
			
		}
	private function updateRayCast():void
	{
		
			for each(var r:rays in rayCastArray) 
			  	r.update();
			
	} //end
		
		private function addJumpRays(b:Body):void 
		{
			var r1:rays;
			var r2:rays;
			var r3:rays;
			r1 = new rays(b, new Vec2(0,0), Math.PI,"heroRay",26);
			r2 = new rays(b, new Vec2(0,0), -3*Math.PI / 4, "heroRay",35);
			r3 = new rays(b, new Vec2(0,0), 3*Math.PI / 4, "heroRay",35);
			rayCastArray.push(r1);
			
			rayCastArray.push(r2);
			rayCastArray.push(r3);
			r1.update();
			r2.update();
			r3.update();
			b.userData.act.rayFailedCounter = 0;
		}
		
		private function levelCompleted():void 
		{
			
			lcompl.tag = 999;
			
			add(lcompl);
			defGroup.sort("tag");
			stopEngines();
			defGroup;
		}
		
		private function gameCompleted():void 
		{
			add(gcompl);
			stopEngines();
		}
		
		private function levelFailed():void 
		{
			add(lFailed);
			stopEngines();
		}
		private function stopEngines():void 
		{
			run = false;
		}
		
		private function createExplosion(bb:Body):void 
		{
			const explosionRadius:Number = 100;
			const explosionStr:Number = 400;
			
            var bodyList:BodyList = _space.bodiesInCircle(bb.position, explosionRadius, false, null, bodyList);
                       
                        var k:int = bodyList.length;
                        if (k > 0)
                        {
                                var v1:Vec2 = Vec2.get();
                                var v2:Vec2 = Vec2.get();
                                var i:int;
                                for (i = 0; i < k; i++)
                                {
                                        var b:Body = bodyList.at(i);
                                  
                                        if (!b.isDynamic()) {
											if (bodyList.at(i).userData.act._type == "ice")
											 actorForDelete.push(bodyList.at(i).userData.act);
											 
                                                continue;
										}	
                                       
                                        var len:Number = Geom.distanceBody(bb, b, v1, v2);
                                       
                                        if (len <= 0)
                                                {
                                                        len = 1;
                                                        v2 = b.position;
                                                }
                                               
                                        var imp:Vec2 = v2.sub(bb.position);
                                        var len2:Number = imp.length;
                                        if (len2 <= 1)
                                        {
                                                imp.setxy(1, 0);
                                                len2 = 1;
                                        }
                                       
                                        imp.muleq(1 / len2);
                                        imp.muleq(((explosionRadius - len) / explosionRadius) * explosionStr);
                                               
                                        b.applyImpulse(imp, v2);
                                }
                               
                                bodyList.clear();
                        }
                       
                       
                }
               
		
		
		private function removeIceUnderHero2(arr:Array):void 
		{
			//a.removeActor();
			for each(var a:actor in arr)
			 actorForDelete.push(a);
		}
		
		private function createBalloon(vec2:Vec2, b:Body):void 
		{
			var currentDistance:Number=100;
			var currentBalloonPoint:Number;
			var aNumber:int = 0;
			var i:int = 0;
			
			 var currentAntActor:AntActor = new AntActor();
				 
				 var currentNode1:actorBox;
				 var currentNode2:actorBox;
				 var currentBalloon:actorCircle;
				 
				 var currentJoint:PivotJoint;
				 var comp:Compound = new Compound();
				 var v2:Vec2;
			     
			for each(var v:Vec2 in b.userData.act.balloonPoints) {
				 v2 = b.localPointToWorld(v);
				 if(currentDistance >= Vec2.distance(v2,vec2)){
				  	currentDistance = Vec2.distance(v2, vec2);
				    aNumber = i;
					}
					i++;
			}
			vec2 = b.localPointToWorld(b.userData.act.balloonPoints[aNumber]);
			
				
				 
				 
				  currentAntActor.x = vec2.x;
				  currentAntActor.y = vec2.y;
				  currentAntActor.angle = 0;
				  currentAntActor.addAnimationFromCache("node1");      
				  add(currentAntActor);
				  currentNode1 = new actorBox(currentAntActor, new Vec2(vec2.x,vec2.y-5), 0, "dynamic", "balloon", [0,0,0,0,0],"wood",[],"rectangle",false,new Vec2(0,0),false,false,0,"none","balloon","destroyed",false);
				  currentNode1._body.compound = comp;
				  currentNode1.heroConnected = b.userData.act;
				  actorArray.push(currentNode1);

				  currentAntActor = new AntActor();
				  currentAntActor.x = vec2.x;
				  currentAntActor.y = vec2.y;
				  currentAntActor.angle = 0;
				  currentAntActor.addAnimationFromCache("node2");      
				  add(currentAntActor);
				  currentNode2 = new actorBox(currentAntActor, new Vec2(vec2.x,vec2.y-5), 0, "dynamic", "balloon", [0,0,0,0,0],"wood",[],"rectangle",false,new Vec2(0,0),false,false,0,"none","balloon","destroyed",false);
				  currentNode2._body.compound = comp;
				  currentNode2.heroConnected = b.userData.act;
				  actorArray.push(currentNode2);
				  
				  currentAntActor = new AntActor();
				  currentAntActor.x = vec2.x;
				  currentAntActor.y = vec2.y;
				  currentAntActor.angle = 0;
				  currentAntActor.repeat = false;
				  currentAntActor.addAnimationFromCache("balloon1"); 
				  add(currentAntActor);
				  
				  currentAntActor.gotoAndPlay(1);
				  currentBalloon  = new actorCircle(currentAntActor, new Vec2(vec2.x,vec2.y-30), 0, "dynamic", "balloon", [0,0,0,0,0],"wood","circle",false,new Vec2(0,0),false,false,0,"none","balloon","destroyed",false);
				  currentBalloon._body.gravMass = -currentBalloon._body.gravMass; 
		          currentBalloon.heroConnected = b.userData.act;
				  currentBalloon._body.compound = comp;
				  actorArray.push(currentBalloon);
				  
				  currentJoint = new PivotJoint(b, currentNode2._body, b.worldPointToLocal(new Vec2(vec2.x,vec2.y+1)), currentNode2._body.worldPointToLocal(new Vec2(vec2.x,vec2.y+1)));
				  currentJoint.ignore = true;
				  currentJoint.maxForce = 1000;
				  currentJoint.compound = comp;
				  
				  currentJoint = new PivotJoint(currentNode1._body, currentNode2._body, currentNode1._body.worldPointToLocal(new Vec2(vec2.x,vec2.y-10)), currentNode2._body.worldPointToLocal(new Vec2(vec2.x,vec2.y-10)));
				  currentJoint.ignore = true;
				  currentJoint.maxForce = 1000;
				  currentJoint.compound = comp;
				  
				  currentJoint = new PivotJoint(currentNode1._body, currentBalloon._body, currentNode1._body.worldPointToLocal(new Vec2(vec2.x,vec2.y+1)), currentBalloon._body.worldPointToLocal(new Vec2(vec2.x,vec2.y+1)));
				  currentJoint.ignore = true;
				  currentJoint.maxForce = 1000;
				  currentJoint.compound = comp;
				  
				  _space.compounds.add(comp);
				  
				  

		}
		
		private function createJoints():void 
		{
			var mcRopeArray:Array =[];
		for each(var jmovie:componentJoint in mcForJoints) {
			 var bList:BodyList;
			 var jointPoint:Vec2 = new Vec2(jmovie.x, jmovie.y);
			 
			switch(jmovie.jointType) {
				 case "pivot":
					 
					  bList = _space.bodiesUnderPoint(jointPoint);
					  
					  if (bList.length == 2) {
						   var jPivot:PivotJoint = new PivotJoint(bList.at(0), bList.at(1), bList.at(0).worldPointToLocal(jointPoint), bList.at(1).worldPointToLocal(jointPoint));
						   jPivot.ignore = jmovie.ignore;
	                       jPivot.space = _space;
						   
						   jPivot.maxForce = 10000000;
						  }
					  else 
					   trace("something wrong");
				 break;
				 
				  case "weld":
					
					  bList = _space.bodiesUnderPoint(jointPoint);
					  
					  if (bList.length == 2) {
						   var jWeld:WeldJoint = new WeldJoint(bList.at(0), bList.at(1), bList.at(0).worldPointToLocal(jointPoint), bList.at(1).worldPointToLocal(jointPoint));
						   jWeld.ignore = jmovie.ignore;
	                       jWeld.space = _space;
						  }
					  else 
					   trace("something wrong");
				 break;
				 
				 case "motor":
					
					  bList = _space.bodiesUnderPoint(jointPoint);
					  
					  if (bList.length == 2) {
						   var jMotor:MotorJoint = new MotorJoint(bList.at(0), bList.at(1),0,1);
						   jMotor.ignore = jmovie.ignore;
	                       jMotor.space = _space;
						   
						  }
					  else 
					   trace("something wrong");
				 break;
				 
				 case "rope":
					//var jRope:* = 
					 mcRopeArray.push([jmovie,false]);
				 break;
				 
				 
			     default:
				 break;
				 }
			}
			
			for each (var comJ:Array  in mcRopeArray) {
				var curJoint:componentJoint;
				  if (!comJ[1]) {
					  curJoint = comJ[0];
			         for each (var comJ2:Array  in mcRopeArray) {
					  if ((curJoint.counter == comJ2[0].counter) && (curJoint != comJ2[0])) {
						comJ2[1] = true;
						comJ[1] = true;
						createRope(comJ2[0],curJoint);
					  }
					 }		  
				  }
				}
		}
		
		private function createRope(Joint1:componentJoint, Joint2:componentJoint):void 
		{
			var v1:Vec2 = new Vec2(Joint1.x, Joint1.y);
			var v2:Vec2 = new Vec2(Joint2.x, Joint2.y);
			var v1_v2:Vec2 = new Vec2(v1.x - v2.x, v1.y - v2.y);
			var v3:Vec2 = new Vec2(0,1);
			
			var nodeNumber:int = 0;
			var nodeOther:Number = 0;
			var nodeOtherV4:Vec2 ;
			
			
			var currentAngle:Number = v1_v2.angle - Math.PI/2;
			
			var XY:Vec2 = new Vec2(); 
			var distance:Number =  Vec2.distance(v1, v2);
			var currentAntActor:AntActor  = new AntActor();
			var currentPoint:Vec2 = new Vec2(0, 0);
			var currentPointJoint:Vec2 = new Vec2(0, 0);
			
			var addThisToV1half:Vec2 = new Vec2(0, 6);
			var addThisToV1:Vec2 = new Vec2(0, 12);
			var currentNode:actor;
			var currentJoint:PivotJoint;
			var comp:Compound =  new Compound();
			var bList:BodyList ;
			var previousBody:Body ;
			var lastBody:Body ;
			var other2:Vec2  = new Vec2(0,3) ;
			
			
			//v1_v2
			
			trace(v3.angle * 180/Math.PI);
			trace(v1_v2.angle * 180/Math.PI);
			other2 = other2.rotate(currentAngle);
			trace(currentAngle * 180/Math.PI);
				 bList = _space.bodiesUnderPoint(v1);  
					  if (bList.length == 1) {
						  
						  lastBody = bList.at(0);
						   if (lastBody.userData.act.gameType == "balloon") {
							   lastBody.compound = comp;
							   }
						  	  
					  }
			_space.compounds.add(comp);
			
			nodeNumber = distance / 12;
			nodeOther = distance - nodeNumber * 12;
			
			//currentPoint.x 
			
			addThisToV1half.rotate(currentAngle);
			addThisToV1.rotate(currentAngle);
			
			currentPoint.x = v2.x + addThisToV1half.x;
			currentPoint.y = v2.y + addThisToV1half.y;
			
		
			
			//first node
			      currentAntActor.x = currentPoint.x;
				  currentAntActor.y = currentPoint.y;
				  currentAntActor.angle = currentAngle;
				  
				  currentAntActor.addAnimationFromCache("mc_node");      
				  currentAntActor.tag = defGroup.numChildren;
				  
				  add(currentAntActor);
				  currentNode = new actorBox(currentAntActor, currentPoint, currentAngle, "dynamic", "rope", [0,0,0,0,0],"steel",[],"rectangle",false,new Vec2(0,0),false,false,0,"none","rope","destroyed",false);
				  currentNode._body.compound = comp;
				  actorArray.push(currentNode);
			/// first joint
			
				 bList = _space.bodiesUnderPoint(v2);  
					  if (bList.length == 2) {
						   currentJoint = new PivotJoint(bList.at(0), bList.at(1), bList.at(0).worldPointToLocal(v2), bList.at(1).worldPointToLocal(v2));
						  
								   
						   currentJoint.ignore = true;
	                       currentJoint.compound = comp;
						   currentJoint.maxForce = 10000000;
						  }
				  
			for (var i:int = 1; i <= nodeNumber-1; i ++ ) {
				  currentAntActor = new AntActor();
			      currentAntActor.x = currentPoint.x + addThisToV1.x * i ;
				  currentAntActor.y = currentPoint.y + addThisToV1.y * i;
				  currentAntActor.angle = currentAngle;
				  
				  currentAntActor.addAnimationFromCache("mc_node");      
				  currentAntActor.tag = defGroup.numChildren;
				  
				  add(currentAntActor);
				  currentNode = new actorBox(currentAntActor, new Vec2(currentAntActor.x,currentAntActor.y), currentAngle, "dynamic", "rope", [0,0,0,0,0],"steel",[],"rectangle",false,new Vec2(0,0),false,false,0,"none","rope","destroyed",false);
				  currentNode._body.compound = comp;
				  previousBody = currentNode._body;
				  actorArray.push(currentNode);
				  
				   currentPointJoint.x = v2.x + addThisToV1.x * i;
				   currentPointJoint.y = v2.y + addThisToV1.y * i;
				   
				  
				   bList = _space.bodiesUnderPoint(currentPointJoint);  
					  if (bList.length == 2) {
						   currentJoint = new PivotJoint(bList.at(0), bList.at(1), bList.at(0).worldPointToLocal(currentPointJoint), bList.at(1).worldPointToLocal(currentPointJoint));
						   currentJoint.ignore = true;
	                       currentJoint.compound = comp;
						   currentJoint.maxForce = 10000000;
						  }
				  
			}
			
			      currentAntActor = new AntActor();
				  currentAntActor.addAnimationFromCache("mc_node");      
				  currentAntActor.scaleY = (nodeOther + 3) / 14;
				  nodeOtherV4 = new Vec2 (0,nodeOther).rotate(currentAngle);
			      currentAntActor.x = currentPoint.x + addThisToV1.x * (i-1) + nodeOtherV4.x + other2.x;
				  currentAntActor.y = currentPoint.y + addThisToV1.y * (i-1) + nodeOtherV4.y + other2.y;
				  currentAntActor.angle = currentAngle;
				  
				  
				  currentAntActor.tag = defGroup.numChildren;
				  
				  add(currentAntActor);
				  currentNode = new actorBox(currentAntActor, new Vec2(currentAntActor.x,currentAntActor.y), currentAngle, "dynamic", "rope", [0,0,0,0,0],"steel",[],"rectangle",false,new Vec2(0,0),false,false,0,"none","rope","destroyed",false);
				  currentNode._body.compound = comp;
				
				  actorArray.push(currentNode);
			      /////last joints
				  
				  
				          currentPointJoint.x = v2.x + addThisToV1.x * i;
				          currentPointJoint.y = v2.y + addThisToV1.y * i;
						  
                           currentJoint = new PivotJoint(previousBody,currentNode._body, previousBody.worldPointToLocal(currentPointJoint), currentNode._body.worldPointToLocal(currentPointJoint));
						   currentJoint.ignore = true;
	                       currentJoint.compound = comp;
						   currentJoint.maxForce = 10000000;
						   
						   currentJoint = new PivotJoint(currentNode._body, lastBody, currentNode._body.worldPointToLocal(v1), lastBody.worldPointToLocal(v1));
						   currentJoint.ignore = true;
	                       currentJoint.compound = comp;
						   currentJoint.maxForce = 10000000;
						   
						   
						   if (String(lastBody.userData.act.gameType).substring(0, 4) == "hero" ){
						    lastBody.userData.act.ropeComp = currentNode;
						    lastBody.userData.act.ropeEnabled =  true;
						  }
				  
		}
		
		private function goToSouund(aButton:AntButton):void 
		{
			trace("sound button");
		}
		
		private function goToRestart(aButton:AntButton):void 
		{
			aButton.eventClick.remove(goToRestart);
			AntG.anthill.switchState(new playGameState());
		}
		
		private function goToMenu(aButton:AntButton):void 
		{
			aButton.eventClick.remove(goToMenu);
			AntG.anthill.switchState(new menuMainState());
		}
		
		private function goToSolution():void 
		{
			trace("solution button");
		}
 
		
				
		override public function preUpdate():void
		{
			if(mouseJoint!= null) {   
			 mouseJointBody._body.position.x = AntG.mouse.x;
			 mouseJointBody._body.position.y = AntG.mouse.y;
			 //trace("reupdate" + mouseJointBody._body.position.x);
			}
			 
			super.preUpdate();
		}
		override public function update():void
		{
			if(_started){
			 if (AntG.mouse.isPressed())
			  mouseDownListener()
			 if (AntG.mouse.isReleased())
			  mouseUpListener()
			}
			
			if(run){
			deletingActors();
			updateRayCast();
			_space.step(1 / 30);
			}
			 
			super.update();
		}
		
		private function deletingActors():void 
		{
			var n:int;
			if (actorForDelete.length > 0){
		     for each(var aToDelete:actor in actorForDelete)
		     {
			  n = actorArray.indexOf(aToDelete);
			  if(n!=-1){
			   actorArray.splice(n, 1);
			   if (aToDelete._type == "star")
			    starCounter--;
	           if (starCounter <= 0)
			    levelCompleted();
				
			  }
		     }
		    }
			
			
			if (raysForDelete.length > 0){
		     for each(var rayToDelete:rays in raysForDelete)
		     {
			  n = rayCastArray.indexOf(rayToDelete);
			  if(n!=-1){
			   rayCastArray.splice(n, 1);
			   
			  }
		     }
			 raysForDelete = [];
		    }
			
			if (actorForDelete.length > 0){
			 for each(var itemToDelete:actor in actorForDelete ) { 
			 if(itemToDelete._body.compound==null)	 
			  itemToDelete.removeActor();
			 else {
				   for (var i:int = 0; i < itemToDelete._body.compound.bodies.length; i++){
				       n = actorArray.indexOf(itemToDelete._body.compound.bodies.at(i).userData.act);
			           if(n!=-1)
		                actorArray.splice(n, 1);
					   
						itemToDelete._body.compound.bodies.at(i).userData.act.removeActor();
				   }
			       		
			        if ((itemToDelete._body.userData.act.shType == "balloon")||(itemToDelete._body.userData.act.shType == "rope"))
 			        _space.compounds.remove(itemToDelete._body.compound);
				  } 
			  n = actorForDelete.indexOf(itemToDelete);
			  if(n!=-1)
		       actorForDelete.splice(n, 1);
			 }
			  //actorForDelete =[];
			}
		}
		override public function postUpdate():void
		{
			for each(var a:actor in actorArray)
			 a.update();
			
			super.postUpdate();
			
			if (AntG.storage.get("gameStatus") == "failed") {
				 levelFailed();
				}
		}
		override public function destroy():void
		{
			_camera.destroy();
			_camera = null;
			super.destroy();
		}
			//end
		
		/**
		 * @private
		 */
	

	}

}