package  {
	
	import flash.display.MovieClip;
	
	
	public class componentIcon extends MovieClip {
		
		
		[Inspectable(type="String", defaultValue="arrow")]
                public var name2:String = "arrow";
                
                [Inspectable(type="Number", defaultValue="0")]
                public var counter:Number = 0;
        
		        [Inspectable(type="String", defaultValue="color")]
                public var type:String = "yellow";        
               
		
		public function componentIcon() {
			// constructor code
		}
	}
	
}
