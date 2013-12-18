package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	/**
	 * ...
	 * @author Ideum
	 */
	public class NodeGraph extends Container3D {
		
		private var _graph:String;
		
		public function NodeGraph() {
			
		}
		
		override public function init():void {
			super.init();
			parseGraph();
		}
		
		/**
		 * A string defining vertices and edges of a node graph. For example 12:0-1,2-3,3-4,4-5,5-6,6-1,1-7,2-8,3-9,4-10,5-11,6-11, where 12 is
		 * the node count and proceeding comma delimited values are link declarations.
		 */
		public function get graph():String { return _graph; }
		public function set graph(value:String):void {
			_graph = value;
		}
		
		/**
		 * Auto-generate Node objects and linking based graph value
		 */
		private function parseGraph():void {
			
			if (!graph) {
				return;
			}
			
			//generate sibling nodes
			var attr:Array = graph.split(":");
			var vertices:int = parseInt(attr[0]);
			var links:Array = attr[1].split(",");
			var node:Node;	
			var nodeCnt:int = numChildren;
			
			for (var i:int = nodeCnt; i < vertices; i++) {
				node = new Node();
				node.x = -1000 + Math.random() * 2000;
				node.y = -1000 + Math.random() * 2000;
				node.z = -1000 + Math.random() * 2000;
				addChild(node);
			}
						
			//apply link assignments
			var indices:Array;
			var source:Node;			
			var target:Node;
			
			for each(var link:String in links) {
				indices = link.split("-");
				try{
				source = getChildAt(parseInt(indices[0])) as Node;
				target = getChildAt(parseInt(indices[1])) as Node;
				source.addTargetNode(target);
				}
				catch(e:Error){}
			}						
		}
		
		/**
		 * Only allow the addition of Node children
		 * @param	child
		 * @return
		 */
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D {
			if (!child is Node) {
				return child;
			}
			return super.addChild(child);
		}
		
	}

}