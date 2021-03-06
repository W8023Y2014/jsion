package jsion.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.comps.Component;
	import jsion.events.DisplayEvent;
	import jsion.events.ReleaseEvent;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 滑动值发生变更时派发
	 */	
	[Event(name="changed", type="jsion.events.DisplayEvent")]
	/**
	 * 滑动条
	 * @author Jsion
	 * 
	 */	
	public class Slider extends Component
	{
		/**
		 * 宽度属性变更
		 */		
		public static const WIDTH:String = Component.WIDTH;
		/**
		 * 高度属性变更
		 */		
		public static const HEIGHT:String = Component.HEIGHT;
		/**
		 * 背景显示对象发生变更
		 */		
		public static const BACKGROUND:String = "background";
		/**
		 * 滑动块按钮发生变更
		 */		
		public static const SLIDERBAR:String = "sliderBar";
		/**
		 * 滑动数据发生变更
		 */		
		public static const SLIDERDATA:String = "sliderData";
		/**
		 * 滑动块偏移量发生变更
		 */		
		public static const BAROFFSET:String = "barOffset";
		
		/**
		 * 滑动填充显示对象发生变更
		 */		
		public static const FILLER:String = "filler";
		/**
		 * 滑动填充显示对象偏移量发生变更
		 */		
		public static const FILLEROFFSET:String = "fillerOffset";
		/**
		 * 滑动填充显示对象宽度发生变更
		 */		
		public static const FILLERWIDTH:String = "fillerWidth";
		/**
		 * 滑动填充显示对象高度发生变更 
		 */		
		public static const FILLERHEIGHT:String = "fillerHeight";
		/**
		 * 滑动填充显示对象遮盖类型
		 */		
		public static const FILLERMASKTYPE:String = "fillerMaskType";
		
		/**
		 * 横向滑动条
		 */		
		public static const HORIZONTAL:int = 1;
		
		/**
		 * 纵向滑动条
		 */		
		public static const VERTICAL:int = 2;
		
		/**
		 * 遮罩模式
		 */		
		public static const MASK:int = 1;
		
		/**
		 * 缩放模式
		 */		
		public static const SCALE:int = 2;
		
		
		private var m_orientation:int;
		
		
		private var m_background:DisplayObject;
		
		private var m_sliderBar:Button;
		
		
		private var m_barOffsetX:int;
		
		private var m_barOffsetY:int;
		
		
		private var m_minValue:int;
		
		private var m_maxValue:int;
		
		private var m_value:int;
		
		private var m_wheelStep:int;
		
		
		
		/**
		 * 鼠标按下时拖动条的起始位置
		 */		
		private var m_startPoint:Point;
		/**
		 * 鼠标按下时拖动条的舞台鼠标位置
		 */		
		private var m_startGlobalPoint:Point;
		
		private var m_minPos:int;
		private var m_maxPos:int;
		
		
		
		private var m_filler:DisplayObject;
		
		private var m_fillerOffsetX:int;
		
		private var m_fillerOffsetY:int;
		
		private var m_fillerWidth:int;
		
		private var m_fillerHeight:int;
		
		private var m_manualFillerWidth:Boolean;
		
		private var m_manualFillerHeight:Boolean;
		
		private var m_fillerType:int;
		
		public function Slider(orientation:int = HORIZONTAL)
		{
			m_orientation = orientation;
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function beginChanges():void
		{
			m_sliderBar.beginChanges();
			
			super.beginChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function commitChanges():void
		{
			m_sliderBar.commitChanges();
			
			super.commitChanges();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_value = 0;
			m_minValue = 0;
			m_maxValue = 100;
			m_wheelStep = 1;
			
			m_fillerType = MASK;
			
			m_sliderBar = new Button();
			m_sliderBar.stopClickPropagation();
			//m_sliderBar.alpha = 0.8;
			
			m_startPoint = new Point();
			
			m_startGlobalPoint = new Point();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function initEvents():void
		{
			super.initEvents();
			
			addEventListener(MouseEvent.CLICK, __clickHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
			m_sliderBar.addEventListener(MouseEvent.MOUSE_DOWN, __barMouseDownHandler);
			m_sliderBar.addEventListener(ReleaseEvent.RELEASE, __barReleaseHandler);
		}
		
		private function __mouseWheelHandler(e:MouseEvent):void
		{
			if(e.delta > 0)
			{
				value = m_value + m_wheelStep;
			}
			else
			{
				value = m_value - m_wheelStep;
			}
		}
		
		private function __barMouseDownHandler(e:MouseEvent):void
		{
			m_startPoint.x = barPosX;
			m_startPoint.y = barPosY;
			m_startGlobalPoint.x = stage.mouseX;
			m_startGlobalPoint.y = stage.mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			stage.addEventListener(Event.DEACTIVATE, __deactivateHandler);
		}
		
		private function __barReleaseHandler(e:ReleaseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMoveHandler);
			stage.removeEventListener(Event.DEACTIVATE, __deactivateHandler);
		}
		
		private function __deactivateHandler(e:Event):void
		{
			__barReleaseHandler(null);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(m_orientation == HORIZONTAL)
			{
				barPosX = e.localX;
			}
			else
			{
				barPosY = e.localY;
			}
			
			calcSliderValue();
			
			refreshFiller();
		}
		
		private function __mouseMoveHandler(e:MouseEvent):void
		{
			var temp:Number;
			
			if(m_orientation == HORIZONTAL)
			{
				temp = m_startPoint.x + stage.mouseX - m_startGlobalPoint.x;
				
				if(temp < m_minPos)
				{
					temp = m_minPos;
				}
				else if(temp > m_maxPos)
				{
					temp = m_maxPos;
				}
				
				barPosX = temp;
			}
			else
			{
				temp = m_startPoint.y + stage.mouseY - m_startGlobalPoint.y;
				
				if(temp < m_minPos)
				{
					temp = m_minPos;
				}
				else if(temp > m_maxPos)
				{
					temp = m_maxPos;
				}
				
				barPosY = temp;
			}
			
			calcSliderValue();
			
			refreshFiller();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			if(m_background) addChild(m_background);
			
			if(m_filler) addChild(m_filler);
			
			addChild(m_sliderBar);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			updateSliderViewSize();
			
			updateSliderViewPos();
		}
		
		private function updateSliderViewSize():void
		{
			if(isChanged(BACKGROUND) || isChanged(WIDTH) || isChanged(HEIGHT))
			{
				if(m_background)
				{
					m_background.width = m_width;
					m_background.height = m_height;
				}
			}
			
			if(isChanged(FILLER) || isChanged(FILLERWIDTH) || isChanged(FILLERHEIGHT))
			{
				if(m_filler)
				{
					m_filler.width = m_fillerWidth;
					m_filler.height = m_fillerHeight;
				}
			}
		}
		
		private function updateSliderViewPos():void
		{
			var temp:Number = (m_value - m_minValue) / (m_maxValue - m_minValue);
			
			var posX:Number, posY:Number;
			
			if(m_orientation == HORIZONTAL)
			{
				m_minPos = m_barOffsetX;
				m_maxPos = m_width - m_barOffsetX;
				
				posX = temp * (m_width - m_barOffsetX * 2) + m_barOffsetX;
				posY = m_height / 2 + m_barOffsetY;
			}
			else
			{
				m_minPos = m_barOffsetY;
				m_maxPos = m_height - m_barOffsetY;
				
				posX = m_width / 2 + m_barOffsetX;
				posY = (1 - temp) * (m_height - m_barOffsetY * 2) + m_barOffsetY;
			}
			
			barPosX = posX;
			barPosY = posY;
			
			refreshFiller();
		}
		
		private function calcSliderValue():void
		{
			var tempValue:int;
			
			if(m_orientation == HORIZONTAL)
			{
				tempValue = (barPosX - m_minPos) / (m_maxPos - m_minPos) * (m_maxValue - m_minValue) + m_minValue;
			}
			else
			{
				tempValue = (m_maxPos - barPosY) / (m_maxPos - m_minPos) * (m_maxValue - m_minValue) + m_minValue;
			}
			
			if(m_value != tempValue)
			{
				m_value = tempValue;
				
				dispatchEvent(new DisplayEvent(DisplayEvent.CHANGED, m_value));
			}
		}
		
		private function refreshFiller():void
		{
			if(m_filler)
			{
				m_filler.x = m_fillerOffsetX;
				m_filler.y = m_fillerOffsetY;
				
				var rect:Rectangle = new Rectangle();
				
				if(m_orientation == HORIZONTAL)
				{
					rect.width = barPosX;
					rect.height = m_fillerHeight;
				}
				else
				{
					m_filler.y += barPosY - m_barOffsetY;
					rect.width = m_fillerWidth;
					rect.height = m_fillerHeight - barPosY;
				}
				
				if(m_fillerType == MASK)
				{
					m_filler.scrollRect = rect;
				}
				else
				{
					m_filler.width = rect.width;
					m_filler.height = rect.height;
				}
			}
		}
		
		/**
		 * 设置拖动块的中心点x坐标所在的位置
		 */		
		protected function get barPosX():Number
		{
			return m_sliderBar.x + m_sliderBar.width / 2;
		}
		
		/** @private */
		protected function set barPosX(value:Number):void
		{
			m_sliderBar.x = value - m_sliderBar.width / 2;
		}
		
		/**
		 * 设置拖动块的中心点y坐标所在的位置
		 */		
		protected function get barPosY():Number
		{
			return m_sliderBar.y + m_sliderBar.height / 2;
		}
		
		/** @private */
		protected function set barPosY(value:Number):void
		{
			m_sliderBar.y = value - m_sliderBar.height / 2;
		}
		
		/**
		 * 滑动条类型
		 */		
		public function get orientation():int
		{
			return m_orientation;
		}
		
		/**
		 * 滑动块x坐标偏移量
		 */		
		public function get barOffsetX():int
		{
			return m_barOffsetX;
		}
		
		/** @private */
		public function set barOffsetX(value:int):void
		{
			if(m_barOffsetX != value)
			{
				m_barOffsetX = value;
				
				onPropertiesChanged(BAROFFSET);
			}
		}
		
		/**
		 * 滑动块y坐标偏移量
		 */		
		public function get barOffsetY():int
		{
			return m_barOffsetY;
		}
		
		/** @private */
		public function set barOffsetY(value:int):void
		{
			if(m_barOffsetY != value)
			{
				m_barOffsetY = value;
				
				onPropertiesChanged(BAROFFSET);
			}
		}

		/**
		 * 滑动条背景对象 如果没设置宽度或高度 未设置的值将被重置
		 */		
		public function get background():DisplayObject
		{
			return m_background;
		}
		
		/** @private */
		public function set background(value:DisplayObject):void
		{
			if(m_background != value)
			{
				DisposeUtil.free(m_background, m_freeBMD);
				
				m_background = value;
				
				if(m_background)
				{
					if(manualWidth == false) m_width = m_background.width;
					if(manualHeight == false) m_height = m_background.height;
				}
				
				onPropertiesChanged(BACKGROUND);
			}
		}

		/**
		 * 滑动数据的最小值
		 */		
		public function get minValue():int
		{
			return m_minValue;
		}
		
		/** @private */
		public function set minValue(value:int):void
		{
			if(m_minValue != value)
			{
				m_minValue = value;
				
				if(m_value < m_minValue) m_value = m_minValue;
				
				onPropertiesChanged(SLIDERDATA);
			}
		}

		/**
		 * 滑动数据的最大值
		 */		
		public function get maxValue():int
		{
			return m_maxValue;
		}
		
		/** @private */
		public function set maxValue(value:int):void
		{
			if(m_maxValue != value)
			{
				m_maxValue = value;
				
				if(m_value > m_maxValue) m_value = m_maxValue;
				
				onPropertiesChanged(SLIDERDATA);
			}
		}

		/**
		 * 滑动数据的当前值
		 */		
		public function get value():int
		{
			return m_value;
		}
		
		/** @private */
		public function set value(value:int):void
		{
			if(m_value != value && value >= m_minValue && value <= m_maxValue)
			{
				m_value = value;
				
				dispatchEvent(new DisplayEvent(DisplayEvent.CHANGED, m_value));
				
				onPropertiesChanged(SLIDERDATA);
			}
		}
		
		
		/**
		 * 按钮弹起时的显示对象资源
		 * 如果宽度和高度未设置时会根据此显示对象的宽高来设置对应的值
		 */		
		public function get upImage():DisplayObject
		{
			return m_sliderBar.upImage;
		}
		
		/** @private */
		public function set upImage(value:DisplayObject):void
		{
			if(m_sliderBar.upImage != value)
			{
				m_sliderBar.upImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时的显示对象资源
		 */		
		public function get overImage():DisplayObject
		{
			return m_sliderBar.overImage;
		}
		
		/** @private */
		public function set overImage(value:DisplayObject):void
		{
			if(m_sliderBar.overImage != value)
			{
				m_sliderBar.overImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时的显示对象资源
		 */		
		public function get downImage():DisplayObject
		{
			return m_sliderBar.downImage;
		}
		
		/** @private */
		public function set downImage(value:DisplayObject):void
		{
			if(m_sliderBar.downImage != value)
			{
				m_sliderBar.downImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮禁用时的显示对象资源
		 */		
		public function get disableImage():DisplayObject
		{
			return m_sliderBar.disableImage;
		}
		
		/** @private */
		public function set disableImage(value:DisplayObject):void
		{
			if(m_sliderBar.disableImage != value)
			{
				m_sliderBar.disableImage = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮弹起时的滤镜对象
		 */		
		public function get upFilters():Array
		{
			return m_sliderBar.upFilters;
		}
		
		/** @private */
		public function set upFilters(value:Array):void
		{
			if(m_sliderBar.upFilters != value)
			{
				m_sliderBar.upFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时的滤镜对象
		 */		
		public function get overFilters():Array
		{
			return m_sliderBar.overFilters;
		}
		
		/** @private */
		public function set overFilters(value:Array):void
		{
			if(m_sliderBar.overFilters != value)
			{
				m_sliderBar.overFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时的滤镜对象
		 */		
		public function get downFilters():Array
		{
			return m_sliderBar.downFilters;
		}
		
		/** @private */
		public function set downFilters(value:Array):void
		{
			if(m_sliderBar.downFilters != value)
			{
				m_sliderBar.downFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮禁用时的滤镜对象
		 */		
		public function get disableFilters():Array
		{
			return m_sliderBar.disableFilters;
		}
		
		/** @private */
		public function set disableFilters(value:Array):void
		{
			if(m_sliderBar.disableFilters != value)
			{
				m_sliderBar.disableFilters = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮状态显示对象x坐标偏移量
		 */
		public function get offsetX():int
		{
			return m_sliderBar.offsetX;
		}
		
		/** @private */
		public function set offsetX(value:int):void
		{
			if(m_sliderBar.offsetX != value)
			{
				m_sliderBar.offsetX = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮状态显示对象y坐标偏移量
		 */
		public function get offsetY():int
		{
			return m_sliderBar.offsetY;
		}
		
		/** @private */
		public function set offsetY(value:int):void
		{
			if(m_sliderBar.offsetY != value)
			{
				m_sliderBar.offsetY = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象x坐标偏移量
		 */
		public function get overOffsetX():int
		{
			return m_sliderBar.overOffsetX;
		}
		
		/** @private */
		public function set overOffsetX(value:int):void
		{
			if(m_sliderBar.overOffsetX != value)
			{
				m_sliderBar.overOffsetX = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮鼠标经过时状态显示对象y坐标偏移量
		 */
		public function get overOffsetY():int
		{
			return m_sliderBar.overOffsetY;
		}
		
		/** @private */
		public function set overOffsetY(value:int):void
		{
			if(m_sliderBar.overOffsetY != value)
			{
				m_sliderBar.overOffsetY = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象x坐标偏移量
		 */
		public function get downOffsetX():int
		{
			return m_sliderBar.downOffsetX;
		}
		
		/** @private */
		public function set downOffsetX(value:int):void
		{
			if(m_sliderBar.downOffsetX != value)
			{
				m_sliderBar.downOffsetX = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}
		
		/**
		 * 按钮按下时状态显示对象y坐标偏移量
		 */
		public function get downOffsetY():int
		{
			return m_sliderBar.downOffsetY;
		}
		
		/** @private */
		public function set downOffsetY(value:int):void
		{
			if(m_sliderBar.downOffsetY != value)
			{
				m_sliderBar.downOffsetY = value;
				
				onPropertiesChanged(SLIDERBAR);
			}
		}

		/**
		 * 指示当背景或filler显示对象为Bitmap,被释放时是否释放 bitmapData 对象。默认为 false 。
		 */		
		public function get freeBMD():Boolean
		{
			return m_freeBMD;
		}
		
		/** @private */
		public function set freeBMD(value:Boolean):void
		{
			m_freeBMD = value;
			
			m_sliderBar.freeBMD = value;
		}

		/**
		 * 滑动填充显示对象。如果未设置 fillerWidth 和 fillerHeight 属性则将设置这两个属性值。
		 */		
		public function get filler():DisplayObject
		{
			return m_filler;
		}
		
		/** @private */
		public function set filler(value:DisplayObject):void
		{
			if(m_filler != value)
			{
				DisposeUtil.free(m_filler, m_freeBMD);
				
				m_filler = value;
				
				if(m_filler)
				{
					if(m_manualFillerWidth == false) m_fillerWidth = m_filler.width;
					
					if(m_manualFillerHeight == false) m_fillerHeight = m_filler.height;
				}
				
				onPropertiesChanged(FILLER);
			}
		}

		/**
		 * 填充显示对象的x坐标偏移量
		 */		
		public function get fillerOffsetX():int
		{
			return m_fillerOffsetX;
		}
		
		/** @private */
		public function set fillerOffsetX(value:int):void
		{
			if(m_fillerOffsetX != value)
			{
				m_fillerOffsetX = value;
				
				onPropertiesChanged(FILLEROFFSET);
			}
		}
		
		/**
		 * 填充显示对象的y坐标偏移量
		 */		
		public function get fillerOffsetY():int
		{
			return m_fillerOffsetY;
		}
		
		/** @private */
		public function set fillerOffsetY(value:int):void
		{
			if(m_fillerOffsetY != value)
			{
				m_fillerOffsetY = value;
				
				onPropertiesChanged(FILLEROFFSET);
			}
		}
		
		/**
		 * 填充显示对象的宽度
		 */		
		public function get fillerWidth():int
		{
			return m_fillerWidth;
		}
		
		/** @private */
		public function set fillerWidth(value:int):void
		{
			if(m_fillerWidth != value)
			{
				m_fillerWidth = value;
				
				m_manualFillerWidth = true;
				
				onPropertiesChanged(FILLERWIDTH);
			}
		}
		
		/**
		 * 填充显示对象的高度
		 */		
		public function get fillerHeight():int
		{
			return m_fillerHeight;
		}
		
		/** @private */
		public function set fillerHeight(value:int):void
		{
			if(m_fillerHeight != value)
			{
				m_fillerHeight = value;
				
				m_manualFillerHeight = true;
				
				onPropertiesChanged(FILLERHEIGHT);
			}
		}

		/**
		 * 填充显示对象的遮盖类型
		 */		
		public function get fillerType():int
		{
			return m_fillerType;
		}
		
		/** @private */
		public function set fillerType(value:int):void
		{
			if(m_fillerType != value && (value == MASK || value == SCALE))
			{
				m_fillerType = value;
				
				onPropertiesChanged(FILLERMASKTYPE);
			}
		}

		/**
		 * 每次鼠标滚轮滚动时滑动值改变的增量
		 */		
		public function get wheelStep():int
		{
			return m_wheelStep;
		}
		
		/** @private */
		public function set wheelStep(value:int):void
		{
			m_wheelStep = value;
		}

		override public function dispose():void
		{
			DisposeUtil.free(m_background, m_freeBMD);
			m_background = null;
			
			DisposeUtil.free(m_filler, m_freeBMD);
			m_filler = null;
			
			m_sliderBar = null;
			
			super.dispose();
		}
	}
}