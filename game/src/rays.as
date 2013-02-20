package  
{
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
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
		private var rayActor:AntActor =  new AntActor();
		public var rayMC:MovieClip =  new MovieClip();
		private var rayAnimation:AntAnimation;
		private var rayAngle:Number = 0;
		private var rayPoints:Array =  [];
		private var ray:Ray;
		private var rayCurrentPoint:Vec2;
		private var rayOffSet:Vec2;
		private var _rayOffSet:Vec2;
		
		private var rayBody:Body;
		private var type:String = "none";
		private var colorRay:uint = 0x000000;
		
		
		
		public function rays(_body:Body,_point:Vec2,_angle:Number,_type:String) 
		{
		
			 type = _type;
			 rayActor = new AntActor();
			 rayActor.tag = 500;
			 switch(type) {
				 case "emitter":
				  colorRay = 0x8CCCDA;
				 break;
				 
				 case "attraction":
				  colorRay = 0x000000;
				 break;
				 
				 case "repulsion":
				  colorRay = 0x009900;
				 break;
				 
				 case "killer":
				  colorRay = 0xFD807F;
				 break;
				 
				 
				 default:
				 break;
				 
				 }
			// AntState(AntG.antSpace).defGroup.sort("tag");
			// AntG.antSpace.add(rayActor);
			 AntG.antSpace.addChild(rayMC);
			 rayCurrentPoint = _body.position;
			 
			 
			 rayAngle = _angle; 
			 rayBody = _body;
			 _rayOffSet = _point;
			 rayOffSet = _rayOffSet.rotate(rayBody.rotation-Math.PI/2);
			 
		}
		public function update():void
		{
			var resultPt:Vec2;
			var rayResult:RayResult;
			var prevVec2:Vec2;
 			var ang:Number = 0;
			
			//trace("x= " + rayOffSet.x + " y= " + rayOffSet.y);
			prevVec2 = Vec2.fromPolar(1, rayBody.rotation-Math.PI/2);
			ray = new Ray(new Vec2(rayBody.position.x-rayOffSet.x,rayBody.position.y-rayOffSet.y), prevVec2);// Vec2.fromPolar(1,bL.at(0).rotation));
					 ray.maxDistance = 200;
					
					 rayResult = AntG.space.rayCast(ray, false);
					if(rayResult!= null)
					 resultPt = ray.at(rayResult.distance);
					else 
					 resultPt = ray.at(ray.maxDistance);
					 
					  rayCurrentPoint = resultPt;
					// rayMC = new MovieClip();
					 rayMC.graphics.clear();
					 rayMC.graphics.lineStyle(4, colorRay, 2, false, "normal", "none", "bevel", 0.1);
					 rayMC.graphics.moveTo(rayBody.position.x-rayOffSet.x,rayBody.position.y-rayOffSet.y);
					 rayMC.graphics.lineTo(resultPt.x, resultPt.y);
					  if (rayResult == null)
						  return;
						  
						 switch(rayResult.shape.body.userData.act.mType) {
							 case "wood":
					          applyImpulses(type, rayResult.shape.body, prevVec2, resultPt);
							  return;
							 break;
							 default:
							 break;
							 
						 }
						 
					  if ((rayResult.shape.body.userData.act.mType != "steel")&&(rayResult.shape.body.userData.act.mType != "glass"))
						 return;
					 for (var i:int = 0 ; i < 4; i++ ) {
			
						   rayAngle = Math.PI - (prevVec2.angle - rayResult.normal.angle); 
						   if (rayAngle > 2 * Math.PI)
						    rayAngle-= 2 * Math.PI;
							
						 prevVec2.x  = rayResult.normal.x;
						 prevVec2.y  = rayResult.normal.y;
						 
						 prevVec2 = new Vec2(rayResult.normal.x,rayResult.normal.y);
						  ray = new Ray(rayCurrentPoint, prevVec2);
					     
						  
						  ray.maxDistance = 300;
					      rayResult = AntG.space.rayCast(ray, false);
						 
					      if(rayResult!= null)
					       resultPt = ray.at(rayResult.distance);
					      else 
					       resultPt = ray.at(ray.maxDistance);
						   
					     rayCurrentPoint = resultPt;
						   rayMC.graphics.lineTo(resultPt.x, resultPt.y);
						   
						   if (rayResult == null)
						  return;
						  
							 switch(rayResult.shape.body.userData.act.mType) {
							 case "wood":
					          applyImpulses(type, rayResult.shape.body, prevVec2, resultPt);
							  return;
							 break;
							 default:
							 break;
							 
						 }
							   
						   if ((rayResult.shape.body.userData.act.mType != "steel")&&(rayResult.shape.body.userData.act.mType != "glass"))
						 return;
						   
				    }
		
		}
		
		private function applyImpulses(_type:String,_body:Body,_pointImpulse:Vec2,_impulse:Vec2):void 
		{
			             switch(_type) {
                               case "repulsion":
								   _body.applyImpulse(_impulse.mul(0.01),_pointImpulse);
								   
							   break;	
							   
							   case "attraction":
								   _body.applyImpulse(_impulse.mul(0.01),_pointImpulse);  
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
		 AntG.antSpace.addChild(rayMC);
		}
		
		private function getAngle(vector3D:Vector3D, vector3D1:Vector3D):Number
		{
	     return Vector3D.angleBetween(vector3D, vector3D1);
		}
}

}