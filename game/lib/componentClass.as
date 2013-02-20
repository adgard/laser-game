package  {
	
	import flash.display.MovieClip;
	
	
	public class componentClass extends MovieClip {
		
		        [Inspectable(type="String", defaultValue="rectangle")]
                public var name2:String = "rectangle";
                
                [Inspectable(type="Boolean", defaultValue="false")]
                public var isStatic:Boolean = false;
                
                [Inspectable(bodyType = "String", defaultValue = "static")]
                public var bodyType:String = "static";
				
				[Inspectable(shapeType = "String", defaultValue = "width_height")]
                public var shapeType:String = "width_height";
				
				[Inspectable(materialType = "String", defaultValue = "glass")]
                public var materialType:String = "glass";
				
				[Inspectable(density = "int", defaultValue = "0")]
                public var density:int = 0;
				
				[Inspectable(dynamicFriction = "int", defaultValue = "0")]
                public var dynamicFriction:int = 0;
				
				[Inspectable(elasticity = "int", defaultValue = "0")]
                public var elasticity:int = 0;
				
				[Inspectable(rollingFriction = "int", defaultValue = "0")]
                public var rollingFriction:int = 0;
				
				[Inspectable(staticFriction = "int", defaultValue = "0")]
                public var staticFriction:int = 0;
				
				[Inspectable(isSensor = "Boolean", defaultValue = "false")]
                public var isSensor:Boolean = false;
				
				[Inspectable(isMovealbe = "Boolean", defaultValue = "false")]
                public var isMoveable:Boolean = false;
				
				[Inspectable(isMovealbeSensor = "Boolean", defaultValue = "false")]
                public var isMoveableSensor:Boolean = false;
				
				[Inspectable(velx = "int", defaultValue = "0")]
                public var velx:int = -1;
				
				[Inspectable(vely = "int", defaultValue = "0")]
                public var vely:int = -1;
				
				[Inspectable(refNumber = "int", defaultValue = "0")]
                public var refNumber:int = -1;
				
				[Inspectable(refType = "string", defaultValue = "none")]
                public var refType:String = "none";
				
				[Inspectable(typeElement = "string", defaultValue = "none")]
                public var typeElement:String = "none";
				
				
				
		public function componentClass() {
			// constructor code
		}
	}
	
}
