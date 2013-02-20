package  {
	
	import flash.display.MovieClip;
	
	
	public class componentPoint extends MovieClip {
		
		[Inspectable(type="String", defaultValue="point")]
                public var name2:String = "joint";
                
                [Inspectable(type="Number", defaultValue="0")]
                public var counter:Number = 0;
        
		        [Inspectable(type="String", defaultValue="none")]
                public var type:String = "none";        
               
				
		public function componentPoint() {
			// constructor code
		}
	}
	
}
