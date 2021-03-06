package jsion.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import jsion.*;
	import jsion.ui.borders.IBorder;
	import jsion.utils.AppDomainUtil;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	public class UIResources implements IUIResources
	{
		private var list:HashMap;
		
		public function UIResources()
		{
			list = new HashMap();
		}
		
		public function putResources(keyValueList:Array):void
		{
			for(var i:Number = 0; i < keyValueList.length; i += 2)
			{
				list.put(keyValueList[i], keyValueList[i + 1]);
			}
		}
		
		public function containsResourceKey(key:String):Boolean
		{
			return list.containsKey(key);
		}
		
		public function getUI(target:Component):IComponentUI
		{
			var ui:IComponentUI = getInstance(target.UIClassID) as IComponentUI;
			
			if(ui == null)
			{
				var cls:Class = target.getUIDefaultBasicClass();
				if(cls) ui = getCreateInstance(cls) as IComponentUI;
			}
			
			return ui;
		}
		
		public function getBoolean(key:String):Boolean
		{
			return list.get(key) as Boolean;
		}
		
		public function getNumber(key:String):Number
		{
			return list.get(key) as Number;
		}
		
		public function getInt(key:String):int
		{
			return list.get(key) as int;
		}
		
		public function getUint(key:String):uint
		{
			return list.get(key) as uint;
		}
		
		public function getString(key:String):String
		{
			return list.get(key) as String;
		}
		
		public function getBorder(key:String):IBorder
		{
			var border:IBorder = getInstance(key) as IBorder;
			
			if(border == null)
			{
				border = DefaultRes.DEFAULT_BORDER; //make it to be an ui resource then can override by next LAF
			}
			
			return border;
		}
		
		public function getIcon(key:String):IICON
		{
			var icon:IICON = getInstance(key) as IICON;
			
			if(icon == null)
			{
				icon = DefaultRes.DEFAULT_ICON;
			}
			
			return icon;
		}
		
		public function getGroundDecorator(key:String):IGroundDecorator
		{
			var gd:IGroundDecorator = getInstance(key) as IGroundDecorator;
			
			if(gd == null)
			{
				gd = DefaultRes.DEFAULT_GROUNDDECORATOR;
			}
			
			return gd;
		}
		
		public function getColor(key:String):ASColor
		{
			var color:ASColor = getInstance(key) as ASColor;
			
			if(color == null)
			{
				color = DefaultRes.DEFAULT_COLOR;
			}
			
			return color;
		}
		
		public function getFont(key:String):ASFont
		{
			var font:ASFont = getInstance(key) as ASFont;
			
			if(font == null)
			{
				font = DefaultRes.DEFAULT_FONT;
			}
			
			return font;
		}
		
		public function getInsets(key:String):Insets
		{
			var insets:Insets = getInstance(key) as Insets;
			
			if(insets == null)
			{
				insets = DefaultRes.DEFAULT_INSETS;
			}
			
			return insets;
		}
		
		public function getStyleTune(key:String):StyleTune
		{
			var st:StyleTune = getInstance(key) as StyleTune;
			
			if(st == null)
			{
				st = DefaultRes.DEFAULT_STYLE_TUNE;
			}
			
			return st;
		}
		
		public function getConstructor(key:String):Class
		{
			var obj:Object = list.get(key);
			
			var cls:Class;
			
			if(obj is String)
			{
				cls = AppDomainUtil.getClass(obj as String);
			}
			else
			{
				cls = obj as Class;
			}
			
			return cls;
		}
		
		public function getBitmapData(key:String):BitmapData
		{
			if(StringUtil.isNullOrEmpty(key)) return null;
			
			var value:* = list.get(key);
			
			if(value is Class)
			{
				return getCreateBitmapData(value as Class);
			}
			
			return value as BitmapData;
		}
		
		public function getDisplayObject(key:String):DisplayObject
		{
			if(StringUtil.isNullOrEmpty(key)) return null;
			
			var obj:DisplayObject;
			
			var value:* = list.get(key);
			
			if(value is Class)
			{
				try
				{
					obj = getCreateInstance(value as Class) as DisplayObject;
				}
				catch(err:Error)
				{
					var bmp:Bitmap = new Bitmap(getBitmapData(key))
					bmp.smoothing = true;
					obj = bmp;
				}
			}
			else if(value is BitmapData)
			{
				return new Bitmap(value);
			}
			else
			{
				obj = value as DisplayObject;
			}
			
			return obj;
		}
		
		public function getInstance(key:String):*
		{
			if(StringUtil.isNullOrEmpty(key)) return null;
			
			var value:* = list.get(key);
			
			if(value is Class)
			{
				return getCreateInstance(value as Class);
			}
			
			return value;
		}
		
		private function getCreateInstance(constructor:Class):Object
		{
			return new constructor();
		}
		
		private function getCreateBitmapData(constructor:Class):BitmapData
		{
			return new constructor(0, 0);
		}
		
		public function dispose():void
		{
			DisposeUtil.free(list);
			list = null;
		}
	}
}