package com.gestureworks.cml.away3d.elements
{
	import com.gestureworks.away3d.Away3DTouchManager;
	import com.gestureworks.cml.core.*;
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.interfaces.*;
	import com.gestureworks.cml.managers.*;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
		
	
	public class TouchContainer3D extends TouchContainer
	{		
		private var _lookat:String;
		private var _pivot:String = "0,0,0";
		
		/**
		 * Constructor
		 */
		public function TouchContainer3D()
		{
			super();	
			transform3d = true;			
			away3d = true;	
		}	
		
		public function updateTransform():void
		{
			if(target)
				target.transform = transform.matrix3D;			
		}
		
		private var _target:*;
		/**
		 * Sets the transformation target
		 */
		public function get target():* { return _target; }
		public function set target(tgt:*):void {
			_target = tgt;
			if(_target){
				transform.matrix3D = _target.transform;
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
			this.x = value.split(",")[0];
			this.y = value.split(",")[1];
			this.z = value.split(",")[2];
		}
		
		private var _pos:String;
		/**
		 * Sets the position 
		 */
		public function get pos():String {return _pos;}
		public function set pos(value:String):void 
		{
			_pos = value;
			this.x = value.split(",")[0];
			this.y = value.split(",")[1];
			this.z = value.split(",")[2];
		}
		
		private var _rot:String;
		/**
		 * Sets the position 
		 */
		public function get rot():String {return _rot;}
		public function set rot(value:String):void 
		{
			_rot = value;
			this.rotationX = value.split(",")[0];
			this.rotationY = value.split(",")[1];
			this.rotationZ = value.split(",")[2];
		}
		
		private var _sca:String;
		/**
		 * Sets the position 
		 */
		public function get sca():String {return _sca;}
		public function set sca(value:String):void 
		{
			_sca = value;
			this.scaleX = value.split(",")[0];
			this.scaleY = value.split(",")[1];
			this.scaleZ = value.split(",")[2];
		}
		
				
		public function get pivot():String 
		{
			return _pivot;
		}
		
		public function set pivot(value:String):void 
		{
			_pivot = value;
		}
		
		public function get lookat():String 
		{
			return _lookat;
		}
		
		public function set lookat(value:String):void 
		{
			_lookat = value;
		}
		
	}
}