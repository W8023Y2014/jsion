package jsion.rpg.engine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import jsion.loaders.BitmapDataLoader;
	import jsion.loaders.BytesLoader;
	import jsion.loaders.JsionLoader;
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.rpg.engine.datas.RPGInfo;
	import jsion.utils.DisposeUtil;
	import jsion.utils.PathUtil;
	
	public class RPGEngine extends RPGSprite
	{
		protected var m_bitmap:Bitmap;
		
		protected var m_camera:Rectangle;
		
		protected var m_waitingLayer:Sprite;
		
		
		protected var m_game:RPGGame;
		
		protected var m_rpgInfo:RPGInfo;
		
		protected var m_mapLoader:BytesLoader;
		
		protected var m_loader:BitmapDataLoader;
		
		protected var m_root:String;
		
		protected var m_mapID:int;
		
		protected var m_mapRoot:String;
		
		public function RPGEngine(w:int, h:int)
		{
			super();
			
			m_camera = new Rectangle(0, 0, w, h);
			
			intialize();
		}
		
		private function intialize():void
		{
			m_game = new RPGGame(m_camera.width, m_camera.height);
			
			m_bitmap = new Bitmap(m_game.bitmapData);
			
			m_waitingLayer = new Sprite();
			
			
			addChild(m_bitmap);
			addChild(m_waitingLayer);
		}
		
		public function get mapRoot():String
		{
			return m_mapRoot;
		}
		
		public function setCameraSize(w:int, h:int):void
		{
			m_camera.width = w;
			m_camera.height = h;
			
			m_game.setCameraSize(w, h);
			
			m_bitmap.bitmapData = m_game.bitmapData;
		}
		
		public function get game():RPGGame
		{
			return m_game;
		}
		
		public function setRoot(root:String = "Maps"):void
		{
			m_root = root;
		}
		
		public function setMapID(id:int):void
		{
			m_mapID = id;
			
			m_mapRoot = PathUtil.combinPath(m_root, m_mapID);
			
			loadMapInfo(id);
			
			showLoading();
		}
		
		private function loadMapInfo(id:int):void
		{
			DisposeUtil.free(m_mapLoader);
			m_mapLoader = new BytesLoader(id + ".map", m_mapRoot);
			m_mapLoader.tag = id;
			m_mapLoader.loadAsync(mapInfoLoadCallback);
		}
		
		private function mapInfoLoadCallback(loader:BytesLoader, success:Boolean):void
		{
			if(loader.status == JsionLoader.ERROR)
			{
				throw new Error("地图信息加载失败!");
				return;
			}
			
			var bytes:ByteArray = loader.data as ByteArray;
			
			m_rpgInfo = new RPGInfo();
			m_rpgInfo.mapRoot = m_root;
			
			var mapInfo:MapInfo = RPGGlobal.trans2MapInfo(bytes);
			m_rpgInfo.mapInfo = mapInfo;
			
			var root:String = PathUtil.combinPath(m_root, mapInfo.mapID);
			
			DisposeUtil.free(m_loader);
			
			if(mapInfo.mapType == MapInfo.TileMap)
			{
				m_loader = new BitmapDataLoader("small.jpg", root);
			}
			else
			{
				m_loader = new BitmapDataLoader("loop.jpg", root);
			}
			
			m_loader.loadAsync(smallMapLoadCallback);
		}
		
		private function smallMapLoadCallback(loader:BitmapDataLoader, success:Boolean):void
		{
			if(loader.status == JsionLoader.ERROR)
			{
				throw new Error("小地图或循环背景加载失败!");
				return;
			}
			
			if(loader.status == JsionLoader.COMPLETE)
			{
				m_rpgInfo.smallOrLoopBmd = BitmapData(loader.data).clone();
				
				m_game.setMap(m_rpgInfo);
				
				onSmallMapLoadComplete();
			}
			
			hideLoading();
		}
		
		protected function onSmallMapLoadComplete():void { }
		
		public function showLoading():void
		{
			trace("正在加载地图数据...");
			m_waitingLayer.graphics.clear();
			m_waitingLayer.graphics.beginFill(0x0);
			m_waitingLayer.graphics.drawRect(0, 0, m_camera.width, m_camera.height);
			m_waitingLayer.graphics.endFill();
		}
		
		public function hideLoading():void
		{
			trace("地图数据加载完成...");
			m_waitingLayer.graphics.clear();
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, __enterFrameHandler);
		}
		
		private function __enterFrameHandler(e:Event):void
		{
			m_game.render();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}