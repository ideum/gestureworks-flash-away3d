package com.gestureworks.cml.away3d.elements {
	/**
	 * ...
	 * @author 
	 */
	public class NodeGraph extends TouchContainer3D {
		
		private var _graph:String;
		
		public function NodeGraph() {
			
		}
		
		/**
		 * A string defining vertices and edges of a node graph. For example 12:0-1,2-3,3-4,4-5,5-6,6-1,1-7,2-8,3-9,4-10,5-11,6-12, where 12 is
		 * the node count and proceeding comma delimited values are link declarations.
		 */
		public function get graph():String { return _graph; }
		public function set graph(value:String):void {
			if (value == _graph) {
				return;
			}
			_graph = value;
			parseGraph();
		}
		
		private function parseGraph():void {
			
		}
		
	}

}