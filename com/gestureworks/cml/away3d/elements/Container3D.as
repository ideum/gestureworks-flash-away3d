package com.gestureworks.cml.away3d.elements
{
	import com.gestureworks.cml.core.*;
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.interfaces.*;
	import com.gestureworks.cml.managers.*;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
		
	/**
	 * for now, just a copy of container
	 */
	
	public class Container3D extends Container implements IContainer
	{		
		private var _lookat:String;
		private var _pivot:String = "0,0,0";
		
		/**
		 * Constructor
		 */
		public function Container3D()
		{
			super();
			
		}	
		
		///**
		 //* Defines the layoutlist
		 //*/
		//public var layoutList:Dictionary = new Dictionary(true);
		//
		private var _layout:*;
		/**
		 * Sets the layout of the container
		 */
		override public function get layout():* {return _layout;}
		override public function set layout(value:*):void 
		{
			_layout = value;
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
		
		
		/**
		 * Adds child to display list and, if not already added, the child list
		 * TODO: This mechanism should be abstracted to better syncrhonize child and display lists  
		 * @param	child
		 * @return
		 */
		override public function addChild(child:DisplayObject):flash.display.DisplayObject 
		{
			if ((childList.search(child) == -1)) {
				
				if (child.hasOwnProperty("id") && String(child["id"]).length > 0)
					childToList(child["id"], child);
				else
					childToList(child.name, child);
			}

			if (this == child) {
				
				trace(this.id, this);
				trace(child["id"], this);
				
				trace("fjlds");
			}	
			
			return super.addChild(child);
		}
				
			
		/**
		 * Dispose method nullify the attributes 
		 */
	    override public function dispose():void 
		{
			super.dispose();
			//layoutList = null;	
			//layout = null;
		}
		
	}
}