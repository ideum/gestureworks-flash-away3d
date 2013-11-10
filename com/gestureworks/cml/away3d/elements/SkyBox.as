package com.gestureworks.cml.away3d.elements {
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import away3d.utils.Cast;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.utils.document;
	
	/**
	 * Create a new SkyBox object. Composed of away3d.primitives.SkyBox as property obj.
	 */
	public class SkyBox extends Container3D {
		
		private var cube_face:Array = new Array();
		public var obj:away3d.primitives.SkyBox;
		
		public function SkyBox() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			for each (var child:* in childList) {
				if (child is Image) {
					cube_face.push(child);
				}
			}
			var bmCubeText:BitmapCubeTexture = 
				new BitmapCubeTexture(Cast.bitmapData(cube_face[0]), 
					Cast.bitmapData(cube_face[1]), // right
					Cast.bitmapData(cube_face[2]), // left
					Cast.bitmapData(cube_face[3]), // up
					Cast.bitmapData(cube_face[4]), // down
					Cast.bitmapData(cube_face[5])); // back
			obj = new away3d.primitives.SkyBox(bmCubeText);
			document.getElementsByTagName(Scene)[0].addChild3D(obj);
			
		}
	}
}