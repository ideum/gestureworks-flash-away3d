package com.gestureworks.away3d.utils {
	import away3d.core.math.MathConsts;
	import flash.geom.Vector3D;
	
	public class Math3DUtils {
					
		public static function sphericalToCartesian(sphericalCoords:Vector3D):Vector3D {
			var d:Number = sphericalCoords.z;
			sphericalCoords.x = 90-sphericalCoords.x;
			var x:Number = d * Math.sin( sphericalCoords.x * MathConsts.DEGREES_TO_RADIANS ) * Math.cos( sphericalCoords.y * MathConsts.DEGREES_TO_RADIANS );
			var y:Number = d * Math.sin( sphericalCoords.x * MathConsts.DEGREES_TO_RADIANS ) * Math.sin( sphericalCoords.y * MathConsts.DEGREES_TO_RADIANS );
			var z:Number = d * Math.cos( sphericalCoords.x * MathConsts.DEGREES_TO_RADIANS );
			return new Vector3D(x, y, z);
		}
		
		public static function cartesianToSpherical(cartesianCoords:Vector3D):Vector3D {			
			var a:Number = 0;
			var e:Number = 0;
			var d:Number = cartesianCoords.length;
			if (d != 0) {			
				e = Math.atan2( cartesianCoords.y, cartesianCoords.x ) * MathConsts.RADIANS_TO_DEGREES;
				a = Math.asin( cartesianCoords.z / d) * MathConsts.RADIANS_TO_DEGREES;
			}
			return new Vector3D(a, e, d);
		}		
		
	}

}