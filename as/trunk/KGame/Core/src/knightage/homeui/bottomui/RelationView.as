package knightage.homeui.bottomui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	
	import jsion.IDispose;
	import jsion.display.IconButton;
	import jsion.display.IconLabelButton;
	import jsion.utils.DisposeUtil;
	
	import knightage.StaticRes;
	
	public class RelationView extends Sprite implements IDispose
	{
		private static const ButtonPadding:int = -1;
		
		private var m_friendIcon:Bitmap;
		private var m_friendButton:IconLabelButton;
		
		private var m_enemyIcon:Bitmap;
		private var m_enemyButton:IconLabelButton;
		
		private var m_familyIcon:Bitmap;
		private var m_familyButton:IconLabelButton;
		
		
		private var m_listView:RelationListView;
		
		public function RelationView()
		{
			super();
			
			initialized();
		}
		
		private function initialized():void
		{
			// TODO Auto Generated method stub
			
			m_friendIcon = new Bitmap(new FriendIcon(0, 0));
			m_friendButton = createIconLabelButton(m_friendIcon, 80, 10, 10);
			addChild(m_friendButton);
			
			m_enemyIcon = new Bitmap(new EnemyIcon(0, 0));
			m_enemyButton = createIconLabelButton(m_enemyIcon, 80, 10, 10);
			m_enemyButton.upFilters = [new ColorMatrixFilter([0.6, 0, 0, 0, 0,  0, 0.6, 0, 0, 0,  0, 0, 0.6, 0, 0,  0, 0, 0, 1, 0])];
			addChild(m_enemyButton);
			
			m_familyIcon = new Bitmap(new FamilyIcon(0, 0));
			m_familyButton = createIconLabelButton(m_familyIcon, 80, 10, 10);
			m_familyButton.upFilters = [new ColorMatrixFilter([0.5, 0, 0, 0, 0,  0, 0.5, 0, 0, 0,  0, 0, 0.5, 0, 0,  0, 0, 0, 1, 0])];
			addChild(m_familyButton);
			
			
			
			
			
			m_friendButton.x = 5;
			m_friendButton.y = 2;
			
			m_enemyButton.x = m_friendButton.x;
			m_enemyButton.y = m_friendButton.y + m_friendButton.height + ButtonPadding;
			
			m_familyButton.x = m_enemyButton.x;
			m_familyButton.y = m_enemyButton.y + m_enemyButton.height + ButtonPadding;
			
			
			
			m_listView = new RelationListView();
			m_listView.x = m_friendButton.x + m_friendButton.width + 2;
			addChild(m_listView);
		}
		
		private function createIconLabelButton(icon:DisplayObject, num:int, hOffset:int, iconGap:int):IconLabelButton
		{
			var btn:IconLabelButton = new IconLabelButton();
			
			btn.beginChanges();
			btn.freeBMD = false;
			btn.upImage = new Bitmap(StaticRes.RelationButtonUpBMD);
			btn.label = formatNum(num);
			btn.labelColor = StaticRes.WhiteColor;
			btn.textFormat = StaticRes.TextFormat15;
			btn.labelUpFilters = StaticRes.TextFilters4;
			btn.labelOverFilters = StaticRes.TextFilters4;
			btn.labelDownFilters = StaticRes.TextFilters4;
			btn.iconUpImage = icon;
			btn.hAlign = IconButton.RIGHT;
			btn.hOffset = hOffset;
			btn.iconGap = iconGap;
			btn.commitChanges();
			
			return btn;
		}
		
		private function formatNum(value:int, strLen:int = 4):String
		{
			var str:String = value.toString();
			
			while(str.length < 4)
			{
				str = " " + str;
			}
			
			return str;
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_friendIcon);
			m_friendIcon = null;
			
			DisposeUtil.free(m_friendButton);
			m_friendButton = null;
			
			
			DisposeUtil.free(m_enemyIcon);
			m_enemyIcon = null;
			
			DisposeUtil.free(m_enemyButton);
			m_enemyButton = null;
			
			
			DisposeUtil.free(m_familyIcon);
			m_familyIcon = null;
			
			DisposeUtil.free(m_familyButton);
			m_familyButton = null;
			
			
			
			DisposeUtil.free(m_listView);
			m_listView = null;
		}
	}
}