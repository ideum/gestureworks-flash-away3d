package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.core.CMLObject;
	
	/**
	 * Loads Geometry instances in CML through the ref attribute 
	 */
	public class Geometry extends CMLObject {
		
		/**
		 * Constructor
		 */
		public function Geometry() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parseCML(cml:XMLList):XMLList {		
			var rXML:XMLList = new XMLList;
			
			if (cml.@ref == "Capsule") {
				cml.@ref = "CapsuleGeometry";
			}	
			else if (cml.@ref == "Cone") {
				cml.@ref = "ConeGeometry";
			}		
			else if (cml.@ref == "Cube") {
				cml.@ref = "CubeGeometry";
			}
			else if (cml.@ref == "Cylinder") {
				cml.@ref = "CylinderGeometry";
			}
			else if (cml.@ref == "NURBS") {
				cml.@ref = "NURBSGeometry";
			}			
			else if (cml.@ref == "Plane") {
				cml.@ref = "PlaneGeometry";
			}
			else if (cml.@ref == "Sphere") {
				cml.@ref = "SphereGeometry";
			}			
			else if (cml.@ref == "Torus") {
				cml.@ref = "TorusGeometry";
			}
			
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