package editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import jsion.core.encoders.JPGEncoder;
	import jsion.core.encoders.PNGEncoder;
	import jsion.utils.ScaleUtil;
	import jsion.utils.StringUtil;
	
	import org.aswing.AbstractButton;
	import org.aswing.AssetBackground;
	import org.aswing.ButtonGroup;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JProgressBar;
	import org.aswing.JRadioButton;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	import org.aswing.ext.Form;

	public class MapCut extends JsionEditorWin
	{
		private var _fileName:JTextField;
		private var openBtn:JButton;
		
		private var _codetype_png:JRadioButton;
		private var _codetype_jpg:JRadioButton;
		
		private var _progressbar:JProgressBar;
		
		/**
		 * 缩略图
		 */ 
		private var _show:JPanel;
		
		/**
		 * 源数据
		 */ 
		private var _resource:Bitmap;
		private var smallMap:BitmapData;
		
		
		private var _winWidth:int = 250;
		private var _winHeight:int = 350;
		private var _boxHeight:int = 120;
		
		
		private var _loopx:uint;
		private var _loopy:uint;
		
		private var _making:Boolean;
		
		
		public function MapCut(owner:JsionMapEditor=null)
		{
			mytitle = "地图切割器";
			super(owner, true);
		}
		
		override protected function init():void
		{
			main = new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS, padding));
			
			_show = new JPanel();
			
			box = new Form();
			box.y = 10;
			
			_fileName = new JTextField("", 12);
			_fileName.setEditable(false);
			
			var lab0:JLabel = new JLabel("选择文件：");
			
			openBtn = new JButton("打开");
			openBtn.addActionListener(openMap);
			
			var lab1:JLabel = new JLabel("编码类型：");
			
			_codetype_png = new JRadioButton("PNG");
			_codetype_png.setHorizontalAlignment(AbstractButton.LEFT);
			_codetype_png.setPreferredWidth(80);
			_codetype_png.setSelected(true);
			_codetype_jpg = new JRadioButton("JPG");
			_codetype_jpg.setHorizontalAlignment(AbstractButton.LEFT);
			_codetype_jpg.setPreferredWidth(60);
			var gp:ButtonGroup = new ButtonGroup();
			gp.appendAll(_codetype_png, _codetype_jpg);
			var pane:JPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS));
			pane.appendAll(_codetype_png, _codetype_jpg);
			
			box.addRow(lab0, _fileName, openBtn);
			box.addRow(lab1, pane);
			box.setSizeWH(_winWidth, _boxHeight);
			main.setSizeWH(_winWidth, _winHeight);
			
			_progressbar = new JProgressBar(JProgressBar.HORIZONTAL);
			//_progressbar.setModel(new DefaultBoundedRangeModel(0,100));
			
			main.append(new JPanel());
			main.append(box);
			main.append(_progressbar);
			main.append(_show);
			//getContentPane().append(main);
			
			super.init();
		}
		
		private function openMap(e:Event):void
		{
			var file_open:File = File.desktopDirectory;
			file_open.browseForOpen('打开地图配置文件', [new FileFilter('图片', '*.jpg;*.gif;*.png' )] );
			file_open.addEventListener(Event.SELECT,onOpen);
		}
		
		private function onOpen(e:Event):void
		{
			var file:File = e.target as File;
			
			_fileName.setText(file.name);
			
			var fs:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();
			fs.open(file,FileMode.READ);
			fs.readBytes(bytes,0,fs.bytesAvailable);
			fs.close();
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onMapComplate);
			loader.loadBytes(bytes);
		}
		
		private function onMapComplate(e:Event):void
		{
			var target:LoaderInfo = e.target as LoaderInfo;
			_resource = target.loader.content as Bitmap;
			
			var _bWidth:int = main.width;//_winWidth - _padding * 2;
			var _bHeight:int = main.height - box.height - _progressbar.height - 5 - padding * 4;
			
			var scale:Number = ScaleUtil.calcScaleFullSize(_resource.width, _resource.height, _bWidth, _bHeight);
			
			var rltWidth:int = _resource.width * scale;
			var rltHeight:int = _resource.height * scale;
			
			if(smallMap != null) smallMap.dispose();
			smallMap = new BitmapData(_bWidth, _bHeight, true, 0);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			matrix.translate((_bWidth - rltWidth) / 2, (_bHeight - rltHeight) / 2);
			
			smallMap.draw(_resource, matrix);
			target.loader.unload();
			
			var bmp:Bitmap = new Bitmap(smallMap);
			_show.setPreferredWidth(bmp.width);
			_show.setPreferredHeight(bmp.height);
			_show.setSizeWH(bmp.width, bmp.height);
			_show.setBackgroundDecorator(new AssetBackground(bmp));
		}
		
		override public function closeReleased():void
		{
			if(_making) return;
			super.closeReleased();
		}
		
		override protected function onSubmit(e:Event):void
		{
			if(e == null)
			{
				//navigateToURL(new URLRequest(JsionEditor.EIDTOR_OUTPUT_ROOT));
				_making = false;
				super.onSubmit(null);
				return;
			}
			
			if(_resource == null || _making) return;
			
			_making = true;
			
			AbstractButton(e.currentTarget).setEnabled(false);
			_codetype_jpg.setEnabled(false);
			_codetype_png.setEnabled(false);
			openBtn.setEnabled(false);
			
			makeSmallMap();
			
			_loopx = _loopy = 0;
			
			var t:Timer = new Timer(1);
			t.addEventListener(TimerEvent.TIMER, makeFile);
			t.start();
		}
		
		private function makeSmallMap():void
		{
			var scale:Number = ScaleUtil.calcScaleFullSize(_resource.width, _resource.height, JsionEditor.SMALL_MAP_WIDTH, JsionEditor.SMALL_MAP_HEIGHT);
			
			var rltWidth:int = _resource.width * scale;
			var rltHeight:int = _resource.height * scale;
			
			var smallBmd:BitmapData = new BitmapData(JsionEditor.SMALL_MAP_WIDTH, JsionEditor.SMALL_MAP_HEIGHT, true, 0);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			matrix.translate((smallBmd.width - rltWidth) / 2, (smallBmd.height - rltHeight) / 2);
			
			smallBmd.draw(_resource, matrix);
			
			var mapid:String = JsionEditor.mapid;
			var dir:String = StringUtil.format(JsionEditor.MAP_OUTPUT_FORMAT, mapid);
			dir = new File(JsionEditor.MAP_OUTPUT_ROOT).resolvePath(dir).nativePath;
			var file:File = new File(dir);
			file.createDirectory();
			
			var extName:String;
			var bytes:ByteArray;
			
			if(_codetype_png.isSelected())
			{
				bytes = PNGEncoder.encode(smallBmd);
				extName = ".png";
			}
			else
			{
				var encoder:JPGEncoder = new JPGEncoder();
				bytes = encoder.encode(smallBmd);
				extName = ".jpg";
			}
			
			var smallFile:File = new File(file.resolvePath(JsionEditor.SMALLMAP_FILE_NAME + extName).nativePath);
			var fs:FileStream = new FileStream();
			fs.open(smallFile, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		private function makeFile(e:Event):void
		{
			var tile_max_x:uint = Math.ceil(JsionEditor.MAP_WIDTH / JsionEditor.TILE_WIDTH);
			var tile_max_y:uint = Math.ceil(JsionEditor.MAP_HEIGHT / JsionEditor.TILE_HEIGHT);
			
			var mapid:String = JsionEditor.mapid;
			var dir:String = StringUtil.format(JsionEditor.MAP_TILES_OUTPUT_FORMAT, mapid);
			dir = new File(JsionEditor.MAP_OUTPUT_ROOT).resolvePath(dir).nativePath;
			var file:File = new File(dir);
			file.createDirectory();
			
			var bmd:BitmapData = new BitmapData(JsionEditor.TILE_WIDTH, JsionEditor.TILE_HEIGHT, true, 0);
			var tileRect:Rectangle = new Rectangle(_loopx * JsionEditor.TILE_WIDTH, _loopy * JsionEditor.TILE_HEIGHT, JsionEditor.TILE_WIDTH, JsionEditor.TILE_HEIGHT);
			bmd.copyPixels(_resource.bitmapData, tileRect, Constant.ZeroPoint);
			
			var extName:String;
			var bytes:ByteArray;
			
			if(_codetype_png.isSelected())
			{
				bytes = PNGEncoder.encode(bmd);
				extName = ".png";
			}
			else
			{
				bytes = JPGEncoder.encode(bmd);
				extName = ".jpg";
			}
			
			var fs:FileStream = new FileStream();
			var filename:String = StringUtil.format(JsionEditor.MAP_TILES_FILENAME_FORMAT, _loopx, _loopy, extName);
			var writerFile:File = new File(file.resolvePath(filename).nativePath);
			
			fs.open(writerFile, FileMode.WRITE);
			fs.writeBytes(bytes, 0, bytes.bytesAvailable);
			fs.close();
			
			_progressbar.setValue(int(100 * (_loopy * tile_max_x + _loopx) / (tile_max_x * tile_max_y)));
			
			_loopx++;
			
			if(_loopx >= tile_max_x)
			{
				_loopx = 0;
				_loopy++;
				
				if(_loopy >= tile_max_y)
				{
					(e.target as Timer).stop();
					(e.target as Timer).removeEventListener(TimerEvent.TIMER,makeFile);
					onSubmit(null);
				}
			}
		}
		
		override public function dispose():void
		{
			_fileName = null;
			
			_codetype_jpg = null;
			
			_codetype_png = null;
			
			_show = null;
			
			openBtn = null;
			
			if(_resource) _resource.bitmapData.dispose();
			_resource = null;
			
			if(smallMap) smallMap.dispose();
			smallMap = null;
			
			super.dispose();
		}
	}
}