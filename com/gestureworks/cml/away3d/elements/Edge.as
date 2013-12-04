package com.gestureworks.cml.away3d.elements {
	import away3d.primitives.CylinderGeometry;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author 
	 */
	public class Edge extends Mesh {
		
		private var _target:Node;
		private var _length:Number;
		
		public function Edge() {
			super();
		}
		
		override public function init():void {
			super.init();			
			length = Vector3D.distance(new Vector3D(x, y, z), target.vector3d);
			geometry = new CylinderGeometry(10, 10, length);			
			CylinderGeometry(geometry).yUp = false;
			material = new ColorMaterial(0x72CAED);	
			lookAt(target.vector3d);			
		}
		
		public function get target():Node { return _target; }
		public function set target(value:Node):void {
			_target = value;
		}
		
		public function get length():Number { return _length; }
		public function set length(value:Number):void {
			_length = value;
		}
		
	}

}