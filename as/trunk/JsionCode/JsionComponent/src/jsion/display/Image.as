package jsion.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.Insets;
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 图片显示对象
	 * 支持九宫格缩放
	 * 默认禁用鼠标事件
	 * @author Jsion
	 */	
	public class Image extends Component
	{
		public static const SOURCE:String = "source";
		public static const SCALE9INSETS:String = "scale9Insets";
		public static const SCALETYPE:String = "scaleType";
		
		/**
		 * 拉伸缩放类型
		 */		
		public static const SCALE:String = CompGlobal.SCALE;
		
		/**
		 * 平铺绽放类型
		 */		
		public static const TILE:String = CompGlobal.TILE;
		
		private var m_source:BitmapData;
		private var m_freeSource:Boolean;
		
		private var m_scale9Insets:Insets;
		
		private var m_scaleType:String;
		
		private var m_minWidth:int;
		private var m_minHeight:int;
		
		
		private var m_bmp1:Bitmap;
		private var m_bmp2:Bitmap;
		private var m_bmp3:Bitmap;
		private var m_bmp4:Bitmap;
		private var m_bmp5:Bitmap;
		private var m_bmp6:Bitmap;
		private var m_bmp7:Bitmap;
		private var m_bmp8:Bitmap;
		private var m_bmp9:Bitmap;
		
		
		public function Image()
		{
			super();
		}
		
		/**
		 * @inheritDOC
		 */		
		override protected function initialize():void
		{
			super.initialize();
			
			m_scaleType = SCALE;
			
			m_freeSource = false;
			mouseEnabled = false;
			mouseChildren = false;
			
			m_bmp1 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp2 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp3 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp4 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp5 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp6 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp7 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp8 = new Bitmap(null, PixelSnapping.AUTO, true);
			m_bmp9 = new Bitmap(null, PixelSnapping.AUTO, true);
		}
		
		/**
		 * @inheritDOC
		 */		
		override protected function addChildren():void
		{
			super.addChildren();
			
			addChild(m_bmp1);
			addChild(m_bmp2);
			addChild(m_bmp3);
			addChild(m_bmp4);
			addChild(m_bmp5);
			addChild(m_bmp6);
			addChild(m_bmp7);
			addChild(m_bmp8);
			addChild(m_bmp9);
		}
		
		/**
		 * 图片的 BitmapData 对象数据
		 */		
		public function get source():BitmapData
		{
			return m_source;
		}
		
		/** @private */
		public function set source(value:BitmapData):void
		{
			if(m_source != value)
			{
				m_source = value;
				
				if(m_source)
				{
					if(manualWidth == false) m_width = m_source.width;
					if(manualHeight == false) m_height = m_source.height;
				}
				
				onPropertiesChanged(SOURCE);
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set width(value:Number):void
		{
			if(value <= minWidth) value = minWidth;
			
			super.width = value;// + (value % 2);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set height(value:Number):void
		{
			if(value <= minHeight) value = minHeight;
			
			super.height = value;// + (value % 2);
		}
		
		/**
		 * 最小宽度
		 */		
		public function get minWidth():int
		{
			return m_minWidth;
		}
		
		/**
		 * 最小高度
		 */		
		public function get minHeight():int
		{
			return m_minHeight;
		}
		
		/**
		 * 请使用scale9Insets属性
		 * @throws Error 废弃了旧的九宫格设置方式 改用 scale9Insets 属性
		 */		
		override public function get scale9Grid():Rectangle
		{
			throw new Error("九宫格范围请使用scale9Insets属性");
		}
		
		/** @private */
		override public function set scale9Grid(innerRectangle:Rectangle):void
		{
			throw new Error("九宫格范围请使用scale9Insets属性");
		}
		
		/**
		 * 九宫格四边距
		 */		
		public function get scale9Insets():Insets
		{
			return m_scale9Insets;
		}
		
		/** @private */
		public function set scale9Insets(value:Insets):void
		{
			m_scale9Insets = value;
			
			if(m_scale9Insets)
			{
				m_minWidth = m_scale9Insets.left + m_scale9Insets.right + 1;
				m_minHeight = m_scale9Insets.top + m_scale9Insets.bottom + 1;
			}
			else
			{
				m_minWidth = 0;
				m_minHeight = 0;
			}
			
			checkSizeWidthMinSize();
			
			onPropertiesChanged(SCALE9INSETS);
		}
		
		/**
		 * 设置绽放值
		 * @default jsion.display.Image.SCALE
		 */		
		public function get scaleType():String
		{
			return m_scaleType;
		}
		
		/** @private */
		public function set scaleType(value:String):void
		{
			if(m_scaleType != value && (value == SCALE || value == TILE))
			{
				m_scaleType = value;
				
				onPropertiesChanged(SCALETYPE);
			}
		}
		
		/**
		 * 指示是否释放 source 属性对象。默认 false 。
		 */		
		public function get freeSource():Boolean
		{
			return m_freeSource;
		}
		
		/** @private */
		public function set freeSource(value:Boolean):void
		{
			m_freeSource = value;
		}
		
		/**
		 * 检查是否小于允许的最小 Size ，如果小于则重置为最小的 Size。
		 */		
		protected function checkSizeWidthMinSize():void
		{
			m_width = Math.max(m_width, m_minWidth);
			m_height = Math.max(m_height, m_minHeight);
		}
		
		/**
		 * @inheritDOC
		 */		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			
			if(m_source == null) return;
			
			if(m_scale9Insets != null)
			{
				var changeSource:Boolean = isChanged(SOURCE);
				var changeSize:Boolean = isChanged(WIDTH) || isChanged(HEIGHT);
				var change9Insets:Boolean = isChanged(SCALE9INSETS);
				var changeType:Boolean = isChanged(SCALETYPE);
				
				var needCreateBMD:Boolean;
				var needUpdateBMD:Boolean;
				
				var tempPoint:Point = new Point();
				var tempRect:Rectangle = new Rectangle();
				
				if(m_bmp1.bitmapData == null || change9Insets)
				{
					if(m_scale9Insets.left != 0 && m_scale9Insets.top != 0)
					{
						m_bmp1.bitmapData = new BitmapData(m_scale9Insets.left, m_scale9Insets.top, true, 0);
					}
					else
					{
						m_bmp1.bitmapData = null;
					}
				}
				
				if(m_bmp3.bitmapData == null || change9Insets)
				{
					if(m_scale9Insets.right != 0 && m_scale9Insets.top != 0)
					{
						m_bmp3.bitmapData = new BitmapData(m_scale9Insets.right, m_scale9Insets.top, true, 0);
					}
					else
					{
						m_bmp3.bitmapData = null;
					}
				}
				
				if(m_bmp7.bitmapData == null || change9Insets)
				{
					if(m_scale9Insets.left != 0 && m_scale9Insets.bottom != 0)
					{
						m_bmp7.bitmapData = new BitmapData(m_scale9Insets.left, m_scale9Insets.bottom, true, 0);
					}
					else
					{
						m_bmp7.bitmapData = null;
					}
				}
				
				if(m_bmp9.bitmapData == null || change9Insets)
				{
					if(m_scale9Insets.right != 0 && m_scale9Insets.bottom != 0)
					{
						m_bmp9.bitmapData = new BitmapData(m_scale9Insets.right, m_scale9Insets.bottom, true, 0);
					}
					else
					{
						m_bmp9.bitmapData = null;
					}
				}
				
				if(m_bmp1.bitmapData)
				{
					m_bmp1.width = m_bmp1.bitmapData.width;
					m_bmp1.height = m_bmp1.bitmapData.height;
				}
				
				if(m_bmp3.bitmapData)
				{
					m_bmp3.width = m_bmp3.bitmapData.width;
					m_bmp3.height = m_bmp3.bitmapData.height;
				}
				
				if(m_bmp7.bitmapData)
				{
					m_bmp7.width = m_bmp7.bitmapData.width;
					m_bmp7.height = m_bmp7.bitmapData.height;
				}
				
				if(m_bmp9.bitmapData)
				{
					m_bmp9.width = m_bmp9.bitmapData.width;
					m_bmp9.height = m_bmp9.bitmapData.height;
				}
				
				needUpdateBMD = change9Insets || changeSource;
				
				if(needUpdateBMD)
				{
					tempPoint.x = 0;
					tempPoint.y = 0;
					
					if(m_bmp1.bitmapData)
					{
						tempRect.x = 0;
						tempRect.y = 0;
						tempRect.width = m_scale9Insets.left;
						tempRect.height = m_scale9Insets.top;
						
						m_bmp1.bitmapData.copyPixels(m_source, tempRect, tempPoint);
					}
					
					
					if(m_bmp3.bitmapData)
					{
						tempRect.x = m_source.width - m_scale9Insets.right;
						tempRect.y = 0;
						tempRect.width = m_scale9Insets.right;
						tempRect.height = m_scale9Insets.top;
						
						m_bmp3.bitmapData.copyPixels(m_source, tempRect, tempPoint);
					}
					
					
					if(m_bmp7.bitmapData)
					{
						tempRect.x = 0;
						tempRect.y = m_source.height - m_scale9Insets.bottom;
						tempRect.width = m_scale9Insets.left;
						tempRect.height = m_scale9Insets.bottom;
						
						m_bmp7.bitmapData.copyPixels(m_source, tempRect, tempPoint);
					}
					
					
					if(m_bmp9.bitmapData)
					{
						tempRect.x = m_source.width - m_scale9Insets.right;
						tempRect.y = m_source.height - m_scale9Insets.bottom;
						tempRect.width = m_scale9Insets.right;
						tempRect.height = m_scale9Insets.bottom;
						
						m_bmp9.bitmapData.copyPixels(m_source, tempRect, tempPoint);
					}
				}
				
				
				if(m_scaleType == SCALE)
				{
					needCreateBMD = change9Insets || changeSource || changeType || isChanged(WIDTH) || isChanged(HEIGHT);
					
					needUpdateBMD = needCreateBMD;
					
					if(m_bmp2.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.top != 0)
						{
							m_bmp2.bitmapData = new BitmapData(m_source.width - m_scale9Insets.left - m_scale9Insets.right, m_scale9Insets.top, true, 0);
						}
						else
						{
							m_bmp2.bitmapData = null;
						}
					}
					
					if(m_bmp4.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.left != 0)
						{
							m_bmp4.bitmapData = new BitmapData(m_scale9Insets.left, m_source.height - m_scale9Insets.top - m_scale9Insets.bottom, true, 0);
						}
						else
						{
							m_bmp4.bitmapData = null;
						}
					}
					
					if(m_bmp5.bitmapData == null || needCreateBMD)
					{
						m_bmp5.bitmapData = new BitmapData(m_source.width - m_scale9Insets.left - m_scale9Insets.right, m_source.height - m_scale9Insets.top - m_scale9Insets.bottom, true, 0);
					}
					
					if(m_bmp6.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.right != 0)
						{
							m_bmp6.bitmapData = new BitmapData(m_scale9Insets.right, m_source.height - m_scale9Insets.top - m_scale9Insets.bottom, true, 0);
						}
						else
						{
							m_bmp6.bitmapData = null;
						}
					}
					
					if(m_bmp8.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.bottom != 0)
						{
							m_bmp8.bitmapData = new BitmapData(m_source.width - m_scale9Insets.left - m_scale9Insets.right, m_scale9Insets.bottom, true, 0);
						}
						else
						{
							m_bmp8.bitmapData = null;
						}
					}
					
					if(needUpdateBMD)
					{
						tempPoint.x = 0;
						tempPoint.y = 0;
						
						if(m_bmp2.bitmapData)
						{
							//上部中间区域
							tempRect.x = m_scale9Insets.left;
							tempRect.y = 0;
							tempRect.width = m_source.width - m_scale9Insets.left - m_scale9Insets.right;
							tempRect.height = m_scale9Insets.top;
							
							m_bmp2.bitmapData.copyPixels(m_source, tempRect, tempPoint);
						}
						
						
						if(m_bmp4.bitmapData)
						{
							//左边中间区域
							tempRect.x = 0;
							tempRect.y = m_scale9Insets.top;
							tempRect.width = m_scale9Insets.left;
							tempRect.height = m_source.height - m_scale9Insets.top - m_scale9Insets.bottom;
							
							m_bmp4.bitmapData.copyPixels(m_source, tempRect, tempPoint);
						}
						
						
						if(m_bmp5.bitmapData)
						{
							//中部中间区域
							tempRect.x = m_scale9Insets.left;
							tempRect.y = m_scale9Insets.top;
							tempRect.width = m_source.width - m_scale9Insets.left - m_scale9Insets.right;
							tempRect.height = m_source.height - m_scale9Insets.top - m_scale9Insets.bottom;
							
							m_bmp5.bitmapData.copyPixels(m_source, tempRect, tempPoint);
						}
						
						
						if(m_bmp6.bitmapData)
						{
							//右部中间区域
							tempRect.x = m_source.width - m_scale9Insets.right;
							tempRect.y = m_scale9Insets.top;
							tempRect.width = m_scale9Insets.right;
							tempRect.height = m_source.height - m_scale9Insets.top - m_scale9Insets.bottom;
							
							m_bmp6.bitmapData.copyPixels(m_source, tempRect, tempPoint);
						}
						
						
						if(m_bmp8.bitmapData)
						{
							//底部中间区域
							tempRect.x = m_scale9Insets.left;
							tempRect.y = m_source.height - m_scale9Insets.bottom;
							tempRect.width = m_source.width - m_scale9Insets.left - m_scale9Insets.right;
							tempRect.height = m_scale9Insets.bottom;
							
							m_bmp8.bitmapData.copyPixels(m_source, tempRect, tempPoint);
						}
					}
					
					if(m_bmp2.bitmapData)
					{
						m_bmp2.width = m_width - m_scale9Insets.left - m_scale9Insets.right;
						m_bmp2.height = m_scale9Insets.top;
					}
					
					if(m_bmp4.bitmapData)
					{
						m_bmp4.width = m_scale9Insets.left;
						m_bmp4.height = m_height - m_scale9Insets.top - m_scale9Insets.bottom;
					}
					
					if(m_bmp5.bitmapData)
					{
						m_bmp5.width = m_width - m_scale9Insets.left - m_scale9Insets.right;
						m_bmp5.height = m_height - m_scale9Insets.top - m_scale9Insets.bottom;
					}
					
					if(m_bmp6.bitmapData)
					{
						m_bmp6.width = m_scale9Insets.right;
						m_bmp6.height = m_height - m_scale9Insets.top - m_scale9Insets.bottom;
					}
					
					if(m_bmp8.bitmapData)
					{
						m_bmp8.width = m_width - m_scale9Insets.left - m_scale9Insets.right;
						m_bmp8.height = m_scale9Insets.bottom;
					}
				}
				else
				{
					needCreateBMD = change9Insets || changeSize || changeType;
					
					needUpdateBMD = changeSource || needCreateBMD;
					
					if(m_bmp2.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.top != 0)
						{
							m_bmp2.bitmapData = new BitmapData(m_width - m_scale9Insets.left - m_scale9Insets.right, m_scale9Insets.top, true, 0);
						}
						else
						{
							m_bmp2.bitmapData = null;
						}
					}
					
					if(m_bmp4.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.left != 0)
						{
							m_bmp4.bitmapData = new BitmapData(m_scale9Insets.left, m_height - m_scale9Insets.top - m_scale9Insets.bottom, true, 0);
						}
						else
						{
							m_bmp4.bitmapData = null;
						}
					}
					
					if(m_bmp5.bitmapData == null || needCreateBMD)
					{
						m_bmp5.bitmapData = new BitmapData(m_width - m_scale9Insets.left - m_scale9Insets.right, m_height - m_scale9Insets.top - m_scale9Insets.bottom, true, 0);
					}
					
					if(m_bmp6.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.right != 0)
						{
							m_bmp6.bitmapData = new BitmapData(m_scale9Insets.right, m_height - m_scale9Insets.top - m_scale9Insets.bottom, true, 0);
						}
						else
						{
							m_bmp6.bitmapData = null;
						}
					}
					
					if(m_bmp8.bitmapData == null || needCreateBMD)
					{
						if(m_scale9Insets.bottom != 0)
						{
							m_bmp8.bitmapData = new BitmapData(m_width - m_scale9Insets.left - m_scale9Insets.right, m_scale9Insets.bottom, true, 0);
						}
						else
						{
							m_bmp8.bitmapData = null;
						}
					}
					
					if(needUpdateBMD)
					{
						//上部中间区域
						tempRect.x = m_scale9Insets.left;
						tempRect.y = 0;
						tempRect.width = m_source.width - m_scale9Insets.left - m_scale9Insets.right;
						tempRect.height = m_scale9Insets.top;
						
						tempPoint.x = 0;
						tempPoint.y = 0;
						
						while(tempPoint.x < m_bmp2.bitmapData.width)
						{
							m_bmp2.bitmapData.copyPixels(m_source, tempRect, tempPoint);
							
							tempPoint.x += tempRect.width;
						}
						
						//左边中间区域
						tempRect.x = 0;
						tempRect.y = m_scale9Insets.top;
						tempRect.width = m_scale9Insets.left;
						tempRect.height = m_source.height - m_scale9Insets.top - m_scale9Insets.bottom;
						
						tempPoint.x = 0;
						tempPoint.y = 0;
						
						while(tempPoint.y < m_bmp4.bitmapData.height)
						{
							m_bmp4.bitmapData.copyPixels(m_source, tempRect, tempPoint);
							
							tempPoint.y += tempRect.height;
						}
						
						//中部中间区域
						tempRect.x = m_scale9Insets.left;
						tempRect.y = m_scale9Insets.top;
						tempRect.width = m_source.width - m_scale9Insets.left - m_scale9Insets.right;
						tempRect.height = m_source.height - m_scale9Insets.top - m_scale9Insets.bottom;
						
						tempPoint.x = 0;
						tempPoint.y = 0;
						
						while(tempPoint.y < m_bmp5.bitmapData.height)
						{
							while(tempPoint.x < m_bmp5.bitmapData.width)
							{
								m_bmp5.bitmapData.copyPixels(m_source, tempRect, tempPoint);
								
								tempPoint.x += tempRect.width;
							}
							
							tempPoint.x = 0;
							tempPoint.y += tempRect.height;
						}
						
						//右部中间区域
						tempRect.x = m_source.width - m_scale9Insets.right;
						tempRect.y = m_scale9Insets.top;
						tempRect.width = m_scale9Insets.right;
						tempRect.height = m_source.height - m_scale9Insets.top - m_scale9Insets.bottom;
						
						tempPoint.x = 0;
						tempPoint.y = 0;
						
						while(tempPoint.y < m_bmp6.bitmapData.height)
						{
							m_bmp6.bitmapData.copyPixels(m_source, tempRect, tempPoint);
							
							tempPoint.y += tempRect.height;
						}
						
						//底部中间区域
						tempRect.x = m_scale9Insets.left;
						tempRect.y = m_source.height - m_scale9Insets.bottom;
						tempRect.width = m_source.width - m_scale9Insets.left - m_scale9Insets.right;
						tempRect.height = m_scale9Insets.bottom;
						
						tempPoint.x = 0;
						tempPoint.y = 0;
						
						while(tempPoint.x < m_bmp8.bitmapData.width)
						{
							m_bmp8.bitmapData.copyPixels(m_source, tempRect, tempPoint);
							
							tempPoint.x += tempRect.width;
						}
					}
					
					m_bmp2.width = m_bmp2.bitmapData.width;
					m_bmp2.height = m_bmp2.bitmapData.height;
					
					m_bmp4.width = m_bmp4.bitmapData.width;
					m_bmp4.height = m_bmp4.bitmapData.height;
					
					m_bmp5.width = m_bmp5.bitmapData.width;
					m_bmp5.height = m_bmp5.bitmapData.height;
					
					m_bmp6.width = m_bmp6.bitmapData.width;
					m_bmp6.height = m_bmp6.bitmapData.height;
					
					m_bmp8.width = m_bmp8.bitmapData.width;
					m_bmp8.height = m_bmp8.bitmapData.height;
				}
				
				m_bmp1.x = 0;
				m_bmp1.y = 0;
				
				m_bmp3.x = m_width - m_scale9Insets.right;
				m_bmp3.y = 0;
				
				m_bmp7.x = 0;
				m_bmp7.y = m_height - m_scale9Insets.bottom;
				
				m_bmp9.x = m_width - m_scale9Insets.right;
				m_bmp9.y = m_height - m_scale9Insets.bottom;
				
				m_bmp2.x = m_scale9Insets.left;
				m_bmp2.y = 0;
				
				m_bmp4.x = 0;
				m_bmp4.y = m_scale9Insets.top;
				
				m_bmp5.x = m_scale9Insets.left;
				m_bmp5.y = m_scale9Insets.top;
				
				m_bmp6.x = m_width - m_scale9Insets.right;
				m_bmp6.y = m_scale9Insets.top;
				
				m_bmp8.x = m_scale9Insets.left;
				m_bmp8.y = m_height - m_scale9Insets.bottom;
			}
			else
			{
				if(m_bmp5.bitmapData != m_source)
				{
					m_bmp1.x = m_bmp1.y = 0;
					m_bmp2.x = m_bmp2.y = 0;
					m_bmp3.x = m_bmp3.y = 0;
					m_bmp4.x = m_bmp4.y = 0;
					m_bmp5.x = m_bmp5.y = 0;
					m_bmp6.x = m_bmp6.y = 0;
					m_bmp7.x = m_bmp7.y = 0;
					m_bmp8.x = m_bmp8.y = 0;
					m_bmp9.x = m_bmp9.y = 0;
					
					disposeBitmapData(m_bmp1);
					disposeBitmapData(m_bmp2);
					disposeBitmapData(m_bmp3);
					disposeBitmapData(m_bmp4);
					//disposeBitmapData(m_bmp5);
					disposeBitmapData(m_bmp6);
					disposeBitmapData(m_bmp7);
					disposeBitmapData(m_bmp8);
					disposeBitmapData(m_bmp9);
					
					m_bmp5.bitmapData = m_source;
					
					m_bmp5.width = m_width;
					m_bmp5.height = m_height;
				}
				
				if(isChanged(WIDTH) || 
					isChanged(HEIGHT))
				{
					m_bmp5.width = m_width;
					m_bmp5.height = m_height;
				}
			}
		}
		
		private function disposeBitmapData(bmp:Bitmap):void
		{
			if(bmp == null) return;
			
			var bmd:BitmapData = bmp.bitmapData;
			DisposeUtil.free(bmd);
			bmp.bitmapData = null;
			
			if(bmp.parent) bmp.parent.removeChild(bmp);
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function dispose():void
		{
			m_bmp1 = null;
			m_bmp2 = null;
			m_bmp3 = null;
			m_bmp4 = null;
			m_bmp5 = null;
			m_bmp6 = null;
			m_bmp7 = null;
			m_bmp8 = null;
			m_bmp9 = null;
			
			if(m_freeSource) DisposeUtil.free(m_source);
			m_source = null;
			m_scale9Insets = null;
			
			super.dispose();
		}
	}
}