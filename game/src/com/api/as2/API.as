import flash.display.MovieClip;
import com.api.as2.security.RC4;
import flash.events.*;
import flash.net.*;
import com.api.as2.evnt.*;
import mx.events.EventDispatcher;
	

class com.api.as2.API {
		
		private var theKey:String;
		private var url:String='/index.php';
		private var gameid:String;
		private var idkey:String='JKLdfr34,56D5,673rdSsDS';
		var addEventListener:Function;
        var removeEventListener:Function;
        var dispatchEvent:Function
		
		public function API(gameid:String,key:String,url:String)
		{
				if (key != undefined) this.theKey=key;
				if (url != undefined) this.url=url;
				if (gameid != undefined) this.gameid=gameid;
				EventDispatcher.initialize(this);
		}
		
		public function startGame()
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
			
			var query=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:LoadVars = new LoadVars();
			loader.onLoad = mx.utils.Delegate.create(this, loadComplete);
			
			function loadComplete(success:Boolean):Void
			{
				query_de;
				query_en;
				
				if(loader.resp)
				{
					reply_en=loader.resp;
					var xml:XML=new XML(RC4.decrypt(loader.resp,theKey));
					reply_de=xml.toString();
					var p1:Number=0;
					var p2:String='';
					if(xml!='')
					{
						p1=xml.firstChild.firstChild.firstChild.attributes['authed']?xml.firstChild.firstChild.firstChild.attributes['authed']:0;
						p2=xml.firstChild.firstChild.firstChild.nextSibling.attributes['username']?xml.firstChild.firstChild.firstChild.nextSibling.attributes['username']:'';
						dispatchEvent({type:APIEvents.STARTGAME,authed:p1,username:p2,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
					}
				}
				else
				{
					trace("Bad xml data loaded in metod 'startGame'.");
					dispatchEvent({type:APIEvents.BADDATA,metod:'startGame'});
				}
			}
			var variables:LoadVars = new LoadVars();
			variables.query = query;
			variables.k = Math.random();
			variables.sendAndLoad(url, loader, "GET");
		}
		
		public function getAuthUrl()
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

			var query=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:LoadVars = new LoadVars();
			loader.onLoad = mx.utils.Delegate.create(this, loadComplete);
			function loadComplete(success:Boolean):Void
			{
				query_de;
				query_en;
				
				if(loader.resp)
				{
					reply_en=loader.resp;
					var xml:XML=new XML(RC4.decrypt(loader.resp,theKey));
					reply_de=xml.toString();

					var p1:String='';
					if(xml!='')
					{
						p1=xml.firstChild.firstChild.firstChild.attributes['authurl']?xml.firstChild.firstChild.firstChild.attributes['authurl']:'';
					}
					dispatchEvent({type:APIEvents.AUTHURL,authurl:p1,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'getAuthUrl'.");
					dispatchEvent({type:APIEvents.BADDATA,metod:'getAuthUrl'});
				}
			}
			var variables:LoadVars = new LoadVars();
			variables.query = query;
			variables.k = Math.random();
			variables.sendAndLoad(url, loader, "GET");
		}
		
		public function getUserName()
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

			var query=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:LoadVars = new LoadVars();
			loader.onLoad = mx.utils.Delegate.create(this, loadComplete);
			function loadComplete(success:Boolean):Void
			{
				query_de;
				query_en;
				
				if(loader.resp)
				{
					reply_en=loader.resp;
					var xml:XML=new XML(RC4.decrypt(loader.resp,theKey));
					reply_de=xml.toString();
					var p1:String='';
					if(xml!='')
					{
						p1=xml.firstChild.firstChild.firstChild.attributes['username']?xml.firstChild.firstChild.firstChild.attributes['username']:'';
					}
					dispatchEvent({type:APIEvents.USERNAME,username:p1,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'getUserName'.");
					dispatchEvent({type:APIEvents.BADDATA,metod:'getUserName'});
				}
			}
			var variables:LoadVars = new LoadVars();
			variables.query = query;
			variables.k = Math.random();
			variables.sendAndLoad(url, loader, "GET");

		}
		
		public function getScore(level)
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
			
			var query=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:LoadVars = new LoadVars();
			loader.onLoad = mx.utils.Delegate.create(this, loadComplete);
			function loadComplete(success:Boolean):Void
			{
				query_de;
				query_en;
				
				if(loader.resp)
				{
					reply_en=loader.resp;
					var xml:XML=new XML(RC4.decrypt(loader.resp,theKey));
					reply_de=xml.toString();
					
					var p1:Number=0;
					var p2:Number=0;
					var p3:Number=0;
					if(xml!='')
					{
						p1=xml.firstChild.firstChild.firstChild.attributes['gameid']?xml.firstChild.firstChild.firstChild.attributes['gameid']:0;
						p2=xml.firstChild.firstChild.firstChild.attributes['level']?xml.firstChild.firstChild.firstChild.attributes['level']:0;
						p3=xml.firstChild.firstChild.firstChild.attributes['score']?xml.firstChild.firstChild.firstChild.attributes['score']:0;
					}
					dispatchEvent({type:APIEvents.GETSCORE,gameid:p1,level:p2,score:p3,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'getScore'.");
					dispatchEvent({type:APIEvents.BADDATA,metod:'getScore'});
				}
			}
			var variables:LoadVars = new LoadVars();
			variables.query = query;
			variables.k = Math.random();
			variables.sendAndLoad(url, loader, "GET");
		}
				
		public function giveScore(level,score)
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
			
			var query=RC4.encrypt(xml,theKey);
			query+=RC4.encrypt(gameid,idkey);
			query_en=query;
			
			var loader:LoadVars = new LoadVars();
			loader.onLoad = mx.utils.Delegate.create(this, loadComplete);
			function loadComplete(success:Boolean):Void
			{
				query_de;
				query_en;
				
				if(loader.resp)
				{
					reply_en=loader.resp;
					var xml:XML=new XML(RC4.decrypt(loader.resp,theKey));
					reply_de=xml.toString();
					
					var p1:Number=0;
					var p2:Number=0;
					var p3:Number=0;
					var p4:String='';
					if(xml!='')
					{
						p1=xml.firstChild.firstChild.firstChild.attributes['gameid']?xml.firstChild.firstChild.firstChild.attributes['gameid']:0;
						p2=xml.firstChild.firstChild.firstChild.attributes['level']?xml.firstChild.firstChild.firstChild.attributes['level']:0;
						p3=xml.firstChild.firstChild.firstChild.nextSibling.attributes['authed']?xml.firstChild.firstChild.firstChild.nextSibling.attributes['authed']:0;
						p4=xml.firstChild.firstChild.firstChild.nextSibling.attributes['username']?xml.firstChild.firstChild.firstChild.nextSibling.attributes['username']:'';
					}
					dispatchEvent({type:APIEvents.GIVESCORE,gameid:p1,level:p2,authed:p3,username:p4,query_de:query_de,query_en:query_en,reply_de:reply_de,reply_en:reply_en});
				}
				else
				{
					trace("Bad xml data loaded in metod 'giveScore'.");
					dispatchEvent({type:APIEvents.BADDATA,metod:'giveScore'});
				}
			}
			var variables:LoadVars = new LoadVars();
			variables.query = query;
			variables.k = Math.random();
			variables.sendAndLoad(url, loader, "GET");
		}
	
	}
