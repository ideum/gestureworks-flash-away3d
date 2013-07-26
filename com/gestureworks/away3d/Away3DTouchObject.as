package com.gestureworks.away3d
{
	import away3d.events.TouchEvent3D;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.events.GWTransformEvent;
	import flash.events.Event;
	import com.gestureworks.core.VirtualTouchObject;
	
	public class Away3DTouchObject extends VirtualTouchObject
	{		
		public function Away3DTouchObject(target:*) 
		{
			super(target);
			transform.matrix3D = target.transform;
			transform3d = true;
		}
				
		public function updateTransform():void
		{
			target.transform = transform.matrix3D;			
		}
	}

}