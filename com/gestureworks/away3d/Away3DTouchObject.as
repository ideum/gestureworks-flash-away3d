package com.gestureworks.away3d
{
	import away3d.containers.View3D;
	import com.gestureworks.core.*;
	import com.gestureworks.interfaces.IAway3D;
	
	public class Away3DTouchObject extends TouchSprite implements IAway3D
	{	
		private var _distance:Number;
		
		public function Away3DTouchObject(target:*=null) 
		{
			super(target);	
			this.target = target;
			transform.matrix3D = target.transform;
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
		override public function updateTarget():void
		{
			target.transform = transform.matrix3D;			
		}
		
	}
}