package jsion.core.compress
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import jsion.HashMap;
	import jsion.utils.ArrayUtil;

	public class PNGCompress
	{
//		private var m_header:ByteArray;
//		
//		private var m_images:Array;
//		
//		private var m_needWrite:Boolean;
//		
//		private var m_indexColors:Array;
//		
//		private var m_replaceColors:HashMap;
//		
//		private var m_actionMap:HashMap;
//		
//		public function PNGCompress()
//		{
//			m_header = new ByteArray();
//			m_images = [];
//			
//			m_needWrite = false;
//			
//			m_indexColors = [];
//			
//			m_replaceColors = new HashMap();
//			
//			m_actionMap = new HashMap();
//		}
//		
//		public function addPNG(data:PNGData):void
//		{
//			if(data == null || data.bitmapData == null) return;
//			
//			m_images.push(data);
//			
//			var map:HashMap = m_actionMap.get(data.action);
//			
//			if(map == null)
//			{
//				map = new HashMap();
//				m_actionMap.put(data.action, map);
//			}
//			
//			var list:Array = map.get(data.direction);
//			
//			if(list == null)
//			{
//				list = [];
//				map.put(data.direction, list);
//			}
//			
//			list.push(data);
//		}
//		
//		public function compress():ByteArray
//		{
//			var imgs:Array = [];
//			for each(var data:PNGData in m_images)
//			{
//				if(data.bitmapData)
//				{
//					imgs.push(data.bitmapData);
//				}
//			}
//			
//			getColorsIndex(imgs, m_indexColors, m_replaceColors);
//			
//			var bytes:ByteArray = new ByteArray();
//			writeBytes(bytes);
//			
//			return bytes;
//		}
//		
//		public function save():void
//		{
//			
//		}
//		
//		/**
//		 * 获取所有图像的索引颜色和替换颜色
//		 * @param imgs 图像列表
//		 * @param indexColors 索引颜色
//		 * @param replaceColors 替换颜色
//		 * 
//		 */		
//		private function getColorsIndex(imgs:Array, indexColors:Array, replaceColors:HashMap):void
//		{
//			ArrayUtil.removeAll(indexColors);
//			replaceColors.removeAll();
//			
//			//遍历所有图像数据并统计所有颜色的使用频率
//			var colorsIndex65535:Array = [];
//			
//			for(var i:int = 0; i < imgs.length; i++)
//			{
//				var bmd:BitmapData = imgs[i] as BitmapData;
//				
//				var rect:Rectangle = bmd.getColorBoundsRect(0xFF000000, 0x00000000, false);
//				
//				if(rect.width == 0 || rect.height == 0)
//				{
//					rect.width = bmd.width;
//					rect.height = bmd.height;
//				}
//				
//				var w1:int = rect.x + rect.width;
//				var h1:int = rect.y + rect.height;
//				
//				for(var y:int = rect.y; y < h1; y++)
//				{
//					for(var x:int = rect.x; x < w1; x++)
//					{
//						var color:uint = bmd.getPixel32(x, y);
//						
//						var a:int = color >> 28 & 0xF;
//						var r:int = color >> 20 & 0xF;
//						var g:int = color >> 12 & 0xF;
//						var b:int = color >> 4  & 0xF;
//						
//						var indexColor:int = a << 12;
//						indexColor |= (r << 8);
//						indexColor |= (g << 4);
//						indexColor |= b;
//						
//						if(colorsIndex65535[indexColor] == null)
//						{
//							colorsIndex65535[indexColor] = 1;
//						}
//						else
//						{
//							colorsIndex65535[indexColor] += 1;
//						}
//					}
//				}
//			}
//			
//			//遍历出所有被使用的颜色值列表
//			var indexColorsMap:HashMap = new HashMap();
//			var orderList:Array = [];
//			
//			for(var j:int = 0; j < 65536; j++)
//			{
//				if(colorsIndex65535[j] != null && colorsIndex65535[j] > 0)
//				{
//					indexColorsMap.put(j, colorsIndex65535[j]);
//					orderList.push({color: j, count: colorsIndex65535[j]});
//				}
//			}
//			
//			orderList.sortOn("count", Array.NUMERIC | Array.DESCENDING);
////			var minUseCount:int = orderList[249].count as int;//后250个使用次数中最小的次数
//			
//			var indexColorsCount:int = 0;
//			
//			for (var k:int = 0; k < orderList.length; k++)
//			{
//				var obj:Object = orderList[k];
//				
//				if(indexColorsCount < 250)// && obj.count >= minUseCount)
//				{
//					indexColors[k] = obj.color;
//					indexColorsCount++;
//				}
//				else
//				{
//					replaceColors.put(obj.color, obj.count);
//				}
//			}
//			
////			//生成索引颜色列表和需要替换的颜色列表
////			var useCountList:Array = indexColorsMap.getValues();//使用次数列表
////			useCountList.sort(Array.NUMERIC);//升序排列使用次数
////			
////			var colorsList:Array = indexColorsMap.getKeys();//颜色列表
////			//var indexColors:Array = [];//索引颜色列表
////			//var replaceColors:HashMap = new HashMap();//需要替换的颜色列表
////			for each(var c:uint in colorsList)
////			{
////				var colorUseCount:int = indexColorsMap.get(c);
////				
////				if(indexColorsCount < 250 && colorUseCount >= minUseCount)
////				{
////					indexColors[indexColorsCount] = c;
////					indexColorsCount++;
////				}
////				else
////				{
////					replaceColors.put(c, colorUseCount);
////				}
////			}
//			
//			//找出替换颜色
//			var replaceColorsList:Array = replaceColors.getKeys();
//			
//			var a1:uint, r1:uint, g1:uint, b1:uint;
//			var a2:uint, r2:uint, g2:uint, b2:uint;
//			var a3:uint, r3:uint, g3:uint, b3:uint;
//			var maxer:int = 256, n:int = 0;
//			for each(var rColor:uint in replaceColorsList)
//			{
//				a1 = rColor >>> 12 << 4 & 0xFF;
//				r1 = rColor >>> 8 << 4 & 0xFF;
//				g1 = rColor >>> 4 << 4 & 0xFF;
//				b1 = rColor >>> 0 << 4 & 0xFF;
//				
//				for(var m:int = 0; m < 250; m++)
//				{
//					var tmpColor:uint = indexColors[m];
//					
//					a2 = tmpColor >>> 12 << 4 & 0xFF;
//					r2 = tmpColor >>> 8 << 4 & 0xFF;
//					g2 = tmpColor >>> 4 << 4 & 0xFF;
//					b2 = tmpColor >>> 0 << 4 & 0xFF;
//					
//					a3 = Math.abs(a2 - a1);
//					r3 = Math.abs(r2 - r1);
//					g3 = Math.abs(g2 - g1);
//					b3 = Math.abs(b2 - b1);
//					
//					var tmp:int = Math.max(a3, r3, g3, b3);
//					
//					if(tmp < maxer)
//					{
//						maxer = tmp;
//						n = m;
//					}
//				}
//				//Key:原颜色，Value：替换后的颜色
//				replaceColors.put(rColor, indexColors[n]);
//			}
//		}
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		
//		private function writeBytes(bytes:ByteArray):void
//		{
//			//文件头
//			var headerBytes:ByteArray = new ByteArray();
//			headerBytes.writeByte(74);
//			headerBytes.writeByte(83);
//			headerBytes.writeByte(73);
//			headerBytes.writeByte(79);
//			headerBytes.writeByte(78);
//			
//			//索引色数据
//			var indexBytes:ByteArray = new ByteArray();
//			
//			for(var i:int = 0; i < m_indexColors.length; i++)
//			{
//				var color:uint = m_indexColors[i];
//				
//				indexBytes.writeShort(color);
//			}
//			
//			//动作数据
//			var actionBytesList:Array = [];
//			getActionBytesList(actionBytesList);
//			
//			//清空字节流
//			bytes.length = 0;
//			bytes.position = 0;
//			
//			//写入文件头
//			bytes.writeBytes(headerBytes, 0, headerBytes.length);
//			//写入索引颜色数据
//			bytes.writeByte(m_indexColors.length);
//			bytes.writeBytes(indexBytes, 0, indexBytes.length);
//			
//			//写入动作数据
//			bytes.writeByte(actionBytesList.length);//动作数量
//			for(var j:int = 0; j < actionBytesList.length; j++)//循环写入动作数据
//			{
//				var bas:ByteArray = actionBytesList[j] as ByteArray;
//				bas.position = 0;
//				bytes.writeUnsignedInt(bas.length);
//				bytes.writeBytes(bas, 0, bas.length);
//			}
//		}
//		
//		private function getActionBytesList(list:Array):void
//		{
//			var actionKeys:Array = m_actionMap.getKeys();
//			
//			for each(var actionKey:int in actionKeys)
//			{
//				var bytes:ByteArray = new ByteArray();
//				
//				list.push(bytes);
//				
//				bytes.writeByte(actionKey);//动作编号
//				
//				var dirMap:HashMap = m_actionMap.get(actionKey) as HashMap;
//				var dirKeys:Array = dirMap.getKeys();
//				
//				for each(var dirKey:int in dirKeys)
//				{
//					var ba:ByteArray = new ByteArray();
//					var dataList:Array = dirMap.get(dirKey);
//					var data:PNGData = PNGData(dataList[0]);
//					ba.writeByte(dirKey);//动作方向
//					ba.writeByte(dataList.length);//动作帧数
//					ba.writeShort(data.bitmapData.width);//帧宽度
//					ba.writeShort(data.bitmapData.height);//帧高度
//					
//					for(var i:int = 0; i < dataList.length; i++)
//					{
//						data = dataList[i] as PNGData;
//						
//						var rect:Rectangle = data.bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
//						
//						if(rect.width == 0 || rect.height == 0)
//						{
//							rect.width = data.bitmapData.width - rect.x;
//							rect.height = data.bitmapData.height - rect.y;
//						}
//						
//						var lenPos:int = ba.position;
//						ba.writeUnsignedInt(0);//预留图像数据长度位
//						ba.writeShort(rect.x);//图像有效像素相对于图像(0, 0)点的x偏移量
//						ba.writeShort(rect.y);//图像有效像素相对于图像(0, 0)点的y偏移量
//						ba.writeShort(rect.width);
//						ba.writeShort(rect.height);
//						
//						var w1:int = rect.x + rect.width;
//						var h1:int = rect.y + rect.height;
//						
//						var pngBytes:ByteArray = new ByteArray();
//						
//						for(var y:int = rect.y; y < h1; y++)
//						{
//							for(var x:int = rect.x; x < w1; x++)
//							{
//								var color:uint = data.bitmapData.getPixel32(x, y);
//								
//								var a:int = color >> 28 & 0xF;
//								var r:int = color >> 20 & 0xF;
//								var g:int = color >> 12 & 0xF;
//								var b:int = color >> 4  & 0xF;
//								
//								var indexColor:int = a << 12;
//								indexColor |= (r << 8);
//								indexColor |= (g << 4);
//								indexColor |= b;
//								
//								if(m_replaceColors.containsKey(indexColor))
//								{
//									indexColor = m_replaceColors.get(indexColor);
//								}
//								
//								var index:int = m_indexColors.indexOf(indexColor);
//								
//								if(index != -1)
//								{
//									pngBytes.writeByte(index);
//								}
//								else
//								{
//									throw new VerifyError("Not found index color.");
//								}
//							}
//						}
//						
//						pngBytes.position = 0;
//						var isn:Boolean = false;
//						var isnNum:int = 0;
//						var oldPos:uint = ba.position;
//						while(pngBytes.bytesAvailable > 0)
//						{
//							var inde:uint = pngBytes.readUnsignedByte();
//							var colr:uint = m_indexColors[inde];
//							var a1:uint = colr >> 12 & 0xF;
//							
//							if(a1 == 0x0)
//							{
//								if(isn == false)
//								{
//									isn = true;
//									isnNum = 1;
//								}
//								else
//								{
//									isnNum += 1;
//								}
//							}
//							else
//							{
//								if(isn)
//								{
//									isn = false;
//									
//									if(isnNum > 255)
//									{
//										ba.writeByte(255);
//										ba.writeShort(isnNum);
//									}
//									else
//									{
//										ba.writeByte(254);
//										ba.writeByte(isnNum);
//									}
//								}
//								
//								ba.writeByte(inde);
//							}
//						}
//						
//						var bytesCount:uint = ba.position - oldPos;
//						ba.position = lenPos;
//						ba.writeUnsignedInt(bytesCount);
//						ba.position = ba.length;
//					}
//					
//					bytes.writeUnsignedInt(ba.length);
//					bytes.writeBytes(ba, 0, ba.length);
//				}
//			}
//		}
	}
}