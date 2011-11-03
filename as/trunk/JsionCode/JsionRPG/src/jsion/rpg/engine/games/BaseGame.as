package jsion.rpg.engine.games
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import jsion.rpg.engine.datas.MapConfig;
	import jsion.rpg.engine.gameobjects.BuildingObject;
	import jsion.rpg.engine.gameobjects.GameObject;
	import jsion.rpg.engine.graphics.GraphicInfo;
	import jsion.rpg.engine.graphics.GraphicResource;
	import jsion.rpg.engine.renders.RenderStatic;
	import jsion.utils.ArrayUtil;

	public class BaseGame implements IDispose
	{
		/**
		 * 所有对象列表
		 */		
		protected var m_objects:Array;
		
		/**
		 * 渲染游戏对象列表(动态变化的)
		 */		
		protected var m_renders:Array;
		
		/**
		 * 成像区，直接用于Bitmap.bitmapData。
		 */		
		protected var m_buffer:BitmapData;
		
		protected var m_worldMap:BaseMap;
		
		protected var m_renderBuilding:RenderStatic;
		
		protected var m_gameWidth:int;
		
		protected var m_gameHeight:int;
		
		protected var m_mapConfig:MapConfig;
		
		protected var m_mapsRoot:String;
		
		protected var m_smallMapBmd:BitmapData;
		
		public function BaseGame(w:int, h:int, mapConfig:MapConfig, mapsRoot:String, smallMapBmd:BitmapData)
		{
			m_gameWidth = w;
			m_gameHeight = h;
			
			m_mapConfig = mapConfig;
			m_mapsRoot = mapsRoot;
			m_smallMapBmd = smallMapBmd;
			
			initialize();
		}
		
		protected function initialize():void
		{
			m_objects = [];
			
			m_renders = [];
			
			buildBuffer();
		}
		
		protected function buildBuffer():void
		{
			m_buffer = new BitmapData(m_gameWidth, m_gameHeight, true, 0);
		}
		
		public function render():void
		{
			//TODO:脏矩形渲染所有objectes或renders对象
			var object:GameObject;
			
			m_objects.sortOn("zOrder", Array.NUMERIC);
			
			for each(object in m_objects)
			{
				object.clearMe();
			}
			
			for each(object in m_objects)
			{
				object.renderMe();
			}
		}
		
		public function setCameraWH(w:int, h:int):void
		{
			if(w <= 0 || h <= 0) return;
			
			if(m_gameWidth == w && m_gameHeight == h) return;
			
			m_gameWidth = w;
			m_gameHeight = h;
			
			var temp:BitmapData = m_buffer;
			
			buildBuffer();
			
			if(temp)
			{
				m_buffer.lock();
				m_buffer.copyPixels(temp, temp.rect, Constant.ZeroPoint);
				m_buffer.unlock();
			}
			
			m_worldMap.setCameraWH(w, h);
			
			temp.dispose();
		}
		
		public function get gameWidth():int
		{
			return m_gameWidth;
		}
		
		public function get gameHeight():int
		{
			return m_gameHeight;
		}
		
		public function get buffer():BitmapData
		{
			return m_buffer;
		}
		
		public function get worldMap():BaseMap
		{
			return m_worldMap;
		}
		
		public function addObject(o:GameObject):void
		{
			if(m_objects.indexOf(o) != -1) return;
			
			m_objects.push(o);
		}
		
		public function removeObject(o:GameObject):void
		{
			ArrayUtil.remove(m_objects, o);
		}
		
		public function createBuilding(info:GraphicInfo, pos:Point):BuildingObject
		{
			var bo:BuildingObject = new BuildingObject();
			bo.game = this;
			bo.render = m_renderBuilding;
			
			var grap:GraphicResource = new GraphicResource(this);
			grap.frameWidth = info.frameWidth;
			grap.frameHeight = info.frameHeight;
			grap.offsetX = info.offsetX;
			grap.offsetY = info.offsetY;
			grap.frameTotal = info.frameTotal;
			grap.fps = info.fps;
			grap.path = info.path;
			grap.filename = info.filename;
			bo.graphicResource = grap;
			grap.loadBitmapData();
			
			bo.setPos(pos.x, pos.y);
			
			return bo;
		}
		
		public function dispose():void
		{
		}
	}
}