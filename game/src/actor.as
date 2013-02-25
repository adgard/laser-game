package 

{
  import adobe.utils.CustomActions;
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
	
	  
	  
	  
   if (_body.userData.act is actorBox) {
	   
	   
	   if (actorBox(_body.userData.act)._refType == "buttonMove") {
		_body.position = Body(_body.userData.act.buttonNode._body).localPointToWorld(_body.userData.act.buttonNode.buttonNodePoint);
		}	
	   
    AntActor(_body.userData.graphic).x = _body.position.x;
	AntActor(_body.userData.graphic).y = _body.position.y;
	AntActor(_body.userData.graphic).angle = ((_body.rotation) * 180 / Math.PI) % 360 ;
	
	//actorBox(_body.userData.act).velxy = _body.velocity;
	if(actorBox(_body.userData.act).gameType == "button"){
	 if ((actorBox(_body.userData.act).isContact == true) && (AntActor(_body.userData.graphic).currentFrame == 1)){
	   AntActor(_body.userData.graphic).gotoAndStop(2);
	   actorBox(_body.userData.act).enableRefference();
	 }
	else {
		  if ((actorBox(_body.userData.act).isContact == false) && (AntActor(_body.userData.graphic).currentFrame == 2)) {
	            AntActor(_body.userData.graphic).gotoAndStop(1);
				actorBox(_body.userData.act).disableRefference();
			  }
		 } 
	}
	if (actorBox(_body.userData.act).gameType == "hero2") {
		_body.userData.act.rayFailedCounter = 0;
		}
	
		
	
	return;
   }
   if (_body.userData.act is actorCircle){ 
    AntActor(_body.userData.graphic).x = _body.position.x;
	AntActor(_body.userData.graphic).y = _body.position.y;
	AntActor(_body.userData.graphic).angle = ((_body.rotation) * 180/Math.PI) % 360 ;
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
