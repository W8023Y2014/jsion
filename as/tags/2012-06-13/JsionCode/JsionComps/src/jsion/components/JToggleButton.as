package jsion.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import jsion.comps.CompGlobal;
	import jsion.comps.Component;
	import jsion.comps.events.UIEvent;
	import jsion.utils.DisposeUtil;
	import jsion.utils.StringUtil;
	
	[Event(name="selected", type="jsion.comps.events.UIEvent")]
	public class JToggleButton extends Component
	{
		public static const UP_IMG:String = CompGlobal.UP_IMG;
		public static const OVER_IMG:String = CompGlobal.OVER_IMG;
		public static const DOWN_IMG:String = CompGlobal.DOWN_IMG;
		public static const DISABLED_IMG:String = CompGlobal.DISABLED_IMG;
		
		public static const UP_FILTERS:String = CompGlobal.UP_FILTERS;
		public static const OVER_FILTERS:String = CompGlobal.OVER_FILTERS;
		public static const DOWN_FILTERS:String = CompGlobal.DOWN_FILTERS;
		public static const DISABLED_FILTERS:String = CompGlobal.DISABLED_FILTERS;
		
		public static const LABEL_UP_FILTERS:String = CompGlobal.LABEL_UP_FILTERS;
		public static const LABEL_OVER_FILTERS:String = CompGlobal.LABEL_OVER_FILTERS;
		public static const LABEL_DOWN_FILTERS:String = CompGlobal.LABEL_DOWN_FILTERS;
		public static const LABEL_DISABLED_FILTERS:String = CompGlobal.LABEL_DISABLED_FILTERS;
		
		public static const HALIGN:String = CompGlobal.HALIGN;
		public static const HGAP:String = CompGlobal.HGAP;
		
		public static const VALIGN:String = CompGlobal.VALIGN;
		public static const VGAP:String = CompGlobal.VGAP;
		
		
		private var m_label:String;
		
		private var m_selectedLabel:String;
		
		private var m_selected:Boolean;
		
		private var m_button:JButton;
		
		private var m_selectedButton:JButton;
		
		private var m_curButton:JButton;
		
		private var m_group:JToggleButtonGroup;
		
		public function JToggleButton(label:String = "", selectedLabel:String = "", container:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0)
		{
			m_label = label;
			m_selectedLabel = selectedLabel;
			
			if(StringUtil.isNullOrEmpty(m_selectedLabel))
				m_selectedLabel = m_label;
			
			super(container, xPos, yPos);
		}
		
		public function get group():JToggleButtonGroup
		{
			return m_group;
		}
		
		public function set group(value:JToggleButtonGroup):void
		{
			m_group = value;
		}
		
		public function get selected():Boolean
		{
			return m_selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(m_selected != value)
			{
				m_selected = value;
				
				invalidate();
				
				dispatchEvent(new UIEvent(UIEvent.SELECTED));
			}
		}
		
		public function get label():String
		{
			return m_label;
		}
		
		public function set label(value:String):void
		{
			if(m_label != value)
			{
				m_label = value;
				
				m_button.label = m_label;
				
				invalidate();
			}
		}
		
		public function get selectedLabel():String
		{
			return m_selectedLabel;
		}
		
		public function set selectedLabel(value:String):void
		{
			if(m_selectedLabel != value)
			{
				m_selectedLabel = value;
				
				m_selectedButton.label = m_selectedLabel;
				
				invalidate();
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			m_button.enabled = value;
			m_selectedButton.enabled = value;
		}
		
		override protected function initEvents():void
		{
			addEventListener(MouseEvent.CLICK, __clickHandler);
		}
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(m_group)
			{
				m_group.selected = this;
			}
			else
			{
				selected = !selected;
			}
		}
		
		override protected function addChildren():void
		{
			m_button = new JButton(m_label, this);
			m_curButton = m_button;
			
			m_selectedButton = new JButton(m_selectedLabel);
		}
		
		override public function setStyle(key:String, value:*, freeBMD:Boolean=true):Object
		{
			//m_button.setStyle(key, value, freeBMD);
			throw new Error("请使用setUnSelectedStyle或setSelectedStyle方法.");
		}
		
		public function setUnSelectedLabelStyle(key:String, value:*, freeBMD:Boolean=true):Object
		{
			invalidate();
			return m_button.setLabelStyle(key, value, freeBMD);
		}
		
		public function setUnSelectedStyle(key:String, value:*, freeBMD:Boolean=true):Object
		{
			invalidate();
			return m_button.setStyle(key, value, freeBMD);
		}
		
		public function setSelectedLabelStyle(key:String, value:*, freeBMD:Boolean=true):Object
		{
			invalidate();
			return m_selectedButton.setLabelStyle(key, value, freeBMD);
		}
		
		public function setSelectedStyle(key:String, value:*, freeBMD:Boolean=true):Object
		{
			invalidate();
			return m_selectedButton.setStyle(key, value, freeBMD);
		}
		
		override public function draw():void
		{
			m_button.drawAtOnce();
			m_selectedButton.drawAtOnce();
			
			if(m_selected == false && m_curButton != m_button)
			{
				if(m_curButton) removeChild(m_curButton);
				
				m_curButton = m_button;
				
				addChild(m_curButton);
				m_curButton.bring2Bottom();
			}
			else if(m_selected && m_curButton != m_selectedButton)
			{
				if(m_curButton) removeChild(m_curButton);
				
				m_curButton = m_selectedButton;
				
				addChild(m_curButton);
				m_curButton.bring2Bottom();
			}
			
			super.draw();
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			
			DisposeUtil.free(m_button);
			m_button = null;
			
			DisposeUtil.free(m_selectedButton);
			m_selectedButton = null;
			
			m_curButton = null;
			
			m_group = null;
			
			super.dispose();
		}
	}
}