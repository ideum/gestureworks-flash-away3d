package com.gestureworks.away3d
{
	import away3d.containers.*;
	import away3d.core.math.MathConsts;
	import away3d.entities.Mesh;
	import away3d.events.*;
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.gestureworks.managers.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class Away3DTouchManager
	{
		private var view:View3D;
		private var touchObjects:Dictionary;		
		private var tBegin:GWTouchEvent;
		private var tMove:GWTouchEvent;
		private var tEnd:GWTouchEvent;
		private var pBegin:Point;
		private var pMove:Point;
		private var pEnd:Point;
		private var vIn:Vector3D;
		private var mIn:Matrix3D;
		private var mOut:Matrix3D;
		
		public function Away3DTouchManager(view3D:View3D) 
		{
			view = view3D;			
			view.scene.addEventListener(TouchEvent3D.TOUCH_MOVE, onTouchMove);
			view.scene.addEventListener(TouchEvent3D.TOUCH_END, onTouchEnd);
			view.scene.addEventListener(TouchEvent3D.TOUCH_OUT, onTouchEnd);
			touchObjects = new Dictionary(true);			
			tBegin = new GWTouchEvent(null, GWTouchEvent.TOUCH_BEGIN, true, false, 0, false);			
			tMove = new GWTouchEvent(null, GWTouchEvent.TOUCH_MOVE, true, false, 0, false);
			tEnd = new GWTouchEvent(null, GWTouchEvent.TOUCH_END, true, false, 0, false);
			mIn = new Matrix3D;
			mOut = new Matrix3D;
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, onFrame);			
		}
				
		public function registerTouchObject(t:*):Away3DTouchObject 
		{
			touchObjects[t] = new Away3DTouchObject(t);
			t.addEventListener(TouchEvent3D.TOUCH_BEGIN, onTouchBegin);
			return touchObjects[t];		
		}
		
		private function onTouchBegin(e:TouchEvent3D):void 
		{
			pBegin = convertScreenData(e.screenX, e.screenY, 1);											
			tBegin.stageX = pBegin.x;
			tBegin.stageY = pBegin.y;
			tBegin.touchPointID = e.touchPointID;			
			tBegin.type = "touchBegin";
			tBegin.target = e.target;
			tBegin.eventPhase = 2;			
			touchObjects[e.target].onTouchDown(tBegin);
		}		

		private function onTouchMove(e:TouchEvent3D):void 
		{
			pMove = convertScreenData(e.screenX, e.screenY, 1);			
			tMove.stageX = pMove.x;
			tMove.stageY = pMove.y;
			tMove.touchPointID = e.touchPointID;			
			tMove.type = "touchMove";
			tMove.target = e.target;
			TouchManager.onTouchMove(tMove, true);
		}
		
		private function onTouchEnd(e:TouchEvent3D):void 
		{	
			pEnd = convertScreenData(e.screenX, e.screenY, 1);								
			tEnd.stageX = pEnd.x;
			tEnd.stageY = pEnd.y;
			tEnd.touchPointID = e.touchPointID;			
			tEnd.type = "touchEnd";
			tEnd.target = e.target;
			TouchManager.onTouchUp(tEnd, true);	
			touchObjects[e.target] = null;
			delete touchObjects[e.target];
		}			
		
		private function convertScreenData(x:Number, y:Number, z:Number):Point
		{
			vIn = view.unproject(x, y, z);
			mIn.position = vIn;
			mIn.appendTranslation(-view.camera.position.x, -view.camera.position.y, -view.camera.position.z);			
			mIn.appendRotation(-view.camera.rotationX, new Vector3D(mIn.rawData[0], mIn.rawData[1], mIn.rawData[2]));
			mIn.appendRotation(-view.camera.rotationY, new Vector3D(mIn.rawData[4], mIn.rawData[5], mIn.rawData[6]));
			mIn.appendRotation(-view.camera.rotationZ, new Vector3D(mIn.rawData[8], mIn.rawData[9], mIn.rawData[10]));	
			return new Point(mIn.position.x * vIn.length, mIn.position.y * vIn.length);
		}
		
		public function alignToCamera(obj:Mesh, dx:Number, dy:Number, dz:Number):Vector3D
		{
			var v:Vector3D = new Vector3D(dx, dy, dz);	
			var len:Number = v.length;
			v.normalize();		
			
			trace(view.camera.rotationX, view.camera.rotationY, view.camera.rotationZ);
			
			mOut.position = new Vector3D(v.x, v.y, v.z);		
			
			mOut.appendRotation(17, new Vector3D(mOut.rawData[0], mOut.rawData[1], mOut.rawData[2]));
			mOut.appendRotation(17, new Vector3D(mOut.rawData[4], mOut.rawData[5], mOut.rawData[6]));
			mOut.appendRotation(17, new Vector3D(mOut.rawData[8], mOut.rawData[9], mOut.rawData[10]));	
			
			mOut.appendRotation(view.camera.rotationX, new Vector3D(mOut.rawData[0], mOut.rawData[1], mOut.rawData[2]));
			mOut.appendRotation(view.camera.rotationY, new Vector3D(mOut.rawData[4], mOut.rawData[5], mOut.rawData[6]));
			mOut.appendRotation(view.camera.rotationZ, new Vector3D(mOut.rawData[8], mOut.rawData[9], mOut.rawData[10]));

			return new Vector3D(mOut.position.x * len, mOut.position.y * len, mOut.position.z * len);
		}		
		
		public static function rotatePoint(aPoint:Vector3D, rotation:Vector3D):Vector3D
		{				
			var x1:Number;
			var y1:Number;
			
			var rotx:Number = rotation.x;
			var roty:Number = rotation.y;
			var rotz:Number = rotation.z;
			
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
		
		private function onFrame(e:GWEvent):void 
		{
			for each (var to:Away3DTouchObject in touchObjects) {
				if (!to.disableNativeTransform)
					to.updateTransform();						
			}		
		}		
	}
}