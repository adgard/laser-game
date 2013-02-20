package com.api.as3 { 

	import flash.display.MovieClip;
	import com.api.as3.security.RC4;
	import flash.events.*;
    import flash.net.*;
	import com.api.as3.evnt.*;
	
	public class API extends MovieClip {
		
		private var theKey:String;
		private var url:String;
		private var gameid:String;
		private var idkey:String='JKLdfr34,56D5,673rdSsDS';
		
		public function API(gameid:String,key:*,url:*)
		{
				this.theKey=key;
				this.url=url;
				this.gameid=gameid;
		}
		
		public function startGame():void
		{
			var xml:String;
			var query_de:String;
			var query_en:String;
			var reply_de:String;
			var reply_en:String;
			
			xml='<?xml version="1.0" encoding="UTF-8"?>';
			xml+='	 <root>';
			xml+='		<query name="startgame">';
			xml+='			<game gameid="'+gameid+'"></game>';
			xml+='		</query>';
			xml+='	</root>';
			query_de=xml;
			
			var query:*=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void{ 
				trace("Security Error in metod 'startGame': " + event);
				sendEvent(APIEvents.SECURITY_ERROR,{metod:'startGame',text:event.text,type:event.type});
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void{ 
				trace("IO Error in metod 'startGame': " + event);
				sendEvent(APIEvents.IO_ERROR,{metod:'startGame',text:event.text,type:event.type});
			});
			loader.addEventListener(Event.COMPLETE, function(event:Event):void{ 
				var d:URLVariables = new URLVariables(loader.data);
				if(d.resp)
				{
					reply_en=d.resp;
					var xml:XML=new XML(RC4.decrypt(d.resp,theKey));
					reply_de=xml.toString();
					var p1:Number=0;
					var p2:String='';
					if(xml!='')
					{
						p1=xml.reply[0].game[0].@authed?xml.reply[0].game[0].@authed:0;
						p2=xml.reply[0].info[0].@username?xml.reply[0].info[0].@username:'';
					}
					sendEvent(APIEvents.STARTGAME,{authed:p1,username:p2,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'startGame'.");
					sendEvent(APIEvents.BADDATA,{metod:'startGame'});
				}
			});
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
            variables.query = query;
			variables.k = Math.random();
            request.data = variables;
			try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
				sendEvent(APIEvents.LOADERROR,{metod:'startGame'});
            }
		}
		
		public function getAuthUrl():void
		{
			var xml:String;
			var query_de:String;
			var query_en:String;
			var reply_de:String;
			var reply_en:String;
			
			xml='<?xml version="1.0" encoding="UTF-8"?>';
			xml+='	 <root>';
			xml+='		<query name="getauthurl">';
			xml+='			<game gameid="'+gameid+'"></game>';
			xml+='		</query>';
			xml+='	</root>';
			query_de=xml;
			
			var query:*=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void{ 
			  trace("Security Error in metod 'getAuthUrl': " + event);
			  sendEvent(APIEvents.SECURITY_ERROR,{metod:'getAuthUrl',text:event.text,type:event.type});
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void{ 
			  trace("IO Error in metod 'getAuthUrl': " + event);
			  sendEvent(APIEvents.IO_ERROR,{metod:'getAuthUrl',text:event.text,type:event.type});
			});
			loader.addEventListener(Event.COMPLETE, function(event:Event):void{ 
				var d:URLVariables = new URLVariables(loader.data);
				if(d.resp)
				{
					reply_en=d.resp;
					var xml:XML=new XML(RC4.decrypt(d.resp,theKey));
					reply_de=xml.toString();

					var p1:String='';
					if(xml!='')
					{
						p1=xml.reply[0].info[0].@authurl?xml.reply[0].info[0].@authurl:'';
					}
					sendEvent(APIEvents.AUTHURL,{authurl:p1,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'getAuthUrl'.");
					sendEvent(APIEvents.BADDATA,{metod:'getAuthUrl'});
				}
			});
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
            variables.query = query;
			variables.k = Math.random();
            request.data = variables;
			try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
				sendEvent(APIEvents.LOADERROR,{metod:'getAuthUrl'});
            }
		}
		
		

		
		


		public function getUserName():void
		{
			var xml:String;
			var query_de:String;
			var query_en:String;
			var reply_de:String;
			var reply_en:String;
			
			xml='<?xml version="1.0" encoding="UTF-8"?>';
			xml+='	 <root>';
			xml+='		<query name="getusername">';
			xml+='			<game gameid="'+gameid+'"></game>';
			xml+='		</query>';
			xml+='	</root>';
			query_de=xml;
			
			var query:*=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void{ 
			  trace("Security Error in metod 'getUserName': " + event);
			  sendEvent(APIEvents.SECURITY_ERROR,{metod:'getUserName',text:event.text,type:event.type});
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void{ 
			  trace("IO Error in metod 'getUserName': " + event);
			  sendEvent(APIEvents.IO_ERROR,{metod:'getUserName',text:event.text,type:event.type});
			});
			loader.addEventListener(Event.COMPLETE, function(event:Event):void{ 
				var d:URLVariables = new URLVariables(loader.data);
				if(d.resp)
				{
					reply_en=d.resp;
					var xml:XML=new XML(RC4.decrypt(d.resp,theKey));
					reply_de=xml.toString();
					
					var p1:String='';
					if(xml!='')
					{
						p1=xml.reply[0].info[0].@username?xml.reply[0].info[0].@username:'';
					}
					sendEvent(APIEvents.USERNAME,{username:p1,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'getUserName'.");
					sendEvent(APIEvents.BADDATA,{metod:'getUserName'});
				}
			});
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
            variables.query = query;
			variables.k = Math.random();
            request.data = variables;
			try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
				sendEvent(APIEvents.LOADERROR,{metod:'getUserName'});
            }
		}
		
		public function getScore(level:*):void
		{
			var xml:String;
			var query_de:String;
			var query_en:String;
			var reply_de:String;
			var reply_en:String;
			
			xml='<?xml version="1.0" encoding="UTF-8"?>';
			xml+='	 <root>';
			xml+='		<query name="getScore">';
			xml+='			<game gameid="'+gameid+'" level="'+level+'"></game>';
			xml+='		</query>';
			xml+='	</root>';
			query_de=xml;
			
			var query:*=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void{ 
			  trace("Security Erro in metod 'getScore'r: " + event);
			  sendEvent(APIEvents.SECURITY_ERROR,{metod:'getScore',text:event.text,type:event.type});
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void{ 
			  trace("IO Error in metod 'getScore': " + event);
			  sendEvent(APIEvents.IO_ERROR,{metod:'getScore',text:event.text,type:event.type});
			});
			loader.addEventListener(Event.COMPLETE, function(event:Event):void{ 
				var d:URLVariables = new URLVariables(loader.data);
				if(d.resp)
				{
					reply_en=d.resp;
					var xml:XML=new XML(RC4.decrypt(d.resp,theKey));
					reply_de=xml.toString();
					
					var p1:Number=0;
					var p2:Number=0;
					var p3:Number=0;
					if(xml!='')
					{
						p1=xml.reply[0].game[0].@gameid?xml.reply[0].game[0].@gameid:0;
						p2=xml.reply[0].game[0].@level?xml.reply[0].game[0].@level:0;
						p3=xml.reply[0].game[0].@score?xml.reply[0].game[0].@score:0;
					}
					sendEvent(APIEvents.GETSCORE,{gameid:p1,level:p2,score:p3,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'getScore'.");
					sendEvent(APIEvents.BADDATA,{metod:'getScore'});
				}
			});
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
            variables.query = query;
			variables.k = Math.random();
            request.data = variables;
			try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
				sendEvent(APIEvents.LOADERROR,{metod:'getScore'});
            }
		}
				
		public function giveScore(level:*,score:*):void
		{
			var xml:String;
			var query_de:String;
			var query_en:String;
			var reply_de:String;
			var reply_en:String;
			
			xml='<?xml version="1.0" encoding="UTF-8"?>';
			xml+='	 <root>';
			xml+='		<query name="givescore">';
			xml+='			<game gameid="'+gameid+'" level="'+level+'" score="'+score+'"></game>';
			xml+='		</query>';
			xml+='	</root>';
			query_de=xml;
			
			var query:*=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void{ 
			  trace("Security Error in metod 'giveScore': " + event);
			  sendEvent(APIEvents.SECURITY_ERROR,{metod:'giveScore',text:event.text,type:event.type});
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void{ 
			  trace("IO Error in metod 'giveScore': " + event);
			  sendEvent(APIEvents.IO_ERROR,{metod:'giveScore',text:event.text,type:event.type});
			});
			loader.addEventListener(Event.COMPLETE, function(event:Event):void{ 
				var d:URLVariables = new URLVariables(loader.data);
				if(d.resp)
				{
					reply_en=d.resp;
					var xml:XML=new XML(RC4.decrypt(d.resp,theKey));
					reply_de=xml.toString();
					
					var p1:Number=0;
					var p2:Number=0;
					var p3:Number=0;
					var p4:String='';
					if(xml!='')
					{
						p1=xml.reply[0].game[0].@gameid?xml.reply[0].game[0].@gameid:0;
						p2=xml.reply[0].game[0].@level?xml.reply[0].game[0].@level:0;
						p3=xml.reply[0].info[0].@authed?xml.reply[0].info[0].@authed:0;
						p4=xml.reply[0].info[0].@username?xml.reply[0].info[0].@username:'';
					}
					sendEvent(APIEvents.GIVESCORE,{gameid:p1,level:p2,authed:p3,username:p4,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'giveScore'.");
					sendEvent(APIEvents.BADDATA,{metod:'giveScore'});
				}
			});
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
            variables.query = query;
			variables.k = Math.random();
            request.data = variables;
			try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
				sendEvent(APIEvents.LOADERROR,{metod:'giveScore'});
            }
		}
		private function sendEvent(typ:String,dat:Object):void
		{
			dispatchEvent(new APIEvents(typ,dat));
		}
		
	}
}