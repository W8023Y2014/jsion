package core.net
{
	import jsion.debug.DEBUG;
	import jsion.events.SocketEvent;
	import jsion.socket.IPacketCryptor;
	import jsion.socket.PacketFactory;
	import jsion.socket.PacketSocket;
	import jsion.utils.DisposeUtil;
	
	public class SocketProxy
	{
		private static var m_socket:PacketSocket;
		
		public static function setPacketClass(cls:Class):void
		{
			PacketFactory.setPacketClass(cls);
		}
		
		public static function setSendCryptor(cryptor:IPacketCryptor):void
		{
			PacketFactory.setSendCryptor(cryptor);
		}
		
		public static function setReceiveCryptor(cryptor:IPacketCryptor):void
		{
			PacketFactory.setReceiveCryptor(cryptor);
		}
		
		public static function connect(ip:String, port:int):void
		{
			if(m_socket) return;
			
			m_socket = new PacketSocket(ip, port);
			
			m_socket.connect();
			
			addSocketEvent(m_socket);
		}
		
		private static function addSocketEvent(socket:PacketSocket):void
		{
			if(socket == null) return;
			
			socket.addEventListener(SocketEvent.CONNECTED, __connectedHandler);
			socket.addEventListener(SocketEvent.CLOSED, __closedHandler);
			socket.addEventListener(SocketEvent.ERROR, __erroredHandler);
			socket.addEventListener(SocketEvent.RECEIVED, __receivedHandler);
		}
		
		private static function removeSocketEvent(socket:PacketSocket):void
		{
			if(socket == null) return;
			
			socket.removeEventListener(SocketEvent.CONNECTED, __connectedHandler);
			socket.removeEventListener(SocketEvent.CLOSED, __closedHandler);
			socket.removeEventListener(SocketEvent.ERROR, __erroredHandler);
			socket.removeEventListener(SocketEvent.RECEIVED, __receivedHandler);
		}
		
		private static function __receivedHandler(e:SocketEvent):void
		{
			// TODO Auto-generated method stub
			
			PacketHandlers.receivePacket(e.eData as GamePacket);
		}
		
		private static function __erroredHandler(e:SocketEvent):void
		{
			// TODO Auto-generated method stub
			
			DEBUG.error("连接错误!");
		}
		
		private static function __closedHandler(e:SocketEvent):void
		{
			// TODO Auto-generated method stub
			
			DEBUG.error("连接关闭!");
		}
		
		private static function __connectedHandler(e:SocketEvent):void
		{
			// TODO Auto-generated method stub
			
			DEBUG.error("已连接!");
		}
		
		public static function sendTCP(pkg:GamePacket):void
		{
			if(m_socket && m_socket.isConnected) m_socket.send(pkg);
		}
		
		public static function forceConnect(ip:String, port:int):void
		{
			removeSocketEvent(m_socket);
			
			DisposeUtil.free(m_socket);
			m_socket = null;
			
			connect(ip, port);
		}
		
		public static function close():void
		{
			if(m_socket && m_socket.isConnected) m_socket.close();
		}
	}
}