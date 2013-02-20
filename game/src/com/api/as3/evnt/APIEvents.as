package com.api.as3.evnt {


import flash.events.Event;


public class APIEvents extends Event {



	public static var USERNAME:String = "USERNAME";
	public static var GETSCORE:String = "GETSCORE";
	public static var GIVESCORE:String = "GIVESCORE";	
	public static var STARTGAME:String = "STARTGAME";
	public static var AUTHURL:String = "AUTHURL";
	public static var BADDATA:String = "BADDATA";
	public static var LOADERROR:String = "LOADERROR";
	public static var SECURITY_ERROR:String = "SECURITY_ERROR";
	public static var IO_ERROR:String = "IO_ERROR";

	
	
	

	
	
	private var _data:Object;

public function APIEvents(typ:String,dat:Object=undefined,bbl:Boolean=false,ccb:Boolean=false):void {
		super(typ, bbl, ccb);
		_data = dat;
	};

	public function get data():Object {
		return _data;
	};


}


}