package  
{
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import ru.antkarlov.anthill.*
		
	import nape.geom.*;
    import nape.phys.*;
    import nape.shape.*;
    import nape.space.*;
    import nape.util.*;
	
	/**
	 * ...
	 * @author adgard
	 */
	public class effects 
	{
		
		private var p:Vec2;
		private var angle:Number;
        private var type:String;
		private var img:AntActor;
		
		public function effects(_img:AntActor,_point:Vec2,_angle:Number,_type:String) 
		{
		    
			 type = _type;
			 p = _point;
			 angle = _angle;
			 img = _img;
			 // AntState(AntG.antSpace).defGroup.sort("tag");
			// AntG.antSpace.add(rayActor);
			 img.x = p.x;
			 img.y = p.y;
			 img.angle = angle;
			 img.repeat = false;
			
			 img.eventComplete.add(deleteAntActor);
            
			
			 
		}
		
		private function deleteAntActor(a:AntActor):void 
		{
			a.eventComplete.remove(deleteAntActor);
			var arr:Array = AntG.storage.get("effectForDelete");
			
			arr.push(this);
			AntG.storage.set("effectForDelete",arr);
			
			//a.kill();
		}
		public function update():void
		{
		switch(type) {
			case "ice":
			 img.alpha = 1 - (img.currentFrame) / img.totalFrames ; 
			break;
		    default:
			
			break;
		 }		
		}
		
		public function hide():void
		{
		
			img.alpha = 0; 
			img.eventComplete.remove(deleteAntActor);
			var arr:Array = AntG.storage.get("effectForDelete");
			
			arr.push(this);
			AntG.storage.set("effectForDelete",arr);
				
		}
		public function remove():void
		{
		
			img.kill();
			
		}
		
}

}