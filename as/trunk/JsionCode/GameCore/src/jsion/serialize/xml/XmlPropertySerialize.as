package jsion.serialize.xml
{
	import flash.utils.*;
	
	import jsion.utils.*;
	/**
	 * XML序列化属性为Xml属性
	 * @author Jsion
	 * 
	 */	
	public class XmlPropertySerialize implements IXmlSerialize
	{
		private var transfer:XmlPropertyTransfer;
		
		public function XmlPropertySerialize()
		{
			transfer = new XmlPropertyTransfer();
		}
		
		/**
		 * 序列化指定对象为Xml
		 * @param nodeName Xml节点名称
		 * @param obj 要序列化的对象
		 * @return 序列化后的Xml对象
		 */		
		public function encode(nodeName:String, obj:Object):XML
		{
			var rlt:String = "<" + nodeName + " ";
			
			var describe:XML = describeType(obj);
			
			for each ( var v:XML in describe..*.( name() == "variable" || name() == "accessor" ) )
			{
				var n:String = v.@name.toString();
				rlt += transfer.encodingProperty(n, obj[n]);
			}
			
			rlt += "/>";
			
			return new XML(rlt);
		}
		
		/**
		 * 反序列化Xml到指定对象
		 * @param obj 反序列化到的目标对象
		 * @param xml 要反序列化的Xml
		 */		
		public function decode(obj:Object, xml:XML):void
		{
			var attributes:XMLList = xml.attributes();
			var tmp:Object = {};
			var x:XML;
			for each(x in attributes)
			{
				tmp[String(x.name())] = String(x);
			}
			
			
			var xl:XMLList = describeType(obj)..*.(name() == "variable" || name() == "accessor");
			for each(x in xl)
			{
				var t:String = String(x.@type);
				var n:String = String(x.@name);
				transfer.decodingProperty(obj, tmp, n, t);
			}
		}
	}
}