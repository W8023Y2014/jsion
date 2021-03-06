package jsion.comps
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import jsion.HashMap;
	import jsion.IDispose;
	import jsion.events.ListenerModel;
	import jsion.events.ReleaseEvent;
	import jsion.utils.ArrayUtil;
	import jsion.utils.DepthUtil;
	import jsion.utils.DisposeUtil;
	
	/**
	 * 鼠标弹起时分派
	 * @eventType jsion.events.ReleaseEvent
	 */	
	[Event(name="release", type="jsion.events.ReleaseEvent")]
	
	/**
	 * 鼠标在对象外面弹起时分派
	 * @eventType jsion.events.ReleaseEvent
	 */	
	[Event(name="releaseOutSide", type="jsion.events.ReleaseEvent")]
	/**
	 * 显示对象基类，实现了在调用 dispose() 时自动移除所有对本对象的监听，并释放所有添加到本显示对象上的所有子显示对象。
	 * @author Jsion
	 */	
	public class JsionSprite extends Sprite implements IDispose
	{
		/**
		 * ReleaseEvent中间变量
		 */		
		private var m_pressedTarget:DisplayObject;
		
		/**
		 * 保存监听本对象事件的监听信息
		 */		
		private var m_listeners:HashMap;
		
		/**
		 * 添加到本显示对象上的所有子显示对象列表
		 */		
		private var m_children:Array;
		
		/**
		 * 是否启用本对象的鼠标事件
		 */		
		private var m_enabled:Boolean;
		
		
		/** @private */
		protected var m_freeBMD:Boolean;
		
		/** @private */
		protected var m_tag:Object;
		
		
		public function JsionSprite()
		{
			super();
			
			m_enabled = true;
			
			m_children = [];
			
			m_listeners = new HashMap();
			
			
			
			addEventListener(MouseEvent.MOUSE_DOWN, __spriteMouseDownListener);
		}
		
		/**
		 * 额外保存的数据。
		 */		
		public function get tag():Object
		{
			return m_tag;
		}
		
		/** @private */
		public function set tag(value:Object):void
		{
			m_tag = value;
		}
		
		/**
		 * 所有的子显示对象列表
		 * 请不要对此属性进行任何添加或删除
		 */		
		public function get children():Array
		{
			return m_children;
		}
		
		/**
		 * 移除所有对本对象的监听
		 * @see #addEventListener()
		 * @see #removeEventListener()
		 */		
		public function removeAllEventListeners():void
		{
			if(m_listeners == null) return;
			
			var list:Array = m_listeners.getValues();
			
			while(list.length > 0)
			{
				var model:ListenerModel = list.pop() as ListenerModel;
				
				for each(var fn:Function in model.listener)
				{
					removeEventListener(model.type, fn, model.useCapture);
				}
			}
		}
		
		/**
		 * 移除所有子对象
		 * @see #addChild()
		 * @see #addChildAt()
		 * @see #removeChild()
		 * @see #removeChildAt()
		 */		
		public function removeDisplayChildren():void
		{
			if(m_children == null) return;
			
			for each(var obj:DisplayObject in m_children)
			{
				removeChild(obj);
			}
		}
		
		/**
		 * 移除并释放所有子对象
		 * @see #addChild()
		 * @see #addChildAt()
		 * @see #removeChild()
		 * @see #removeChildAt()
		 */		
		public function removeAndFreeChildren():void
		{
			if(m_children == null) return;
			
			DisposeUtil.free(m_children, m_freeBMD);
		}
		
		/**
		 * 提到最上层
		 * @see #bring2Bottom()
		 */		
		public function bring2Top():void
		{
			DepthUtil.bringToTop(this);
		}
		
		/**
		 * 放到最底层
		 * @see #bring2Top()
		 */		
		public function bring2Bottom():void
		{
			DepthUtil.bringToBottom(this);
		}
		
		/**
		 * 防止对点击事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopClickPropagation():void
		{
			addEventListener(MouseEvent.CLICK, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标经过事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopMouseOverPropagation():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标移出事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopMouseOutPropagation():void
		{
			addEventListener(MouseEvent.MOUSE_OUT, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标按下事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopMouseDownPropagation():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标弹起事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopMouseUpPropagation():void
		{
			addEventListener(MouseEvent.MOUSE_UP, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标经过事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopRollOverPropagation():void
		{
			addEventListener(MouseEvent.ROLL_OVER, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标移出事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopRollOutPropagation():void
		{
			addEventListener(MouseEvent.ROLL_OUT, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标滚轮事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopMouseWheelPropagation():void
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, __mouseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标释放事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopReleasePropagation():void
		{
			addEventListener(ReleaseEvent.RELEASE, __releaseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对鼠标在外部释放事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopReleaseOutSidePropagation():void
		{
			addEventListener(ReleaseEvent.RELEASE_OUT_SIDE, __releaseEventStopPropagationHandler);
		}
		
		/**
		 * 防止对除鼠标滚动外的所有鼠标事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget) 中的任何事件侦听器。
		 */		
		public function stopAllMouseEventPropagation():void
		{
			stopClickPropagation();
			stopMouseOverPropagation();
			stopMouseOutPropagation();
			stopMouseDownPropagation();
			stopMouseUpPropagation();
			stopRollOverPropagation();
			stopRollOutPropagation();
			stopReleasePropagation();
			stopReleaseOutSidePropagation();
		}
		
		private function __mouseEventStopPropagationHandler(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		private function __releaseEventStopPropagationHandler(e:ReleaseEvent):void
		{
			e.stopPropagation();
		}
		
		//==========================================		保存事件监听信息			==========================================
		/**
		 * 重写添加事件监听 保存监听信息
		 * 使用 EventDispatcher 对象注册事件侦听器对象，以使侦听器能够接收事件通知。
		 * @param type 事件的类型
		 * @param listener 处理事件的侦听器函数。此函数必须接受 Event 对象作为其唯一的参数，并且不能返回任何结果，如以下示例所示： function(evt:Event):void
		 * @param useCapture 确定侦听器是运行于捕获阶段、目标阶段还是冒泡阶段。如果将 useCapture 设置为 true，则侦听器只在捕获阶段处理事件，而不在目标或冒泡阶段处理事件。 如果 useCapture 为 false，则侦听器只在目标或冒泡阶段处理事件。 若要在所有三个阶段都侦听事件，请调用两次 addEventListener，一次将 useCapture 设置为 true，第二次再将 useCapture 设置为 false。
		 * @param priority 事件侦听器的优先级。 优先级由一个带符号的 32 位整数指定。 数字越大，优先级越高。 优先级为 n 的所有侦听器会在优先级为 n -1 的侦听器之前得到处理。 如果两个或更多个侦听器共享相同的优先级，则按照它们的添加顺序进行处理。 默认优先级为 0。
		 * @param useWeakReference 确定对侦听器的引用是强引用，还是弱引用。 强引用（默认值）可防止您的侦听器被当作垃圾回收。 弱引用则没有此作用。
		 * @see #removeEventListener()
		 * 
		 */		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var str:String = type + useCapture;
			
			var model:ListenerModel;
			
			if(m_listeners.containsKey(str))
			{
				model = m_listeners.get(str);
				if(ArrayUtil.containsValue(model.listener, listener) == false)
					model.listener.push(listener);
			}
			else
			{
				model = new ListenerModel();
				
				model.type = type;
				model.listener = [];
				model.listener.push(listener);
				model.useCapture = useCapture;
				
				m_listeners.put(str, model);
			}
		}
		
		/**
		 * 重写移除事件监听 删除对应的监听信息
		 * @param type 事件的类型。 
		 * @param listener 要删除的侦听器对象。 
		 * @param useCapture 指出是否为捕获阶段或目标阶段和冒泡阶段注册了侦听器。 如果为捕获阶段以及目标和冒泡阶段注册了侦听器，则需要对 removeEventListener() 进行两次调用才能将这两个侦听器删除，一次调用将 useCapture() 设置为 true，另一次调用将 useCapture() 设置为 false。 
		 * @see #addEventListener()
		 * 
		 */		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			var str:String = type + useCapture;
			
			if(m_listeners)
			{
				var model:ListenerModel = m_listeners.get(str);
				
				if(model != null)
				{
					ArrayUtil.remove(model.listener, listener);
					
					if(model.listener.length == 0) DisposeUtil.free(m_listeners.remove(str));
				}
			}
		}
		
		//==========================================		保存事件监听信息			==========================================
		
		
		
		//==========================================		保存子显示对象		==========================================
		
		/**
		 * 将一个 DisplayObject 子实例添加到该 DisplayObjectContainer 实例中。 子项将被添加到该 DisplayObjectContainer 实例中其它所有子项的前（上）面。 （要将某子项添加到特定索引位置，请使用 addChildAt() 方法。） 如果添加一个已将其它显示对象容器作为父项的子对象，则会从其它显示对象容器的子列表中删除该对象。
		 * @param child 要作为该 DisplayObjectContainer 实例的子项添加的 DisplayObject 实例。
		 * @return 在 child 参数中传递的 DisplayObject 实例。
		 * @see #addChildAt()
		 * @see #removeChild()
		 * @see #removeChildAt()
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			super.addChild(child);
			
			ArrayUtil.push(m_children, child);
			
			return child;
		}
		
		/**
		 * 将一个 DisplayObject 子实例添加到该 DisplayObjectContainer 实例中。 该子项将被添加到指定的索引位置。 索引为 0 表示该 DisplayObjectContainer 对象的显示列表的后（底）部。
		 * @param child 要作为该 DisplayObjectContainer 实例的子项添加的 DisplayObject 实例。
		 * @param index 添加该子项的索引位置。 如果指定当前占用的索引位置，则该位置以及所有更高位置上的子对象会在子级列表中上移一个位置。
		 * @see #addChild()
		 * @see #removeChild()
		 * @see #removeChildAt()
		 * 
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child == null) return null;
			
			super.addChildAt(child, index);
			
			ArrayUtil.push(m_children, child);
			
			return child;
		}
		
		/**
		 * 从 DisplayObjectContainer 实例的子列表中删除指定的 child DisplayObject 实例。 将已删除子项的 parent 属性设置为 null；如果没有对该子项的任何其它引用，则将该对象作为垃圾回收。 DisplayObjectContainer 中该子项之上的任何显示对象的索引位置都减去 1。 垃圾回收器是 Flash Player 用来重新分配未使用的内存空间的进程。 当在某处变量或对象不再被主动地引用或存储时，垃圾回收器将清理其过去占用的内存空间，并且如果不存在对该变量或对象的任何其它引用，则擦除此内存空间。
		 * @param child 要删除的 DisplayObject 实例。
		 * @return 在 child 参数中传递的 DisplayObject 实例。
		 * @see #addChild()
		 * @see #addChildAt()
		 * @see #removeChildAt()
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(child == null) return null;
			
			if(child.parent == this) super.removeChild(child);
			
			ArrayUtil.remove(m_children, child);
			
			return child;
		}
		
		/**
		 * 从 DisplayObjectContainer 的子列表中指定的 index 位置删除子 DisplayObject。 将已删除子项的 parent 属性设置为 null；如果没有对该子项的任何其它引用，则将该对象作为垃圾回收。 DisplayObjectContainer 中该子项之上的任何显示对象的索引位置都减去 1。 垃圾回收器是 Flash Player 用来重新分配未使用的内存空间的进程。 当在某处变量或对象不再被主动地引用或存储时，垃圾回收器将清理其过去占用的内存空间，并且如果不存在对该变量或对象的任何其它引用，则擦除此内存空间。
		 * @param index 要删除的 DisplayObject 的子索引。
		 * @return 已删除的 DisplayObject 实例。
		 * @see #addChild()
		 * @see #addChildAt()
		 * @see #removeChild()
		 */		
		override public function removeChildAt(index:int):DisplayObject
		{
			if(index < 0 || index >= numChildren) return null;
			
			var child:DisplayObject = super.removeChildAt(index);
			
			ArrayUtil.remove(m_children, child);
			
			return child;
		}
		
		//==========================================		保存子显示对象		==========================================
		
		
		
		
		
		//==========================================		是否启用本对象的鼠标事件		 ==========================================
		
		/**
		 * 是否启用本对象
		 */		
		public function get enabled():Boolean
		{
			return m_enabled;
		}
		
		/** @private */		
		public function set enabled(value:Boolean):void
		{
			if(m_enabled != value)
			{
				m_enabled = value;
				mouseEnabled = mouseChildren = m_enabled;
				tabEnabled = m_enabled;
			}
		}
		
		//==========================================		是否启用本对象的鼠标事件		 ==========================================
		
		
		
		
		//==========================================		ReleaseEvent实现		 ==========================================
		
		private function __spriteMouseDownListener(e:MouseEvent):void
		{
			m_pressedTarget = e.target as DisplayObject;
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, __stageRemovedFrom);
			}
		}
		
		private function __stageMouseUpListener(e:MouseEvent):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener);
			
			var isOutSide:Boolean = false;
			var target:DisplayObject = e.target as DisplayObject;
			
			if(!(this == target || CompUtil.isAncestorDisplayObject(this, target)))
			{
				isOutSide = true;
			}
			
			dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE, isOutSide, e));
			
			if(isOutSide)
			{
				dispatchEvent(new ReleaseEvent(ReleaseEvent.RELEASE_OUT_SIDE, isOutSide, e));
			}
			
			m_pressedTarget = null;
		}
		
		private function __stageRemovedFrom(e:Event):void
		{
			m_pressedTarget = null;
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener);
		}
		
		//==========================================		ReleaseEvent实现		 ==========================================
		
		
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		public function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0x000000, 1, dist, dist, .3, 1, knockout);
		}
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 释放资源
		 */		
		public function dispose():void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, __stageMouseUpListener, false);
//			removeEventListener(MouseEvent.MOUSE_DOWN, __spriteMouseDownListener);
//			removeEventListener(Event.REMOVED_FROM_STAGE, __stageRemovedFrom);
//			removeEventListener(MouseEvent.MOUSE_OVER, __rollOverHandler);
//			removeEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler);
//			removeEventListener(MouseEvent.ROLL_OUT, __rollOutHandler);
//			removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
//			removeEventListener(ReleaseEvent.RELEASE, __releaseHandler);
//			removeEventListener(Event.ENTER_FRAME, __trackMouseWhileInBounds);
//			removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
			
//			deactivateMouseTrap();
			
			removeAllEventListeners();
			DisposeUtil.free(m_listeners);
			m_listeners = null;
			
			DisposeUtil.free(m_children, m_freeBMD);
			m_children = null;
			
			m_pressedTarget = null;
		}
	}
}