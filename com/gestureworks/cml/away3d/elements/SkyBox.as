package com.gestureworks.cml.away3d.elements {
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import away3d.utils.Cast;
	import com.gestureworks.cml.element.Image;
	
	/**
	 * ...
	 *
	 */
	public class SkyBox extends Container3D {
		
		private var cube_face:Array = new Array();
		private var _skyBox:away3d.primitives.SkyBox;
		
		public function SkyBox() {
			super();
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void {
			
			var counter:Number = 0;
			while (this.numChildren > 0) {

				if (this.getChildAt(0) is Image && counter < 6) {
					cube_face.push(this.getChildAt(0));
					counter++;
				}
				this.removeChildAt(0);
			}
			
			var bmCubeText:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(cube_face[0]), Cast.bitmapData(cube_face[1]), Cast.bitmapData(cube_face[2]), Cast.bitmapData(cube_face[3]), Cast.bitmapData(cube_face[4]), Cast.bitmapData(cube_face[5]));
			//																						right										left							up							down							front							back
			_skyBox = new away3d.primitives.SkyBox(bmCubeText);
			
			//find scene or camera tag? 
			if (this.parent is Scene) 
				Scene(this.parent).addChild3D(_skyBox);
			
		}
	}
}