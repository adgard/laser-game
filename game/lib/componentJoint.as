package  {
	
	import flash.display.MovieClip;
	
	
	public class componentJoint extends MovieClip {
		
		[Inspectable(type="String", defaultValue="joint")]
                public var name2:String = "joint";
                
                [Inspectable(type="Boolean", defaultValue="true")]
                public var ignore:Boolean = true;
                
                [Inspectable(jointType = "String", defaultValue = "pivot")]
                public var jointType:String = "pivot";
				
		public function componentJoint() {
			// constructor code
		}
	}
	
}
