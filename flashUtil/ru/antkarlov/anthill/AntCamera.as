package ru.antkarlov.anthill
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * Реализует рендеринг всех визуальных сущностей.
	 * 
	 * <p>Чтобы реализовать перемещение камеры (скролл уровней), используйте атрибут <code>scroll</code>
	 * для перемещения камеры в игровом мире.</p>
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Anton Karlov
	 * @since  29.08.2012
	 */
	public class AntCamera extends Sprite
	{
		//---------------------------------------
		// CLASS CONSTANTS
		//---------------------------------------
		
		/**
		 * Стиль слежения камеры: свободный стиль, по X и Y.
		 */
		public static const STYLE_FREELY:uint = 0;
		
		/**
		 * Стиль слежения камеры: горизонтальный, только по X.
		 */
		public static const STYLE_HORIZONTAL:uint = 1;
		
		/**
		 * Стиль слежения камеры: вертикальный, только по Y.
		 */
		public static const STYLE_VERTICAL:uint = 2;
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		/**
		 * Флаг определяющий следует ли выполнять заливку цветом в буфер камеры перед рендером объектов.
		 * @default    false
		 */
		public var fillBackground:Boolean;
		
		/**
		 * Цвет заливки.
		 * @default    0xFF000000
		 */
		public var backgroundColor:uint;
		
		/**
		 * Содержит смещение камеры относительно игрового мира.
		 * Чтобы прокручивать игровые миры, достаточно менять значения <code>scroll.x</code> и <code>scroll.y</code>.
		 * @default    (0,0)
		 */
		public var scroll:AntPoint;
		
		/**
		 * Основной буфер камеры куда производится отрисовка всех визуальных объектов.
		 */
		public var buffer:BitmapData;
		
		/**
		 * Фактор увеличения изображения.
		 * @default    1
		 */
		public var zoom:int;
		
		/**
		 * Прямоугольник задающий границы для перемещения камеры.
		 * @default    null
		 */
		public var bounds:AntRect;
		
		/**
		 * Цель которую приследует камера.
		 * @default    null
		 */
		public var target:AntEntity;
		
		/**
		 * Стиль слежения за объектом.
		 * @default    STYLE_FREELY
		 */
		public var followStyle:uint;
		
		/**
		 * Фактор опережения камеры при движении за целью.
		 * @default    8
		 */
		public var leadingFactor:Number;
		
		/**
		 * Фактор отставания камеры при движении за целью.
		 * @default    0.25
		 */
		public var smoothFactor:Number;
		
		/**
		 * Свойство цели для преследования которое используется для определения его позиции по X.
		 * @default    "globalX"
		 */
		public var positionPropertyX:String;
		
		/**
		 * Свойство цели для преследования которое используется для определения его позиции по X.
		 * @default    "globalY"
		 */
		public var positionPropertyY:String;
		
		/**
		 * Определяет следует ли при преследовании цели округлять координаты камеры.
		 * @default    false
		 */
		public var approximatePosition:Boolean;
		
		/**
		 * Центр экрана.
		 */
		public var screenCenter:AntPoint;
		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		
		/**
		 * Помшник для заливки буфера камеры цветом.
		 */
		protected var _flashRect:Rectangle;
		
		/**
		 * Битмап для вывода буффера камеры на экран стандартными средствами Flash.
		 */
		protected var _bitmap:Bitmap;
		
		/**
		 * Помошник для рассчета новой позиции камеры.
		 */
		protected var _newPos:AntPoint;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		/**
		 * @constructor
		 */
		public function AntCamera(aWidth:int, aHeight:int, aZoom:int = 1)
		{
			super();
			
			fillBackground = false;
			backgroundColor = 0xFF000000;
			scroll = new AntPoint();
			zoom = aZoom;
			bounds = null;
			
			_bitmap = new Bitmap(new BitmapData(aWidth, aHeight, true, backgroundColor));
			_bitmap.scaleX = _bitmap.scaleY = zoom;
			addChild(_bitmap);
			
			buffer = _bitmap.bitmapData;
			buffer.lock();
			
			_flashRect = new Rectangle(0, 0, aWidth, aHeight);
			_newPos = new AntPoint();
			screenCenter = new AntPoint(aWidth * 0.5, aHeight * 0.5);
			
			target = null;
			followStyle = STYLE_FREELY;
			leadingFactor = 8;
			smoothFactor = 0.25;
			positionPropertyX = "globalX";
			positionPropertyY = "globalY";
			approximatePosition = false;
		}
		
		/**
		 * Уничтожает экземпляр камеры и осовобождает память.
		 */
		public function destroy():void
		{
			AntG.removeCamera(this);
			
			buffer.unlock();
			buffer.dispose();
			buffer = null;
			
			if (contains(_bitmap))
			{
				removeChild(_bitmap);
			}
			_bitmap = null;
			
			if (parent != null)
			{
				parent.removeChild(this);
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Устанавливает цель за которой будет выполнятся слежение.
		 * 
		 * @param	aTarget	 Цель за которой будет выполнятся слежение.
		 * @param	aStyle	 Стиль слежения.
		 */
		public function follow(aTarget:AntEntity, aStyle:uint = STYLE_FREELY):void
		{
			target = aTarget;
			followStyle = aStyle;
		}
		
		/**
		 * Моментальное перемещение камеры к указанной позиции.
		 * 
		 * @param	aPoint	 Точка к которой будет перемещена камера.
		 */
		public function focusOn(aPoint:AntPoint):void
		{
			aPoint.x += (aPoint.x > 0) ? 0.0000001 : -0.0000001;
			aPoint.y += (aPoint.y > 0) ? 0.0000001 : -0.0000001;
			_newPos.set(-(aPoint.x - width) - screenCenter.x, -(aPoint.y - height) - screenCenter.y);
			
			if (bounds != null)
			{
				_newPos.x = limitByX(_newPos.x);
				_newPos.y = limitByY(_newPos.y);
			}
			
			scroll.x = _newPos.x;
			scroll.y = _newPos.y;
		}
		
		/**
		 * Устанавливает ограничение для перемещения камеры.
		 * 
		 * @param	aLowerX	 Минимально допустимая позиция камеры по X (обычно это 0).
		 * @param	aLowerY	 Минимально допустимая позиция камеры по Y (обычно это 0).
		 * @param	aUpperX	 Максимально допустимая позиция камеры по X (обычно это ширина уровня).
		 * @param	aUpperY	 Максимально допустимая позиция камеры по Y (обычно это высота уровня).
		 */
		public function setBounds(aLowerX:int, aLowerY:int, aUpperX:int, aUpperY:int):void
		{
			if (bounds == null)
			{
				bounds = new AntRect();
			}
			
			bounds.set(aLowerY, aLowerY, aUpperX, aUpperY);
			update();
		}
		
		/**
		 * Обработка действий камеры.
		 */
		public function update():void
		{
			if (target != null)
			{
				switch (followStyle)
				{
					case STYLE_FREELY :
						_newPos.x = (scroll.x - (-target[positionPropertyX] + screenCenter.x - (target.velocity.x * AntG.elapsed) * leadingFactor)) * smoothFactor;
						_newPos.y = (scroll.y - (-target[positionPropertyY] + screenCenter.y - (target.velocity.y * AntG.elapsed) * leadingFactor)) * smoothFactor;
					break;
					
					case STYLE_HORIZONTAL :
						_newPos.x = (scroll.x - (-target[positionPropertyX] + screenCenter.x - (target.velocity.x * AntG.elapsed) * leadingFactor)) * smoothFactor;
					break;
					
					case STYLE_VERTICAL :
						_newPos.y = (scroll.y - (-target[positionPropertyY] + screenCenter.y - (target.velocity.y * AntG.elapsed) * leadingFactor)) * smoothFactor;
					break;
				}
				
				if (approximatePosition)
				{
					_newPos.x += (_newPos.x > 0) ? 0.0000001 : -0.0000001;
					_newPos.y += (_newPos.y > 0) ? 0.0000001 : -0.0000001;
					_newPos.set(scroll.x - AntMath.ceil(_newPos.x), scroll.y - AntMath.ceil(_newPos.y));
				}
				else
				{
					_newPos.set(scroll.x - _newPos.x, scroll.y - _newPos.y);
				}
				
				if (bounds != null)
				{
					_newPos.x = limitByX(_newPos.x);
					_newPos.y = limitByY(_newPos.y);
				}
				
				scroll.x = _newPos.x;
				scroll.y = _newPos.y;
			}
			else if (bounds != null)
			{
				scroll.x = limitByX(scroll.x);
				scroll.y = limitByY(scroll.y);
			}
		}
		
		/**
		 * Отрисовка буфера камеры на экран.
		 */
		public function draw():void
		{
			buffer.unlock();
			buffer.lock();
			
			if (fillBackground)
			{
				buffer.fillRect(_flashRect, backgroundColor);
			}
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Ограничивает значение по горизонтали согласно заданным границам.
		 * 
		 * @param	aValue	 Новая позиция по горизонтали.
		 * @return		Если новая позиция вышла за пределы границы, то вернет крайнюю доступную позицию.
		 */
		protected function limitByX(aValue:Number):Number
		{
			if (aValue > bounds.left)
			{
				aValue = bounds.left;
			}
			else if (AntMath.abs(aValue) > bounds.right - width)
			{
				aValue = -(bounds.right - width);
			}
			
			return aValue;
		}
		
		/**
		 * Ограничивает значение по вертикали согласно заданным границам.
		 * 
		 * @param	aValue	 Новая позиция по вертикали.
		 * @return		Если новая позиция вышла за пределы границы, то вернет крайнюю доступную позицию.
		 */
		protected function limitByY(aValue:Number):Number
		{
			if (aValue > bounds.top)
			{
				aValue = bounds.top;
			}
			else if (AntMath.abs(aValue) > bounds.bottom - height)
			{
				aValue = -(bounds.bottom - height);
			}
			
			return aValue;
		}

	}

}