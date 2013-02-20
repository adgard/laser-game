package ru.antkarlov.anthill.plugins
{
	import Box2D.Dynamics.b2World;
	import ru.antkarlov.anthill.*;
	
	/**
	
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author adgard
	 * @since  25.01.2013
	 */
	public class box2DPlugin implements IPlugin
	{
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		
		public var eventComplete:AntEvent;
		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		
		
		
		/**
		 * Используется для рассчета текущей паузы между задачами.
		 * @default    0
		 */
		protected var m_World:b2World;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function box2dPlugin(aCycle:Boolean = false)
		{
			super();
			
			m_World = null;
			
			eventComplete = new AntEvent();
		}
		
		/**
		 * Освобождает ресурсы занимаемые мендежером задач.
		 * Следует вызывать перед удалением.
		 */
		public function destroy():void
		{
			clear();
			eventComplete.clear();
			eventComplete = null;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		
		
		
		
	
		
		/**
		 * Удаляет все задачи из менеджера и останавливает его работу.
		 */
		public function clear():void
		{
			
		}
		
		
				
		//---------------------------------------
		// IPlugin Implementation
		//---------------------------------------

		//import ru.antkarlov.anthill.plugins.IPlugin;
		public function preUpdate():void
		{
			//
		}

		public function update():void
		{
			
		}

		public function postUpdate():void
		{
			//
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Запускает работу менеджера задача.
		 */
		protected function start():void
		{
			if (!_isStarted)
			{
				AntG.addPlugin(this);
				_isStarted = true;
				_isPaused = false;
			}
		}
		
		/**
		 * Останавливает работу менеджера задач.
		 */
		protected function stop():void
		{
			if (_isStarted)
			{
				AntG.removePlugin(this);
				_isStarted = false;
			}
		}
		
		
	
	
		
	}

}