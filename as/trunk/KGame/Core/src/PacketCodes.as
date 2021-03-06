package
{
	public class PacketCodes
	{
		/**
		 * 转发给逻辑服务器
		 */		
		public static const LogicCode:int = 3;
		
		/**
		 * 重新连接其他网关服务器
		 */		
		public static const ReConnect:int = 1001;
		
		/**
		 * 服务器满载,无法继续连接.
		 */		
		public static const ServerBusies:int = 1002;
		
		/**
		 * 连接验证成功,通知客户端发送登陆包.
		 */		
		public static const NoticLogin:int = 1011;
		
		/**
		 * 登陆
		 */		
		public static const Login:int = 1012;
		
		/**
		 * 通知玩家角色注册
		 */		
		public static const NoticeRegist:int = 1013;
		
		/**
		 * 玩家角色注册(注册失败时以此协议返回)
		 */		
		public static const Regist:int = 1014;
		
		/**
		 * 被踢下线
		 */		
		public static const KitPlayer:int = 1015;
		
		/**
		 * 服务端消息
		 */		
		public static const ServerMsg:int = 10000;
		
		
		
		
		
		
		
		/**
		 * 玩家登陆信息
		 */		
		public static const LoginPlayer:int = 1101;
		/**
		 * 登陆玩家的英雄信息
		 */		
		public static const LoginHero:int = 1016;
		
		
		
		
		
		/**
		 * 刷新酒馆英雄
		 */		
		public static const RefreshTavernHeros:int = 1017;
		
		
		/**
		 * 举行派对
		 */		
		public static const Party:int = 1019;
		
		
		/**
		 * 招募英雄
		 */		
		public static const EmployHero:int = 1018;
		
		
		
		
		/**
		 * 升级建筑
		 */		
		public static const UpgradeBuilding:int = 1501;
		
		/**
		 * 建造建筑
		 */		
		public static const CreateBuilding:int = 1502;
	}
}