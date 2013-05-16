package 

{
  import adobe.utils.CustomActions;
  import nape.constraint.AngleJoint;
  import nape.constraint.Constraint;
  import nape.constraint.PivotJoint;
  import nape.phys.Body;
  import ru.antkarlov.anthill.AntActor;
  import ru.antkarlov.anthill.*;
  
 
  import flash.display.Graphics;
  import flash.display.Sprite;
 import flash.display.DisplayObjectContainer;
  import flash.display.DisplayObject;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import flash.geom.Vector3D;
 
   import flash.display.MovieClip;
  //import flash.geom
  
  
  

  
public class actor extends EventDispatcher
{
	 public var _body:Body;
    
	 public var _type:String = "";
	 public var refArray:Array = [];
	 public var _refNumber:int = 0 ;
	 public var _refType:String = "";
	 public var _deleted:Boolean = false;
	 
	
  public function actor(body:Body,refType:String,refNumber:int) {
	  
	//pushKoef = _pushKoef;
	 _body = body;
   _body.userData.act = this;
   _type = _body.userData.act.gameType;
   _refType = refType;
   
   _refNumber = refNumber;
   
   
  }//end
  
 
 
  public function update():void {
	  updateBody();
	  updateOther();
	}//end
//////////////////////////////////////////////////	
  private function updateOther():void {


  }//end

 
	///////////////////////////////////////////////  
  private function updateBody():void {
	
	  
	   if (_body.userData.act.isRotatingD !=0) {
		   _body.userData.act.rotateDynamic();
		   }
	  
   if (_body.userData.act is actorBox) {
	   
	  
	   if (actorBox(_body.userData.act)._refType == "buttonMove") {
		_body.position = Body(_body.userData.act.buttonNode._body).localPointToWorld(_body.userData.act.buttonNode.buttonNodePoint);
		_body.rotation = Body(_body.userData.act.buttonNode._body).rotation + _body.userData.act.initAngle ;

		}	
	  
		if (actorBox(_body.userData.act)._refType == "lever") {
		 var j:AngleJoint = AngleJoint(_body.constraints.at(0));
		 
		// trace("rotation= " + (j.body1.rotation - j.body2.rotation));
		 if ((j.body1.rotation - j.body2.rotation) > 0.2) {
		 	if(actorBox(_body.userData.act).LeverType!=-1){
			 actorBox(_body.userData.act).LeverType = -1; 
		     trace("left action")
		    _body.userData.act.enableRefference();
			}
		 }
		 else 
		   if ((j.body1.rotation - j.body2.rotation) < -0.2) {
			  if(actorBox(_body.userData.act).LeverType!=1){
		       trace("right action");
			  _body.userData.act.disableRefference();
			  actorBox(_body.userData.act).LeverType = 1; 
			  }
		   }
		   else {
			     actorBox(_body.userData.act).LeverType =0; 
			    }
		}
		
    AntActor(_body.userData.graphic).x = _body.position.x;
	AntActor(_body.userData.graphic).y = _body.position.y;
	AntActor(_body.userData.graphic).angle = ((_body.rotation) * 180 / Math.PI) % 360 ;
	
	if(_body.userData.act.imgCounter>=0){
	 _body.userData.act.imgCounter --;
	}
	if (_body.userData.act.imgCounter == 0) {
		if(_body.userData.act.isStatic==false)
	     AntActor(_body.userData.graphic).visible = true;
	}
	
	
	//actorBox(_body.userData.act).velxy = _body.velocity;
	if ((_body.userData.act).gameType == "button") {
		
		(_body.userData.act).checkAngle();
		
	 if (((_body.userData.act).isContact == true) && (AntActor(_body.userData.graphic).currentFrame == 1)){
	   AntActor(_body.userData.graphic).gotoAndStop(2);
	   (_body.userData.act).enableRefference();
	 }
	else {
		  if (((_body.userData.act).isContact == false) && (AntActor(_body.userData.graphic).currentFrame == 2)) {
	            AntActor(_body.userData.graphic).gotoAndStop(1);
				(_body.userData.act).disableRefference();
			  }
		 } 
	}
	if (actorBox(_body.userData.act).gameType == "hero2") {
		_body.userData.act.rayFailedCounter = 0;
		}
	
		
	
	return;
   }
   if (_body.userData.act is actorCircle) { 
	   
	   
	   	if ((_body.userData.act).gameType == "button") {
		
		(_body.userData.act).checkAngle();
		
        if ((actorCircle(_body.userData.act)._refType == "buttonClick")&&(actorCircle(_body.userData.act).isMoveable)) {
		_body.position = Body(_body.userData.act.buttonNode._body).localPointToWorld(_body.userData.act.buttonNode.buttonNodePoint);
		_body.rotation = Body(_body.userData.act.buttonNode._body).rotation + _body.userData.act.initAngle;

		}
	}
	   
    AntActor(_body.userData.graphic).x = _body.position.x;
	AntActor(_body.userData.graphic).y = _body.position.y;
	AntActor(_body.userData.graphic).angle = ((_body.rotation) * 180 / Math.PI) % 360 ;
	
	if(_body.userData.act.imgCounter>=0){
	 _body.userData.act.imgCounter --;
	}
	if (_body.userData.act.imgCounter == 0) {
		if(_body.userData.act.isStatic==false)
	     AntActor(_body.userData.graphic).visible = true;
	}
	//trace(_body.rotation);
	  // actorCircle(_body.userData.act).velxy = _body.velocity;
	return;
   }
  
  }//end

  
  
  
  
	  
 public function removeActor():void {
	  
	   if (_body.userData.act is actorBox) { 
           AntActor(_body.userData.graphic).kill();
		   //AntActor(_body.userData.graphic).reset;
		   AntG.space.bodies.remove(_body);
	   return;
       }
	   if (_body.userData.act is actorCircle){ 
            AntActor(_body.userData.graphic).kill();
		 //  _body.userData.graphic = null;
		   AntG.space.bodies.remove(_body);
	   return;
       }
  

	  }//end

 }

}
