package com.gestureworks.away3d
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.events.TouchEvent3D;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.utils.*;
	
	import away3d.core.math.Matrix3DUtils;
	import away3d.primitives.LineSegment;
	import away3d.entities.SegmentSet;
	import away3d.debug.WireframeAxesGrid;
	import away3d.debug.AwayStats;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.events.GWTransformEvent;
	import com.gestureworks.core.VirtualTouchObject;
	
	
	public class Away3DTouchObject extends VirtualTouchObject
	{		
		public function Away3DTouchObject(target:*) 
		{
			super(target);	
			transform.matrix3D = target.transform;
			transform3d = true;			
			registerPoints = false;	
			away3d = true;
		}
				
		public function updateTransform():void
		{
			target.transform = transform.matrix3D;			
		}
		
		
		
		
	}

}