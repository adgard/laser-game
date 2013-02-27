package  {
	
	import flash.display.MovieClip;
	
	
	public class componentJoint extends MovieClip {
		
		[Inspectable(type="String", defaultValue="joint")]
                public var name2:String = "joint";
                
                [Inspectable(type="Boolean", defaultValue="true")]
                public var ignore:Boolean = true;
                
                [Inspectable(jointType = "String", defaultValue = "pivot")]
                public var jointType:String = "pivot";
				 
				[Inspectable(type="Number", defaultValue="0")]
                public var counter:Number = 0;
				
		public function componentJoint() {
			// constructor code
		}
	}
	
}
