package testdrive
{
	
	import ru.antkarlov.anthill.*;
	import flash.filters.GlowFilter;
	
	/**
	 * Демонстрация работы со звуком.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Антон Карлов
	 * @since  07.09.2012
	 */
	public class TestSound extends AntState
	{
		
		private var _camera:AntCamera;
		private var _listener:AntActor;
		private var _musicSample:AntActor;
		private var _isDragSource:Boolean = false;
		private var _isDragListener:Boolean = false;
		private var _offset:AntPoint = new AntPoint();
		private var _mousePos:AntPoint = new AntPoint();
		private var _targetPoint:AntPoint = new AntPoint();
		
		private var _started:Boolean = false;
		
		public function TestSound()
		{
			super();
			
			_camera = new AntCamera(640, 480);
			_camera.fillBackground = true;
			_camera.backgroundColor = 0xFFCCCCCC;
			AntG.addCamera(_camera);
			addChild(_camera);
			AntG.track(_camera, "TestSound camera");
			
			AntG.debugger.console.hide();
			AntG.debugger.monitor.show();
			AntG.debugger.perfomance.hide();
			
			// Очищаем монитор.
			AntG.debugger.monitor.clear();
			
			// Добавляем классы клипов которые необходимо растеризировать.
			AntG.cache.addClips([ ButtonGray_mc, SoundListener_mc, SoundSource_mc ]);
			
			// Добавляем обработчик для завершения процесса растеризации.
			AntG.cache.eventComplete.add(onCacheComplete);
			
			// Запускаем процесс растеризации клипов.
			AntG.cache.cacheClips();
			
			AntG.debugger.show();
		}
		
		/**
		 * Обработчик события завершения растеризации.
		 */
		private function onCacheComplete():void
		{
			/* Если при добавлении звуков из файлов все звуки находятся в одной папке или на сайте,
			то можно указать путь отдельно чтобы не указывать его каждый раз при добавлении файла. */
			AntG.sounds.baseURL = "sounds/";
			
			// Добавление звука в менеджер звуков из файла.
			//AntG.sounds.addStream("sample.mp3", "MusicSample_snd");
			
			/* Если базовый путь не указан и звуки лежат не в той же папке что и флешка, то еследует
			кроме имени файла указывать и путь: */
			// AntG.sounds.addStream("sounds/sample.m3", "MusicSample_snd");
			
			/* Добавление звука из ресурсов который может находится в *.fla или *.swc. */
			AntG.sounds.addEmbedded(Fire_snd, "fire");
			AntG.sounds.addEmbedded(MusicSample_snd);
			
			/* Создаем слушателя звуков для которого будет рассчитываться стерео эффект, слушателем може быть любая сущность.
			Примечание: Если звуковой менеджер не имеет ни одного слушателя, то слушателями по умолчанию являются центры камер. */
			_listener = new AntActor();
			_listener.addAnimationFromCache("SoundListener_mc");
			_listener.x = AntG.widthHalf;
			_listener.y = AntG.heightHalf;
			_listener.animationSpeed = 0.5;
			_listener.play();
			add(_listener);
			
			// Добавляем сущность как слушателя звуков в звуковой менджер.
			AntG.sounds.addListener(_listener);
			
			/* Создаем визуальный образ для источника звука. */
			_musicSample = new AntActor();
			_musicSample.addAnimationFromCache("SoundSource_mc");
			_musicSample.moves = true;
			_musicSample.x = AntMath.randomRangeInt(0, 640);
			_musicSample.y = AntMath.randomRangeInt(0, 480);
			_musicSample.play();
			_musicSample.animationSpeed = 0.5;
			add(_musicSample);
			
			// Воспроизводим звук.
			AntG.track(AntG.sounds.play("MusicSample_snd", _musicSample, true, 999));
			
			// Случайная точка куда должен перемещатся наш источник звука.
			_targetPoint.set(AntMath.randomRangeInt(0, 640), AntMath.randomRangeInt(0, 480));
			
			_started = true;
			
			var labelInfo:AntLabel = new AntLabel("system");
			labelInfo.x = 15;
			labelInfo.y = 15;
			labelInfo.beginChange();
			labelInfo.text = "Демо работы AntSoundManager и AntSound.\nПредыдущее/следущее демо: влево/вправо.\n\nВы можете перетаскивать обьекты, а так же просто где-нибудь покликать.\nОранжевый - слушатель, Зеленый - источник.";
			labelInfo.highlightText("Manager", 0xFF0000);
			labelInfo.highlightText("AntSound", 0xFF0000);
			labelInfo.highlightText("вправо", 0x00FF00);
			labelInfo.highlightText("влево", 0x00FF00);
			labelInfo.highlightText("Оранжевый", 0xFF9900);
			labelInfo.highlightText("Зеленый", 0x8FBA2C);
			labelInfo.setStroke();
			labelInfo.endChange();
			labelInfo.tag = 999;
			add(labelInfo);
		}
		
		/**
		 * Создает эффект и звук выстрела в указанной точке.
		 */
		private function makeShot(aX:int, aY:int):void
		{
			// Если звуки выключены.
			if (AntG.sounds.mute)
			{
				return;
			}
			
			// Переиспользуем уже существующий эффект.
			var actor:AntActor = defGroup.recycle(AntActor) as AntActor;
			if (!actor.exists)
			{
				// Если старый эффект, воскрешаем его.
				actor.revive();
			}
			else
			{
				// Иначе инициализируем новый эффект
				actor.addAnimationFromCache("SoundSource_mc");
				actor.animationSpeed = 0.5;
				actor.play();
			}
			
			// Воспроизводим звук выстрела и записываем указатель на звук в актера.
			/* Внимание: Если звук выключен, то метод play() вернет null. */
			actor.userData = AntG.sounds.play("fire", actor);
			
			// Добавляем обработчик события на завершение проигрывание звука чтобы удалить актера.
			(actor.userData as AntSound).eventComplete.add(onFireComplete);
			
			AntG.track(actor.userData);
			
			// Устанавливаем новое положение актеру.
			actor.reset(aX, aY, AntMath.angleDeg(aX, aY, _listener.x, _listener.y));
		}
		
		/**
		 * Обработчик завершения проигрывания звука убивающий актера.
		 */
		private function onFireComplete(aSound:AntSound):void
		{
			var actor:AntActor;
			
			// Перебераем всех актеров.
			for (var i:int = 0; i < defGroup.numChildren; i++)
			{
				actor = defGroup.children[i] as AntActor;
				
				// Находим актера который содержит указатель на звук который закончил проигрывание.
				if (actor != null && actor.exists && actor.userData == aSound)
				{
					// Очищаем соыбтия, обнуляем указатель на звук и убиваем актера.
					(actor.userData as AntSound).eventComplete.clear();
					actor.userData = null;
					actor.kill();
					return;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update():void
		{
			if (!_started)
			{
				return;
			}
			
			// Рассчет движения музыкального источника звука.
			//-----------------------------------------------------------------
			var ang:Number = AntMath.angleDeg(_musicSample.x, _musicSample.y, _targetPoint.x, _targetPoint.y);
			var offsetAng:Number = _musicSample.angle - ang;
			
			// Нормализируем угол.
			if (offsetAng > 180)
			{
				offsetAng = -360 + offsetAng;
			}
			else if (offsetAng < -180) 
			{
				offsetAng = 360 + offsetAng;
			}
			
			// Плавно поворачиваем источник к новой цели.
			if (Math.abs(offsetAng) < 5) 
			{
				_musicSample.angle -= offsetAng;
			}
			else if (offsetAng > 0)
			{
				_musicSample.angle -= 150 * AntG.elapsed;
			}
			else 
			{
				_musicSample.angle += 150 * AntG.elapsed;
			}
			
			// Устанавливаем векторную скорость движения.
			var angRad:Number = AntMath.toRadians(_musicSample.angle);
			_musicSample.velocity.set(250 * Math.cos(angRad), 250 * Math.sin(angRad));
			
			// Проверяем достиг ли источник звука своей цели...
			if (AntMath.distance(_musicSample.x, _musicSample.y, _targetPoint.x, _targetPoint.y) < 5)
			{
				// если достик, то ставим новую случайную цель.
				_targetPoint.set(AntMath.randomRangeInt(0, 640), AntMath.randomRangeInt(0, 480));
			}
			
			// Реализация перетаскивания музыкального источника и слушателя.
			//-----------------------------------------------------------------
			
			// Получаем координаты мыши в игровом мире.
			AntG.mouse.getWorldPosition(null, _mousePos);
			
			// Если кнопка мыши была нажата, то...
			if (AntG.mouse.isPressed())
			{
				// Проверяем попадает ли точка клика в музыкальный источник...
				if (_musicSample.isInsidePoint(_mousePos))
				{
					/* Если попали, отключаем движение, включаем флаг перетаскивания и 
					запоминаем смещение мышки относительно источника. */
					_musicSample.moves = false;
					_isDragSource = true;
					_offset.set(_musicSample.x - _mousePos.x, _musicSample.y - _mousePos.y);
				}
				// Проверяем попадает ли точка клика в слушателя...
				else if (_listener.isInsidePoint(_mousePos))
				{
					/* Если попали, включаем флаг перетаскивания и запоминаем смещение мышки
					относительно слушателя. */
					_isDragListener = true;
					_offset.set(_listener.x - _mousePos.x, _listener.y - _mousePos.y);
				}
				else
				{
					// Иначе просто создаем эффект выстрела в месте клика.
					makeShot(_mousePos.x, _mousePos.y);
				}
			}
			
			// Если активирован флаг перетаскивания источника.
			if (_isDragSource)
			{
				_musicSample.x = _mousePos.x + _offset.x;
				_musicSample.y = _mousePos.y + _offset.y;
			}
			
			// Если активирован флаг перетаскивания слушателя.
			if (_isDragListener)
			{
				_listener.x = _mousePos.x + _offset.x;
				_listener.y = _mousePos.y + _offset.y;
			}
			
			// Если кнопка мыши была отпущена.
			if (AntG.mouse.isReleased())
			{
				/* Включаем движение источника звука и сбрасываем все флаги перетаскивания. */
				_musicSample.moves = true;
				_isDragSource = false;
				_isDragListener = false;
			}
			
			super.update();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function postUpdate():void
		{
			AntG.beginWatch();
			AntG.watchValue("deads", AntG.sounds.numDead());
			AntG.watchValue("living", AntG.sounds.numLiving());
			AntG.endWatch();
			
			if (_started && AntG.keys.isPressed("LEFT"))
			{
				AntG.switchState(new TestUI());
			}
			
			if (_started && AntG.keys.isPressed("RIGHT"))
			{
				AntG.switchState(new TestTileMap());
			}
		}
		
		/**
		 * @private
		 */
		override public function destroy():void
		{
			AntG.cache.eventComplete.remove(onCacheComplete);
			AntG.sounds.clear();
			
			_camera.destroy();
			_camera = null;
			
			super.destroy();
		}

	}

}