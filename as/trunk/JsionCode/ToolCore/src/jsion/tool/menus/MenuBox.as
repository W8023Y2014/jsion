package jsion.tool.menus
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import jsion.rpg.RPGGlobal;
	import jsion.rpg.engine.datas.MapInfo;
	import jsion.tool.BaseFrame;
	import jsion.tool.ToolGlobal;
	import jsion.tool.compresses.CompressPane;
	import jsion.tool.mapeditor.CreateFrame;
	import jsion.tool.mapeditor.MapFrame;
	import jsion.tool.mapeditor.datas.MapData;
	import jsion.tool.mgrs.FileMgr;
	import jsion.tool.piccuter.PicCuterFrame;
	import jsion.tool.pngpacker.PackerFrame;
	import jsion.tool.uieditor.UIEditorFrame;
	import jsion.tool.unicode.TransfPane;
	import jsion.tool.xmlformats.XmlFormatPane;
	import jsion.utils.ObjectUtil;
	
	import mx.managers.PopUpManager;
	
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.event.AWEvent;
	
	public class MenuBox extends JMenuBar
	{
		public function MenuBox()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			var tool:JMenu = new JMenu("工具(&T)");
			
			var item:JMenuItem;
			
			
			item = new JMenuItem("Unicode转换");
			item.setPreferredWidth(150);
			item.addActionListener(onUnicodeClickHandler);
			tool.append(item);
			
			item = new JMenuItem("UI编辑器");
			item.addActionListener(onUIEditorClickHandler);
			tool.append(item);
			
			item = new JMenuItem("资源打包器");
			item.addActionListener(onPackerClickHandler);
			tool.append(item);
			
			item = new JMenuItem("文件压缩");
			item.addActionListener(onCompressHandler);
			tool.append(item);
			
			item = new JMenuItem("XML格式化");
			item.addActionListener(onXmlFormatHandler);
			tool.append(item);
			
			item = new JMenuItem("切割图片");
			item.addActionListener(onCutPicHandler);
			tool.append(item);
			
			item = new JMenuItem("打开地图");
			item.addActionListener(onOpenMapHandler);
			tool.append(item);
			
			item = new JMenuItem("新建地图");
			item.addActionListener(onCreateMapHandler);
			tool.append(item);
			
			append(tool);
		}
		
		private function onUnicodeClickHandler(e:AWEvent):void
		{
			PopUpManager.createPopUp(ToolGlobal.windowedApp, TransfPane, true);
		}
		
		private function onUIEditorClickHandler(e:AWEvent):void
		{
			new UIEditorFrame().show();
		}
		
		private function onPackerClickHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PackerFrame();
			
			frame.show();
		}
		
		private function onCompressHandler(e:AWEvent):void
		{
			//ToolGlobal.dragDropCompress = PopUpManager.createPopUp(ToolGlobal.windowedApp, CompressPane, true);
			PopUpManager.createPopUp(ToolGlobal.windowedApp, CompressPane, true);
		}
		
		private function onXmlFormatHandler(e:AWEvent):void
		{
			//ToolGlobal.xmlFormater = PopUpManager.createPopUp(ToolGlobal.windowedApp, XmlFormatPane, true);
			PopUpManager.createPopUp(ToolGlobal.windowedApp, XmlFormatPane, true);
		}
		
		private function onCutPicHandler(e:AWEvent):void
		{
			var frame:BaseFrame = new PicCuterFrame();
			
			frame.show();
		}
		
		private function onOpenMapHandler(e:AWEvent):void
		{
			FileMgr.openBrowse(onOpenMapCallback, null, [new FileFilter("地图信息文件", "*.map")]);
		}
		
		private function onOpenMapCallback(file:File):void
		{
			var bytes:ByteArray = new ByteArray();
			
			var fs:FileStream = new FileStream();
			
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			
			var mapRoot:String = file.nativePath.replace(/([0-9]+)\\([0-9]+).map$/, "");
			
			var mapInfo:MapInfo = RPGGlobal.trans2MapInfo(bytes);
			
			var md:MapData = new MapData();
			ObjectUtil.copyToTarget2(mapInfo, md);
			md.mapRoot = mapRoot;
			showMapFrame(md);
		}
		
		private function showMapFrame(mapInfo:MapData):void
		{
			var frame:MapFrame = new MapFrame();
			frame.setMap(mapInfo);
			frame.show();
		}
		
		private function onCreateMapHandler(e:AWEvent):void
		{
			var frame:CreateFrame = new CreateFrame(true);
			
			frame.setCreateCallback(showMapFrame);
			
			frame.show();
		}
	}
}