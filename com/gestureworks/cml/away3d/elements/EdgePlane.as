package com.gestureworks.cml.away3d.elements {
	import away3d.events.Object3DEvent;
	import away3d.primitives.PlaneGeometry;
	import com.gestureworks.away3d.utils.Math3DUtils;
	import com.gestureworks.cml.away3d.geometries.CylinderGeometry;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
	import away3d.core.base.Geometry;
	
	/**
	 * Object linking source and target nodes
	 * @author Ideum
	 */
	public class EdgePlane extends Edge {
		
		/**
		 * Constructor
		 */
		public function EdgePlane() {
			super();	
		}
		
		/**
		 * Initialization function
		 */
		override public function init():void {				
			if (initialized) {
				return;				
			}
			else {
				superInit();
				initialized = true;				
			}		
			
			try{ source = Node(parent); }
			catch (e:Error) { return; }
			
			length = distance;
			
			//connect edge to target node
			followTarget();
		}
		
		/**
		 * 
		 * @param	e
		 */
		override protected function followTarget(e:Object3DEvent=null):void {
			if (source && target) {								
				var sphr:Vector3D = Math3DUtils.cartesianToSpherical( target.scenePosition.subtract(source.scenePosition) );				
				position = new Vector3D();
				rotateTo(0, -sphr.x, sphr.y);
				scaleX = sphr.z / length;
				moveRight(length / 2);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get defaultGeometry():away3d.core.base.Geometry {
			return new PlaneGeometry(100, 10, 1, 1, false, false);
		}
		
	}

}