//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2012 
// 
////////////////////////////////////////////////////////////////////////////////

package
{

	import flash.events.Event;
	import flash.display.Sprite;
	import ru.antkarlov.anthill.*;
	import testdrive.*;

	/**
	 * Application entry point for AnthillExamples.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author Антон Карлов
	 * @since 27.08.2012
	 */
	[SWF(width="640", height="480", backgroundColor="#FFFFFF")]
	[Frame(factoryClass="ExamplePreloader")]
	public class AnthillExamples extends Sprite
	{
	
		/**
		 * @constructor
		 */
		public function AnthillExamples()
		{
			super();
			(stage == null) ? addEventListener(Event.ADDED_TO_STAGE, initialize) : initialize(null);
		}

		/**
		 * Initialize stub.
		 */
		private function initialize(event:Event):void
		{
			if (event != null)
			{
				removeEventListener(Event.ADDED_TO_STAGE, initialize);
			}
			
			trace("AnthillExamples::initialize()");
		
			var engine:Anthill = new Anthill(TestAntActor, 60);
			addChild(engine);
			
			AntG.setScreenSize(640, 480);
		}
	
	}

}