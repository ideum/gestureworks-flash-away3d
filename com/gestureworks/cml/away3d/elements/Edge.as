package com.gestureworks.cml.away3d.elements {
	import away3d.events.Object3DEvent;
	import com.gestureworks.cml.away3d.geometries.CylinderGeometry;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
	
	/**
	 * Object linking source and target nodes
	 * @author Ideum
	 */
	public class Edge extends Mesh {
		
		private var initialized:Boolean = false;
		
		private var _source:Node;
		private var _target:Node;
		private var _length:Number;
		
		private var defaultGeometry:CylinderGeometry = new CylinderGeometry(10, 10);
		private var defaultMaterial:ColorMaterial = new ColorMaterial(0x72CAED);	
		
		/**
		 * Constructor
		 */
		public function Edge() {
			super();
			geometry = defaultGeometry;
			material = defaultMaterial;
		}
		
		/**
		 * Initialization function
		 */
		override public function init():void {				
			if (initialized) {
				reset();				
			}
			else{
				initialized = true;
				super.init();				
			}

			source = Node(parent);
			
			//calculate length
			var srcSurfaceOffset:Number = "radius" in source.geometry ? source.geometry["radius"] : source.geometry["width"] / 2;
			var tgtSurfaceOffset:Number = "radius" in target.geometry ? target.geometry["radius"] : target.geometry["width"] / 2;
			length = distance - srcSurfaceOffset - tgtSurfaceOffset;	
			
			geometry["height"] = length;
			geometry["yUp"] = false;			
			
			//connect edge to target node
			//movePivot(0, 0, -length / 2);											
			//lookAt(source.inverseSceneTransform.deltaTransformVector(target.scenePosition));						
			//moveTo(0, 0, length / 2);
			
			lookAt(source.inverseSceneTransform.transformVector(target.scenePosition));
			moveForward(length / 2 + tgtSurfaceOffset);
		}
		
		/**
		 * Reset initial state
		 */
		public function reset():void {
			position = new Vector3D(0, 0, 0);
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
			if (_target) {
				_target.addEventListener(Object3DEvent.POSITION_CHANGED, followTarget);
			}
		}
		
		/**
		 * Length of edge (distance between source and target)
		 */
		public function get length():Number { return _length; }
		public function set length(value:Number):void {
			_length = value;
		}
	
		public function get distance():Number { return Vector3D.distance(source.scenePosition, target.scenePosition); }
		
		/**
		 * 
		 * @param	e
		 */
		private function followTarget(e:Object3DEvent):void {
			if(source && target){
				lookAt(source.inverseSceneTransform.transformVector(target.scenePosition));
				scaleZ = distance / length;	
			}
		}
		
	}

}