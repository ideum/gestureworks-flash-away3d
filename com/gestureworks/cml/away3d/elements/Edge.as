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
		
		protected var initialized:Boolean = false;
		
		protected var _source:Node;
		protected var _target:Node;
		protected var _length:Number;
		
		protected var defaultGeometry:CylinderGeometry = new CylinderGeometry(10, 10);
		protected var defaultMaterial:ColorMaterial = new ColorMaterial(0x72CAED);	
		
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
				return;				
			}
			else{
				initialized = true;
				super.init();				
			}
			
			try{ source = Node(parent); }
			catch (e:Error) { return; }
			
			//calculate length
			var srcSurfaceOffset:Number = "radius" in source.geometry ? source.geometry["radius"] : source.geometry["width"] / 2;
			var tgtSurfaceOffset:Number = "radius" in target.geometry ? target.geometry["radius"] : target.geometry["width"] / 2;
			length = distance;// - srcSurfaceOffset - tgtSurfaceOffset;	
			
			geometry["height"] = length;
			geometry["yUp"] = false;			
			
			//connect edge to target node
			position = new Vector3D();
			lookAt(source.inverseSceneTransform.transformVector(target.scenePosition));						
			moveForward(length * scaleZ / 2);
		}
		
		/**
		 * Reset initial state
		 */
		public function reset():void {
			position = new Vector3D(0, 0, 0);
			pivotPoint = new Vector3D(0, 0, 0);
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
	
		/**
		 * Distance between source and target nodes
		 */
		public function get distance():Number { return Vector3D.distance(source.scenePosition, target.scenePosition); }
		
		/**
		 * 
		 * @param	e
		 */
		protected function followTarget(e:Object3DEvent):void {
			if (source && target) {				
				position = new Vector3D();
				lookAt(source.inverseSceneTransform.transformVector(target.scenePosition));				
				scaleZ = distance / length;	
				moveForward(length * scaleZ / 2);
			}
		}
		
	}

}