package knightage.core.net.handlers
{
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.PacketCodes;
	import knightage.core.net.SLGPacket;
	import knightage.core.net.SocketProxy;
	
	public class ReConnectGatewayHandler implements IPacketHandler
	{
		public function ReConnectGatewayHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.ReConnect;
		}
		
		public function handle(pkg:SLGPacket):void
		{
			t("重连网关服务器");
			
			var clientID:int = pkg.readInt();
			
			var ip:String = pkg.readUTF();
			
			var port:int = pkg.readInt();
			
			SocketProxy.forceConnect(ip, port);
		}
	}
}