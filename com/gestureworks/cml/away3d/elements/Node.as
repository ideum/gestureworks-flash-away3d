package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.SphereGeometry;
	import com.gestureworks.cml.away3d.interfaces.INode;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	/**
	 * ...
	 * @author Ideum
	 */
	public class Node extends Mesh implements INode {
		
		private var _lookAtCamera:Boolean = true;
		private var _expanded:Boolean = false;
		private var _directed:Boolean = false;
		private var _autoToggle:Boolean = false;
		private var _autoToggleThreshold:Number = 0;
		private var _autoToggleVisibility:Boolean = true;
		private var _targets:String;
		private var _content:*;
		private var _index:int;
		private var _label:String;
		
		private var edges:Vector.<Edge> = new Vector.<Edge>();
		
		public function Node() {
			super();
			geometry = new SphereGeometry();
			material = new ColorMaterial();
		}
		
		override public function init():void {
			super.init();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get lookAtCamera():Boolean { return _lookAtCamera; }
		public function set lookAtCamera(value:Boolean):void {
			_lookAtCamera = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get expanded():Boolean { return _expanded; }
		
		/**
		 * @inheritDoc
		 */
		public function get directed():Boolean { return _directed; }
		
		/**
		 * @inheritDoc
		 */
		public function get leaf():Boolean { return edges.length == 0; }
		
		/**
		 * @inheritDoc
		 */
		public function expand(level:int = 1):void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function collapse(level:int = 0):void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function toggle():void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoToggle():Boolean { return _autoToggle; } 
		public function set autoToggle(value:Boolean):void {
			_autoToggle = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoToggleThreshold():Number { return _autoToggleThreshold; }
		public function set autoToggleThreshold(value:Number):void {
			_autoToggleThreshold = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoToggleVisibility():Boolean { return _autoToggleVisibility;  }
		public function set autoToggleVisibility(value:Boolean):void {
			_autoToggleVisibility = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function reset(level:int = int.MAX_VALUE):void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targets():String { return _targets; }
		public function set targets(value:String):void {
			_targets = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get content():* { return _content; }
		public function set content(value:*):void {
			_content = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get index():int { return _index; }
		public function set index(value:int):void {
			_index = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get level():String { return "a"; }
		
		/**
		 * @inheritDoc
		 */
		public function get hierarchy():String { return level; }
		
		/**
		 * @inheritDoc
		 */
		public function get label():String { return _label; }
		public function set label(value:String):void {
			_label = value;
		}
		
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D {
			if (child is Node) {
				var target:Node = child as Node;
				target.geometry = geometry;
				target.material = material;
				target.x = x + 200;
			}
			return super.addChild(child);
		}
		
	}

}