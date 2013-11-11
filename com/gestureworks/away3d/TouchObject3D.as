package com.gestureworks.away3d
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import com.gestureworks.core.*;
	import com.gestureworks.interfaces.ITouchObject3D;
	
	public class TouchObject3D extends TouchSprite implements ITouchObject3D
	{	
		private var _distance:Number;
		public var centerTransform:Boolean = true;
		public var camera:Camera3D;
		
		public function TouchObject3D(_vto:*=null) 
		{
			super(_vto);
			if (_vto) {
				transform.matrix3D = vto.transform.clone();
			}
			touch3d = true;
		}	
		/**
		 * Current distance from the target to camera
		 */
		public function get distance():Number 
		{
			var d:Number = 0;
			if (vto && view) {
				d = View3D(view).camera.project(vto.scenePosition).length;
				_distance = d;
			}
			return d; 
		}
		
		/**
		 * Updates target transform
		 */		
		override public function updateVTO():void
		{
			vto.transform = transform.matrix3D;			
		}
		
	}
}