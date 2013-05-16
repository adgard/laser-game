package  
{
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import ru.antkarlov.anthill.*
		
	import nape.geom.*;
    import nape.phys.*;
    import nape.shape.*;
    import nape.space.*;
    import nape.util.*;
	
	/**
	 * ...
	 * @author adgard
	 */
	public class rays 
	{
		private var rayPoint:Vec2 =  new Vec2(0, 0);
		private var rayPointStat:Vec2 =  new Vec2(28, 0);
		
		private var rayInitialPoint:Vec2 =  new Vec2(0,0);
		private var rayFinalPoint:Vec2 =  new Vec2(0,0);
		
		private var filt:InteractionFilter =  new InteractionFilter();
		private var rayActor:AntActor =  new AntActor();
		public var rayMC:MovieClip =  new MovieClip();
		public var rayMC2:MovieClip =  new MovieClip();
		public var rayMCEnd:MovieClip =  new MovieClip();
		
		
		private var rayAnimation:AntAnimation  = new AntAnimation();
		private var rayAngle:Number = 0;
		private var rayAngleInitial:Number = 0;
		
		private var rayPoints:Array =  [];
		private var ray:Ray;
		private var rayCurrentPoint:Vec2;
		private var rayOffSet:Vec2;
		private var _rayOffSet:Vec2;
		private var p:Vec2;
		
		private var rayBody:Body;
		private var type:String = "none";
		private var colorRay:uint = 0x000000;
		private var distance:Number = 0;
		
		
		
		
		
		public function rays(_body:Body,_point:Vec2,_angle:Number,_type:String,_distance:Number) 
		{
		     distance = _distance;
			 type = _type;
			 //filt.sensorGroup = 0x00000010;
			 //filt.sensorMask = 0x00000100;
			   filt.collisionGroup =0x00000010;
		     //filt.collisionMask = 0x00000100;
			 
			 rayActor = new AntActor();
			 rayActor.tag = 500;
			 switch(type) {
				 case "emitter":
				  colorRay = 0xF30021;
				 break;
				 
				 case "attraction":
				  colorRay = 0x00CC00;
				 break;
				 
				 case "repulsion":
				  colorRay = 0xC10087;
				 break;
				 
				 case "killer":
				  colorRay = 0xF30021;
				 break;
				 
			      case "heroRay":
				  rayMC.visible = false;
				  rayMC2.visible = false;
				  rayMCEnd.visible = false;
				  
				  colorRay = 0x000000;
				 break;
				 
				 
				 
				 default:
				 break;
				 
				 }
			// AntState(AntG.antSpace).defGroup.sort("tag");
			// AntG.antSpace.add(rayActor);
			 rayMC.filters = new Array(
               new BlurFilter(1, 1, 1),
               new GlowFilter(colorRay, 0.8, 4, 4, 3, 2)
			   
             );
			// rayAnimation.makeFromMovieClip(rayMC);
			// rayAnimation.makeFromMovieClip(rayMC2);
			 
			 //AntActor(_body.userData.graphic).addAnimation(rayAnimation);
			 AntG.antSpace.addChild(rayMC);
			 AntG.antSpace.addChild(rayMC2);
			 AntG.antSpace.addChild(rayMCEnd);
			 
			
			 
			// AntG.antSpace.addChild(redRay);
			 
			 rayCurrentPoint = _body.position;
			 
			 
			
			 rayAngleInitial = _angle;
			 rayBody = _body;
			 rayAngle = rayBody.rotation;
			 _rayOffSet = new Vec2(0, 0);//_point;
			 p = _point//.rotate(Math.PI/2);
			// rayOffSet = _rayOffSet.rotate(rayBody.rotation-Math.PI/2);
			 
		}
		public function update():void
		{
			var resultPt:Vec2;
			var rayResult:RayResult;
			var prevVec2:Vec2;
 			var ang:Number = 0;
 			
			//_rayOffSet = p;
			rayOffSet = _rayOffSet.rotate(rayBody.rotation);
			//trace("x= " + rayOffSet.x + " y= " + rayOffSet.y);
			if (type == "heroRay") 
			 prevVec2 = Vec2.fromPolar(1,3 * Math.PI / 2 + rayAngleInitial);
			else 
			 prevVec2 = Vec2.fromPolar(1, rayBody.rotation - Math.PI / 2 + rayAngleInitial);
			 //trace("prevec= " + String(rayBody.rotation - Math.PI / 2 + rayAngleInitial));
			
			ray = new Ray(new Vec2(rayBody.position.x-rayOffSet.x,rayBody.position.y-rayOffSet.y), prevVec2);// Vec2.fromPolar(1,bL.at(0).rotation));
					 ray.maxDistance = distance;
					
					 rayResult = AntG.space.rayCast(ray, false,filt);
					if(rayResult!= null)
					 resultPt = ray.at(rayResult.distance);
					else 
					 resultPt = ray.at(ray.maxDistance);
					 
					  rayCurrentPoint = resultPt;
					// rayMC = new MovieClip();
					//redRay.x = rayBody.position.x - rayOffSet.x;
					//redRay.y = rayBody.position.y - rayOffSet.y;
					//redRay.rotation = rayBody.rotation;
					 rayInitialPoint = new Vec2(rayBody.position.x - rayOffSet.x, rayBody.position.y - rayOffSet.y);
					// rayPoint = rayPointStat;
					 rayPoint = Vec2.fromPolar(30, rayBody.rotation - Math.PI / 2 + rayAngleInitial)//rayPoint.rotate(rayBody.rotation - Math.PI / 2 + rayAngleInitial);
					 rayFinalPoint.x = rayInitialPoint.x + rayPoint.x;
					 rayFinalPoint.y = rayInitialPoint.y + rayPoint.y;
					 
					 rayMCEnd.graphics.clear();
					 rayMCEnd.graphics.lineStyle(4, colorRay, 0.6, false, "normal", "none", "bevel", 0.1);
					 rayMCEnd.graphics.beginFill(0xFFFFFF,1);
					 
					 rayMC.graphics.clear();
					 rayMC.graphics.lineStyle(4, colorRay, 0.6, false, "normal", "none", "bevel", 0.1);
					 rayMC.graphics.moveTo(rayFinalPoint.x,rayFinalPoint.y);
					 rayMC.graphics.lineTo(resultPt.x, resultPt.y);
					 
					 rayMC2.graphics.clear();
					 rayMC2.graphics.lineStyle(2, 0xFFFFFF, 0.6, false, "normal", "none", "bevel", 0.1);
					 rayMC2.graphics.moveTo(rayFinalPoint.x,rayFinalPoint.y);
					 rayMC2.graphics.lineTo(resultPt.x, resultPt.y);
					   //////////////////////// 
					  if (type == "heroRay") {
						   if (rayResult != null) {
							 rayBody.userData.act.canJump = true;
							 
							 if (AntG.storage.get("gameStatus") != "failed")
							  rayBody.userData.graphic.addAnimationFromCache("mc_hero2"); 
							 rayBody.userData.act.rayFailedCounter = 0;
							 rayMC.visible =  false;
							 
							 return;
						   }
						   else {
							     rayBody.userData.act.rayFailedCounter++; 
								  if (rayBody.userData.act.rayFailedCounter >= 3) {
									   rayBody.userData.act.canJump = false;
									   if(AntG.storage.get("gameStatus")!="failed")
									    rayBody.userData.graphic.addAnimationFromCache("hero2_a1"); 
									   rayBody.userData.act.rayFailedCounter = 0;
									  }
									return;  
							    }
						    
					  }	  
						////////////////////
					  if (rayResult == null){
					      rayMCEnd.graphics.drawCircle(resultPt.x,resultPt.y,4)
						  return;
					  }
						  
						 switch(rayResult.shape.body.userData.act.rayType) {
							 case "destroyed":
								 if ((type == "killer") || (type == "emitter")) {
									 //if(rayResult.shape.body.userData.act.type=="")
					              AntG.storage.get("actorForDelete").push(rayResult.shape.body.userData.act);
							     }
								 else {
								  applyImpulses(type, rayResult.shape.body, resultPt, prevVec2.normalise());
								  rayMCEnd.graphics.drawCircle(resultPt.x,resultPt.y,4)
								 }
							   return;
							   
							 break;
						 case "intake":
							  if (((type == "killer") || (type == "emitter")) && (String(rayResult.shape.body.userData.act.gameType).substring(0, 4) == "hero")) {
							  
							  if((!AntG.sounds.isPlaying("kill")&&AntG.storage.get("gameStatus")!="failed"))
							   AntG.sounds.play("kill");
							AntG.storage.set("gameStatus", "failed");
							  
							   
							 if(rayResult.shape.body.userData.act.polygon.sensorEnabled == true)
							    rayResult.shape.body.userData.graphic.addAnimationFromCache(String(rayResult.shape.body.userData.act.gameType).substr(0, 5) + "_a2_2");
							   else  
							    rayResult.shape.body.userData.graphic.addAnimationFromCache(String(rayResult.shape.body.userData.act.gameType).substr(0, 5) + "_a2");
								
							  rayResult.shape.body.userData.graphic.repeat = false;
								return;
							 }
							 else {
					           applyImpulses(type, rayResult.shape.body, resultPt, prevVec2.normalise());
							   rayMCEnd.graphics.drawCircle(resultPt.x,resultPt.y,4)
							   return;
							 }  
							  break;
						     
							 case "reflex":
					         // trace("reflex"); 
						     break;
							 
							 case "pass":
					          trace("pass"); 
						     return;
							 
							 break;
							 default:
							 
						 }
						 
						 
					  
					 for (var i:int = 0 ; i < 4; i++ ) {
			
						   rayAngle = Math.PI - (prevVec2.angle - rayResult.normal.angle); 
						   if (rayAngle > 2 * Math.PI)
						    rayAngle-= 2 * Math.PI;
							
						 prevVec2.x  = rayResult.normal.x;
						 prevVec2.y  = rayResult.normal.y;
						 
						 prevVec2 = new Vec2(rayResult.normal.x, rayResult.normal.y);
						 prevVec2.rotate(rayAngle);
						  ray = new Ray(rayCurrentPoint, prevVec2);
					     
						  
						  ray.maxDistance = distance;
					      rayResult = AntG.space.rayCast(ray, false,filt);
						 
					      if(rayResult!= null)
					       resultPt = ray.at(rayResult.distance);
					      else 
					       resultPt = ray.at(ray.maxDistance);
						   
					     rayCurrentPoint = resultPt;
						   rayMC.graphics.lineTo(resultPt.x, resultPt.y);
						   rayMC2.graphics.lineTo(resultPt.x, resultPt.y);
						   
						   
						   if (rayResult == null) {
							   rayMCEnd.graphics.drawCircle(resultPt.x,resultPt.y,4)
						     return;
						   }
						  
						    switch(rayResult.shape.body.userData.act.rayType) {
							 case "destroyed":
								 if((type == "killer")||(type == "emitter")){
					              AntG.storage.get("actorForDelete").push(rayResult.shape.body.userData.act);
							     }
								 else {
								  applyImpulses(type, rayResult.shape.body, resultPt, prevVec2.normalise());
								  rayMCEnd.graphics.drawCircle(resultPt.x,resultPt.y,4)
								 }
							   return;
							 case "intake":
							 if (((type == "killer") || (type == "emitter")) && (String(rayResult.shape.body.userData.act.gameType).substring(0, 4) == "hero")) {
							 
							  if((!AntG.sounds.isPlaying("kill")&&AntG.storage.get("gameStatus")!="failed"))
							   AntG.sounds.play("kill");
							 
							   AntG.storage.set("gameStatus", "failed"); 
							   if(rayResult.shape.body.userData.act.polygon.sensorEnabled == true)
							    rayResult.shape.body.userData.graphic.addAnimationFromCache(String(rayResult.shape.body.userData.act.gameType).substr(0, 5) + "_a2_2");
							   else  
							    rayResult.shape.body.userData.graphic.addAnimationFromCache(String(rayResult.shape.body.userData.act.gameType).substr(0, 5) + "_a2");
							  
							  rayResult.shape.body.userData.graphic.repeat = false;
								return;
							 }
					         else {  
								 applyImpulses(type, rayResult.shape.body, resultPt, prevVec2.normalise());
							   rayMCEnd.graphics.drawCircle(resultPt.x, resultPt.y, 4);
							 }
							   return;
							  break
							 
						     
							 case "reflex":
					          trace("reflex"); 
						     break;
							 
							 case "pass":
					          trace("pass"); 
						     return;
							 
							 break;
							 default:
							 
						 }
						 
						   
				    }
		
		}
		public function hide():void {
	          rayMCEnd.visible = false;
			  rayMC.visible = false;
			  rayMC2.visible = false;
			}
		private function applyImpulses(_type:String,_body:Body,_pointImpulse:Vec2,_impulse:Vec2):void 
		{
			var m:Number = 0 ;
            m = _body.mass;
			if (_body.userData.act.refType == "lever")
			 m *= 2;
			//trace(m);
			               switch(_type) {
                               case "repulsion":
								   _body.applyImpulse(_impulse.mul(m * 10),_pointImpulse);
								   
							   break;	
							   
							   case "attraction":
								   _body.applyImpulse(_impulse.mul(m * 10).rotate(Math.PI),_pointImpulse);  
							   break;	
							   case "steel":
							   break;	 
						       default:
							   break;
							   
							   }
		}
		
		public function clear():void
		{
	     rayMC.graphics.clear();
		 rayMC2.graphics.clear();
		 rayMCEnd.graphics.clear();
		 
		 
		 AntG.antSpace.addChild(rayMC);
		 AntG.antSpace.addChild(rayMC2);
		 AntG.antSpace.addChild(rayMCEnd);
		 
		}
		
		private function getAngle(vector3D:Vector3D, vector3D1:Vector3D):Number
		{
	     return Vector3D.angleBetween(vector3D, vector3D1);
		}
}

}