package jsion.view
{
	import com.utils.DisposeHelper;
	
	import flash.text.TextField;
	
	import jsion.AlbumsMgr;
	import jsion.data.CoverPage;

	public class CoverLayer extends PhotoLayer
	{
		protected var _author:TextField;
		
		override protected function initTextView():void
		{
			super.initTextView();
			
			DisposeHelper.dispose(_author);
			_author = null;
			
			var page:CoverPage = _photoPage as CoverPage;
			if(page)
			{
				_author = AlbumsMgr.createTextField(page.author, page.authorFont, page.authorSize, page.authorColor, page.authorBold, page.authorItalic, page.authorX, page.authorY);
				addChild(_author);
			}
		}
		
		override public function dispose():void
		{
			DisposeHelper.dispose(_author);
			_author = null;
			
			super.dispose();
		}
	}
}