package com.gestureworks.away3d
{
	import away3d.containers.*;
	import away3d.core.math.MathConsts;
	import away3d.entities.Mesh;
	import away3d.events.*;
	import com.gestureworks.cml.away3d.elements.TouchContainer3D;
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.gestureworks.managers.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class Away3DTouchManager
	{
		private static var view:View3D;	
		private static var tBegin:GWTouchEvent;
		private static var tMove:GWTouchEvent;
		private static var tEnd:GWTouchEvent;
		private static var vIn:Vector3D;
		private static var mIn:Matrix3D;
		private static var mOut:Matrix3D;
		private static var touchObjects:Dictionary;	
		
		public static var touch3d:Boolean = false;
		
		//public function Away3DTouchManager(view3D:View3D) 
		//{
			//view = view3D;
			//view.scene.addEventListener(TouchEvent3D.TOUCH_MOVE, onTouchMove);
			//view.scene.addEventListener(TouchEvent3D.TOUCH_END, onTouchEnd);
			//view.scene.addEventListener(TouchEvent3D.TOUCH_OUT, onTouchEnd);
			//touchObjects = new Dictionary(true);			
			//tBegin = new GWTouchEvent(null, GWTouchEvent.TOUCH_BEGIN, true, false, 0, false);			
			//tMove = new GWTouchEvent(null, GWTouchEvent.TOUCH_MOVE, true, false, 0, false);
			//tEnd = new GWTouchEvent(null, GWTouchEvent.TOUCH_END, true, false, 0, false);
			//mIn = new Matrix3D;
			//mOut = new Matrix3D;
			//GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, onFrame);			
		//}
		
		public static function initialize():void {
			TouchManager.registerHook(point3DListener);
		}
				
		public static function registerTouchObject(t:*):Away3DTouchObject 
		{
			if (t is TouchContainer3D){
				touchObjects[t.target] = t;
				return null; 
			}
			else
				touchObjects[t] = new Away3DTouchObject(t);
			return touchObjects[t];		
		}
		
		public static function deregisterTouchObject(t:*):void 
		{
			delete touchObjects[t];
		}	
		
		private static function point3DListener(e:GWTouchEvent):void {
			trace(e);
		}
		
		private static function onTouchBegin(e:TouchEvent3D):void 
		{			
			if (touch3d) {
				tBegin.stageX = e.scenePosition.x;
				tBegin.stageY = e.scenePosition.y;
				tBegin.stageZ = e.scenePosition.z;
			}
			else {
				var v:Vector3D = convertScreenData(e.screenX, e.screenY, 1);	
				tBegin.stageX = v.x;
				tBegin.stageY = v.y;
				tBegin.stageZ = v.z;						
			}
			tBegin.touchPointID = e.touchPointID;			
			tBegin.type = "touchBegin";
			tBegin.target = ITouchObject(touchObjects[e.target]);
			tBegin.eventPhase = 3;				
			TouchManager.onTouchDown(tBegin, true);
		}		

		private static function onTouchMove(e:TouchEvent3D):void 
		{
			if (touch3d) {
				tMove.stageX = e.scenePosition.x;
				tMove.stageY = e.scenePosition.y;
				tMove.stageZ = e.scenePosition.z;
			}
			else {
				var v:Vector3D = convertScreenData(e.screenX, e.screenY, 1);
				//trace(v.x, v.y, v.z);
				tMove.stageX = v.x;
				tMove.stageY = v.y;
				tMove.stageZ = v.z;					
			}
			tMove.touchPointID = e.touchPointID;			
			tMove.type = "touchMove";
			tMove.target = e.target;
			TouchManager.onTouchMove(tMove, true);
		}
		
		private static function onTouchEnd(e:TouchEvent3D):void 
		{
			if (touch3d) {
				tEnd.stageX = e.scenePosition.x;
				tEnd.stageY = e.scenePosition.y;
				tEnd.stageZ = e.scenePosition.z;
			}
			else {
				var v:Vector3D = convertScreenData(e.screenX, e.screenY, 1);				
				tEnd.stageX = v.x;
				tEnd.stageY = v.y;
				tEnd.stageZ = v.z;					
			}	
			tEnd.touchPointID = e.touchPointID;			
			tEnd.type = "touchEnd";
			tEnd.target = e.target;
			TouchManager.onTouchUp(tEnd, true);	
		}			
		
		public static function convertScreenData(x:Number, y:Number, z:Number=1, target:TouchSprite=null):Vector3D
		{			
			vIn = view.unproject(x, y, z);
			
			var len:Number = vIn.length;
			
			//vIn.normalize();
			
			//trace(vIn.length, vIn.x, vIn.y, vIn.z);
			return new Vector3D(vIn.x, vIn.y, vIn.z);
			
			//mIn.position = vIn;
			//mIn.appendTranslation(-view.camera.position.x, -view.camera.position.y, -view.camera.position.z);			
			//mIn.appendRotation(-view.camera.rotationX, new Vector3D(mIn.rawData[0], mIn.rawData[1], mIn.rawData[2]));
			//mIn.appendRotation(-view.camera.rotationY, new Vector3D(mIn.rawData[4], mIn.rawData[5], mIn.rawData[6]));
			//mIn.appendRotation(-view.camera.rotationZ, new Vector3D(mIn.rawData[8], mIn.rawData[9], mIn.rawData[10]));			
		}
		
		public static function alignToCamera(obj:Mesh, dx:Number, dy:Number, dz:Number):Vector3D
		{
			var v:Vector3D = new Vector3D(dx, dy, dz);	
			
			var cam:Vector3D = view.camera.position;
			cam.normalize();
			
			mOut.position = new Vector3D(v.x, v.y, v.z);	
			
			var sph:Vector3D = cartesianToSpherical( cam );						
			
			//mOut.appendRotation(sph.x * MathConsts.RADIANS_TO_DEGREES, new Vector3D(mOut.rawData[0], mOut.rawData[1], mOut.rawData[2]));
			//mOut.appendRotation(sph.y * MathConsts.RADIANS_TO_DEGREES, new Vector3D(mOut.rawData[4], mOut.rawData[5], mOut.rawData[6]));
			//mOut.appendRotation(sph.z * MathConsts.RADIANS_TO_DEGREES, new Vector3D(mOut.rawData[8], mOut.rawData[9], mOut.rawData[10]));	
			
			mOut.appendRotation(view.camera.rotationX, new Vector3D(mOut.rawData[0], mOut.rawData[1], mOut.rawData[2]));
			mOut.appendRotation(view.camera.rotationY, new Vector3D(mOut.rawData[4], mOut.rawData[5], mOut.rawData[6]));
			mOut.appendRotation(view.camera.rotationZ, new Vector3D(mOut.rawData[8], mOut.rawData[9], mOut.rawData[10]));
			
			return new Vector3D(mOut.position.x, mOut.position.y, mOut.position.z);
		}		
				
		
		private static function onFrame(e:GWEvent):void 
		{
			for each (var to:Away3DTouchObject in touchObjects) {
				if (to.nativeTransform)
					to.updateTransform();						
			}		
		}
		
		
		public static function sphericalToCartesian(sphericalCoords:Vector3D):Vector3D
		{
			var cartesianCoords:Vector3D = new Vector3D();
			var r:Number = sphericalCoords.z;
			cartesianCoords.y = r*Math.sin(-sphericalCoords.y);
			var cosE:Number = Math.cos(-sphericalCoords.y);
			cartesianCoords.x = r*cosE*Math.sin(sphericalCoords.x);
			cartesianCoords.z = r*cosE*Math.cos(sphericalCoords.x);
			return cartesianCoords;
		}
		public static function cartesianToSpherical(cartesianCoords:Vector3D):Vector3D
		{
			var cartesianFromCenter:Vector3D = new Vector3D();
			cartesianFromCenter.x = cartesianCoords.x;
			cartesianFromCenter.y = cartesianCoords.y;
			cartesianFromCenter.z = cartesianCoords.z;
			var sphericalCoords:Vector3D = new Vector3D();
			sphericalCoords.z = cartesianFromCenter.length;
			sphericalCoords.x = Math.atan2(cartesianFromCenter.x, cartesianFromCenter.z);
			sphericalCoords.y = -Math.asin((cartesianFromCenter.y) / sphericalCoords.z);
			return sphericalCoords;
		}
		
	}
}