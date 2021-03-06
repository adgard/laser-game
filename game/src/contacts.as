package  
{
	import nape.callbacks.*;
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.dynamics.CollisionArbiter;
	import nape.phys.*
	import nape.geom.Vec2;
	
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.OptionType;
	import ru.antkarlov.anthill.*;
	/**
	 * ...
	 * @author adgard
	 */
	public class contacts
	{
		private var opt1:OptionType;
		private var opt2:OptionType;
		
		public function contacts() 
		{
			initCollisionListenersButtons();
			initCollisionListenersMoveSensor();	
			initCollisionListenersHero2Ice();	
			initCollisionListenersSpikes();	
			initCollisionListenersCollectble();	
			initCollisionListenersMagnet();	
			initCollisionListenersMagnetStat();	
			
	    }
		
		private function initCollisionListenersMagnetStat():void 
		{
			var opt1:OptionType = new OptionType([AntG.storage.get("magnetStatCBT")]);
		    var opt2:OptionType = new OptionType(AntG.storage.get("dynamicCBT"));
		   
			var ongoingCollideListener:InteractionListener = new InteractionListener(CbEvent.ONGOING, InteractionType.SENSOR, opt1, opt2, ongoingCollisionHandlerMagnetStat);
			var endCollideListener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.SENSOR, opt1, opt2, endCollisionHandlerMagnetStat);
			
			
			 AntG.space.listeners.add(ongoingCollideListener);
			 AntG.space.listeners.add(endCollideListener);
		}
		
		private function endCollisionHandlerMagnetStat(cb:InteractionCallback):void 
		{
			if (Body(cb.int1).userData.act.gameType == "magnetStat") {
			 if(Body(cb.int1).userData.act.magnetEnabled == true) { 		
			  if(Body(cb.int2).userData.act.magnetStatInited == true){	
			      Body(cb.int2).userData.act.magnetStatInited = false;
				  Body(cb.int2).gravMass = -Body(cb.int2).gravMass; 
				}
			 }
			}
		    if (Body(cb.int2).userData.act.gameType == "magnetStat") {
			 if(Body(cb.int2).userData.act.magnetEnabled == true) { 		
			  if(Body(cb.int1).userData.act.magnetStatInited == true){	
			      Body(cb.int1).userData.act.magnetStatInited = false;
				  Body(cb.int1).gravMass = -Body(cb.int1).gravMass; 
				}
			 }
			}
			 
		}
		
		private function ongoingCollisionHandlerMagnetStat(cb:InteractionCallback):void 
		{
			if(Body(cb.int1).userData.act.gameType == "magnetStat"){
			 if(Body(cb.int1).userData.act.magnetEnabled==true) { 
			  if(Body(cb.int2).userData.act.magnetStatInited == false){	
			      Body(cb.int2).userData.act.magnetStatInited = true;
				  Body(cb.int2).gravMass = -Body(cb.int2).gravMass; 
				}
			 }
			 else {
				   if(Body(cb.int2).userData.act.magnetStatInited == true){
				     Body(cb.int2).userData.act.magnetStatInited = false;  
				     Body(cb.int2).gravMass = -Body(cb.int2).gravMass;
				   }
				  }
			}
		 
		 if(Body(cb.int2).userData.act.gameType == "magnetStat"){
			 if(Body(cb.int2).userData.act.magnetEnabled==true) { 
			  if(Body(cb.int1).userData.act.magnetStatInited == false){	
			      Body(cb.int1).userData.act.magnetStatInited = true;
				  
				}
			 }
			 else {
				    if(Body(cb.int1).userData.act.magnetStatInited == true){
				     Body(cb.int1).userData.act.magnetStatInited = false;  
				     Body(cb.int1).gravMass = -Body(cb.int2).gravMass;
				   }
				  }
			}	
			
		}
		
		private function initCollisionListenersMagnet():void 
		{
			var opt1:OptionType = new OptionType([AntG.storage.get("magnetCBT")]);
		    var opt2:OptionType = new OptionType(AntG.storage.get("dynamicCBT"));
		   
			var beginCollideListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, opt1, opt2, beginCollisionHandlerMagnet);
			
			 AntG.space.listeners.add(beginCollideListener);
		}
		
		private function beginCollisionHandlerMagnet(cb:InteractionCallback):void 
		{
			var p:Vec2;
			if (cb.int1.userData.act.gameType == "magnet") { 
				var jPiv:PivotJoint;
				var colArb:CollisionArbiter;
			  if (cb.int1.userData.act.magnetJointInited == false) {	
				  
				   if (Body(cb.int2).constraints.length > 0)
						   {
					        var b:Body;
							b = PivotJoint(Body(cb.int2).constraints.at(0)).body1;
							if (b != cb.int2) {
								b = b;
								}
							else {
								  b = PivotJoint(Body(cb.int2).constraints.at(0)).body2;
								 }
								 
							 if(b!=null){
							  // b.userData.act.magnetJointInited = false;
					           b.userData.act.magnetJoint.space = null;
				               b.userData.act.magnetJoint = null;   
						    }
						   }
				  
			               Body(cb.int1).velocity.setxy(-Body(cb.int1).velocity.x, -Body(cb.int1).velocity.y);
						   
						   for (var i:int = 0 ; i < cb.arbiters.length ; i++ ){
						    
							trace(cb.arbiters.at(i).isCollisionArbiter());
							
						      if (cb.arbiters.at(i).isCollisionArbiter()) {
							       colArb = cb.arbiters.at(i).collisionArbiter;
								   trace(colArb.contacts.at(0).position);
								   trace(colArb.contacts.at(1).position);
								   
								   if (colArb.contacts.length == 1)
								     p =  colArb.contacts.at(0).position; 
								   else {	 
								   if(AntG.space.bodiesInCircle(colArb.contacts.at(0).position,5).length <2)
								    p = colArb.contacts.at(1).position;
								   else 
								    p = colArb.contacts.at(0).position;
								   }
									
								   cb.int1.userData.act.magnetJointInited = true;
								    jPiv = new PivotJoint(Body(cb.int1), Body(cb.int2), Body(cb.int1).worldPointToLocal(p),Body(cb.int2).worldPointToLocal(p));
						             jPiv.ignore = false;
	                                 jPiv.space = AntG.space;
				                    
						             cb.int1.userData.act.magnetJoint = jPiv;
									 return;
								  }
						   }
						    
						
			  }
			 }
		    else {
			  if(cb.int2.userData.act.magnetJointInited == false){	
			     
				       
				     if (Body(cb.int1).constraints.length > 0)
						   {
					        var b:Body;
							b = PivotJoint(Body(cb.int1).constraints.at(0)).body1;
							if (b != cb.int1) {
								b = b;
								}
							else {
								  b = PivotJoint(Body(cb.int1).constraints.at(0)).body2;
								 }
								 
							 if(b!=null){
							  // b.userData.act.magnetJointInited = false;
					           b.userData.act.magnetJoint.space = null;
				               b.userData.act.magnetJoint = null;   
						    }
						   }
				  
				  
				       
				  
				       Body(cb.int2).velocity.setxy(-Body(cb.int2).velocity.x, -Body(cb.int2).velocity.y);
				       
					   for (var i:int = 0 ; i < cb.arbiters.length ; i++ ){
						   
							trace(cb.arbiters.at(i).isCollisionArbiter());
							
						      if (cb.arbiters.at(i).isCollisionArbiter()) {
							       colArb = cb.arbiters.at(i).collisionArbiter;
								   
								   cb.int2.userData.act.magnetJointInited = true;
								   
								   if (colArb.contacts.length == 1)
								     p =  colArb.contacts.at(0).position; 
								   else {	 
								   if(AntG.space.bodiesInCircle(colArb.contacts.at(0).position,5).length <2)
								    p = colArb.contacts.at(1).position;
								   else 
								    p = colArb.contacts.at(0).position;
								   }
									
									 
								    jPiv = new PivotJoint(Body(cb.int1), Body(cb.int2), Body(cb.int1).worldPointToLocal(p),Body(cb.int2).worldPointToLocal(p));
						             jPiv.ignore = false;
	                                 jPiv.space = AntG.space;
				                     
						             cb.int1.userData.act.magnetJoint = jPiv;
									 return;
								  }
						   }
					
				}
				  else {
				  //   cb.int2.userData.act.magnetJointInited = false;
					 cb.int2.userData.act.magnetJoint.space = null;
				     cb.int2.userData.act.magnetJoint = null;
				           
				   }
			}
		}
		
		public function initCollisionListenersCollectble():void 
		{
			var opt1:OptionType = new OptionType([AntG.storage.get("hero2CBT"),AntG.storage.get("hero1CBT"),AntG.storage.get("hero4CBT")]);
		    var opt2:OptionType = new OptionType(AntG.storage.get("collectCBT"));
		   
			var beginCollideListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, opt1, opt2, beginCollisionHandlerCollect);
			
			 AntG.space.listeners.add(beginCollideListener);
		}
		
		private function beginCollisionHandlerCollect(cb:InteractionCallback):void 
		{
			if (cb.int1.userData.act.gameType == "star") { 
			  if(cb.int1.userData.act._deleted == false){	
			   AntG.storage.get("actorForDelete").push(cb.int1.userData.act);
			   cb.int1.userData.act._deleted = true;
			  }
			 }
		    else {
			  if(cb.int2.userData.act._deleted == false){		
			    AntG.storage.get("actorForDelete").push(cb.int2.userData.act);
			    cb.int2.userData.act._deleted = true; 
			   }
			}
		}
		
		private function initCollisionListenersSpikes():void 
		{
		   var opt1:OptionType = new OptionType([AntG.storage.get("hero2CBT"),AntG.storage.get("hero1CBT"),AntG.storage.get("hero3CBT"),AntG.storage.get("hero4CBT"),AntG.storage.get("balloonCBT")]);
		   var opt2:OptionType = new OptionType(AntG.storage.get("spikeCBT"));
		  //var opt1:OptionType = new OptionType(AntG.storage.get("balloonCBT"));
		   
			var beginCollideListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, opt1, opt2, beginCollisionHandlerSpikes);
			
			 AntG.space.listeners.add(beginCollideListener);
			
		}
		
		private function beginCollisionHandlerSpikes(cb:InteractionCallback):void 
		{
			if (cb.int1.userData.act.gameType == "spike") {
				
			  if (cb.int2.userData.act._deleted == false) {	
				  if (String(cb.int2.userData.act.gameType).substr(0, 4) == "hero") {
			      
					 if((!AntG.sounds.isPlaying("kill")&&AntG.storage.get("gameStatus")!="failed")){
					 AntG.sounds.play("kill")
					 
					 AntG.storage.set("gameStatus", "failed");
					 }
				   
				   if(cb.int2.userData.act.polygon.sensorEnabled == true)
				    cb.int2.userData.graphic.addAnimationFromCache(String(cb.int2.userData.act.gameType).substr(0, 5) + "_a2_2");
				   else 
				    cb.int2.userData.graphic.addAnimationFromCache(String(cb.int2.userData.act.gameType).substr(0, 5) + "_a2");
				    
				   cb.int2.userData.graphic.repeat = false;
				   cb.int2.userData.act._deleted = true;
				  }
				  else 
				  {
					  AntG.storage.get("actorForDelete").push(cb.int2.userData.act);
			          cb.int2.userData.act._deleted = true;
				  } 
			   }
			 }
		    else {
			  if (cb.int1.userData.act._deleted == false) {	
				  if (String(cb.int1.userData.act.gameType).substr(0, 4) == "hero") {
			       
					 if ((!AntG.sounds.isPlaying("kill") && AntG.storage.get("gameStatus") != "failed")) {
					  AntG.sounds.play("kill")
					  AntG.storage.set("gameStatus", "failed");
					 }
				   
				  if(cb.int1.userData.act.polygon.sensorEnabled == true)
				    cb.int1.userData.graphic.addAnimationFromCache(String(cb.int1.userData.act.gameType).substr(0, 5) + "_a2_2");
				   else 
				    cb.int1.userData.graphic.addAnimationFromCache(String(cb.int1.userData.act.gameType).substr(0, 5) + "_a2");
				   cb.int1.userData.graphic.repeat = false;
				   
				   cb.int1.userData.act._deleted = true;
				  }
				  else 
				  {
					  AntG.storage.get("actorForDelete").push(cb.int1.userData.act);
			          cb.int1.userData.act._deleted = true;
				  } 
			   }
			}
		}
		
		private function initCollisionListenersHero2Ice():void 
		{
			var opt1:OptionType = new OptionType(AntG.storage.get("hero2CBT"));
		   var opt2:OptionType = new OptionType(AntG.storage.get("iceCBT"));
		   
			var beginCollideListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, opt1, opt2, beginCollisionHandlerHero2Ice);
			var endCollideListener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.COLLISION, opt1, opt2, endCollisionHandlerHero2Ice);
			
			 AntG.space.listeners.add(beginCollideListener);
			 AntG.space.listeners.add(endCollideListener);
		
		}
		
		private function beginCollisionHandlerHero2Ice(cb:InteractionCallback):void 
		{
			
			  var n:int;
			
			if (cb.int1.userData.act.gameType == "hero2") { 
			   cb.int1.userData.act.contactCounterIce--;
			   n = cb.int1.userData.act.iceUnderHero.indexOf(cb.int2.userData.act);
			  if ((n != -1)&&(Body(cb.int1).velocity.y < -40)){
                AntG.storage.get("actorForDelete").push(cb.int2.userData.act);
		       cb.int1.userData.act.iceUnderHero.splice(n, 1); 
			   
			  }
			 }
		 else {
			   cb.int2.userData.act.contactCounterIce--;
			    n = cb.int2.userData.act.iceUnderHero.indexOf(cb.int1.userData.act);
			  if ((n != -1)&&(Body(cb.int2).velocity.y <-40)) {
			   AntG.storage.get("actorForDelete").push(cb.int1.userData.act);
		       cb.int2.userData.act.iceUnderHero.splice(n, 1); 
			  }
			  }	
			  
		}
		
		private function endCollisionHandlerHero2Ice(cb:InteractionCallback):void 
		{
			trace("end ice hero");
			
			if (cb.int1.userData.act.gameType == "hero2") { 
			   cb.int1.userData.act.contactCounterIce++;
			   cb.int1.userData.act.iceUnderHero.push(cb.int2.userData.act); 
			 }
		 else {
			   cb.int2.userData.act.contactCounterIce++;
			   cb.int2.userData.act.iceUnderHero.push(cb.int1.userData.act);
			  }	 
			
			
			 
		}
		
		////////////////
		private function initCollisionListenersMoveSensor():void 
		{
		   var opt1:OptionType = new OptionType(AntG.storage.get("movesensorCBT"));
		   var opt2:OptionType = new OptionType(AntG.storage.get("moveableCBT"));
		 
		   
		   var beginCollideListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR,opt1,opt2, beginCollisionHandlerMoveSensor);
	       var endCollideListener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.SENSOR,opt1,opt2, endCollisionHandlerMoveSensor);
	       
		   AntG.space.listeners.add(beginCollideListener); 
		   AntG.space.listeners.add(endCollideListener);
		}
		
		private function endCollisionHandlerMoveSensor(cb:InteractionCallback):void 
		{
			trace("end move sensor");
		}
		
		private function beginCollisionHandlerMoveSensor(cb:InteractionCallback):void 
		{
		 //	trace("begin move sensor");	
			if (cb.int1.userData.act.isMoveable) {
			   Body(cb.int1).velocity.setxy(Body(cb.int2).userData.act.velxy.x , Body(cb.int2).userData.act.velxy.y);
			   if(Body(cb.int2).userData.act.refType=="move"){
			    Body(cb.int1).userData.act.velxy.x = Body(cb.int2).userData.act.velxy.x;
			    Body(cb.int1).userData.act.velxy.y = Body(cb.int2).userData.act.velxy.y;
			   }
			   if((Body(cb.int1).userData.act.Arrow)&&!((Body(cb.int1).userData.act.velxy.x==0)&&(Body(cb.int1).userData.act.velxy.y==0)))
					  Body(cb.int1).userData.act.Arrow.angle = 180/Math.PI*(Vec2(Body(cb.int1).userData.act.velxy)).angle;
			   
			   //Body(cb.int1).userData.act.velxy = Body(cb.int1).velocity;
			 }
		 else {
			  // AntActor(cb.int2.userData.graphic).gotoAndStop(2);
			    Body(cb.int2).velocity.setxy(Body(cb.int1).userData.act.velxy.x , Body(cb.int1).userData.act.velxy.y);
				if(Body(cb.int2).userData.act.refType=="move"){
				Body(cb.int2).userData.act.velxy.x = Body(cb.int1).userData.act.velxy.x;
			    Body(cb.int2).userData.act.velxy.y = Body(cb.int1).userData.act.velxy.y;
				}
			   if((Body(cb.int2).userData.act.Arrow)&&!((Body(cb.int2).userData.act.velxy.x==0)&&(Body(cb.int2).userData.act.velxy.y==0)))
					  Body(cb.int2).userData.act.Arrow.angle = 180/Math.PI*(Vec2(Body(cb.int2).userData.act.velxy)).angle;
			   
			   
	           // Body(cb.int2).userData.act.velxy = Body(cb.int2).velocity;	  
		 }	 
		}
		////////
		private function initCollisionListenersButtons():void
        {
	       var opt1:OptionType = new OptionType(AntG.storage.get("dynamicCBT"));
		   var opt2:OptionType = new OptionType(AntG.storage.get("buttonCBT"));
		 
		   
		   var ongoingCollideListener:InteractionListener = new InteractionListener(CbEvent.ONGOING, InteractionType.SENSOR,opt1,opt2, ongoingCollisionHandlerButtons);
	       var endCollideListener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.SENSOR, opt1, opt2, endCollisionHandlerButtons);
		   var beginCollideListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR,opt1,opt2, beginCollisionHandlerButtons);
	       
		   AntG.space.listeners.add(ongoingCollideListener); 
		   AntG.space.listeners.add(endCollideListener);
		   AntG.space.listeners.add(beginCollideListener);
        }
		
		private function beginCollisionHandlerButtons(cb:InteractionCallback):void 
		{
			// trace("begin");
		if ((cb.int1.userData.act.buttonNode == cb.int2.userData.act ) || (cb.int2.userData.act.buttonNode == cb.int1.userData.act ))
		  return;
		 	 
		 if (cb.int1.userData.act.gameType == "button") {
			   //AntActor(cb.int1.userData.graphic).gotoAndStop(2);
			   cb.int1.userData.act.isContact = false;
			   cb.int1.userData.act.contactCounter++;
			 }
		 else {
			  // AntActor(cb.int2.userData.graphic).gotoAndStop(2);
			   cb.int2.userData.act.isContact = false;
			   cb.int2.userData.act.contactCounter++;
			  }	 
		}
		
		private function endCollisionHandlerButtons(cb:InteractionCallback):void 
		{
			// trace("end");
			
		 if ((cb.int1.userData.act.buttonNode == cb.int2.userData.act ) || (cb.int2.userData.act.buttonNode == cb.int1.userData.act ))
		  return;
		 if (cb.int1.userData.act.gameType == "button") {
			   cb.int1.userData.act.contactCounter--;
			   if (cb.int1.userData.act.contactCounter<=0) {
				      (cb.int1.userData.act).isContact = false;
				    }
			   }
		 else {
			   cb.int2.userData.act.contactCounter--;
			   if (cb.int2.userData.act.contactCounter<=0) {
				      (cb.int2.userData.act).isContact = false;
				    }
			  }	 
		}
		private function ongoingCollisionHandlerButtons(cb:InteractionCallback):void
        {
	   //  trace("ongoing");
	   if ((cb.int1.userData.act.buttonNode == cb.int2.userData.act ) || (cb.int2.userData.act.buttonNode == cb.int1.userData.act ))
		  return;
		 
		 if (cb.int1.userData.act.gameType == "button") {
			   //AntActor(cb.int1.userData.graphic).gotoAndStop(2);
			   (cb.int1.userData.act).isContact = true;
			 }
		 else {
			  // AntActor(cb.int2.userData.graphic).gotoAndStop(2);
			   (cb.int2.userData.act).isContact = true;
			  }	 
	     
		 
        }
		//////
		
	}

}