package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.away3d.interfaces.IGeometry;
	import com.gestureworks.cml.core.CMLObject;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.core.CMLParser;
	/**
	 * ...
	 * @author 
	 */
	public class Geometry extends CMLObject {
				
		public function Geometry() {
			super();
		}
		
		override public function parseCML(cml:XMLList):XMLList {		
			var rXML:XMLList = new XMLList;
			if (cml.@ref != undefined) {
				var ref:String = String(cml.@ref);
				var cp:XMLList = cml.copy();
				cp.setName(ref);
				delete cp.@ref;
				rXML = cp;
			}
			return rXML;
		}		
	}
}