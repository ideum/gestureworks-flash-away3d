package com.gestureworks.cml.away3d.elements {
	import away3d.events.Object3DEvent;
	import away3d.primitives.PlaneGeometry;
	import com.gestureworks.away3d.utils.Math3DUtils;
	import com.gestureworks.cml.away3d.geometries.CylinderGeometry;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
	
	/**
	 * Object linking source and target nodes
	 * @author Ideum
	 */
	public class EdgePlane extends Mesh {
		
		protected var defaultGeometry:CylinderGeometry = new PlaneGeometry(10, 10);
		protected var defaultMaterial:ColorMaterial = new ColorMaterial(0x72CAED);	
		
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
			else{
				initialized = true;
				super.init();
			}		
			
			//connect edge to target node
			followTarget();
		}
		
		/**
		 * 
		 * @param	e
		 */
		protected function followTarget(e:Object3DEvent=null):void {
			if (source && target) {				
				var targetPos:Vector3D = source.inverseSceneTransform.transformVector(target.scenePosition);
				var sphr:Vector3D = Math3DUtils.cartesianToSpherical(targetPos.position.subtract(position));	
				position = new Vector3D();
				rotateTo(0, -sphr.x, sphr.y);
				scaleX = distance / length;
				moveRight(length * scaleX / 2);
			}
		}
		
	}

}