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
			
			var d:int = sphericalCoords.z * 2; 
			
			var x:Number = d * Math.sin( sphericalCoords.x ) * Math.cos( sphericalCoords.y );
			var y:Number = d * Math.sin( sphericalCoords.x ) * Math.sin( sphericalCoords.y );
			var z:Number = d * Math.cos( sphericalCoords.x );
			return new Vector3D(x, y, z);
		}
		
	}

}