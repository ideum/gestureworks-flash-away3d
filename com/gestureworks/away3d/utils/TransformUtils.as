package com.gestureworks.away3d.utils {
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author 
	 */
	public class TransformUtils {
		
		//*** ADJUST THE FUNCTION DEFINITIONS AS NEEDED ****//
		
		/**
		 * This method will update a dtheta gesture rotate value
		 * so that applied transformation will be parallel 
		 * to the camera's view plane.
		 */
		public static function alignRotateToCamera(obj3d:ObjectContainer3D, camera:Camera3D, dtheta:Number):Vector {
			// return as vector (euler) or angle axis, this is up to you.
			var v:Vector3D = new Vector3D;
			return v;
		}
		
		/**
		 * This method will update a dtheta gesture rotate value
		 * so that applied transformation will snap to the nearest x,y,z 
		 * axis on the object.
		 */
		public static function snapRotateToCamera(obj3d:ObjectContainer3D, camera:Camera3D, dtheta:Number):void {
			// return as vector (euler) or angle axis, this is up to you.
			var v:Vector3D = new Vector3D;
			return v;			
		}
		
	}

}