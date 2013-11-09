package com.gestureworks.away3d.utils {
	import away3d.core.math.MathConsts;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author 
	 */
	public class Math3DUtils {
					
		public static function sphericalToCartesian(sphericalCoords:Vector3D):Vector3D {
			var cartesianCoords:Vector3D = new Vector3D();
			var d:Number = sphericalCoords.z;
			var x:Number = d * Math.sin( sphericalCoords.x * MathConsts.DEGREES_TO_RADIANS ) * Math.cos( sphericalCoords.y * MathConsts.DEGREES_TO_RADIANS );
			var y:Number = d * Math.sin( sphericalCoords.x * MathConsts.DEGREES_TO_RADIANS ) * Math.sin( sphericalCoords.y * MathConsts.DEGREES_TO_RADIANS );
			var z:Number = d * Math.cos( sphericalCoords.x * MathConsts.DEGREES_TO_RADIANS );
			return new Vector3D(x, y, z);
		}
		
	}

}