package com.api.as3.security { 
	/**
	* Encrypts and decrypts an alleged RC4 hash.
	* @authors Sven Dens - http://www.svendens.be
	* @version 0.1
	*
	* Orginal Flash port by:
	* Gabor Penoff - http://www.fns.hu
	* Email: fns@fns.hu
	*/
	
	public class RC4 {
		/**
		* Variables
		* @exclude
		*/
		protected static var sbox:Array = new Array(255);
		protected static var mykey:Array = new Array(255);
		
		/**
		* Encrypts a string with the specified key.
		*/
		public static function encrypt(src:String, key:String):String {
			var mtxt:Array = strToChars(src);
			var mkey:Array = strToChars(key);
			var result:Array = calculate(mtxt, mkey);
			return charsToHex(result);
		}
		
		/**
		* Decrypts a string with the specified key.
		*/
		public static function decrypt(src:String, key:String):String {
			var mtxt:Array = hexToChars(src);
			var mkey:Array = strToChars(key);
			var result:Array = calculate(mtxt, mkey);
			return charsToStr(result);
		}
		
		/**
		* Private methods.
		*/
		protected static function initialize(pwd:Array):void {
			var b:Number = 0;
			var tempSwap:Number;
			var intLength:Number = pwd.length;
			for (var a:Number = 0; a <= 255; a++) {
				mykey[a] = pwd[(a%intLength)];
				sbox[a] = a;
			}
			for (var a2:Number=0; a2<=255; a2++) {
				b = (b+sbox[a2]+mykey[a2]) % 256;
				tempSwap = sbox[a2];
				sbox[a2] = sbox[b];
				sbox[b] = tempSwap;
			}
		}
		protected static function calculate(plaintxt:Array, psw:Array):Array {
			initialize(psw);
			var i:Number = 0; var j:Number = 0;
			var cipher:Array = new Array();
			var k:Number, temp:Number, cipherby:Number;
			for (var a:Number = 0; a<plaintxt.length; a++) {
				i = (i+1) % 256;
				j = (j+sbox[i])%256;
				temp = sbox[i];
				sbox[i] = sbox[j];
				sbox[j] = temp;
				var idx:Number = (sbox[i]+sbox[j]) % 256;
				k = sbox[idx];
				cipherby = plaintxt[a]^k;
				cipher.push(cipherby);
			}
			return cipher;
		}
		protected static function charsToHex(chars:Array):String {
			var result:String = new String("");
			var hexes:Array = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
			for (var i:Number = 0; i<chars.length; i++) {
				result += hexes[chars[i] >> 4] + hexes[chars[i] & 0xf];
			}
			return result;
		}
		protected static function hexToChars(hex:String):Array {
			var codes:Array = new Array();
			for (var i:Number = (hex.substr(0, 2) == "0x") ? 2 : 0; i<hex.length; i+=2) {
				codes.push(parseInt(hex.substr(i, 2), 16));
			}
			return codes;
		}
		protected static function charsToStr(chars:Array):String {
			var result:String = new String("");
			for (var i:Number = 0; i<chars.length; i++) {
				result += String.fromCharCode(chars[i]);
			}
			return result;
		}
		protected static function strToChars(str:String):Array {
			var codes:Array = new Array();
			for (var i:Number = 0; i<str.length; i++) {
				codes.push(str.charCodeAt(i));
			}
			return codes;
		}
	}
}