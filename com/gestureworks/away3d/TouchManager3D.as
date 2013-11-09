package com.gestureworks.away3d
{
	import away3d.containers.*;
	import away3d.core.pick.IPicker;
	import away3d.core.pick.PickingCollisionVO;
	import away3d.core.pick.PickingType;
	import away3d.events.*;
	import com.gestureworks.cml.away3d.elements.Scene;
	import com.gestureworks.cml.away3d.elements.TouchContainer3D;
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.gestureworks.managers.*;
	import flash.display.DisplayObjectContainer;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class TouchManager3D
	{
		private static var tBegin:GWTouchEvent;
		private static var tMove:GWTouchEvent;
		private static var tEnd:GWTouchEvent;
		private static var touchPicker:IPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;  
		private static var touchObjects:Dictionary = new Dictionary(true);	
		private static var collider:PickingCollisionVO; 
		private static var pointTargets:Dictionary = new Dictionary();
		public static var touch3d:Boolean = true;
		
		public static function initialize():void {
			TouchManager.registerHook(point3DListener);
			touchPicker.onlyMouseEnabled = false;
		}
				
		public static function registerTouchObject(t:*, touch3d:Boolean=true):TouchContainer3D
		{
			if (t is TouchContainer3D){
				touchObjects[t.vto] = t;
				return null; 
			}
			else {
				touchObjects[t] = new TouchContainer3D(t);
				touchObjects[t].vto = t;
				touchObjects[t].touch3d = touch3d;
			}
			return touchObjects[t];		
		}
		
		public static function deregisterTouchObject(t:*):void 
		{
			if(t is TouchContainer3D)
				delete touchObjects[t.vto];
			else
				delete touchObjects[t];
		}	
		
		private static function validTarget(obj:Object):Object {
			if (!obj)
				return obj;
			if (touchObjects[obj])
				return touchObjects[obj];
			return validTarget(obj.parent);
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
			var sceneTouch:Boolean = e.target is Scene;
			var viewTouch:Boolean = e.target && e.target.parent is View3D;
			if (sceneTouch || viewTouch) {
				
				if (sceneTouch) {
					//collider = touchPicker.getSceneCollision(e.stageX, e.stageY, Scene(e.target.));					
				}
				else {
					var view:View3D = e.target.parent as View3D;
					e.view = view as DisplayObjectContainer;
					collider = touchPicker.getViewCollision(e.stageX, e.stageY, view);
				}
				
				if (collider) {
					e.target = validTarget(collider.entity);
					
					if(e.target){
						pointTargets[e.touchPointID] = e.target;		
						e.target.view = view;
						
						if ("touch3d" in e.target && e.target.touch3d) {
							var v:Vector3D = view.unproject(e.stageX, e.stageY, e.target.distance);
							e.stageX = v.x;
							e.stageY = v.y;
							e.stageZ = v.z;
						}
					}
				}
			}
		
			return e;
		}
		
		
		public static function hitTest3D(target: TouchObject3D, view:View3D, x:Number, y:Number):Boolean
		{			
			var hit:Boolean = false;
			collider = touchPicker.getViewCollision(x, y, view);
			
			if (collider) {
					//if( validTarget(collider.entity)) 
					trace("hit object 3d", collider.entity);
					
					if ( collider.entity.assetType == "Mesh"){//WireFrameCube
						collider.entity.showBounds = true;
					}
					if ( collider.entity.assetType == "WireFrameCube"){//
						collider.entity.showBounds = true;
					}
					if ( collider.entity.assetType == "WireframeCylinder"){//WireFrameCube
						collider.entity.showBounds = true;
					}
					
					hit = true;
			}
			
			//trace("touch manager",collider,target, hit,view)
			return hit;
			
		}
		

		private static function onTouchMove(e:GWTouchEvent):GWTouchEvent
		{
			if (pointTargets.hasOwnProperty(e.touchPointID)) {
				if (e.target && e.target.parent is View3D) {
					var view:View3D = e.target.parent as View3D;
					e.view = view as DisplayObjectContainer;
					e.target = pointTargets[e.touchPointID];	
					e.target.view = view;
						if ("touch3d" in e.target && e.target.touch3d) {
							var v:Vector3D = view.unproject(e.stageX, e.stageY, e.target.distance);
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
					e.target.view = view;
						if ("touch3d" in e.target && e.target.touch3d) {
							var v:Vector3D = view.unproject(e.stageX, e.stageY, e.target.distance);
							e.stageX = v.x;
							e.stageY = v.y;
							e.stageZ = v.z;
						}
				}
				delete pointTargets[e.touchPointID];				
			}			
			return e;
		}			
		
	}
}