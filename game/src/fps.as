package{
	import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;
 
    public class fps extends Sprite{
        private var last:uint = getTimer();
        private var ticks:uint = 0;
        private var tf:TextField;
 
        public function fps(xPos:int, yPos:int, mm:mainMenu=null, color:uint=0xffffff, fillBackground:Boolean=false, backgroundColor:uint=0x000000) {
            x = xPos;
            y = yPos + 20;
			tf = new TextField();
            tf.textColor = color;
            tf.text = "----- fps";
            tf.selectable = false;
            tf.background = fillBackground;
            tf.backgroundColor = backgroundColor;
            tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = x;
			tf.y = y;
            
            mm.parent.addChild(tf);
            width = tf.textWidth;
            height = tf.textHeight;
            addEventListener(Event.ENTER_FRAME, tick);
        }
 
        public function tick(evt:Event):void {
            ticks++;
            var now:uint = getTimer();
            var delta:uint = now - last;
            if (delta >= 1000) {
                //trace(ticks / delta * 1000+" ticks:"+ticks+" delta:"+delta);
                var fps:Number = ticks / delta * 1000;
                tf.text = fps.toFixed(1) + " fps";
                ticks = 0;
                last = now;
				trace(tf.text);
            }
        }
    }
}