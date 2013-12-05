package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.away3d.geometries.CylinderGeometry;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author 
	 */
	public class Edge extends Mesh {
		
		private var _source:Node;
		private var _target:Node;
		private var _length:Number;
		
		private var defaultGeometry:CylinderGeometry = new CylinderGeometry(10, 10);
		private var defaultMaterial:ColorMaterial = new ColorMaterial(0x72CAED);	
		
		public function Edge() {
			super();
			geometry = defaultGeometry;
			material = defaultMaterial;
		}
		
		override public function init():void {
			super.init();	
			
			source = Node(parent);
			
			//calculate length
			var srcSurfaceOffset:Number = "radius" in source.geometry ? source.geometry["radius"] : source.geometry["width"] / 2;
			var tgtSurfaceOffset:Number = "radius" in target.geometry ? target.geometry["radius"] : target.geometry["width"] / 2;
			length = Vector3D.distance(source.scenePosition, target.scenePosition) - srcSurfaceOffset - tgtSurfaceOffset;		
			
			geometry["height"] = length;
			geometry["yUp"] = false;
			
			//connect edge to target node
			lookAt(target.position);		
			moveForward(length/2+tgtSurfaceOffset);
		}
		
		/**
		 * Source node
		 */
		public function get source():Node { return _source; }
		public function set source(value:Node):void {
			_source = value;
		}
		
		/**
		 * Target node
		 */
		public function get target():Node { return _target; }
		public function set target(value:Node):void {
			_target = value;
		}
		
		/**
		 * Length of edge (distance between source and target)
		 */
		public function get length():Number { return _length; }
		public function set length(value:Number):void {
			_length = value;
		}		
	}

}