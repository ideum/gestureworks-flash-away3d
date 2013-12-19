package com.gestureworks.cml.away3d.layouts {
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import com.gestureworks.away3d.utils.LayoutTransforms;
	import com.gestureworks.away3d.utils.Math3DUtils;
	import com.gestureworks.cml.away3d.elements.Layout3D;
	import com.gestureworks.cml.layouts.Layout;
	import com.gestureworks.cml.utils.NumberUtils;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class Circle3DLayout extends Layout3D {
		
		private var _radius:Number = 100;
				
		public function Circle3DLayout() {
			super();
			
			
		}
		
		override public function layout(container:ObjectContainer3D):void {
			
			var i:int;
			var cnt:int = container.numChildren;
			var layoutTransforms:LayoutTransforms;		
			var azi:Number;
			var cart:Vector3D;
			var child:Object3D;
			childTransforms.length = 0;
			
			for (i = 0; i < cnt; i++) {								
				layoutTransforms = new LayoutTransforms;
				azi = 360 / cnt * i;
				cart = Math3DUtils.sphericalToCartesian( new Vector3D(azi, 0, radius) );
				child = container.getChildAt(i);
				layoutTransforms.pos = cart;
					
				//layoutTransforms.rot = new Vector3D(NumberUtils.randomNumber(rotMin.x, rotMax.x),
				//	NumberUtils.randomNumber(rotMin.y, rotMax.y),
				//	NumberUtils.randomNumber(rotMin.z, rotMax.z));
				
				childTransforms.push(layoutTransforms);
			}
			
			super.layout(container);
		}

		/**
		 * Sets the radius of the circle.
		 */	
		public function get radius():Number {
			return _radius;
		}
		public function set radius(value:Number):void {
			_radius = value;
		}
		
	}
}