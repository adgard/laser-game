package  
{
	import nape.callbacks.*;
	import nape.phys.*
	
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
			
	    }
		
		public function initCollisionListenersCollectble():void 
		{
			var opt1:OptionType = new OptionType([AntG.storage.get("hero2CBT"),AntG.storage.get("hero1CBT")]);
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
		   //var opt1:OptionType = new OptionType([AntG.storage.get("hero2CBT"),AntG.storage.get("hero1CBT"),AntG.storage.get("hero3CBT"),AntG.storage.get("hero4CBT"),AntG.storage.get("balloonCBT")]);
		   var opt2:OptionType = new OptionType(AntG.storage.get("spikeCBT"));
		   var opt1:OptionType = new OptionType(AntG.storage.get("balloonCBT"));
		   
			var beginCollideListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, opt1, opt2, beginCollisionHandlerSpikes);
			
			 AntG.space.listeners.add(beginCollideListener);
			
		}
		
		private function beginCollisionHandlerSpikes(cb:InteractionCallback):void 
		{
			if (cb.int1.userData.act.gameType == "spike") { 
			  if(cb.int2.userData.act._deleted == false){	
			   AntG.storage.get("actorForDelete").push(cb.int2.userData.act);
			   cb.int2.userData.act._deleted = true;
			  }
			 }
		    else {
			  if(cb.int1.userData.act._deleted == false){		
			    AntG.storage.get("actorForDelete").push(cb.int1.userData.act);
			    cb.int1.userData.act._deleted = true; 
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
			   //Body(cb.int1).userData.act.velxy = Body(cb.int1).velocity;
			 }
		 else {
			  // AntActor(cb.int2.userData.graphic).gotoAndStop(2);
			    Body(cb.int2).velocity.setxy(Body(cb.int1).userData.act.velxy.x ,Body(cb.int1).userData.act.velxy.y);
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
			 
		 if (cb.int1.userData.act.gameType == "button") {
			   //AntActor(cb.int1.userData.graphic).gotoAndStop(2);
			   actorBox(cb.int1.userData.act).isContact = false;
			   cb.int1.userData.act.contactCounter++;
			 }
		 else {
			  // AntActor(cb.int2.userData.graphic).gotoAndStop(2);
			   actorBox(cb.int2.userData.act).isContact = false;
			   cb.int2.userData.act.contactCounter++;
			  }	 
		}
		
		private function endCollisionHandlerButtons(cb:InteractionCallback):void 
		{
			// trace("end");
		 if (cb.int1.userData.act.gameType == "button") {
			   cb.int1.userData.act.contactCounter--;
			   if (cb.int1.userData.act.contactCounter<=0) {
				      actorBox(cb.int1.userData.act).isContact = false;
				    }
			   }
		 else {
			   cb.int2.userData.act.contactCounter--;
			   if (cb.int2.userData.act.contactCounter<=0) {
				      actorBox(cb.int2.userData.act).isContact = false;
				    }
			  }	 
		}
		private function ongoingCollisionHandlerButtons(cb:InteractionCallback):void
        {
	   //  trace("ongoing");
		 if (cb.int1.userData.act.gameType == "button") {
			   //AntActor(cb.int1.userData.graphic).gotoAndStop(2);
			   actorBox(cb.int1.userData.act).isContact = true;
			 }
		 else {
			  // AntActor(cb.int2.userData.graphic).gotoAndStop(2);
			   actorBox(cb.int2.userData.act).isContact = true;
			  }	 
	     
		 
        }
		//////
		
	}

}