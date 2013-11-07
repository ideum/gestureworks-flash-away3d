package com.gestureworks.away3d.utils {
	import com.gestureworks.cml.away3d.interfaces.IGeometry;
	import com.gestureworks.cml.core.CMLParser;
	/**
	 * ...
	 * @author 
	 */
	public class CML3DUtils {
		
		
		/**
		 * Determines if CML object is a Geometry instance
		 * @param	tag
		 * @return
		 */
		public static function isGeometry(tag:String):Boolean {
			return CMLParser.searchPackages(tag,["com.gestureworks.cml.away3d.geometries."]) is IGeometry; 
		}
		
		
		
	}

}