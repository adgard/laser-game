package  
{
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import nape.callbacks.*;
	import nape.constraint.PivotJoint;
	import nape.dynamics.InteractionFilter;
	import nape.shape.Circle;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.phys.*;
	import nape.space.Space;
	import ru.antkarlov.anthill.AntAnimation;
	
	import ru.antkarlov.anthill.AntActor;
	import ru.antkarlov.anthill.*;
	/**
	 * ...
	 * @author adgard
	 */
	public class actorBox extends actor
	{
		public var LeverType:int =  0;
		public var magnetEnabled:Boolean =  false;
		
	    public var filt:InteractionFilter = new InteractionFilter();
		public var isRotatingD:Boolean =  false;
		public var ropeEnabled:Boolean =  false;
		public var isRotating:Boolean =  false;
		public var bClickEnabled:Boolean =  false;
		
		public var ropeComp:actor;
		public var rotateAngle:Number = 0 ;
		public var initialAngle:Number = -1 ;
		
		
		public var balloonEnabled:Boolean =  false;
		public var xy:Vec2 = new Vec2(0, 0);
	    public var rotation:Number = 0;
		public var bType:String  = "";
		public var type:String  = "";
		public var isJumping:Boolean  = false;
		public var canJump:Boolean  = false;
		public var jumpRayEnabled:Boolean  = false;
		public var rayFailedCounter:int  = 0;
		public var buttonNode:actor;
		public var buttonNodePoint:Vec2;
		public var magnetJointInited:Boolean = false;
		public var magnetJoint:PivotJoint;
		
		public var magnetStatInited:Boolean = false;
		
		
		
		public var rayEnabled:Boolean  = false;
		public var rayArray:Array  = [];
		public var circle:Circle;
		
		public var heroConnected:actor = null;
		public var settings:Array  = [];
		public var body:Body;
		public var shType:String;
		public var mType:String;
		public var polygon:Polygon;
		public var scaleX:int =1;
		public var scaleY:int = 1;
		public var pointsArray:Array = [];
		public var isSensor:Boolean = false;
		public var isContact:Boolean = false;
		public var velxy:Vec2 ;
		public var isMoveSensor:Boolean = false;
		public var isMoveable:Boolean = false;
		
		public var refType:String = "none";
		public var refNumber:int = 0;
		
		
		public var contactCounter:int = 0;
		public var contactCounterIce:int = 0;
		public var iceUnderHero:Array = [];
		public var gameType:String = "none";
		public var rayType:String = "intake";
		
		public var isStatic:Boolean = false;
		
		
		public var balloonPoints:Array = [new Vec2( -23,-23),new Vec2( -23,23),new Vec2( 23,-23),new Vec2( 23,23)];
		
		
		
		
		
		
		
		public function actorBox( img:AntActor,_xy:Vec2, _rotation:Number, _bType:String,_shType:String, _settings:Array, _mType:String, _pointsArray:Array,_type:String,_isSensor:Boolean,_velxy:Vec2,_isMoveable:Boolean,_isMoveSensor:Boolean,_refNumber:int, _refType:String,_gameType:String, _rayType:String,_isStatic:Boolean) 
		{
	      //space = space;
		  isStatic = _isStatic;
		  rayType = _rayType;
		  if (rayType == "reflex")
		   trace(rayType);
		  
		  gameType = _gameType;
		  refType = _refType;
		  refNumber = _refNumber;
		  
		  isMoveable = _isMoveable;
		  isMoveSensor = _isMoveSensor;
		  
		  filt.sensorGroup = 0x000000001;
		  filt.sensorMask =  0x000000001;
		  filt.collisionGroup =0x00000001;
		  filt.collisionMask = 0x00000001;
		  velxy = _velxy;
		  isSensor =  _isSensor;
		  xy = _xy;
		  type = _type;
		  pointsArray =  _pointsArray;
		  rotation = _rotation;
		  bType = _bType;
		  shType =  _shType;
		  mType = _mType;
		  settings = _settings;
		  switch(bType) {
           case "dynamic":
		    body = new Body(BodyType.DYNAMIC); 
	       break;
		  
		   case "static":
		    body = new Body(BodyType.STATIC); 
	       break;
		  
		   case "kinematic":
		    body = new Body(BodyType.KINEMATIC); 
		   break;
		 
	       default:
			 body = new Body();
	       break;
		}
		  
		if (isMoveable) {
			// body.velocity.setxy(velxy.x, velxy.y);
			 body.cbTypes.add(AntG.storage.get("moveableCBT"))
			}
		if (isMoveSensor) {
			 body.cbTypes.add(AntG.storage.get("movesensorCBT"))
			}
			
			
		
		  switch(shType) {
           case "width_height":
		    polygon = new Polygon(Polygon.box((img.width-3) * scaleX, (img.height-3) * scaleY)) ;
	       break;
		   
		   case "rope":
		    polygon = new Polygon(Polygon.box((img.width) * scaleX, (img.height) * scaleY)) ;
	       break;
		   
		   case "balloon":
		    polygon = new Polygon(Polygon.box(4, 12)) ;
	       break;
		  
		   case "48_48":
		    polygon = new Polygon(Polygon.box(48, 48)) ;
	       break;
		   case "herobox":
		    polygon = new Polygon(Polygon.box((img.width - 3) * scaleX, (img.height - 3) * scaleY)) ;
			polygon.sensorEnabled  = false;
			circle = new Circle(img.width / 2 - 2);
			circle.sensorEnabled =  true;
	       break;
		   
		   
		   case "points":
		    polygon = new Polygon(pointsArray);
	       break;
		  
		   
		 
	       default:
			 polygon = new Polygon(Polygon.box(img.width * scaleX, img.height * scaleY));
	       break;
		}	
		
		 
		if (rotation!=0)
		 trace(rotation);
		 //img.
		
		if (isSensor) {
			polygon.sensorEnabled = true;
			}
		else 
		     {
			  polygon.sensorEnabled = false;	 
			 }
		switch (mType) {
		 case "wood":
		  polygon.material = Material.wood();	 
		 break;	 
		 case "steel":
		  polygon.material = Material.steel();	 
		 break;	 
		 case "sand":
		  polygon.material = Material.sand();	 
		 break;	 
		 case "rubber":
		  polygon.material = Material.rubber();	 
		 break;	 
		 case "ice":
		  polygon.material = Material.ice();	 
		 break;	 
		  
		 
		 case "glass":
		  polygon.material = Material.glass();	 
		 break;	
	     case "custom": 
		  polygon.material.density = settings[0];
		  polygon.material.dynamicFriction = settings[1];
		  polygon.material.elasticity = settings[2];
		  polygon.material.rollingFriction = settings[3];
		  polygon.material.staticFriction = settings[4];
		 break;
		 
	 default:
		 polygon.material = Material.steel();
		 break;
		}
		if (shType == "herobox")
		{
			circle.material = polygon.material;
		}
		switch (gameType) {
		
		 case "button":
			body.cbTypes.add(AntG.storage.get("buttonCBT"));
		 break;
		
		 case "hero1":
		 	body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			body.cbTypes.add(AntG.storage.get("hero1CBT"));		
		 break;
		 
		 case "hero2":
		 	body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			body.cbTypes.add(AntG.storage.get("hero2CBT"));		
		 break;
		 
		  case "hero4":
		 	body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			body.cbTypes.add(AntG.storage.get("hero4CBT"));	
			circle.sensorEnabled = true;
		 break;
		 
		 case "balloon":
				body.cbTypes.add(AntG.storage.get("balloonCBT"));	
		 break;
			 
		 case "hero3":
		 	body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			body.cbTypes.add(AntG.storage.get("hero3CBT"));		
		 break;
		 
		 case "magnet":
		 	body.cbTypes.add(AntG.storage.get("magnetCBT"));		
		 break;
		 
		 case "magnetStat":
		 	body.cbTypes.add(AntG.storage.get("magnetStatCBT"));		
		 break;
		 
		case "rope":
		 	body.cbTypes.add(AntG.storage.get("dynamicCBT"));
		break;
		 
		 case "ice":
			body.cbTypes.add(AntG.storage.get("iceCBT"));	
		 break;
			
		 case "spike":
			body.cbTypes.add(AntG.storage.get("spikeCBT"));	
		 break;
		
		 case "star":
			body.cbTypes.add(AntG.storage.get("collectCBT"));	
		 break;
		
		 case "emitter":
		  	// polygon.filter.collisionMask = 0x000000001;
			// polygon.filter.collisionGroup = 0x000000001;
			 
		 break;
		 
		  case "fan":
		  	// polygon.filter.collisionMask = 0x000000001;
			// polygon.filter.collisionGroup = 0x000000001;
			 
		break;	
		
		 case "attraction":
		  	 //polygon.filter.collisionMask = 0x000000001;
			 //polygon.filter.collisionGroup = 0x000000001;
			 
		break;	
		 case "repulsion":
		  	 //polygon.filter.collisionMask = 0x000000001;
			 //polygon.filter.collisionGroup = 0x000000001;
			 
		break;	
		 
		
		
		 default:
			if(bType == "dynamic"){
			 body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			}
		 break;
				
		}
		
		
		switch(rayType) {
           case "pass":
		     polygon.filter = filt;
		   break;
		   
	       default:
		     //polygon.group = 0x000000001;
		   break;
		}	
		
		
		body.rotation = rotation;	
		body.shapes.add(polygon);
		if (shType == "herobox") 
		 body.shapes.add(circle);
		
		
		body.position.setxy(xy.x, xy.y);
		if (isStatic) {
             img.visible = false;
			}
		body.userData.graphic = img;
		//body.
		super(body,refType,refNumber);
		}
		
		public function enableRefference():void 
		{
			for each (var refActor:* in actor(this).refArray ) {
				switch (refActor._refType) {
				 case "move":
					 refActor._body.velocity.setxy(refActor.velxy.x, refActor.velxy.y);	 
				 break;
				 
				 case "moveMagnet":
					 refActor._body.velocity.setxy(refActor.velxy.x, refActor.velxy.y);	 
				 break;
				 
				 
				 case "magnetStat":
					 refActor.magnetEnabled = true;	 
				 break;
				 
			    case "buttonMove":
				 trace("enable button move");
				break;
				 
				case "leverMove":
				 trace("lever left");
				 refActor._body.velocity.setxy(refActor.velxy.x, refActor.velxy.y);	 
				break;
				 case "rotate":
					 
					 Body(refActor._body).angularVel = refActor.velxy.x/4;
					 
				 break;
				 
			 
				 case "rotateDynamic":	
					 refActor.isRotatingD = true;
				 break;
				 
				 case "rotateStop":
					 Body(refActor._body).angularVel = refActor.velxy.x/4;
					refActor.isRotating = true;
				 break;
			     case "rotateAngle":
				    if(initialAngle==-1){
					 initialAngle = refActor._body.rotation;
					  rotateAngle = refActor.velxy.y * Math.PI / 180;
					}
					 Body(refActor._body).angularVel = refActor.velxy.x/4;
					 refActor.isRotating = true;
				 break;
			     default:
				  trace("something default");
				 break;
					
				}
			}
			
		}
		public function checkAngle():void {
			for each (var refActor:* in actor(this).refArray ) {
			if(refActor.isRotating){	
			 if (Math.abs(initialAngle - refActor._body.rotation) > rotateAngle) {
				 Body(refActor._body).angularVel = 0;
				 }
			 }
			}
		}
	 public function rotateDynamic():void {
		 Body(body).applyAngularImpulse(this.velxy.x/4);
	  }
		public function disableRefference():void 
		{
			
			for each (var refActor:* in actor(this).refArray ) {
				switch (refActor._refType) {
				 
				 case "move":
					 refActor.velxy.x = refActor._body.velocity.x;
					 refActor.velxy.y = refActor._body.velocity.y;
					 
					 refActor._body.velocity.setxy(0,0);
				 break;
				 
				 case "moveMagnet":
					 refActor.velxy.x = refActor._body.velocity.x;
					 refActor.velxy.y = refActor._body.velocity.y;
					 
					 refActor._body.velocity.setxy(0, 0);
					  if (refActor.magnetJointInited) {
						   AntG.space.constraints.remove(refActor.magnetJoint);
						   refActor.magnetJoint = null;
						   refActor.magnetJointInited = false;
						  }	 
				 break;
				 
				 case "magnetStat":
					 refActor.magnetEnabled = false;	 
				 break;
				 
				 case "rotateStop":
					 Body(refActor._body).angularVel = 0;
					 refActor.isRotating = false;
				 break;
				case "leverMove":
				 trace("lever right");
				 refActor._body.velocity.setxy(-refActor.velxy.x, -refActor.velxy.y);	 
				break;
				 
				  case "rotate":
					 refActor.velxy.x = refActor._body.angularVel;
					 
					 Body(refActor._body).angularVel = 0;
				  break;
				  
				  case "rotateAngle":
					;
				  break;
				  case "rotateDynamic":
					 
					 refActor.isRotatingD = false;
				 break;
				 
			     default:
				  trace("something default");
				 break;
					
				}
			}
			
		}
		

		
	}

}