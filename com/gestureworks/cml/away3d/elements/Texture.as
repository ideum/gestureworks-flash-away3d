package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.core.CMLObject;
	
	/**
	 * Loads Texture instances in CML through the ref attribute 
	 */
	public class Texture extends CMLObject {
		
		/**
		 * Constructor
		 */		
		public function Texture() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parseCML(cml:XMLList):XMLList {		
			var rXML:XMLList = new XMLList;
			if (cml.@ref != undefined) {
				
				if (cml.@ref == "Bitmap") {
					cml.@ref = "BitmapTexture";
				}	
				else if (cml.@ref == "Video") {
					cml.@ref = "VideoTexture";
				}	
				else if (cml.@ref == "VideoCamera") {
					cml.@ref = "VideoCameraTexture";
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