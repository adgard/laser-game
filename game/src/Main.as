package

{
	import adobe.utils.CustomActions;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import org.as3lib.kitchensync.action.tweentarget.TargetProperty;
	
	
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;

	//import
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mochi.as3.*;
	
	

	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import flash.system.Capabilities;
    import flash.net.navigateToURL;

	import flash.system.Security;
	
	import ru.antkarlov.anthill.*;
	
	/**
	 * ...
	 * @author sergiy
	 */
	//[Frame(factoryClass="Preloader")]
public  dynamic class Main extends  MovieClip
	{
		
	    public function Main():void 
		{
    		if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}//end 		
		
		private function init(e:Event):void 
		{
		
		if ( isUrl(["","flashgamelicense.com","www.flashgamelicense.com", "www.bestphysics.com", "bestphysics.com"]) ) {	
			
		  
		  removeEventListener(Event.ADDED_TO_STAGE, init);
		 
			var engine:Anthill = new Anthill(initGameState);
			addChild(engine);
		
			AntG.frameRate = 30;// setFramerate(60);
			AntG.setScreenSize(800, 480);
			
			var fps:fpsBox = new fpsBox(stage);
            addChild(fps);
			
        }
		 else{ 
			 trace("blocked");
		     addChild(new sitelock());
			 removeEventListener(Event.ADDED_TO_STAGE, init);
			 return; 
		   } 
			
			
		}
		
	
		
	
		
public function isUrl(urls:Array):Boolean 
  {
   var url:String = loaderInfo.loaderURL;
   var urlStart:Number = url.indexOf("://")+3;
   var urlEnd:Number = url.indexOf("/", urlStart);
   var domain:String = url.substring(urlStart, urlEnd);
   var LastDot:Number = domain.lastIndexOf(".")-1;
   var domEnd:Number = domain.lastIndexOf(".", LastDot)+1;
   domain = domain.substring(domEnd, domain.length);
   for (var i:int = 0; i < urls.length; i++) 
    if (domain == urls[i]) return true;

    return false;
  }


   public function Update(e:Event):void {
	   
	  
		
		}//end   

		

	
	}
	
	
}