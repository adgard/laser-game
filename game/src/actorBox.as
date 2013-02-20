package  
{
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import nape.callbacks.*;
	
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
		public var xy:Vec2 = new Vec2(0, 0);
	    public var rotation:Number = 0;
		public var bType:String  = "";
		public var type:String  = "";
		public var isJumping:Boolean  = false;
		public var rayEnabled:Boolean  = false;
		public var rayArray:Array  = [];
		
		
		
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
		
		
		
		
		
		public function actorBox( img:AntActor,_xy:Vec2, _rotation:Number, _bType:String,_shType:String, _settings:Array, _mType:String, _pointsArray:Array,_type:String,_isSensor:Boolean,_velxy:Vec2,_isMoveable:Boolean,_isMoveSensor:Boolean,_refNumber:int, _refType:String,_gameType:String) 
		{
	      //space = space;
		  gameType = _gameType;
		  refType = _refType;
		  refNumber = _refNumber;
		  
		  isMoveable = _isMoveable;
		  isMoveSensor = _isMoveSensor;
		  
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
		    polygon = new Polygon(Polygon.box((img.width-2) * scaleX, (img.height-2) * scaleY)) ;
	       break;
		   
		   case "balloon":
		    polygon = new Polygon(Polygon.box(4, 12)) ;
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
		 break;
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
		 
		 case "balloon":
				body.cbTypes.add(AntG.storage.get("balloonCBT"));	
		 break;
			 
		 case "hero3":
		 	body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			body.cbTypes.add(AntG.storage.get("hero3CBT"));		
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
		  	 polygon.filter.collisionMask = 0x000000001;
			 polygon.filter.collisionGroup = 0x000000001;
			 
		 break;
		 
		  case "fan":
		  	 polygon.filter.collisionMask = 0x000000001;
			 polygon.filter.collisionGroup = 0x000000001;
			 
		break;	
		
		 case "attraction":
		  	 polygon.filter.collisionMask = 0x000000001;
			 polygon.filter.collisionGroup = 0x000000001;
			 
		break;	
		 case "repulsion":
		  	 polygon.filter.collisionMask = 0x000000001;
			 polygon.filter.collisionGroup = 0x000000001;
			 
		break;	
		 default:
			if(bType == "dynamic"){
			 body.cbTypes.add(AntG.storage.get("dynamicCBT"));
			}
		 break;
				
		}
		body.rotation = rotation;	
		body.shapes.add(polygon);
		
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
					 
					 Body(refActor._body).angularVel = refActor.velxy.x/4;
					 
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