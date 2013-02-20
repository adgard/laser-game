package
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.system.Capabilities; // version check for scale9Grid bug
	
	/**
	 * ...
	 * @author sergiy
	 */
	public class bigBung
	{
		public var sprBung:MovieClip;
		public var sprPointStart:Point;
		public var sprPointFinish:Point;
		public var type:String;
		public var bungArray:Array = [];
		public var currentMovie:MovieClip;
		public var parent:DisplayObjectContainer;
		public var points:Array;
		public var a:Array;
		public var fire:MovieClip;
		public var isDeleted:Boolean = false;
		public var teleported:Boolean = false;
		public var rot:Number = 0;
		
		
		
		
		public function bigBung(_world:b2World, _parent:DisplayObjectContainer, _sprBung:MovieClip, _sprPointStart:Point, _sprPointFinish:Point, _type:String, _points:Array, _rot:Number) {
			//fire = _fire;
			rot = _rot;
			sprBung = _sprBung;
			sprPointStart = _sprPointStart;
			sprPointFinish = _sprPointFinish;
			parent = _parent;
			type = _type;
			trace(sprPointStart.x + " =start= " + sprPointStart.y);
			//trace(sprPointFinish.x + " =finish= " + sprPointFinish.y);
			var i:int=0
			switch(type) {
				 case "point":
			  for (i = 0; i < 10;i++ ){
	            currentMovie = MovieClip(duplicateDisplayObject(sprBung));
				currentMovie.scaleX = 0.8;
				currentMovie.scaleY = 0.8;
				
				currentMovie.x = sprPointStart.x;
				currentMovie.y = sprPointStart.y;
				//currentMovie.x += Math.round(Math.random()) * 10 - 5;
				//currentMovie.y += Math.round(Math.random()) * 10 - 5;
				currentMovie.rotation = Math.round(Math.random() * 360);
				currentMovie.gotoAndPlay(Math.round(Math.random() * 7));
				fire.addChild(currentMovie);
				bungArray.push(currentMovie);
			 }
			  parent.addChild(fire);
			 break;
			 
			 case "line":
			  a = RasterizeLine(sprPointStart, sprPointFinish);
			 
			  var distance:int = Point.distance(sprPointStart, sprPointFinish);
			  for each(var p:Point in a){
			   
			 
	            currentMovie = MovieClip(duplicateDisplayObject(sprBung));
				currentMovie.x = p.x;
				currentMovie.y = p.y;
				currentMovie.x += Math.round(Math.random()) * 10 - 5;
				currentMovie.y += Math.round(Math.random()) * 10 - 5;
				currentMovie.rotation = Math.round(Math.random()*360);
				parent.addChild(currentMovie);
				bungArray.push(currentMovie);
			 
			}
			 break;
			 
			 case "lines":
			  points = _points;
			  
			  for each(var p3:b2Vec2 in points) {
				a = RasterizeLine(sprPointStart, new Point(p3.x * 30, p3.y * 30));
				
				for each(var p4:Point in a){
				 currentMovie = MovieClip(duplicateDisplayObject(sprBung));
				 currentMovie.x = p4.x;
				 currentMovie.y = p4.y;
				 currentMovie.x += Math.round(Math.random()) * 10 - 5;
				 currentMovie.y += Math.round(Math.random()) * 10 - 5;
				 currentMovie.rotation = Math.round(Math.random()*360);
				 parent.addChild(currentMovie);
				 bungArray.push(currentMovie);
				}
			}
			   
			 break;
			 case "blood":
			 break;
			 
		 case "bloons":
			  
			currentMovie = MovieClip(duplicateDisplayObject(sprBung));	
			currentMovie.scaleX = 1.5;
			currentMovie.scaleY = 1.5;
			
			parent.addChild(currentMovie);
			 break;
			 
		case "drops":
			  
			currentMovie = MovieClip(duplicateDisplayObject(sprBung));	
			currentMovie.scaleX = 1/6;
			currentMovie.scaleY = 1/6;
			
			parent.addChild(currentMovie);
			
		break;	 
			 
			 
		 case "rocket":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 0.6;
			 currentMovie.scaleY = 0.6;
			  parent.addChild(currentMovie);
			
		break;
			 
		 case "grenade":
			 currentMovie = sprBung;	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 0.6;
			 currentMovie.scaleY = 0.6;
			  parent.addChild(currentMovie);
	
		break;	 
		
		case "dynamite":
			 currentMovie = sprBung;// MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x+538*0.6;
			 currentMovie.y = sprPointStart.y+68*0.6;
			 currentMovie.scaleX = 0.6;
			 currentMovie.scaleY = 0.6;
			  parent.addChild(currentMovie);
		break;	 
		
		case "zombie_1":
			 currentMovie = sprBung;	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;	 
		case "zombie_2":
			 currentMovie = sprBung//ovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;	 
		case "zombie_3":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;	 
		case "zombie_4":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;	 
		case "zombie_5":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;	 
		
		case "zombie_6":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;	 
		
		case "knife_boom":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;	 
		
		
		case "knife_flash":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 0.8;
			 currentMovie.scaleY = 0.8;
			 parent.addChild(currentMovie);
		break;
		
		case "flash":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 0.4;
			 currentMovie.scaleY = 0.4;
			 parent.addChild(currentMovie);
		break;
		
		
		case "boom4":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 0.5;
			 currentMovie.scaleY = 0.5;
			 parent.addChild(currentMovie);
		break;
		
		case "boom_ballon":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;
	
		case "teleport":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;
		case "teleportRevert":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;
		
		case "firefire":
			 currentMovie = sprBung//MovieClip(duplicateDisplayObject(sprBung));	
			 currentMovie.rotation = rot;
			 currentMovie.x = sprPointStart.x;
			 currentMovie.y = sprPointStart.y;
			 currentMovie.scaleX = 1;
			 currentMovie.scaleY = 1;
			 parent.addChild(currentMovie);
		break;
			 default:
			 break;
			}
			
			
		}//end
	
public function RasterizeLine(start:Point,end:Point):Array
{
	
    var lineDx:Number = end.x - start.x;
    var lineDy:Number = end.y - start.y;
    var arrayPixel:Array = [];
	var temp:Point;
	var dv:Point;
	var x:int = 0;
    var y:int = 0;
	var endX:int = 0;
	var endY:int = 0;
	var v:Point;
	
	// Horizontal tracing.
    if ( Math.abs( lineDx ) >= Math.abs( lineDy ) )
    {
        // Swap points.
        if ( lineDx < 0 )
        {
            lineDx *= -1;
            lineDy *= -1;
           temp = start;
            start = end;
            end = temp;
        }

		dv = new Point( 1, lineDy / lineDx );

         x = (int)(Math.floor( start.x ));
         y = (int)(Math.floor( start.y ));
        endX = (int)(Math.ceil( end.x ));
        endY = (int)(Math.floor( end.y ));

        // Line(x) = Y0 + dY/dX * (x - X0);
        // Get point V = Line( x );
         v = new Point( x, start.y + ( x - start.x ) * dv.y );

        if ( lineDy > 0 )
        {
            while ( x != endX )
            {
                arrayPixel.push(new Point(x,y));
                v.x += dv.x; v.y += dv.y;
                if ( ( v.y > y + 1 ) && ( y != endY ) )
				  arrayPixel.push(new Point(x,++y));
                x++;
            }
        }
        else
        {
            while ( x != endX )
            {
                arrayPixel.push(new Point(x,y));
                v.x += dv.x; v.y += dv.y;
                if ( ( v.y < y ) && ( y != endY ) )
					arrayPixel.push(new Point(x,--y));
                x++;
            }
        }
    }
    else // Vertical tracing.
    {
        if ( lineDy < 0 )
        {
            lineDx *= -1;
            lineDy *= -1;
            temp = start;
            start = end;
            end = temp;
        }

         dv = new Point( lineDx / lineDy, 1 );

         x = (int)(Math.floor( start.x ));
		 y = (int)(Math.floor( start.y ));

        endX = (int)(Math.floor( end.x ));
		endY = (int)(Math.ceil( end.y ));

         v = new Point(start.x + ( y - start.y ) * dv.x, y);

        if ( lineDx > 0 )
        {
            while ( y != endY )
            {
                arrayPixel.push(new Point(x,y));
                v.x += dv.x; v.y += dv.y;
                if ( ( v.x > x + 1 ) && ( x != endX ) )
                    arrayPixel.push(new Point(++x,y));
                y++;
            }
        }
        else
        {
            while ( y != endY )
            {
              arrayPixel.push(new Point(x,y));
                v.x += dv.x; v.y += dv.y;
                if ( ( v.x < x ) && ( x != endX ) )
                   arrayPixel.push(new Point(--x,y));
                y++;
            }
        }
    }
	return arrayPixel;
}

   public function removeBang():void {
	   if(isDeleted == false){
         isDeleted = true;
		
			 currentMovie.stop();
		      parent.removeChild(currentMovie);
			  //currentMovie = null;
		 
		}
	}
   public function checkBang2():Boolean {
		var i:int = 0;
		var cm:MovieClip;
		if(isDeleted == false){
		switch(type) {
			case "rocket":
		 if (MovieClip(currentMovie).currentFrame == 14){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		break;
		
		case "grenade":
		 if (MovieClip(currentMovie).currentFrame == 47){
		  
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   }
		break;
		
		case "dynamite":
		 if (MovieClip(currentMovie).currentFrame == 35){
		
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		break;
		
		case "zombie_1":
		 if (MovieClip(currentMovie).currentFrame == 12){
		  
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		 case "knife_boom":
		 if (MovieClip(currentMovie).currentFrame == 12){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		case "knife_flash":
		 if (MovieClip(currentMovie).currentFrame == 5){
		    parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		 
		case "flash":
		 if (MovieClip(currentMovie).currentFrame == 5){
		    parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		 case "zombie_2":
		 if (MovieClip(currentMovie).currentFrame == 12){
		  
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		 case "zombie_3":
		 if (MovieClip(currentMovie).currentFrame == 12){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		 case "zombie_4":
		 if (MovieClip(currentMovie).currentFrame == 12){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		 
		 case "zombie_5":
		 if (MovieClip(currentMovie).currentFrame == 12){
		  
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		 break;
		 
		case "zombie_6":
		 if (MovieClip(currentMovie).currentFrame == 12){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		break;
        case "boom4":
		 if (MovieClip(currentMovie).currentFrame == 16){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		break;
		
		case "boom_ballon":
		 if (MovieClip(currentMovie).currentFrame == 12){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		break;
		
		case "firefire":
		 if (MovieClip(currentMovie).currentFrame == 3){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		break;
		
		
		case "teleport":
		 if (MovieClip(currentMovie).currentFrame == 12){
		 
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG,this));
		   return true;
	     }
		break;
	case "teleportRevert":
		if ((MovieClip(currentMovie).currentFrame > 10) && (teleported == false ))
		{
		   parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.TELEPORT_HERO, [currentMovie.x,currentMovie.y]));
		    teleported = true;
		}
		   if (MovieClip(currentMovie).currentFrame == 12){
		  
		    parent.dispatchEvent(new eventLoadLevel(eventLoadLevel.DELETE_BANG, this)); 
		   return true;
	     }
		break;
		
		

default:
	break;
		}
		}
		  return false;
		}//end
   
	public function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
		var targetClass:Class = Object(target).constructor;
		var duplicate:DisplayObject = new targetClass() as DisplayObject;
		
		// duplicate properties
		duplicate.transform = target.transform;
		duplicate.filters = target.filters;
		duplicate.cacheAsBitmap = target.cacheAsBitmap;
		duplicate.opaqueBackground = target.opaqueBackground;
		if (target.scale9Grid) {
			var rect:Rectangle = target.scale9Grid;
			
			if (Capabilities.version.split(" ")[1] == "9,0,16,0"){
				// Flash 9 bug where returned scale9Grid as twips
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
			}
			
			duplicate.scale9Grid = rect;
		}
		
		// Flash 10 only
		// duplicate.graphics.copyFrom(target.graphics);
		
		// add to target parent's display list
		// if autoAdd was provided as true
		if (autoAdd && target.parent) {
			target.parent.addChild(duplicate);
		}
		return duplicate;
	}
 }
}