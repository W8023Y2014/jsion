package knightage
{
	public class StaticConfig
	{
		/**
		 * 建筑类型一级对应的建筑模板ID
		 */		
		public static const BuildFirstLvTIDList:Array = [0, 1, 101, 201, 301, 401, 501, 601, 701, 801, 901, 1001, 1101];
		
		/**
		 * 建筑名称列表，与建筑类型一一对应。
		 */		
		public static const BuildTypeNameList:Array = ["", "城堡", "农田", "酒馆", "兵营", "训练场", "市场", "监狱", "占卜屋", "潘多拉", "铁匠铺", "研究学院", "雕像"];
		
		/**
		 * 各兵系对应的默认兵种列表
		 */		
		public static const DefaultSoilderTypeList:Array = [0, 11, 21, 31, 41, 51];
		
		/**
		 * 城堡提升下一级所需要经验值列表
		 */		
		public static const CastleUpGradeExp:Array = [0, 10, 100, 400, 900, 1600, 2500, 3600, 4900, 6400, 8100, 10000, 12100, 14400, 16900, 19600, 22500, 25600, 28900, 32400, 36100, 40000, 44100, 48400, 52900, 57600, 62500, 67600, 72900, 78400, 84100, 90000, 96100, 102400, 108900, 115600, 122500, 129600, 136900, 144400, 152100, 160000, 168100, 176400, 184900, 193600, 202500, 211600, 220900, 230400, 240100, 250000, 260100, 270400, 280900, 291600, 302500, 313600, 324900, 336400, 348100, 360000, 372100, 384400, 396900, 409600, 422500, 435600, 448900, 462400, 476100, 490000, 504100, 518400, 532900, 547600, 562500, 577600, 592900, 608400, 624100, 640000, 656100, 672400, 688900, 705600, 722500, 739600, 756900, 774400, 792100, 810000, 828100, 846400, 864900, 883600, 902500, 921600, 940900, 960400, 980100, 1000000];
	}
}