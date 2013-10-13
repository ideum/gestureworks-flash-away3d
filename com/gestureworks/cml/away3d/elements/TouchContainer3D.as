package com.gestureworks.cml.away3d.elements
{
	import away3d.containers.ObjectContainer3D;
	import com.gestureworks.away3d.Away3DTouchManager;
	import com.gestureworks.cml.core.*;
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.interfaces.*;
	import com.gestureworks.cml.managers.*;
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
		
	
	public class TouchContainer3D extends TouchContainer
	{		
		private var _lookat:String;
		private var _pivot:String = "0,0,0";
		private var _obj3D:ObjectContainer3D; 
		
		/**
		 * Constructor
		 */
		public function TouchContainer3D()
		{
			super();	
			away3d = true;	
		}
		
		override public function init():void 
		{
			super.init();
			obj3D = new ObjectContainer3D();
			obj3D.name = id;
			obj3D.x = x;
			obj3D.y = y;
			obj3D.z = z;
			obj3D.pivotPoint = new Vector3D(pivot.split(",")[0], pivot.split(",")[1], pivot.split(",")[2]);
			obj3D.rotationX = rotationX;
			obj3D.rotationY = rotationY;
			obj3D.rotationZ = rotationZ;
			if (lookat) //overides any rotation above
				obj3D.lookAt(new Vector3D(lookat.split(",")[0], lookat.split(",")[1], lookat.split(",")[2]));
			obj3D.scaleX = scaleX;
			obj3D.scaleY = scaleY;
			obj3D.scaleZ = scaleZ;
			
			if (parent is TouchContainer3D)
				TouchContainer3D(parent).addChild3D(obj3D);
		}
		
		override public function updateVTO():void 
		{
			vto.transform = transform.matrix3D;
		}
		
		private var _vto:*;
		/**
		 * Sets the transformation target
		 */
		override public function get vto():Object { return _vto; }
		override public function set vto(tgt:Object):void {
			_vto = tgt;
			if(_vto){
				transform.matrix3D = _vto.transform;
				Away3DTouchManager.registerTouchObject(this);
			}
			else {
				transform.matrix3D = null;
				Away3DTouchManager.deregisterTouchObject(this);
			}
		}
		
		private var _position:*;
		/**
		 * Sets the position 
		 */
		override public function get position():* {return _position;}
		override public function set position(value:*):void 
		{
			_position = value;
			x = value.split(",")[0];
			y = value.split(",")[1];
			z = value.split(",")[2];
		}
		
		/**
		 * Sets the position 
		 */
		public function get pos():* {return _position;}
		public function set pos(value:*):void 
		{
			position = value;
		}		
		
		private var _rot:String;
		/**
		 * Sets the rotation 
		 */
		public function get rot():String {return _rot;}
		public function set rot(value:String):void 
		{
			_rot = value;
			rotationX = value.split(",")[0];
			rotationY = value.split(",")[1];
			rotationZ = value.split(",")[2];
		}
		
		private var _sca:String;
		/**
		 * Sets the scale 
		 */
		public function get sca():String {return _sca;}
		public function set sca(value:String):void 
		{
			_sca = value;
			scaleX = value.split(",")[0];
			scaleY = value.split(",")[1];
			scaleZ = value.split(",")[2];
		}
		
				
		public function get pivot():String { return _pivot; }		
		public function set pivot(value:String):void {
			_pivot = value;
		}
		
		public function get lookat():String { return _lookat; }		
		public function set lookat(value:String):void {
			_lookat = value;
		}
		
		public function addChild3D(child:ObjectContainer3D):void {
			obj3D.addChild(child);
		}
		
		public function get obj3D():ObjectContainer3D { return _obj3D; }		
		public function set obj3D(value:ObjectContainer3D):void {
			_obj3D = value;
		}		
		
	}
}