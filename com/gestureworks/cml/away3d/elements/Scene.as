package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import com.gestureworks.cml.elements.Container;
	import flash.events.Event;
	
	/**
	 * Creates a 3D scene.
	 */
	public class Scene extends Container {				
		
		private var views:Vector.<View3D> = new Vector.<View3D>;		
		public var scene3D:Scene3D;		
		
		private var _renderViews:Boolean = true;
			
		/**
		 * Constructor
		 */
		public function Scene() {
			super();
			scene3D = new Scene3D();
		}	
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			super.init();
			
			if (renderViews) {
				addEventListener(Event.ENTER_FRAME, tick);
			}		
		}				
		
		/**
		 * Adds view to the scene.
		 * @param	view
		 */
		public function addView(view:View3D):void {
			views.push(view);
			addChild(view);
		}
		
		/**
		 * Adds to the 3D display list.
		 * @param	child
		 */
		public function addChild3D(child:*):void {
			scene3D.addChild(child);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addAllChildren():void {		
			var n:int = childList.length;
			for (var i:int = 0; i < childList.length; i++) {
				if (childList[i] is ObjectContainer3D)				
					addChild3D(childList[i]);
				else if (childList[i] is Light) {
					addChild3D(childList[i].childList[0]);
				}
				if (n != childList.length)
					i--;
			}
		}			
				
		/**
		 * @private
		 * Render update
		 */
		private function tick(e:Event):void {
			for each (var v:View3D in views) {
				v.render();
			}
		}
		
		/**
		 * Dispose methods to nullify children
		 */
		override public function dispose():void {
			super.dispose();
			removeEventListener(Event.ENTER_FRAME, tick);
			scene3D = null;
		}
		
		/**
		 * Render views on each frame
		 */
		public function get renderViews():Boolean { return _renderViews; }
		public function set renderViews(value:Boolean):void {
			_renderViews = value;
		}
	}
}