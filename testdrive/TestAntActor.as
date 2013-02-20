package testdrive
{
	
	import ru.antkarlov.anthill.*;
	import ru.antkarlov.anthill.debug.AntDrawer;
	import flash.filters.GlowFilter;
	import ru.antkarlov.anthill.debug.AntGlyphButton;
	
	/**
	 * Демострация производительности и работы с анимациями.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  25.08.2012
	 */
	public class TestAntActor extends AntState
	{
		protected var _camera:AntCamera;
		
		protected var _started:Boolean = false;
		protected var _randomScale:Boolean = false;
		protected var _randomColor:Boolean = false;
		
		public function TestAntActor()
		{
			super();
			
			_camera = new AntCamera(640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xff000000;
			AntG.addCamera(_camera);
			addChild(_camera);
			AntG.track(_camera, "TestAntActor camera");
			
			/*_camera = new AntCamera(320, 480);
			_camera.x = 320;
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xff000000;
			AntG.addCamera(_camera);
			addChild(_camera);*/
			
			// Очищаем монитор.
			AntG.debugger.monitor.clear();
			
			// Добавляем классы клипов которые необходимо растеризировать.
			AntG.cache.addClips([ Explosion_mc, ButtonBasic_mc, CursorBasic_mc, CursorBasicAnim_mc, CursorStop_mc, CursorBusy_mc ]);
			
			// Добавляем обработчик для завершения процесса растеризации.
			AntG.cache.eventComplete.add(onCacheComplete);
			
			// Запускаем процесс растеризации клипов.
			AntG.cache.cacheClips();
			
			// Показываем отладчик.
			AntG.debugger.show();
			
			// Но скрываем из отладчика консоль за ненадобностью.
			AntG.debugger.console.hide();
			AntG.debugger.monitor.show();
			AntG.debugger.perfomance.show();
		}
		
		/**
		 * @private
		 */
		private function onCacheComplete():void
		{
			// Кнопка вкл./выкл. случайного размера спрайтов.
			var btnScale:AntButton = AntButton.makeButton("ButtonBasic_mc", "scale: off", new AntLabel("system", 8, 0x000000));
			
			// Устаналиваем кнопку где-то внизу в центре экрана
			btnScale.x = AntG.widthHalf - btnScale.width * 0.5 - 5;
			btnScale.y = AntG.height - 30;
			
			// Добавляем обработчик клика (указатель на метод)
			btnScale.eventDown.add(onScaleClick);
			
			// Кнопка вкл./выкл. случайного цвета спрайтов.
			var btnColor:AntButton = AntButton.makeButton("ButtonBasic_mc", "color: off", new AntLabel("system", 8, 0x000000));
			
			// Устаналиваем кнопку где-то внизу в центре экрана
			btnColor.x = AntG.widthHalf + btnColor.width * 0.5 + 5;
			btnColor.y = AntG.height - 30;
			
			// Добавляем обработчик клика
			btnColor.eventDown.add(onColorClick);
			
			// В поле tag для кнопок записываем любое большое число чтобы кнопка не затерялась за взырвами,
			// это будет что-то вроде Z индекса :)
			btnScale.tag = btnColor.tag = 999;
			
			// Добавляем кнопки в структуру
			add(btnScale);
			add(btnColor);
			
			// Устанавливаем флаг что все готово к работе и можно создавать взрывы!
			_started = true;
			
			var labelInfo:AntLabel = new AntLabel("system");
			labelInfo.x = 15;
			labelInfo.y = 15;
			labelInfo.beginChange();
			labelInfo.text = "Демо работы AntActor.\nПредыдущее/следущее демо: влево/вправо.";
			labelInfo.highlightText("AntActor", 0xFF0000);
			labelInfo.highlightText("вправо", 0x00FF00);
			labelInfo.highlightText("влево", 0x00FF00);
			labelInfo.applyFilters([ new GlowFilter(0xFF000000, 1, 2, 2, 5) ]);
			labelInfo.endChange();
			labelInfo.tag = 999;
			add(labelInfo);
			
			AntG.track(btnScale, "scale button");
			AntG.track(btnColor, "scale color");
			AntG.track(labelInfo, "label info");
		}
		
		/**
		 * Обработчик клика по кнопке scale.
		 */
		private function onScaleClick(aButton:AntButton):void
		{
			// Включаем/выключаем режим случайного размера и меняем текстовую метку кнопки.
			_randomScale = !_randomScale;
			aButton.text = (_randomScale) ? "scale: on" : "scale: off";
		}
		
		/**
		 * Обработчик клика по кнопку color.
		 */
		private function onColorClick(aButton:AntButton):void
		{
			// Включаем/выключаем режим случайного цвета и меняем текстовую метку кнопки.
			_randomColor = !_randomColor;
			aButton.text = (_randomColor) ? "color: on" : "color: off";
		}
		
		/**
		 * Создание взрыва.
		 */
		private function onMakeExplosion():void
		{
			// Используем метод recycle чтобы переработать старый не используемый больше объект,
			// либо если отходов нет, будет создан новый экземпляр объека с указанным классом.
			var explosion:AntActor = defGroup.recycle(AntActor) as AntActor;
			
			// Если объект был переработан (то есть когда-то ранее существовал)
			if (!explosion.exists)
			{
				// Воскрешаем его.
				explosion.revive();
				
				// И задаем новое случайное местоположение.
				explosion.reset(AntMath.randomRangeInt(0, AntG.width), AntMath.randomRangeInt(0, AntG.height));
			}
			else
			{
				// Иначе объект новый.
				// Задем случайное местоположение.
				explosion.reset(AntMath.randomRangeInt(0, 640), AntMath.randomRangeInt(0, 480));
				
				// Задаем скорость анимации.
				explosion.animationSpeed = 0.5;
				
				/* Подсказка: если задать более медленную скорость анимации, то будет создаваться больше 
				актеров и получится настоящий стресс-тест ;) */
				
				// Добавляем новую анимацию.
				explosion.addAnimationFromCache("Explosion_mc");
				
				// Вешаем обработчик события на завершение анимации чтобы убить актера.
				explosion.eventComplete.add(onKill);
				
				// Запускаем воспроизведение анимации.
				explosion.play();
				
				/* Примечание: если используется метод recycle() для создания новых экземпляров,
				то нет необходимости вручную добалять новые объекты в структуру, так как метод recycle(),
				добавляет новый объект автоматически в ту группу для которой он был вызван. */
				
				// Сортируем все объекты по полю "tag" - это нужно чтобы кнопки были всегда поверх взрывов.
				explosion.tag = defGroup.numChildren;
				defGroup.sort("tag");
			}
			
			// Если включен режим случайного размера, то даем случайный размер либо 1 к 1.
			explosion.scale.x = explosion.scale.y = (_randomScale) ? AntMath.randomRangeNumber(0.5, 1.5) : 1;
			
			/* Примечание: при задании актеру каких-либо трансформаций типа вращения, скэйла или blend, то
			для визаулизации такого актера используется метод draw(), что снижает производительность. */
			
			// Если включен режим случайного цвета, то даем случайный цвет, либо заливаем прозрачным белым.
			explosion.color = (_randomColor) ? AntMath.combineRGB(AntMath.randomRangeInt(0, 255), AntMath.randomRangeInt(0, 255), AntMath.randomRangeInt(0, 255)) : 0x00FFFFFF;
			
			/* Примечание: при задании актеру цветовой трансформации и/или прозрачности, то для рендера такого актера  
			используется дополнительный буфер чтобы не испортить оригинальную анимацию. Таким образом на каждого 
			актера с цветовой трансформацией выделяется дополнительная оперативная память. Если сбросить 
			прозрачность на 1.0 и цвет на 0x00FFFFFF, то дополнительный буфер будет освобожден. Эту разницу хорошо видно
			в профайлере производительности на этом юнит-тесте если включать и выключать случайный цвет. */
		}
		
		/**
		 * Обработчик события завершения проигрывания анимации для актера.
		 */
		private function onKill(aActor:AntActor):void
		{
			// Убиваем актера.
			aActor.kill();
		}
		
		/**
		 * Этот метод вызывается каждый кадр перед тем как все будет отрисовано.
		 * Здесь следует выполнять процессинг игры.
		 */
		override public function update():void
		{
			if (_started)
			{
				// Если есть добро, то каждый фрейм создаем взрывы!
				onMakeExplosion();
			}
			
			super.update();
		}
		
		/**
		 * Этот метод вызывается каждый кадр сразу после метода update().
		 */
		override public function postUpdate():void
		{
			// Выводим интересующую нас информацию в дебаг мониторчик.
			AntG.beginWatch();
			AntG.watchValue("active", AntG.numOfActive);
			AntG.watchValue("visible", AntG.numOfActive);
			AntG.watchValue("onScreen", AntG.numOnScreen);
			AntG.endWatch();
			
			if (_started && AntG.keys.isPressed("LEFT"))
			{
				AntG.switchState(new TestTileMap());
			}
			
			if (_started && AntG.keys.isPressed("RIGHT"))
			{
				AntG.switchState(new TestTaskManager());
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