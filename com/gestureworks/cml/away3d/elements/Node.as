package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.SphereGeometry;
	import com.gestureworks.cml.away3d.interfaces.INode;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import flash.geom.Vector3D;
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
			_expanded = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function collapse(level:int = 0):void {
			_expanded = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toggle():void {
			if (_expanded)
				collapse();
			else
				expand();
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
			loadState(0);
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
		
		public function get vector3d():Vector3D { return new Vector3D(x, y, z); }
		
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D {
			super.addChild(child);
			if (child is Node) {
				addNode(child as Node);
			}
			else if (child is Edge){
				edges.push(child);
				Edge(child).init();
			}
			
			return child;
		}
		
		private function addNode(target:Node):void {
			target.geometry = geometry;
			target.material = material;
			target.x = x + 200;
			target.y = y + 200;
			target.z = z + 50;
			
			var edge:Edge = new Edge();
			edge.target = target;
			addChild(edge);			
		}
		
	}

}