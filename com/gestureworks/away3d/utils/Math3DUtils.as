package com.gestureworks.away3d.utils {
	/**
	 * ...
	 * @author 
	 */
	public class Math3DUtils {
					
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