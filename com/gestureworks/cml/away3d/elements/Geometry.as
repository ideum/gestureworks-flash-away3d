package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.core.CMLObject;
	
	/**
	 * Loads Geometry instances in CML through ref attribute 
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