package  
{
	import flash.geom.Point;
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
	public class balloon 
	{
		public var xy:Vec2 = new Vec2(0, 0);
	    private var circleBalloon:AntActor ;
		private var node1Balloon:AntActor ;
		private var node2Balloon:AntActor ;
		
		public var rotation:Number = 0;
		public var bType:String  = "";
		public var type:String  = "";
		
		
		public var settings:Array  = [];
		public var body:Body;
		public var shType:String;
		public var mType:String;
		public var polygon:Polygon;
		public var scaleX:int =1;
		public var scaleY:int = 1;
		public var pointsArray:Array = [];
		public var balloonCompounds:Compound = new Compound();
		
		
		public function balloon(_xy:Vec2) 
		{
	      //space = space;
		  xy = _xy;
		  
		   node1Balloon = new AntActor();
		   node1Balloon.addAnimationFromCache("node1"); 
		  
		  body = new Body(BodyType.DYNAMIC); 
	      polygon = new Polygon(Polygon.box(node1Balloon.width, node1Balloon.height)) ; 
		  polygon.rotate(rotation);
		  polygon.material = Material.wood();	 
		  
		  
		  body.shapes.add(polygon);
		
		  body.position.setxy(node1Balloon.x, node1Balloon.y);
		  
		  
		  AntG.antSpace.add(node1Balloon);
		  body.userData.graphic = node1Balloon;
		//body.
		
		}
		
	}

}