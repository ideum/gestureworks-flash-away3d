package com.gestureworks.cml.away3d.elements
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.core.*;
	import com.gestureworks.cml.elements.*;
	import com.gestureworks.cml.interfaces.*;
	import com.gestureworks.cml.managers.*;
	import com.gestureworks.interfaces.ITouchObject3D;
	import flash.geom.Vector3D;
		
	
	public class TouchContainer3D extends TouchContainer implements ITouchObject3D
	{		
		private var _vto:*;		
		private var _centerTransform:Boolean;
		private var _distance:Number;
		
		private var _sca:String;
		private var _pos:String;
		private var _rot:String;
		private var _lookat:String;
		private var _pivot:String = "0,0,0";	
		private var _touchOnlyTranslate:Boolean = true;
		/**
		 * Constructor
		 */
		public function TouchContainer3D(_vto:Object=null)
		{
			super();	
			if (_vto) {
				transform.matrix3D = _vto.transform.clone();
			}			
			touch3d = true;
			affineTransform = false;
			centerTransform = true;
		}
		
		override public function init():void 
		{
			super.init();
			
			if (_vto) {
				vto.pivotPoint = new Vector3D(pivot.split(",")[0], pivot.split(",")[1], pivot.split(",")[2]);				
				updateVTO();
				if (lookat) //overides any rotation
					vto.lookAt(new Vector3D(lookat.split(",")[0], lookat.split(",")[1], lookat.split(",")[2]));
			}
		}
		
		/**
		 * Current distance from the target to camera
		 */
		public function get distance():Number {
			var d:Number = 0;
			if (vto && view) {
				d = View3D(view).camera.project(vto.scenePosition).z; 
				_distance = d;
			}
			return d; 
		}		
		
		
		/**
		 * Sets the transformation target
		 */
		override public function get vto():Object { return _vto; }
		override public function set vto(tgt:Object):void {
			_vto = tgt;
			if(_vto){
				transform.matrix3D = _vto.transform;
				TouchManager3D.registerTouchObject(this);
			}
			else {
				transform.matrix3D = null;
				TouchManager3D.deregisterTouchObject(this);
			}
		}
				
		/**
		 * Sets the position as a comma seperated list.
		 */
		public function get pos():* {return _pos;}
		public function set pos(value:*):void 
		{
			_pos = value;
			x = value.split(",")[0];
			y = value.split(",")[1];
			z = value.split(",")[2];
		}		
		
		/**
		 * Sets the rotation as a comma seperated list. 
		 */
		public function get rot():String {return _rot;}
		public function set rot(value:String):void 
		{
			_rot = value;
			rotationX = value.split(",")[0];
			rotationY = value.split(",")[1];
			rotationZ = value.split(",")[2];
		}
		
		/**
		 * Sets the scale as a comma seperated list.
		 */
		public function get sca():String {return _sca;}
		public function set sca(value:String):void 
		{
			_sca = value;
			scaleX = value.split(",")[0];
			scaleY = value.split(",")[1];
			scaleZ = value.split(",")[2];
		}
		
		/**
		 * Sets the pivot point as a comma seperated list.
		 */		
		public function get pivot():String { return _pivot; }		
		public function set pivot(value:String):void {
			_pivot = value;
		}
		
		/**
		 * Sets the lookAt vector as a comma seperated list.
		 */			
		public function get lookat():String { return _lookat; }		
		public function set lookat(value:String):void {
			_lookat = value;
		}
		
		/**
		 * The 3D object this touch container represents.
		 */			
		public function get obj():ObjectContainer3D { return _vto; }		
		public function set obj(value:ObjectContainer3D):void {
			_vto = value;
		}		
		
		/**
		 * Sets whether the transformations are about the center of the object.
		 */
		public function get centerTransform():Boolean { return _centerTransform; }
		public function set centerTransform(value:Boolean):void { _centerTransform = value; }
		

		/**
		 * Adds a child to the 3D object this touch container represents.
		 */		
		public function addChild3D(child:ObjectContainer3D):void {
			obj.addChild(child);
		}
			
		/**
		 * Updates target transform
		 */		
		private var _base_vector:Vector3D = new Vector3D(); // For garbage collection prevention
		override public function updateVTO():void
		{
			if (_touchOnlyTranslate) {
				vto.position = transform.matrix3D.transformVector(_base_vector);
			}
			else {
				vto.transform = transform.matrix3D;
			}		
		}	
		
		

		
	}
}