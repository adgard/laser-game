package 
{
	/**
	 * Copyright(C) 2007 Schell Scivally
	 *
	 * Animation is an Actionscript 3 class made to address the limitations of the builtin
	 * MovieClip class.
	 * 
	 * This file is one part of efnxAS3classes.
	 * 
	 * efnxAS3classes are free software; you can redistribute it and/or modify
	 * it under the terms of the GNU General Public License as published by
	 * the Free Software Foundation; either version 3 of the License, or
	 * (at your option) any later version.
	 * 
	 * efnxAS3classes are distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 * GNU General Public License for more details.
	 * 
	 * You should get a copy of the GNU General Public License
	 * at <http://www.gnu.org/licenses/>
	 */
	 
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	//	fpsBox monitors the FPS of an swf and shows the instantaneous and average FPS in a textField  //
	///////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////
	//	usage - var fps:fpsBox = new fpsBox(stage:Stage); addChild(fps)  //
	//////////////////////////////////////////////////////////////////////


	import flash.display.Stage;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
	
	//import com.efnx.utils.mainFrame;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	   
    public class fpsBox extends TextField
    {
        protected var frames:uint = 0;
        protected var format:TextFormat = new TextFormat();
		protected var averageArray:Array = new Array();
		protected var targetFPS:int = 0;
       
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	       
        public function fpsBox(...rest)		//instantiates the class and sets initial settings	
        {
            var timer:Timer = new Timer(1000);
            format.font = "Verdana";
            format.color = 0x000000;
            format.size = 10;
            this.autoSize = TextFieldAutoSize.LEFT;
            this.defaultTextFormat = format;
           	this.text = "-- FPS ---- AV";
			this.y = 20;
            timer.addEventListener(TimerEvent.TIMER, tick);
			/*
			if(rest[0] is mainFrame)
			{	
				rest[0].register(everyFrame);	//mainFrame is a previously unreleased class
			}else 
			*/
			if(rest[0] is Stage)
			{
				rest[0].addEventListener(Event.ENTER_FRAME, everyFrame, false, 0, true);
				targetFPS = rest[0].frameRate;
			}else
			{
            	this.addEventListener(Event.ENTER_FRAME, everyFrame, false, 0, true);
			}
			
            timer.start();
        }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		   
        public function everyFrame(event:Event):void	//called every frame to increment the frames, after one second the result
        {												//is shown and averaged
            frames++;
        }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	       
        protected function tick(event:TimerEvent):void		//called every second to display FPS and calculate average FPS
        {
            averageArray.push(frames);
			if(averageArray.length == 4)
			{
				for(var i:int = 1; i<averageArray.length; i++)
				{
					averageArray[0] += averageArray[i];
				}
				averageArray.splice(1, averageArray.length-1);
				averageArray[0] /= 4;
			}
			this.text = frames + " FPS " + Math.round(averageArray[0]) + " AV";
			if(targetFPS != 0)
			{
				this.appendText(" /" + targetFPS);
			}
            frames = 0;
        }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
    }//end class
}//end package

