package com.gestureworks.away3d
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import com.gestureworks.core.*;
	import com.gestureworks.interfaces.IAway3D;
	
	public class Away3DTouchObject extends TouchSprite implements IAway3D
	{	
		private var _distance:Number;
		public var centerTransform:Boolean = true;
		public var camera:Camera3D;
		
		public function Away3DTouchObject(vto:*=null) 
		{
			super(target);	
			this.vto = vto;
			transform.matrix3D = vto.transform;
		}	
		/**
		 * Current distance from the target to camera
		 */
		public function get distance():Number 
		{ 
			//_distance = View3D(view).camera.project(target.scenePosition).length;
			return _distance; 
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