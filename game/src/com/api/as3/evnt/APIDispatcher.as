package com.api.as3.evnt{

	import flash.events.EventDispatcher;
	import flash.events.Event;

	class APIDispatcher extends EventDispatcher {
		public static  const TIME:String = "time";
		public function doAction():void {
			dispatchEvent(new Event(APIDispatcher.TIME));
		}
	}
}