package testdrive
{
	import ru.antkarlov.anthill.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * Description
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Anton Karlov
	 * @since  26.08.2012
	 */
	public class TestUI extends AntState
	{
		private var _camera:AntCamera;
		private var _labelForScale:AntLabel;
		private var _scaleSpeed:Number = 1;
		private var _outputLabel:AntLabel;
		
		protected var _started:Boolean = false;
		private var _test:int = 100;
		
		public function TestUI()
		{
			super();
			
			_camera = new AntCamera(640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFFFFFFF;
			AntG.addCamera(_camera);
			addChild(_camera);
			AntG.track(_camera, "TestUI camera");
			
			AntG.debugger.console.hide();
			AntG.debugger.monitor.hide();
			AntG.debugger.perfomance.hide();
			
			AntG.debugger.monitor.clear();
			
			// Добавляем классы клипов которые необходимо растеризировать.
			AntG.cache.addClips([ ButtonBasic_mc, ButtonGray_mc, ButtonBlue_mc, ButtonVector_mc ]);
			
			// Добавляем обработчик для завершения процесса растеризации.
			AntG.cache.eventComplete.add(onCacheComplete);
			
			// Запускаем процесс растеризации клипов.
			AntG.cache.cacheClips();
			
			AntG.debugger.hide();
		}
		
		/**
		 * Обработчик события завершения растеризации.
		 */
		private function onCacheComplete():void
		{
			AntG.cache.eventComplete.clear();
			
			// Создание графического курсора
			AntG.mouse.makeCursor("CursorBasicAnim_mc");
			AntG.mouse.makeCursor("CursorStop_mc");
			AntG.mouse.makeCursor("CursorBusy_mc");
			AntG.mouse.cursor.play();
			AntG.useSystemCursor = false;
			
			// Первая кнопка
			var btn:AntButton = AntButton.makeButton("ButtonBasic_mc", "rotate me!", new AntLabel("system", 8, 0x000000));
			btn.x = 100;
			btn.y = 200;
			btn.label.applyFilters([ new DropShadowFilter(1, 90, 0xFFFFFF, 1, 1, 1, 5) ]);
			btn.eventClick.add(onClickMe);
			btn.overCursorAnim = "CursorBusy_mc";
			btn.downCursorAnim = "CursorStop_mc";
			add(btn);
			
			// Вторая кнопка
			btn = new AntButton();
			btn.addAnimationFromCache("ButtonBlue_mc");
			btn.x = 250;
			btn.y = 200;
			btn.smoothing = false;
			btn.eventClick.add(onClickScale);
			btn.overCursorAnim = "CursorBusy_mc";
			add(btn);
			
			// Третья кнопка
			btn = AntButton.makeButton("ButtonGray_mc", "Not selected", new AntLabel("Verdana", 10, 0x000000, false));
			btn.x = 400;
			btn.y = 200;
			btn.toggle = true;
			btn.eventUp.add(onUp);
			btn.eventDown.add(onDown);
			btn.eventOver.add(onOver);
			btn.eventOut.add(onOut);
			btn.eventClick.add(onClick);
			add(btn);
			
			// Четвертая кнопка
			btn = new AntButton();
			btn.addAnimationFromCache("ButtonVector_mc");
			btn.x = 500;
			btn.y = 200;
			add(btn);
			
			var label:AntLabel = new AntLabel("system", 8, 0x000000);
			label.text = "Текст тоже может вращатся.";
			label.x = 100;
			label.y = 250;
			label.axis.set(label.width * 0.5, label.height * 0.5);
			label.angularAcceleration = 5;
			label.moves = true;
			add(label);
			
			label = new AntLabel("system", 8, 0x000000);
			label.text = "и изменять размер";
			label.x = 250;
			label.y = 250;
			label.axis.set(label.width * 0.5, label.height * 0.5);
			_labelForScale = label;
			add(label);
			
			label = new AntLabel("system", 16, 0xFF0000);
			label.text = "?";
			label.x = 350;
			label.y = 230;
			_outputLabel = label;
			add(label);
			
			label = new AntLabel("Arial", 12, 0x000000, false);
			label.beginChange();
			label.autoSize = false;
			
			label.text = "Текст может содержать большие и не очень абзацы.\n\nА так же иметь переносы строк и вообще можно делать с текстом все то что можно делать с TextField.\n\nЕще можно просто и быстро подсвечивать слова и словосочетания.";
			label.align = AntLabel.CENTER;
			label.highlightText("TextField", 0xFF0000);
			label.highlightText("слова", 0x00FF00);
			label.highlightText("словосочетания", 0x0000FF);
			label.highlightText("можно", 0xFF00FF);
			label.wordWrap = true;
			label.setSize(300, 200);
			
			label.endChange();
			label.x = 300;
			label.y = 300;
			add(label);
			
			var labelInfo:AntLabel = new AntLabel("system");
			labelInfo.x = 15;
			labelInfo.y = 15;
			labelInfo.beginChange();
			labelInfo.text = "Демо работы AntLabel и AntButton.\nПредыдущее/следущее демо: влево/вправо.";
			labelInfo.highlightText("AntButton", 0xFF0000);
			labelInfo.highlightText("AntLabel", 0xFF0000);
			labelInfo.highlightText("вправо", 0x00FF00);
			labelInfo.highlightText("влево", 0x00FF00);
			labelInfo.setStroke();
			labelInfo.endChange();
			labelInfo.tag = 999;
			add(labelInfo);
			
			_started = true;
		}
		
		private function onClickMe(aButton:AntButton):void
		{
			aButton.angularAcceleration = 5;
			aButton.moves = !aButton.moves;
			trace("TestUI::onClickMe()");
		}
		
		private function onClickScale(aButton:AntButton):void
		{
			(aButton.scale.x > 1) ? aButton.scale.set(1, 1) : aButton.scale.set(2, 2);
		}
		
		/**
		 * @private
		 */
		private function onDown(aButton:AntButton):void
		{
			_outputLabel.text = "onDown";
		}
		
		/**
		 * @private
		 */
		private function onUp(aButton:AntButton):void
		{
			_outputLabel.text = "onUp";
		}
		
		/**
		 * @private
		 */
		private function onOver(aButton:AntButton):void
		{
			_outputLabel.text = "onOver";
		}
		
		private function onOut(aButton:AntButton):void
		{
			_outputLabel.text = "onOut";
		}
		
		private function onClick(aButton:AntButton):void
		{
			aButton.text = (aButton.selected) ? "Selected" : "Not selected";
		}
		
		/**
		 * @private
		 */
		override public function update():void
		{
			if (_started)
			{
				_labelForScale.scale.x += _scaleSpeed * AntG.elapsed;
				_labelForScale.scale.y = _labelForScale.scale.x;
				if (_labelForScale.scale.x > 1.5)
				{
					_labelForScale.scale.x = 1.5;
					_scaleSpeed *= -1;
				}
				else if (_labelForScale.scale.x < 0.5)
				{
					_labelForScale.scale.x = 0.5;
					_scaleSpeed *= -1;
				}
			}
			
			super.update();
		}
		
		/**
		 * @private
		 */
		override public function postUpdate():void
		{
			if (_started && AntG.keys.isPressed("LEFT"))
			{
				AntG.switchState(new TestTaskManager());
			}
			
			if (_started && AntG.keys.isPressed("RIGHT"))
			{
				AntG.switchState(new TestSound());
			}
		}
		
		/**
		 * @private
		 */
		override public function destroy():void
		{
			AntG.cache.eventComplete.remove(onCacheComplete);
			
			_camera.destroy();
			_camera = null;
			
			super.destroy();
		}

	}

}