package jsion.comps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jsion.comps.events.ReleaseEvent;
	import jsion.utils.DisposeUtil;
	
	public class Component extends ComSprite implements ITip
	{
		private var m_mousePoint:Point = new Point();
		
		private var m_bitmapForHit:Bitmap;
		
		private var m_enterFraming:Boolean;
		
		private var m_hited:Boolean;
		
		private var m_threshold:int = 128;
		
		private var m_model:StateModel;
		
		protected var m_rolloverEnabled:Boolean;
		
		private var m_stopPropagation:Boolean;
		
		private var m_ignoreTransparents:Boolean;
		
		public function Component()
		{
			super();
			
			m_model = new StateModel();
			
			
			addEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			addEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			addEventListener(MouseEvent.CLICK, __clickHandler);
			
			initialize();
			
			initEvents();
		}
		
		
		protected function initialize():void
		{
		}
		
		protected function initEvents():void
		{
		}
		
		
		public function get stopPropagation():Boolean
		{
			return m_stopPropagation;
		}
		
		public function set stopPropagation(value:Boolean):void
		{
			m_stopPropagation = value;
		}
		
		public function get rolloverEnabled():Boolean
		{
			return m_rolloverEnabled;
		}
		
		public function set rolloverEnabled(value:Boolean):void
		{
			m_rolloverEnabled = value;
		}
		
		public function get ignoreTransparents():Boolean
		{
			return m_ignoreTransparents;
		}
		
		public function set ignoreTransparents(value:Boolean):void
		{
			if(m_ignoreTransparents != value)
			{
				m_ignoreTransparents = value;
				
				DisposeUtil.free(m_bitmapForHit);
				m_bitmapForHit = null;
				
				if(m_ignoreTransparents)
				{
					m_hited = false;
					m_enterFraming = false;
					mouseEnabled = true;
					
					buttonMode = false;
					
					activateMouseTrap();
				}
				else
				{
					deactivateMouseTrap();
					removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
					removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				}
			}
		}
		
		public function hitTestMouse():Boolean
		{
			if(stage)
				return hitTestPoint(stage.mouseX, stage.mouseY);
			
			return false;
		}
		
		//==================================================		update state model			==================================================
		
		private function __rollOverHandler(e:MouseEvent):void
		{
			if(rolloverEnabled)
			{
				if(m_model.pressed || !e.buttonDown)
				{
					m_model.rollOver = true;
				}
			}
			
			if(m_model.pressed) m_model.armed = true;
		}
		
		private function __rollOutHandler(e:MouseEvent):void
		{
			if(rolloverEnabled)
			{
				if(m_model.pressed == false)
				{
					m_model.rollOver = false;
				}
			}
			
			m_model.armed = false;
		}
		
		private function __mouseDownHandler(e:MouseEvent):void
		{
			m_model.armed = true;
			m_model.pressed = true;
		}
		
		private function __releaseHandler(e:ReleaseEvent):void
		{
			m_model.pressed = false;
			m_model.armed = false;
			
			if(rolloverEnabled && !hitTestMouse())
			{
				m_model.rollOver = false;
			}
		}
		
		//==================================================		update state model			==================================================
		
		private function __clickHandler(e:MouseEvent):void
		{
			if(stopPropagation)
			{
				e.stopPropagation();
			}
		}
		
		
		
		//==============================================		忽略透明像素			==============================================
		
		protected function activateMouseTrap():void
		{
			addEventListener(MouseEvent.ROLL_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OVER, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.ROLL_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_OUT, __captureMouseEvent, false, int.MAX_VALUE);
			addEventListener(MouseEvent.MOUSE_MOVE, __captureMouseEvent, false, int.MAX_VALUE);
		}
		
		protected function deactivateMouseTrap():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OVER, __captureMouseEvent);
			removeEventListener(MouseEvent.ROLL_OUT, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT, __captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_MOVE, __captureMouseEvent);
		}
		
		private function __captureMouseEvent(e:MouseEvent):void
		{
			if(m_enterFraming == false && (e.type == MouseEvent.MOUSE_OVER || e.type == MouseEvent.ROLL_OVER))
			{
				m_enterFraming = true;
				mouseEnabled = false;
				addEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				__trackMouseWhileInBounds();
				addEventListener(MouseEvent.MOUSE_UP, __upHandler);
			}
			
			if(!m_hited)
			{
				//trace("stopImmediatePropagation", e.type);
				e.stopImmediatePropagation();
			}
		}
		
		private function __upHandler(e:MouseEvent):void
		{
			if(m_model && m_model.rollOver == false && bitmapHitTest())
			{
				m_hited = true;
				buttonMode = true;
				mouseEnabled = true;
				deactivateMouseTrap();
				dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, true, false, m_bitmapForHit.mouseX, m_bitmapForHit.mouseY));
			}
		}
		
		private function __trackMouseWhileInBounds(e:Event = null):void
		{
			if(bitmapHitTest() != m_hited)
			{
				m_hited = !m_hited;
				
				if(m_hited)
				{
					buttonMode = true;
					mouseEnabled = true;
					deactivateMouseTrap();
				}
				else
				{
					mouseEnabled = false;
					
					buttonMode = false;
				}
			}
			
			var globalPoint:Point = m_bitmapForHit.localToGlobal(m_mousePoint);
			if(hitTestPoint(globalPoint.x, globalPoint.y) == false)
			{
				removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
				removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
				m_enterFraming = false;
				mouseEnabled = true;
				activateMouseTrap();
			}
		}
		
		protected function bitmapHitTest():Boolean
		{
			if(m_bitmapForHit == null) drawBitmapHit();
			
			m_mousePoint.x = m_bitmapForHit.mouseX;
			m_mousePoint.y = m_bitmapForHit.mouseY;
			
			return m_bitmapForHit.bitmapData.hitTest(CompGlobal.ZeroPoint, m_threshold, m_mousePoint);
		}
		
		protected function drawBitmapHit():void
		{
			if(m_bitmapForHit)
			{
				DisposeUtil.free(m_bitmapForHit);
			}
			
			var b:Rectangle = getBounds(this);
			
			var bmd:BitmapData = new BitmapData(b.width, b.height, true, 0);
			var mx:Matrix = new Matrix();
			mx.translate(-b.left, -b.top);
			bmd.draw(this);
			
			m_bitmapForHit = new Bitmap(bmd);
			m_bitmapForHit.visible = false;
			addChild(m_bitmapForHit);
			m_bitmapForHit.x = b.left;
			m_bitmapForHit.y = b.top;
		}
		
		//==============================================		忽略透明像素			==============================================
		
		
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
			removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
			removeEventListener(MouseEvent.CLICK, __clickHandler);
			removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
			removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
			
			deactivateMouseTrap();
			
			DisposeUtil.free(m_bitmapForHit);
			m_bitmapForHit = null;
			
			m_mousePoint = null;
			
			super.dispose();
		}
	}
}

