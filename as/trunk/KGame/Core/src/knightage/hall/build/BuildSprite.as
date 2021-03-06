package knightage.hall.build
{
	import core.net.SocketProxy;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import jsion.IDispose;
	import jsion.display.Button;
	import jsion.utils.DisposeUtil;
	import jsion.utils.InstanceUtil;
	
	import knightage.GameUtil;
	import knightage.StaticConfig;
	import knightage.StaticRes;
	import knightage.display.Frame;
	import knightage.events.PlayerEvent;
	import knightage.hall.tavern.TavernUIView;
	import knightage.mgrs.MsgTipMgr;
	import knightage.mgrs.PlayerMgr;
	import knightage.mgrs.VisitMgr;
	import knightage.net.packets.build.CreateBuildingPacket;
	import knightage.net.packets.build.UpgradeBuildingPacket;
	import knightage.player.GamePlayer;
	import knightage.templates.BuildTemplate;
	
	public class BuildSprite extends Sprite implements IDispose
	{
		private var m_type:int;
		
		private var m_buildView:BuildView;
		
		private var m_createButton:Button;
		
		private var m_upgradeButton:Button;
		
		private var m_player:GamePlayer;
		
		public function BuildSprite(gp:GamePlayer, type:int)
		{
			m_player = gp;
			
			m_type = type;
			
			super();
			
			initialized();
		}
		
		public function get buildType():int
		{
			return m_type;
		}

		private function initialized():void
		{
			m_buildView = new BuildView(m_player, m_type);
			addChild(m_buildView);
			m_buildView.addEventListener(MouseEvent.CLICK, __buildClickHandler);
			
			var template:BuildTemplate = GameUtil.getBuildTemplate(m_player, m_type);
			
			if(template)
			{
				x = template.PosX;
				y = template.PosY;
			}
			
			checkCreateOrUpgrade(m_type);
			
			PlayerMgr.addEventListener(PlayerEvent.BUILD_UPGRADE, __buildChangeHandler);
		}
		
		private function __buildChangeHandler(e:PlayerEvent):void
		{
			var t:int = e.data as int;
			
			if(t == m_type)
			{
				m_buildView.loadBuildRes();
			}
			
			checkCreateOrUpgrade(m_type);
		}
		
		
		
		
		private function checkCreateOrUpgrade(type:int):void
		{
			if(VisitMgr.isSelf == false) return;
			
			var template:BuildTemplate = GameUtil.getBuildTemplate(m_player, type);
			
			var castleTemplate:BuildTemplate = GameUtil.getBuildTemplate(m_player, BuildType.Castle);
			
			if(template == null)
			{
				var canShowCreateBtn:Boolean = false;
				
				template = GameUtil.getBuildFirstLvTemplate(type);
				
				if(template == null)
				{
					canShowCreateBtn = false;
				}
				else if(type == BuildType.Castle)
				{
					if(template.NeedMoney <= PlayerMgr.self.coins && StaticConfig.CastleUpGradeExp[template.Lv] <= PlayerMgr.self.experience)
					{
						canShowCreateBtn = true;
					}
				}
				else if(castleTemplate && template.NeedCastleLv < castleTemplate.Lv && template.NeedMoney <= PlayerMgr.self.coins)
				{
					canShowCreateBtn = true;
				}
				
				if(canShowCreateBtn)
				{
					if(m_createButton == null)
					{
						m_createButton = new Button();
						m_createButton.beginChanges();
						m_createButton.freeBMD = false;
						m_createButton.upImage = new Bitmap(StaticRes.BuildCreateBMD);
						m_createButton.commitChanges();
						addChild(m_createButton);
						
						m_createButton.x = -int(m_createButton.width / 2);
						m_createButton.y = -int(m_createButton.height);
						
						m_createButton.addEventListener(MouseEvent.CLICK, __createBuildHandler);
					}
				}
				else
				{
					if(m_createButton) m_createButton.removeEventListener(MouseEvent.CLICK, __createBuildHandler);
					DisposeUtil.free(m_createButton);
					m_createButton = null;
				}
			}
			else
			{
				if(m_createButton) m_createButton.removeEventListener(MouseEvent.CLICK, __createBuildHandler);
				DisposeUtil.free(m_createButton);
				m_createButton = null;
				
				var nextTemplate:BuildTemplate = GameUtil.getBuildNextTemplate(m_player, m_type);
				
				var canShowUpgradeBtn:Boolean = false;
				
				if(nextTemplate == null)
				{
					canShowUpgradeBtn = false;
				}
				else if(type == BuildType.Castle)
				{
					if(nextTemplate.NeedMoney <= PlayerMgr.self.coins && StaticConfig.CastleUpGradeExp[nextTemplate.Lv] <= PlayerMgr.self.experience)
					{
						canShowUpgradeBtn = true;
					}
				}
				else if(castleTemplate && nextTemplate.NeedCastleLv < castleTemplate.Lv && nextTemplate.NeedMoney <= PlayerMgr.self.coins)
				{
					canShowUpgradeBtn = true;
				}
				
				if(canShowUpgradeBtn)
				{
					if(m_upgradeButton == null)
					{
						m_upgradeButton = new Button();
						m_upgradeButton.beginChanges();
						m_upgradeButton.freeBMD = false;
						m_upgradeButton.upImage = new Bitmap(StaticRes.BuildUpgradeBMD);
						m_upgradeButton.commitChanges();
						addChild(m_upgradeButton);
						
						m_upgradeButton.x = -int(m_upgradeButton.width / 2);
						m_upgradeButton.y = -int(m_upgradeButton.height);
						
						m_upgradeButton.addEventListener(MouseEvent.CLICK, __upgradeBuildHandler);
					}
				}
				else
				{
					if(m_upgradeButton) m_upgradeButton.removeEventListener(MouseEvent.CLICK, __upgradeBuildHandler);
					
					DisposeUtil.free(m_upgradeButton);
					m_upgradeButton = null;
				}
			}
			
			if(template)
			{
				x = template.PosX;
				y = template.PosY;
			}
		}
		
		private function __buildClickHandler(e:MouseEvent):void
		{
			var frame:Frame;
			
			switch(m_type)
			{
				case BuildType.Tavern:
					frame = InstanceUtil.createSingletion(TavernUIView);
					if(frame.isOnStage)
					{
						frame.close();
						frame = null;
					}
					else
					{
						frame.show();
					}
					break;
				default:
					MsgTipMgr.show(StaticConfig.BuildTypeNameList[m_type] + "功能开发中...");
					break;
			}
		}
		
		private function __createBuildHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("建造:" + StaticConfig.BuildTypeNameList[m_type]);
			
			var pkg:CreateBuildingPacket = new CreateBuildingPacket();
			
			pkg.buildType = m_type;
			
			SocketProxy.sendTCP(pkg);
		}
		
		private function __upgradeBuildHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("升级:" + StaticConfig.BuildTypeNameList[m_type]);
			
			var pkg:UpgradeBuildingPacket = new UpgradeBuildingPacket();
			
			pkg.buildType = m_type;
			
			SocketProxy.sendTCP(pkg);
		}
		
		public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.BUILD_UPGRADE, __buildChangeHandler);
			
			DisposeUtil.free(m_buildView);
			m_buildView = null;
			
			DisposeUtil.free(m_createButton);
			m_createButton = null;
			
			DisposeUtil.free(m_upgradeButton);
			m_upgradeButton = null;
			
			m_player = null;
		}
	}
}