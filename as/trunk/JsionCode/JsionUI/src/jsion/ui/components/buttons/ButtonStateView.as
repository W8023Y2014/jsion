package jsion.ui.components.buttons
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import jsion.*;
	import jsion.ui.ASColor;
	import jsion.ui.Component;
	import jsion.ui.graphics.Graphics2D;
	import jsion.ui.graphics.SolidBrush;
	
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	public class ButtonStateView extends Sprite implements IDispose
	{
		protected var m_upImage:DisplayObject;
		
		protected var m_overImage:DisplayObject;
		
		protected var m_downImage:DisplayObject;
		
		protected var m_disabledImage:DisplayObject;
		
		
		
		protected var m_selectedImage:DisplayObject;
		
		protected var m_overSelectedImage:DisplayObject;
		
		protected var m_downSelectedImage:DisplayObject;
		
		protected var m_disabledSelectedImage:DisplayObject;
		
		
		
		protected var lastImage:DisplayObject;
		
		
		
		protected var m_size:IntDimension = new IntDimension();
		
		
		
		public var enabled:Boolean;
		
		public var downed:Boolean;
		
		public var overed:Boolean;
		
		public var selected:Boolean;
		
		private var m_freeBitmapData:Boolean;
		
		public function ButtonStateView(freeBitmapData:Boolean = false)
		{
			m_freeBitmapData = freeBitmapData;
			super();
		}
		
		public function getSize():IntDimension
		{
			if(lastImage) return new IntDimension(lastImage.width, lastImage.height);
			
			return new IntDimension();
		}
		
		private var m_shape:Sprite;
		
		public function updateTrigger(size:IntDimension = null):void
		{
			if(size == null) return;
			
			if(m_shape == null)
			{
				m_shape = new Sprite();
				addChild(m_shape);
				DepthUtil.bringToBottom(m_shape);
			}
			
			var g:Graphics2D = new Graphics2D(m_shape.graphics);
			g.clear();
			g.fillRectangle(new SolidBrush(new ASColor(0x336699, 1)), 0, 0, size.width, size.height);
		}
		
		public function update(size:IntDimension = null):void
		{
			var image:DisplayObject;
			
			var tmpImage:DisplayObject;
			
			if(selected) image = m_selectedImage;
			else image = m_upImage;
			
			if(!enabled)
			{
				if(selected && m_disabledSelectedImage)
				{
					tmpImage = m_disabledSelectedImage;
				}
				else
				{
					tmpImage = m_disabledImage;
				}
			}
			else if(downed)
			{
				if(selected && m_downSelectedImage)
				{
					tmpImage = m_downSelectedImage;
				}
				else
				{
					tmpImage = m_downImage;
				}
			}
			else if(overed)
			{
				if(selected && m_overSelectedImage)
				{
					tmpImage = m_overSelectedImage;
				}
				else
				{
					tmpImage = m_overImage;
				}
			}
			else if(selected)
			{
				tmpImage = m_selectedImage;
			}
			
			if(tmpImage != null)
			{
				image = tmpImage;
			}
			
			if(image != lastImage)// && image != null)
			{
				if(lastImage) lastImage.visible = false;
				
				if(image) image.visible = true;
				
				lastImage = image;
			}
			
			if(size != null && image)
			{
				image.width = size.width;
				image.height = size.height;
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			child.visible = false;
			
			return super.addChild(child);
		}
		
		public function setUpImage(image:DisplayObject):void
		{
			checkAsset(m_upImage, image);
			m_upImage = image;
			addChild(image);
		}
		
		public function setOverImage(image:DisplayObject):void
		{
			checkAsset(m_overImage, image);
			m_overImage = image;
			addChild(image);
		}
		
		public function setDownImage(image:DisplayObject):void
		{
			checkAsset(m_downImage, image);
			m_downImage = image;
			addChild(image);
		}
		
		public function setDisabledImage(image:DisplayObject):void
		{
			checkAsset(m_disabledImage, image);
			m_disabledImage = image;
			addChild(image);
		}
		
		
		
		public function setSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_selectedImage, image);
			m_selectedImage = image;
			addChild(image);
		}
		
		public function setOverSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_overSelectedImage, image);
			m_overSelectedImage = image;
			addChild(image);
		}
		
		public function setDownSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_downSelectedImage, image);
			m_downSelectedImage = image;
			addChild(image);
		}
		
		public function setDisabledSelectedImage(image:DisplayObject):void
		{
			checkAsset(m_disabledSelectedImage, image);
			m_disabledSelectedImage = image;
			addChild(image);
		}
		
		override public function get width():Number
		{
			if(super.width > 1) return super.width;
			
			return m_size.width
		}
		
		override public function get height():Number
		{
			if(super.height > 1) return super.height;
			
			return m_size.height;
		}
		
		protected function checkAsset(image:DisplayObject, value:DisplayObject):void
		{
			if(image != null && contains(image))
			{
				throw new Error("You are set a already exists asset!");
			}
			
			if(value)
			{
				m_size.width = Math.max(m_size.width, value.width);
				m_size.height = Math.max(m_size.height, value.height);
			}
		}
		
		public function getPreferredSize(component:Component):IntDimension
		{
			if(m_upImage)
			{
				if(m_upImage is Component)
					return Component(m_upImage).getPreferredSize();
				return new IntDimension(m_upImage.width, m_upImage.height);
			}
			else if(m_overImage)
			{
				if(m_upImage is Component)
					return Component(m_overImage).getPreferredSize();
				return new IntDimension(m_overImage.width, m_overImage.height);
			}
			else if(m_downImage)
			{
				if(m_upImage is Component)
					return Component(m_downImage).getPreferredSize();
				return new IntDimension(m_downImage.width, m_downImage.height);
			}
			else if(m_disabledImage)
			{
				if(m_upImage is Component)
					return Component(m_disabledImage).getPreferredSize();
				return new IntDimension(m_disabledImage.width, m_disabledImage.height);
			}
			else if(m_selectedImage)
			{
				if(m_upImage is Component)
					return Component(m_selectedImage).getPreferredSize();
				return new IntDimension(m_selectedImage.width, m_selectedImage.height);
			}
			else if(m_overSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_overSelectedImage).getPreferredSize();
				return new IntDimension(m_overSelectedImage.width, m_overSelectedImage.height);
			}
			else if(m_downSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_downSelectedImage).getPreferredSize();
				return new IntDimension(m_downSelectedImage.width, m_downSelectedImage.height);
			}
			else if(m_disabledSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_disabledSelectedImage).getPreferredSize();
				return new IntDimension(m_disabledSelectedImage.width, m_disabledSelectedImage.height);
			}
			
			return new IntDimension();
		}
		
		public function getMinimumSize(component:Component):IntDimension
		{
			if(m_upImage)
			{
				if(m_upImage is Component)
					return Component(m_upImage).getMinimumSize();
				//return new IntDimension(m_upImage.width, m_upImage.height);
			}
			else if(m_overImage)
			{
				if(m_upImage is Component)
					return Component(m_overImage).getMinimumSize();
				//return new IntDimension(m_overImage.width, m_overImage.height);
			}
			else if(m_downImage)
			{
				if(m_upImage is Component)
					return Component(m_downImage).getMinimumSize();
				//return new IntDimension(m_downImage.width, m_downImage.height);
			}
			else if(m_disabledImage)
			{
				if(m_upImage is Component)
					return Component(m_disabledImage).getMinimumSize();
				//return new IntDimension(m_disabledImage.width, m_disabledImage.height);
			}
			else if(m_selectedImage)
			{
				if(m_upImage is Component)
					return Component(m_selectedImage).getMinimumSize();
				//return new IntDimension(m_selectedImage.width, m_selectedImage.height);
			}
			else if(m_overSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_overSelectedImage).getMinimumSize();
				//return new IntDimension(m_overSelectedImage.width, m_overSelectedImage.height);
			}
			else if(m_downSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_downSelectedImage).getMinimumSize();
				//return new IntDimension(m_downSelectedImage.width, m_downSelectedImage.height);
			}
			else if(m_disabledSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_disabledSelectedImage).getMinimumSize();
				//return new IntDimension(m_disabledSelectedImage.width, m_disabledSelectedImage.height);
			}
			
			return new IntDimension();
		}

		public function getMaximumSize(component:Component):IntDimension
		{
			if(m_upImage)
			{
				if(m_upImage is Component)
					return Component(m_upImage).getMaximumSize();
				//return new IntDimension(m_upImage.width, m_upImage.height);
			}
			else if(m_overImage)
			{
				if(m_upImage is Component)
					return Component(m_overImage).getMaximumSize();
				//return new IntDimension(m_overImage.width, m_overImage.height);
			}
			else if(m_downImage)
			{
				if(m_upImage is Component)
					return Component(m_downImage).getMaximumSize();
				//return new IntDimension(m_downImage.width, m_downImage.height);
			}
			else if(m_disabledImage)
			{
				if(m_upImage is Component)
					return Component(m_disabledImage).getMaximumSize();
				//return new IntDimension(m_disabledImage.width, m_disabledImage.height);
			}
			else if(m_selectedImage)
			{
				if(m_upImage is Component)
					return Component(m_selectedImage).getMaximumSize();
				//return new IntDimension(m_selectedImage.width, m_selectedImage.height);
			}
			else if(m_overSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_overSelectedImage).getMaximumSize();
				//return new IntDimension(m_overSelectedImage.width, m_overSelectedImage.height);
			}
			else if(m_downSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_downSelectedImage).getMaximumSize();
				//return new IntDimension(m_downSelectedImage.width, m_downSelectedImage.height);
			}
			else if(m_disabledSelectedImage)
			{
				if(m_upImage is Component)
					return Component(m_disabledSelectedImage).getMaximumSize();
				//return new IntDimension(m_disabledSelectedImage.width, m_disabledSelectedImage.height);
			}
			
			return IntDimension.createBigDimension();
		}
		
		public function dispose():void
		{
			DisposeUtil.free(m_shape);
			m_shape = null;
			
			DisposeUtil.free(m_upImage, m_freeBitmapData);
			m_upImage = null;
			
			DisposeUtil.free(m_overImage, m_freeBitmapData);
			m_overImage = null;
			
			DisposeUtil.free(m_downImage, m_freeBitmapData);
			m_downImage = null;
			
			DisposeUtil.free(m_disabledImage, m_freeBitmapData);
			m_disabledImage = null;
			
			DisposeUtil.free(m_selectedImage, m_freeBitmapData);
			m_selectedImage = null;
			
			DisposeUtil.free(m_overSelectedImage, m_freeBitmapData);
			m_overSelectedImage = null;
			
			DisposeUtil.free(m_downSelectedImage, m_freeBitmapData);
			m_downSelectedImage = null;
			
			DisposeUtil.free(m_disabledSelectedImage, m_freeBitmapData);
			m_disabledSelectedImage = null;
			
			lastImage = null;
			
			m_size = null;
		}
	}
}