package com.gestureworks.cml.away3d.layouts {
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.math.Vector3DUtils;
	import com.gestureworks.away3d.utils.LayoutTransforms;
	import com.gestureworks.away3d.utils.Math3DUtils;
	import com.gestureworks.cml.away3d.elements.Layout3D;
	import flash.geom.Vector3D;
	
	/**
	 * Circle layout that can be rotated in 3D.
	 * @author Iduem
	 */
	public class CircleLayout3D extends Layout3D {
		
		private var _radius:Number;
		private var _rot:Vector3D;
		
		/**
		 * Constructor
		 * @param	radius
		 */
		public function CircleLayout3D(radius:Number = 100, rot:Vector3D = null) {
			super();				
			_radius = radius;
			_rot = rot ||= new Vector3D(10, 0, 0);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function layout(container:ObjectContainer3D):void {
			
			var i:int;
			var cnt:int;
			var layoutTransforms:LayoutTransforms;		
			var azi:Number;
			var cart:Vector3D;
			var child:Object3D;
			childTransforms.length = 0;
			
			if(!children){
				children = getChildren(container);
			}

			cnt = children.length;	
			for (i = 0; i < cnt; i++) {								
				layoutTransforms = new LayoutTransforms;
				azi = 360 / cnt * i;
				cart = Math3DUtils.sphericalToCartesian( new Vector3D(azi, 0, radius) );
				cart = Vector3DUtils.rotatePoint(cart, rot);
				child = children[i];
				layoutTransforms.pos = cart;				
				
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
		
		/**
		 * Sets the rotation of the circle in 3D.
		 */	
		public function get rot():Vector3D {
			return _rot;
		}
		public function set rot(value:Vector3D):void {
			_rot = value;
		}		

	}
}