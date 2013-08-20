package com.gestureworks.cml.element.away3d {
	import away3d.containers.ObjectContainer3D;
	import away3d.events.TouchEvent3D;
	import com.gestureworks.cml.element.away3d.Container3D;
	import com.gestureworks.core.VirtualTouchObject;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.TouchManager;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 *
	 */
	public class Group extends Container3D {
		private var _groupObj3D:ObjectContainer3D;
		private var _touchEnabled:Boolean = false;
		
		public function Group() {
			super();
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void {
			displayComplete();
		}
		
		/**
		 * CML callback Initialisation
		 */
		override public function displayComplete():void {
			groupObj3D = new ObjectContainer3D();
			groupObj3D.name = this.id;
			groupObj3D.x = this.x;
			groupObj3D.y = this.y;
			groupObj3D.z = this.z;
			groupObj3D.pivotPoint = new Vector3D(this.pivot.split(",")[0], this.pivot.split(",")[1], this.pivot.split(",")[2]);
			groupObj3D.rotationX = this.rotationX;
			groupObj3D.rotationY = this.rotationY;
			groupObj3D.rotationZ = this.rotationZ;
			if (this.lookat) //overides any rotation above
				groupObj3D.lookAt(new Vector3D(this.lookat.split(",")[0], this.lookat.split(",")[1], this.lookat.split(",")[2]));
			groupObj3D.scaleX = this.scaleX;
			groupObj3D.scaleY = this.scaleY;
			groupObj3D.scaleZ = this.scaleZ;
			
			if (this.parent is Scene)
				Scene(this.parent).addChild3D(groupObj3D);
			
			if (this.parent is Group)
				Group(this.parent).addChild3D(groupObj3D);
			
			if (this.parent is Mesh)
				Mesh(this.parent).addChild3D(groupObj3D);
			
			if (this.parent is Light)
				Light(this.parent).addChild3D(groupObj3D);
			
			//Need a way to search for the Gesture Tag so this can be set
			if (this._touchEnabled) {
				var st:AwayTouchObject = new AwayTouchObject(this);
				st.gestureList = {"n-drag": true, "n-rotate": true, "n-scale": true};
				st.disableNativeTransform = false;
				st.gestureReleaseInertia = false;
				enableListeners();
			}
			
			
			//if (this._touchEnabled) {
			if (cmlGestureList != undefined) {
				var st:AwayTouchObject = new AwayTouchObject(this);
				//st.gestureList = {"n-drag": true, "n-rotate": true, "n-scale": true};
				st.makeGestureList(cmlGestureList);
				st.disableNativeTransform = true;
				st.gestureReleaseInertia = true;
				enableListeners();
			}			
		
		}
		
		
		private function enableListeners():void {
			//trace("enableListeners")
			_groupObj3D.mouseEnabled = true;
			_groupObj3D.mouseChildren = true;
			
			_groupObj3D.addEventListener(TouchEvent3D.TOUCH_BEGIN, ontouch);
			_groupObj3D.addEventListener(TouchEvent3D.TOUCH_MOVE, ontouch);
			_groupObj3D.addEventListener(TouchEvent3D.TOUCH_END, ontouch);
		}
		
		private var cmlGestureList:XMLList;
		override public function parseCML(cml:XMLList):XMLList {
			if (cml.GestureList != undefined)
				cmlGestureList = cml.GestureList;
			return super.parseCML(cml);
		}		
		
		public function ontouch(e:TouchEvent3D):void {
			e.stopPropagation();
			var event:GWTouchEvent
			switch (e.type) {
				case TouchEvent3D.TOUCH_BEGIN: 
					for each (var vto:VirtualTouchObject in TouchManager.touchObjects) {
						if (e.object == vto.target.groupObj3D)
						{
							event = new GWTouchEvent(null, GWTouchEvent.TOUCH_BEGIN, true, false, e.touchPointID, false);
							event.stageX = e.screenX;
							event.stageY = e.screenY;
							event.eventPhase = 2;
							event.target = vto;
							vto.onTouchDown(event);
						}
					}
					break;
				case TouchEvent3D.TOUCH_MOVE: 
					event = new GWTouchEvent(null, GWTouchEvent.TOUCH_MOVE, true, false, e.touchPointID, false);
					event.stageX = e.screenX;
					event.stageY = e.screenY;
					TouchManager.onTouchMove(event);
					break;
				case TouchEvent3D.TOUCH_END: 
					event = new GWTouchEvent(null, GWTouchEvent.TOUCH_END, true, false, e.touchPointID, false);
					event.stageX = e.screenX;
					event.stageY = e.screenY;
					TouchManager.onTouchUp(event);
					break;
			}
		}
		
		public function addChild3D(child:ObjectContainer3D):void {
			groupObj3D.addChild(child);
		}
		
		public function get groupObj3D():ObjectContainer3D {
			return _groupObj3D;
		}
		
		public function set groupObj3D(value:ObjectContainer3D):void {
			_groupObj3D = value;
		}
		
		public function get touchEnabled():Boolean {
			return _touchEnabled;
		}
		
		public function set touchEnabled(value:Boolean):void {
			_touchEnabled = value;
		}
	
	}

}