package knightage.hall.tavern
{
	import core.net.SocketProxy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsion.display.Button;
	import jsion.display.ProgressBar;
	import jsion.loaders.DisplayLoader;
	import jsion.utils.DisposeUtil;
	import jsion.utils.InstanceUtil;
	import jsion.utils.JUtil;
	
	import knightage.GameUtil;
	import knightage.StaticRes;
	import knightage.display.Frame;
	import knightage.events.PlayerEvent;
	import knightage.hall.build.BuildType;
	import knightage.mgrs.DateMgr;
	import knightage.mgrs.MsgTipMgr;
	import knightage.mgrs.PlayerMgr;
	import knightage.mgrs.TemplateMgr;
	import knightage.net.packets.tavern.PartyPacket;
	import knightage.net.packets.tavern.RefreshTavernHerosPacket;
	import knightage.player.GamePlayer;
	import knightage.templates.HeroTemplate;
	
	public class TavernUIView extends Frame
	{
		private static const Point1:Point = new Point(172, 168);
		private static const Point2:Point = new Point(329, 168);
		private static const Point3:Point = new Point(473, 168);
		
		
		private var m_titleIcon:DisplayObject;
		
		private var m_tavernBackground:DisplayObject;
		
		
		
		private var m_loader1:DisplayLoader;
		private var m_loader2:DisplayLoader;
		private var m_loader3:DisplayLoader;
		
		
		
		private var m_item1:TavernHeroInfoView;
		
		private var m_item2:TavernHeroInfoView;
		
		private var m_item3:TavernHeroInfoView;
		
		
		
		private var m_treasureChestsButton:Button;
		
		private var m_partyButton:PartyButton;
		
		private var m_grandPartyButton:PartyButton;
		
		private var m_progress:ProgressBar;
		
		private var m_countDown:CountDown;
		
		private var m_player:GamePlayer;
		
		public function TavernUIView()
		{
			super("", false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			m_tavernBackground = new Bitmap(new TavernBackgroundAsset(0, 0));
			
			addToContent(m_tavernBackground);
			
			var posY:int = 230;
			
			
			m_item1 = new TavernHeroInfoView(1);
			m_item1.x = 20;
			m_item1.y = posY;
			addToContent(m_item1);
			
			m_item2 = new TavernHeroInfoView(2);
			m_item2.y = posY;
			addToContent(m_item2);
			
			m_item3 = new TavernHeroInfoView(3);
			m_item3.y = posY;
			addToContent(m_item3);
			
			JUtil.layeroutOneByOneHorizontal(0, m_item1, m_item2, m_item3);
			
			
			
			
			
			
			
			beginChanges();
			contentOffsetX = 20;
			contentOffsetY = 17;
			titleBarVOffset = -27;
			setContentSize(m_tavernBackground.width, m_tavernBackground.height);
			m_titleIcon = new Bitmap(new TavernTitleIcon(0, 0));
			titleView = m_titleIcon;
			titleVOffset = -5;
			commitChanges();
			
			
			
			
			
			
			m_progress = new ProgressBar();
			m_progress.beginChanges();
			m_progress.x = 38;
			m_progress.y = 425;
			m_progress.freeBMD = true;
			m_progress.progressBar = new Bitmap(new LivelyBarAsset(0, 0));
			m_progress.commitChanges();
			addToContent(m_progress);
			
			
			
			m_countDown = new CountDown();
			m_countDown.x = 498;
			m_countDown.y = 423;
			addToContent(m_countDown);
			
			
			
			
			m_treasureChestsButton = new Button();
			m_treasureChestsButton.beginChanges();
			m_treasureChestsButton.clickSoundID = StaticRes.ButtonClickSoundID;
			m_treasureChestsButton.x = 200;
			m_treasureChestsButton.y = 410;
			m_treasureChestsButton.freeBMD = true;
			m_treasureChestsButton.upImage = new Bitmap(new TreasureChestsAsset(0, 0));
			m_treasureChestsButton.commitChanges();
			addToContent(m_treasureChestsButton);
			
			
			
			
			m_partyButton = new PartyButton(PartyButton.Party);
			m_partyButton.x = 247;
			m_partyButton.y = 388;
			addToContent(m_partyButton);
			m_partyButton.setMoney(0);
			
			m_grandPartyButton = new PartyButton(PartyButton.GrandParty);
			m_grandPartyButton.x = m_partyButton.x + m_partyButton.width + 3;
			m_grandPartyButton.y = m_partyButton.y;
			addToContent(m_grandPartyButton);
			m_grandPartyButton.setMoney(0);
			
			
			
			
			
			
			
			m_treasureChestsButton.addEventListener(MouseEvent.CLICK, __treasureChestClickHandler);
			
			m_partyButton.addEventListener(MouseEvent.CLICK, __partyClickHandler);
			
			m_grandPartyButton.addEventListener(MouseEvent.CLICK, __grandPartyClickHandler);
			
			m_countDown.addEventListener(Event.COMPLETE, __countDownCompleteHandler);
			
			
			
			PlayerMgr.addEventListener(PlayerEvent.REFRESH_TAVERN_HERO, __refreshSelfTavernHeroHandler);
			PlayerMgr.addEventListener(PlayerEvent.GRAND_PARTY_PRICE_CHANGED, __grandPartyPriceChangedHandler);
			PlayerMgr.addEventListener(PlayerEvent.PRESTIGE_CHANGED, __prestigeChangedHandler);
			PlayerMgr.addEventListener(PlayerEvent.BUILD_UPGRADE, __buildUpgradeHandler);
			PlayerMgr.addEventListener(PlayerEvent.EMPLOY_HERO, __employHeroHandler);
			
			refreshData();
		}
		
		private function __treasureChestClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("宝箱功能开发中...");
		}
		
		private function __partyClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("举行派对...");
			
			var pkg:PartyPacket = new PartyPacket();
			
			pkg.partyType = 1;
			
			SocketProxy.sendTCP(pkg);
		}
		
		private function __grandPartyClickHandler(e:MouseEvent):void
		{
			MsgTipMgr.show("豪华派对...");
			
			var pkg:PartyPacket = new PartyPacket();
			
			pkg.partyType = 2;
			
			SocketProxy.sendTCP(pkg);
		}
		
		
		private function __countDownCompleteHandler(e:Event):void
		{
			var pkg:RefreshTavernHerosPacket = new RefreshTavernHerosPacket();
			
			pkg.pid = m_player.playerID;
			
			SocketProxy.sendTCP(pkg);
		}
		
		
		
		
		
		private function __refreshSelfTavernHeroHandler(e:PlayerEvent):void
		{
			refreshView();
		}
		
		private function __grandPartyPriceChangedHandler(e:PlayerEvent):void
		{
			m_grandPartyButton.setMoney(m_player.partyGold);
		}
		
		private function __prestigeChangedHandler(e:PlayerEvent):void
		{
			m_progress.maxValue = GameUtil.getPrestigeUpgradeExp(m_player);
			m_progress.value = m_player.prestige;
		}
		
		private function __buildUpgradeHandler(e:PlayerEvent):void
		{
			if(e.data == BuildType.Tavern)
			{
				var partyPrice:int = GameUtil.getPartyPrice(m_player);
				m_partyButton.setMoney(partyPrice);
				
				var partyGold:int = GameUtil.getGrandPartyPrice(m_player);
				if(m_player.partyGold < partyGold)
				{
					PlayerMgr.addGrandPartyGold(partyGold - m_player.partyGold);
				}
			}
		}
		
		private function __employHeroHandler(e:PlayerEvent):void
		{
			switch(e.data)
			{
				case 1:
					m_item1.setData(null);
					DisposeUtil.free(m_loader1);
					break;
				case 2:
					m_item2.setData(null);
					DisposeUtil.free(m_loader2);
					break;
				case 3:
					m_item3.setData(null);
					DisposeUtil.free(m_loader3);
					break;
			}
		}
		
		
		
		public function refreshData():void
		{
			m_player = PlayerMgr.self;
			
			refreshView();
		}
		
		
		private function refreshView():void
		{
			var now:Date = DateMgr.getCurrentDateTime();
			
			var timeSpan:* = (now.time - m_player.lastRefreshTime.time) / 1000;
			
			var maxSeconds:int = 3600;
			
			var seconds:int = 0;
			
			if(timeSpan >= maxSeconds)
			{
				seconds = 0;
			}
			else
			{
				seconds = maxSeconds - int(timeSpan);
			}
			
			m_countDown.setSeconds(seconds);
			
			
			if(seconds == 0) return;
			
			
			var template:HeroTemplate;
			
			template = TemplateMgr.findHeroTemplate(m_player.lastHero1TID);
			m_item1.setData(template);
			DisposeUtil.free(m_loader1);
			if(template)
			{
				m_loader1 = new DisplayLoader(template.BustImg, Config.ResRoot);
				m_loader1.loadAsync(bustLoadCallback);
			}
			else
			{
				m_loader1 = null;
			}
			
			template = TemplateMgr.findHeroTemplate(m_player.lastHero2TID);
			m_item2.setData(template);
			DisposeUtil.free(m_loader2);
			if(template)
			{
				m_loader2 = new DisplayLoader(template.BustImg, Config.ResRoot);
				m_loader2.loadAsync(bustLoadCallback);
			}
			else
			{
				m_loader2 = null;
			}
			
			template = TemplateMgr.findHeroTemplate(m_player.lastHero3TID);
			m_item3.setData(template);
			DisposeUtil.free(m_loader3);
			if(template)
			{
				m_loader3 = new DisplayLoader(template.BustImg, Config.ResRoot);
				m_loader3.loadAsync(bustLoadCallback);
			}
			else
			{
				m_loader3 = null;
			}
			
			var partyPrice:int = GameUtil.getPartyPrice(m_player);
			m_partyButton.setMoney(partyPrice);
			
			m_grandPartyButton.setMoney(m_player.partyGold);
			
			m_progress.maxValue = GameUtil.getPrestigeUpgradeExp(m_player);
			m_progress.value = m_player.prestige;
			
			//m_partyButton.enabled = VisitMgr.isSelf;
			//m_grandPartyButton.enabled = VisitMgr.isSelf;
		}
		
		private function bustLoadCallback(loader:DisplayLoader, successed:Boolean):void
		{
			switch(loader)
			{
				case m_loader1:
					m_loader1.x = Point1.x - int(m_loader1.width / 2);
					m_loader1.y = Point1.y - m_loader1.height;
					break;
				case m_loader2:
					m_loader2.x = Point2.x - int(m_loader2.width / 2);
					m_loader2.y = Point2.y - m_loader2.height;
					break;
				case m_loader3:
					m_loader3.x = Point3.x - int(m_loader3.width / 2);
					m_loader3.y = Point3.y - m_loader3.height;
					break;
			}
			
			addToContent(loader);
		}
		
		
		
		
		override public function dispose():void
		{
			PlayerMgr.removeEventListener(PlayerEvent.REFRESH_TAVERN_HERO, __refreshSelfTavernHeroHandler);
			PlayerMgr.removeEventListener(PlayerEvent.GRAND_PARTY_PRICE_CHANGED, __grandPartyPriceChangedHandler);
			PlayerMgr.removeEventListener(PlayerEvent.PRESTIGE_CHANGED, __prestigeChangedHandler);
			PlayerMgr.removeEventListener(PlayerEvent.BUILD_UPGRADE, __buildUpgradeHandler);
			PlayerMgr.removeEventListener(PlayerEvent.EMPLOY_HERO, __employHeroHandler);
			
			InstanceUtil.removeSingletion(TavernUIView);
			
			DisposeUtil.free(m_titleIcon);
			m_titleIcon = null;
			
			DisposeUtil.free(m_tavernBackground);
			m_tavernBackground = null;
			
			DisposeUtil.free(m_item1);
			m_item1 = null;
			
			DisposeUtil.free(m_item2);
			m_item2 = null;
			
			DisposeUtil.free(m_item3);
			m_item3 = null;
			
			DisposeUtil.free(m_loader1);
			m_loader1 = null;
			
			DisposeUtil.free(m_loader2);
			m_loader2 = null;
			
			DisposeUtil.free(m_loader3);
			m_loader3 = null;
			
			DisposeUtil.free(m_treasureChestsButton);
			m_treasureChestsButton = null;
			
			DisposeUtil.free(m_partyButton);
			m_partyButton = null;
			
			DisposeUtil.free(m_grandPartyButton);
			m_grandPartyButton = null;
			
			DisposeUtil.free(m_progress);
			m_progress = null;
			
			DisposeUtil.free(m_countDown);
			m_countDown = null;
			
			m_player = null;
			
			super.dispose();
		}
	}
}