package com.gestureworks.away3d
{
	import away3d.containers.*;
	import away3d.core.pick.IPicker;
	import away3d.core.pick.PickingCollisionVO;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.events.*;
	import com.gestureworks.cml.away3d.elements.TouchContainer3D;
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.gestureworks.managers.*;
	import flash.display.DisplayObjectContainer;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class Away3DTouchManager
	{
		private static var tBegin:GWTouchEvent;
		private static var tMove:GWTouchEvent;
		private static var tEnd:GWTouchEvent;
		private static var vIn:Vector3D;
		private static var mIn:Matrix3D;
		private static var mOut:Matrix3D;
		private static var touchPicker:IPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;  
		private static var touchObjects:Dictionary = new Dictionary(true);	
		private static var collider:PickingCollisionVO; 
		private static var pointTargets:Dictionary = new Dictionary();
		
		public static var touch3d:Boolean = false;
		
		public static function initialize():void {
			TouchManager.registerHook(point3DListener);
			mIn = new Matrix3D();
			mOut = new Matrix3D();
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
		
		private static function point3DListener(e:GWTouchEvent):GWTouchEvent {
			switch(e.type) {
				case "gwTouchBegin":
					return onTouchBegin(e);
				case "gwTouchMove":
					return onTouchMove(e);
				case "gwTouchEnd":
					return onTouchEnd(e);
				default:
					return e;
			}
		}
		
		private static function onTouchBegin(e:GWTouchEvent):GWTouchEvent 
		{		
			if (e.target && e.target.parent is View3D) {			
				var view:View3D = e.target.parent as View3D;
				e.view = view as DisplayObjectContainer;
				collider = touchPicker.getViewCollision(e.stageX, e.stageY, view);
				if (collider) {
					e.target = touchObjects[collider.entity];
					pointTargets[e.touchPointID] = e.target;
					if (touch3d) {
						e.stageX = e.target.scenePosition.x;
						e.stageY = e.target.scenePosition.y;
						e.stageZ = e.target.scenePosition.z;
					}
					else {
						var v:Vector3D = view.unproject(e.stageX, e.stageY, 0);	
						v = view.unproject(e.stageX, e.stageY, v.length)
						e.stageX = v.x;
						e.stageY = v.y;
						e.stageZ = v.z;
					}			
				}
			}
		
			return e;
		}		

		private static function onTouchMove(e:GWTouchEvent):GWTouchEvent
		{
			if (pointTargets.hasOwnProperty(e.touchPointID)) {
				if (e.target && e.target.parent is View3D) {
					var view:View3D = e.target.parent as View3D;
					e.view = view as DisplayObjectContainer;
					e.target = pointTargets[e.touchPointID];	
					if (touch3d) {
						e.stageX = e.target.scenePosition.x;
						e.stageY = e.target.scenePosition.y;
						e.stageZ = e.target.scenePosition.z;
					}
					else {
						var v:Vector3D = view.unproject(e.stageX, e.stageY, 0);	
						v = view.unproject(e.stageX, e.stageY, v.length)
						e.stageX = v.x;
						e.stageY = v.y;
						e.stageZ = v.z;
					}
				}
			}
			return e;
		}
		
		private static function onTouchEnd(e:GWTouchEvent):GWTouchEvent
		{
			if (pointTargets.hasOwnProperty(e.touchPointID)) {
				if (e.target && e.target.parent is View3D) {
					var view:View3D = e.target.parent as View3D;
					e.view = view as DisplayObjectContainer;
					e.target = pointTargets[e.touchPointID];	
					if (touch3d) {
						e.stageX = e.target.scenePosition.x;
						e.stageY = e.target.scenePosition.y;
						e.stageZ = e.target.scenePosition.z;
					}
					else {
						var v:Vector3D = view.unproject(e.stageX, e.stageY, 0);	
						v = view.unproject(e.stageX, e.stageY, v.length)
						e.stageX = v.x;
						e.stageY = v.y;
						e.stageZ = v.z;
					}
				}
				delete pointTargets[e.touchPointID];				
			}			
			return e;
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