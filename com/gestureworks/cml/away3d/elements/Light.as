package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.core.CMLObject;
	
	/**
	 * Loads Light instances in CML through the ref attribute 
	 */
	public class Light extends CMLObject {
		
		/**
		 * Constructor
		 */		
		public function Light() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parseCML(cml:XMLList):XMLList {		
			var rXML:XMLList = new XMLList;
						
			if (cml.@ref != undefined) {
				
				if (cml.@ref == "Point") {
					cml.@ref = "PointLight";
				}	
				else if (cml.@ref == "Directional") {
					cml.@ref = "DirectionalLight";
				}	
				
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