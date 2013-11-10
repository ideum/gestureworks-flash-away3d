package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.core.CMLObject;
	
	/**
	 * Loads Material instances in CML through the ref attribute 
	 */
	public class Material extends CMLObject {
		
		/**
		 * Constructor
		 */		
		public function Material() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parseCML(cml:XMLList):XMLList {		
			var rXML:XMLList = new XMLList;
			
			if (cml.@texture != undefined) {
				cml.@tref = cml.@texture;
				delete cml.@texture;
			}	
			
			if (cml.@lightPicker != undefined) {
				cml.@lpref = cml.@lightPicker;
				delete cml.@lightPicker;
			}			
			
			if (cml.@ref != undefined) {
				
				if (cml.@ref == "Color") {
					cml.@ref = "ColorMaterial";
				}	
				else if (cml.@ref == "Texture") {
					cml.@ref = "TextureMaterial";
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