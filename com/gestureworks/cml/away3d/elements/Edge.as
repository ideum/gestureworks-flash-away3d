package com.gestureworks.cml.away3d.elements {
	/**
	 * ...
	 * @author 
	 */
	public class Edge extends Mesh {
		
		private var _target:Node;
		
		public function Edge(target:Node=null) {
			_target = target;
		}
		
		public function get target():Node { return _target; }
		public function set target(value:Node):void {
			_target = value;
		}
		
	}

}