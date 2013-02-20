package  {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	 import flash.net.navigateToURL;
	 import flash.utils.*
	 import com.api.as3.API;
    import com.api.as3.evnt.APIEvents;
	import flash.system.Capabilities;
	// cpmstar 4457QB1F50080
	
	/**
	 * 
	 */
	public dynamic class Preloader extends MovieClip {
		
		//[Embed(source="sounds/S.mp3")]
          // public var bg:Class;
		 // private  var atLogo:*; 
		
		
		
		private var preloader		:Shape;
		private var progressText	:TextField;
		private var infoText		:TextField;
		
		private var clock:clockOrange = new clockOrange;
		//private var clockArrow:arr2;
		private var atLogo:*;
		private var minuteplay2:*;
		
		//private var comicsMovie:MovieClip = new comics();
		//public var api:API;
		//public var loginned:Boolean = false;
		public var playButton:SimpleButton = new preloaderPlay();
		
		public function Preloader() {
			
		//	stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
            //api = new API('000015', 'Wyb32aou', 'http://twotowersgames.com/api'); 
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			// show loader
			
		  
		   
			
			//minuteplay2 = minuteplay(SimpleButton(clock.getChildByName("minute")));
			//minuteplay2.addEventListener(MouseEvent.CLICK, logoListener3);
			
			//clock.getChildByName("ttLogoPreloader").addEventListener(MouseEvent.CLICK, logoListener2);;
			
			clock.x = 0;
			clock.y = 0;
			clock.visible = true;
			addChild(clock);
			
		
			//clockArrow = arr2(clock.getChildByName("arrow12"));
			
		
			preloader = new Shape();
			preloader.graphics.beginFill(0xFFFFFF);
			preloader.graphics.drawRect( -13, -15, 30, 30);
			preloader.graphics.endFill();
			//addChild(preloader);
			
			progressText = new TextField();
			var progressTextFormat:TextFormat = new TextFormat("Comic Sans MS", 24, 0xFFFFFF, true);
			progressTextFormat.align = TextFormatAlign.CENTER;
			progressText.defaultTextFormat = progressTextFormat;
			addChild(progressText);
			
			infoText = new TextField();
			infoText.width = 300;
			//infoText.defaultTextFormat = progressTextFormat;
			//infoText.text = "Please wait a few minutes";
			//addChild(infoText);
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		
		
		private function logoListener2(e:MouseEvent):void 
		{
			trace("logo");
			//soundSystem.PlaySound("button");
		   // var url:String="http://twotowersgames.com";
           // var urlRequest2:URLRequest=new URLRequest(url);
            //navigateToURL(urlRequest2);
			
		      trace("solution handler");
		}
		
		private function onResize(e:Event = null):void {
			
			
			if (preloader) {
				preloader.x = stage.stageWidth/2 ;
				preloader.y = stage.stageHeight/2;
			}
			if (progressText) {
				progressText.x = 320;//(stage.stageWidth - progressText.width)/2 ;
				progressText.y = (stage.stageHeight)/2+50;
			//	infoText.x = (stage.stageWidth - infoText.width)/2 ;
				//infoText.y = (stage.stageHeight)/2  - 60;
			}
		}
		
		private function progress(e:ProgressEvent):void {
			// update loader
			 
			
			if (progressText) {
				trace("ebitetotal" + e.bytesTotal);
				progressText.text = Math.round(e.bytesLoaded / e.bytesTotal * 100).toString() + " %";
				//clockArrow.rotation = Math.round(e.bytesLoaded / e.bytesTotal * 100) * 3.6;
				trace(progressText.text);
			}
			//hed.x = e.bytesLoaded / e.bytesTotal * 170 * 6;
		
			//hed.rotation = (hed.x-32)*360/200;
		}
		
		private function checkFrame(e:Event):void {
		//	preloader.rotation += 5;
			
			if (loaderInfo.bytesLoaded/ loaderInfo.bytesTotal==1 ) {
              if(currentFrame == totalFrames)
				stop();
				
				prestartup();

			}
		}
		
		
		
		private function prestartup():void
		{
			
			
			stop();
			clock.getChildByName("preloaderText").visible = false;
			progressText.visible = false;
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			addChild(playButton);
			playButton.x = 320;
			playButton.y = 380;
			playButton.addEventListener(MouseEvent.CLICK,startup)
			
		}
		
		
		private function startup(e:MouseEvent):void {
			
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			// hide loader
			trace("start");
		 
			playButton.removeEventListener(MouseEvent.CLICK, startup);
			removeChild(playButton);
	      
			removeChild(clock);
			
			//removeChild(infoText);
		  //  removeChild(preloader);
			removeChild(progressText);
			//removeChild(infoText);
			preloader = null;
			progressText = null;
			//infoText = null; 
			//clockArrow = null;
			trace("trace");
			this;
			var mainClass:Class = getDefinitionByName("Main") as Class;
			
			if (parent == stage) stage.addChildAt(new mainClass() as DisplayObject, 0);
			else addChild(new mainClass() as DisplayObject);
			
	
			
		}
		
	}
	
}
/*package domino
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.engine.SpaceJustifier;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import mochi.as3.*;
	
	
	
	public dynamic class Preloader extends MovieClip 
	{
		[Embed(source="img/bg.svg")]
           public var bg:Class;
		   
		
		   
		   
		private var progress2:TextField;  
		
		private var loader2:Sprite = new loader();
		private var title2:TextField;//= new title();
		private var format1:TextFormat = new TextFormat();
		private var spaceBg:space = new space();
		
		public function Preloader() 
		{
			init();
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			//loaderInfo.
			// show loader
		}//end
		private function init():void {
			
//MochiAd.showPreGameAd({clip:root, id:"e8f1fb7c28f77337", res:"640x480"});
              
            //MochiBot.track(this, "e9ac4a41");
		    progress2 = new TextField();
			progress2.x = 300;
			progress2.y = 60;
			progress2.mouseEnabled = false;

			format1.font="Hobo Std";
            format1.color = 0x996600;
			format1.bold = true;
			format1.size = 22;
			title2 = new TextField();
			
		   
			spaceBg.cacheAsBitmap = true;
		addChild(spaceBg);
		
			
			loader2.x = 240;
			loader2.y = 220;
			loader2.mouseEnabled = false;
			addChild(loader2);
		
			
			//addChild(progress2);
			}//end
			
			private function onConnectError():void
			{
				trace("error");
			}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			progress2.text = String(Math.round(100 * (e.bytesLoaded / e.bytesTotal))) + "%";
			//trace(e.bytesLoaded);
			//trace(e.bytesTotal);
			//trace("loading");
			
		}//end
		
		private function checkFrame(e:Event):void 
		{
			trace(currentFrame);
			trace(totalFrames);
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}//end
		
		private function startup():void 
		{
			// hide loader
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("domino.Main") as Class;
			removeChild(loader2);
			removeChild(spaceBg);
			
			addChild(new Main() as DisplayObject);
			
		}//end
		
	}
	
}
*/