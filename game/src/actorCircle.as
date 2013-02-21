package  
{
	import flash.geom.Point;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.phys.*;
	import nape.space.Space;
	import ru.antkarlov.anthill.*;
	
	import ru.antkarlov.anthill.AntActor;
	/**
	 * ...
	 * @author adgard
	 */
	public class actorCircle extends actor
	{
		public var rayEnabled:Boolean  = false;
		public var rayArray:Array  = [];
		public var xy:Vec2 = new Vec2(0, 0);
	    public var rotation:Number = 0;
		public var bType:String  = "";
		public var type:String  = "";
		public var settings:Array  = [];
		public var body:Body;
		public var shType:String;
		public var mType:String;
		public var circle:Circle;
		public var polygon:Polygon;
		public var scaleX:int =1;
		public var scaleY:int = 1;
		public var isSensor:Boolean = false;
		public var velxy:Vec2;
		public var isMoveSensor:Boolean = false;
		public var isMoveable:Boolean = false;
		
		public var refType:String = "none";
		public var refNumber:int = 0;
		
		public var contactCounterIce:int = 0;
		public var iceUnderHero:Array = [];
		public var gameType:String = "none";
		
		public var canJump:Boolean  = false;
		
		
		public function actorCircle( img:AntActor,_xy:Vec2, _rotation:Number, _bType:String,_shType:String, _settings:Array, _mType:String,_type:String,_isSensor:Boolean,_velxy:Vec2,_isMoveable:Boolean,_isMoveSensor:Boolean,_refNumber:int, _refType:String,_gameType:String) 
		{
	      gameType = _gameType;
		   refType = _refType;
		  refNumber = _refNumber;
		  
		  isMoveable = _isMoveable;
		  isMoveSensor = _isMoveSensor;
		  velxy = _velxy;
		  isSensor = _isSensor;
		  type = _type;
		  xy = _xy;
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
		    circle = new Circle(img.width/2);
	       break;
		   case "balloon":
		    circle = new Circle(21);
	       break;
		   
		   case "star":
		    circle = new Circle(11);
	       break;
		   
		   case "herocircle":
		    polygon = new Polygon(Polygon.box((img.width - 2) * scaleX, (img.height - 2) * scaleY)) ;
			circle = new Circle(img.width / 2 - 2);
			polygon.sensorEnabled  = true;
			circle.sensorEnabled =  false;
			img.gotoAndStop(2);
	       break;
		   
	       default:
		     circle = new Circle(img.width/2);
			 
		   break;
		}	
		
		
		
		 if (isSensor) {
			circle.sensorEnabled = true;
			}
		else 
		     {
			  circle.sensorEnabled = false;	 
			 }
		switch (mType) {
		 case "wood":
		  circle.material = Material.wood();	 
		 break;	 
		 case "steel":
		  circle.material = Material.steel();	 
		 break;	 
		 case "sand":
		  circle.material = Material.sand();	 
		 break;	 
		 case "rubber":
		  circle.material = Material.rubber();	 
		 break;	 
		 case "ice":
		  circle.material = Material.ice();	 
		 break;	 
		 case "glass":
		  circle.material = Material.glass();	 
		 break;	
	     case "custom": 
		  circle.material.density = settings[0];
		  circle.material.dynamicFriction = settings[1];
		  circle.material.elasticity = settings[2];
		  circle.material.rollingFriction = settings[3];
		  circle.material.staticFriction = settings[4];
		 break;
		 
	     default:
		 break;
		}
		
		if (shType == "herocircle")
		{
			polygon.material = circle.material;
		}
			switch (gameType) {
			 case "button":
				body.cbTypes.add(AntG.storage.get("buttonCBT"));	
			 break;
			 
			 case "balloon":
				body.cbTypes.add(AntG.storage.get("balloonCBT"));	
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
			 
		     case "hero4":
		 	  body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			  body.cbTypes.add(AntG.storage.get("hero4CBT"));		
		     break;
			 
		     default:
			  if(bType == "dynamic"){
			   body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			  }
		     break;	
			}
		body.rotation = rotation;	
		body.shapes.add(circle);
		if (shType == "herocircle") 
		 body.shapes.add(polygon);
		 
		body.allowRotation = true;
		
		body.position.setxy(xy.x, xy.y);
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
				 
				  case "rotate":
					 
					 Body(refActor._body).angularVel = refActor.velxy.x;
					 
				 break;
			     default:
				  trace("something default");
				 break;
					
				}
			}
			
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
				 
				  case "rotate":
					 refActor.velxy.x = refActor._body.angularVel;
					 
					 Body(refActor._body).angularVel = 0;
				 break;
			     default:
				  trace("something default");
				 break;
					
				}
			}
			
		}
		
	}

}