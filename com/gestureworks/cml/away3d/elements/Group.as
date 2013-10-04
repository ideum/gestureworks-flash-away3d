package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.events.TouchEvent3D;
	import com.gestureworks.away3d.Away3DTouchObject;
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
				var st:Away3DTouchObject = new Away3DTouchObject(groupObj3D);
				st.gestureList = {"n-drag": true, "n-rotate": true, "n-scale": true};
				st.disableNativeTransform = false;
				st.gestureReleaseInertia = false;
			}
						
			if (cmlGestureList != undefined) {
				var st:Away3DTouchObject = new Away3DTouchObject(groupObj3D);
				st.gestureList = {"n-drag": true, "n-rotate": true, "n-scale": true};
				st.gestureList = cmlGestureList;
				st.disableNativeTransform = true;
				st.gestureReleaseInertia = true;
			}			
		
		}
		
		
		override public function parseCML(cml:XMLList):XMLList {
			if (cml.GestureList != undefined)
				cmlGestureList = cml.GestureList;
			return super.parseCML(cml);
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
		
		override public function get touchEnabled():Boolean {
			return _touchEnabled;
		}
		
		override public function set touchEnabled(value:Boolean):void {
			_touchEnabled = value;
		}
	
	}

}