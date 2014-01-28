package com.gestureworks.away3d.utils {
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import com.gestureworks.cml.away3d.elements.TouchContainer3D;
	import com.gestureworks.events.GWGestureEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author 
	 */
	public class TransformUtils {
				
		/**
		 * This method will update a dtheta gesture rotate value
		 * so that applied transformation will be parallel 
		 * to the camera's view plane.
		 */
		public static function alignRotateToCamera(obj3d:ObjectContainer3D, camera:Camera3D):Vector3D {
			var axis:Vector3D = camera.forwardVector.clone();
			axis.negate();
			axis = obj3d.parent.inverseSceneTransform.deltaTransformVector(axis);
			
			return axis;
		}
		
		/**
		 * This method will update a dtheta gesture rotate value
		 * so that applied transformation will snap to the nearest 
		 * x,y,z axis perpendicular to the camera's view plane 
		 * (meaning the applied rotational transformation will be 
		 * approximately parallel to the camera's view plane).
		 * axis on the object.
		 */
		public static function snapRotateToCamera(obj3d:ObjectContainer3D, camera:Camera3D):Vector3D {
			var camFwd:Vector3D = camera.forwardVector;
			camFwd = obj3d.parent.inverseSceneTransform.deltaTransformVector(camFwd);
			
			var rotAxis:Vector3D
			
			var right:Number = camFwd.dotProduct(obj3d.rightVector);
			var left:Number = camFwd.dotProduct(obj3d.leftVector);
			var up:Number = camFwd.dotProduct(obj3d.upVector);
			var down:Number = camFwd.dotProduct(obj3d.downVector);
			var front:Number = camFwd.dotProduct(obj3d.forwardVector);
			var back:Number = camFwd.dotProduct(obj3d.backVector);
			
			var min:Number = Math.min(front, back, left, right, up, down);
			
			switch (min) 
			{
				case right:
					rotAxis = obj3d.rightVector;
				break;
				case left:
					rotAxis = obj3d.leftVector;
				break;
				case up:
					rotAxis = obj3d.upVector;
				break;
				case down:
					rotAxis = obj3d.downVector;
				break;
				case front:
					rotAxis = obj3d.forwardVector;
				break;
				case back:
					rotAxis = obj3d.backVector;
				break;
			default:
				trace("############FAILED")
			}
			
			return rotAxis;			
		}
		
		public static function updateAxisRotation(e:GWGestureEvent, axis:Vector3D):void {
			var obj3d:ObjectContainer3D = ObjectContainer3D(TouchContainer3D(e.currentTarget).vto);
			var mtx:Matrix3D = obj3d.transform.clone();
			mtx.appendRotation(e.value.rotate_dtheta, axis, obj3d.position);
			obj3d.transform = mtx;
		}
		
	}

}