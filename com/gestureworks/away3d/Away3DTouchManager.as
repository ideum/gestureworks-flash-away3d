package com.gestureworks.away3d
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.MathConsts;
	import away3d.core.math.Vector3DUtils;
	import away3d.events.TouchEvent3D;
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.gestureworks.managers.*;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class Away3DTouchManager
	{
		private var touchBegin:GWTouchEvent;
		private var touchMove:GWTouchEvent;
		private var touchEnd:GWTouchEvent;
	

		private var touchObjects:Dictionary;
		
		private var view:View3D;
		
		public function Away3DTouchManager(view3D:View3D) {
			view = view3D;
			
			view.scene.addEventListener(TouchEvent3D.TOUCH_MOVE, onTouchMove);
			view.scene.addEventListener(TouchEvent3D.TOUCH_END, onTouchEnd);
			view.scene.addEventListener(TouchEvent3D.TOUCH_OUT, onTouchEnd);
			
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, onFrame);
			touchBegin = new GWTouchEvent(null, GWTouchEvent.TOUCH_BEGIN, true, false, 0, false);			
			touchMove = new GWTouchEvent(null, GWTouchEvent.TOUCH_MOVE, true, false, 0, false);
			touchEnd = new GWTouchEvent(null, GWTouchEvent.TOUCH_END, true, false, 0, false);
			touchObjects = new Dictionary(true);			
		}
				
		public function registerTouchObject(t:*):Away3DTouchObject {
			touchObjects[t] = new Away3DTouchObject(t);
			t.addEventListener(TouchEvent3D.TOUCH_BEGIN, onTouchBegin);
			return touchObjects[t];		
		}
		
		private function onTouchBegin( e:TouchEvent3D ):void {
			touchBegin.touchPointID = e.touchPointID;
			
			//touchBegin.stageX = view.camera.project(e.scenePosition).x * -view.camera.project(e.scenePosition).z;
			//touchBegin.stageY = view.camera.project(e.scenePosition).y * -view.camera.project(e.scenePosition).z * .5625; 
			
			var v:Vector3D = view.unproject(e.screenX, e.screenY, 1);
			var rot:Vector3D = new Vector3D( -view.camera.rotationX, -view.camera.rotationY, -view.camera.rotationZ);	
			v = rotatePoint(v, rot);
			var x:Number = v.x * Math.abs(v.z);
			var y:Number = v.y * Math.abs(v.z);
			
			touchBegin.stageX = v.x;
			touchBegin.stageY = v.y;
			
			touchBegin.target = e.target;
			touchBegin.eventPhase = 2;			
			
			touchObjects[e.target].onTouchDown(touchBegin);
		}		

		private function onTouchMove( e:TouchEvent3D ):void {
			touchMove.touchPointID = e.touchPointID;			
			
			var v:Vector3D = view.unproject(e.screenX, e.screenY, 1);	
			var cam:Vector3D = view.camera.position;
						
			trace("\n");
			trace("o-touchPoint: ", v.x.toFixed(3), v.y.toFixed(3), v.z.toFixed(3), v.length.toFixed(3));
			
			var rot:Vector3D = new Vector3D(-view.camera.rotationX, -view.camera.rotationY, -view.camera.rotationZ); 			
			v = Away3DTouchManager.rotatePoint(v, rot);

			trace("r-touchPoint: ", v.x.toFixed(3), v.y.toFixed(3), v.z.toFixed(3), v.length.toFixed(3) );
									
			var newX:Number = v.x * v.length;
			var newY:Number = v.y * v.length;
			
			trace(v.length);
			
			touchMove.stageX = newX;
			touchMove.stageY = newY;
			
			touchMove.target = e.target;
			TouchManager.onTouchMove(touchMove, true);
		}
		
		
		private function onTouchEnd( e:TouchEvent3D ):void {	
			touchEnd.touchPointID = e.touchPointID;
		
			var v:Vector3D = view.unproject(e.screenX, e.screenY, 0);
			var x:Number = v.x * v.z;
			var y:Number = v.y * v.z;
			
			touchMove.stageX = x;
			touchMove.stageY = y;
			
			TouchManager.onTouchUp(touchEnd, true);	
			touchObjects[e.target] = null;
			delete touchObjects[e.target];
		}			
				
		

		//public static function cartToSpher(cart:Vector3D):Vector3D
		//{
			//var dis:Number = cart.length;
			//var azi:Number = (Math.acos(cart.y/dis)) * MathConsts.RADIANS_TO_DEGREES;
			//var ele:Number = (Math.atan2(cart.z, cart.x)) * MathConsts.RADIANS_TO_DEGREES;	
			//return new Vector3D(azi, ele, dis);
		//}
		//
		//
		//public static function spherToCart(spher:Vector3D):Vector3D
		//{
			//var azi:Number = spher.x * MathConsts.DEGREES_TO_RADIANS;
			//var ele:Number = spher.y * MathConsts.DEGREES_TO_RADIANS;
			//var dis:Number = spher.z;			
			//
			//var x:Number = dis * Math.sin(azi) * Math.sin(ele);
			//var y:Number = dis * Math.sin(ele);
			//var z:Number = dis * Math.cos(azi) * Math.sin(ele);			
			//return new Vector3D(x, y, z);
		//}		
		
		
   
		
		private function onFrame(e:GWEvent):void 
		{
			for each (var to:Away3DTouchObject in TouchManager.touchObjects) {
				to.updateTransform();						
			}		
		}	

		
		public static function rotatePoint(aPoint:Vector3D, rotation:Vector3D):Vector3D
		{				
				var x1:Number;
				var y1:Number;
				
				var rad:Number = MathConsts.DEGREES_TO_RADIANS; 
				var rotx:Number = rotation.x*rad;
				var roty:Number = rotation.y*rad;
				var rotz:Number = rotation.z*rad;
				
				var sinx:Number = Math.sin(rotx);
				var cosx:Number = Math.cos(rotx);
				var siny:Number = Math.sin(roty);
				var cosy:Number = Math.cos(roty);
				var sinz:Number = Math.sin(rotz);
				var cosz:Number = Math.cos(rotz);
				
				var x:Number = aPoint.x;
				var y:Number = aPoint.y;
				var z:Number = aPoint.z;
				
				y1 = y;
				y = y1*cosx + z* -sinx;
				z = y1*sinx + z*cosx;
				
				x1 = x;
				x = x1*cosy + z*siny;
				z = x1* -siny + z*cosy;
				
				x1 = x;
				x = x1*cosz + y* -sinz;
				y = x1*sinz + y*cosz;
				
				aPoint.x = x;
				aPoint.y = y;
				aPoint.z = z;
				
			return aPoint;
		}		
	}
}