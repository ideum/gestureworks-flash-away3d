package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import com.gestureworks.cml.away3d.geometries.SphereGeometry;
	import com.gestureworks.cml.away3d.interfaces.INode;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import flash.utils.Dictionary;
	
	/**
	 * Provides Node hiearchy management and graph construction
	 * @author Ideum
	 */
	public class Node extends Mesh implements INode {
		
		private const ASCII_START:int = 97;
		
		private var _lookAtCamera:Boolean = true;
		private var _expanded:Boolean = true;
		private var _directed:Boolean = false;
		private var _autoToggle:Boolean = false;
		private var _autoToggleThreshold:Number = 0;
		private var _autoToggleVisibility:Boolean = true;
		private var _targets:String;
		private var _content:*;
		private var _index:int;
		private var _label:String;
		private var _numLevel:int = 0;
		
		private var _edges:Vector.<Edge> = new Vector.<Edge>();
		private var _allEdges:Dictionary = new Dictionary();
		
		private var defaultGeometry:SphereGeometry = new SphereGeometry();
		private var defaultMaterial:ColorMaterial = new ColorMaterial(0xFF0000); 
		
		/**
		 * Constructor
		 */
		public function Node() {
			super();
			geometry = defaultGeometry;
			material = defaultMaterial;
			mouseEnabled = true;
		}
		
		/**
		 * Initialization function
		 */
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
		public function get isLeaf():Boolean { return _edges.length == 0; }
		
		/**
		 * @inheritDoc
		 */
		public function get isRoot():Boolean { return !(parent is Node); }
		
		/**
		 * @inheritDoc
		 */
		public function get root():INode { 
			var a:Vector.<Node> = Node.ancestors(this);
			if (a.length){
				return a.pop();
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function expand(levelCnt:int = int.MAX_VALUE):void {	
			if (!levelCnt){
				return;				
			}	
			
			levelCnt--;
			for each(var edge:Edge in _edges) {
				edge.visible = true;
				edge.target.visible = true;
				edge.target.expand(levelCnt);
			}
			_expanded = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function collapse(levelCnt:int = 0):void {			
			var e:Vector.<Edge> = edgesAtLevel(levelCnt);
			for each(var edge:Edge in e) {
				edge.visible = false;
				edge.target.visible = false;
				edge.target.collapse();
			}					
			
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
		public function get level():String { 
			var lev:String = "";
			for (var i:int = 0; i <= Math.floor(numLevel / 26); i++) {
				lev += String.fromCharCode(_numLevel % 26 + ASCII_START); 
			}
			return lev;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numLevel():int { return _numLevel; }
		
		/**
		 * @inheritDoc
		 */
		public function get nodeId():String { return level + index; }	
		
		/**
		 * @inheritDoc
		 */
		public function get hierarchy():String {
			var h:String = "";
			for each(var a:Node in Node.ancestors(this)) {
				h += a.nodeId + "-";
			}
			if (h.charAt(h.length - 1) == "-"){
				h = h.slice(0, h.length - 1);
			}
			return h;
		}
		
		/**
		 * Returns all ancestor Node objects of the provided Node
		 */
		public static function ancestors(n:Node):Vector.<Node> {
			var a:Vector.<Node> = new Vector.<Node>();
			if (!n) {
				return a;
			}
			
			a.push(n);
			if (n.parent is Node) {
				a = a.concat(ancestors(Node(n.parent)));
			}
			return a;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get label():String { return _label; }
		public function set label(value:String):void {
			_label = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get edges():Vector.<Edge> { return _edges; }
		
		/**
		 * Returns edges at a decendant level relative to this node
		 * @param	level
		 * @return
		 */
		public function edgesAtLevel(level:int = 0):Vector.<Edge> {
			var lEdges:Vector.<Edge> = new Vector.<Edge>();
			if (!level){
				return edges;
			}
			for each(var edge:Edge in edges) {
				if (edge.target.numLevel == numLevel + level) {
					lEdges = lEdges.concat(edge.target.edges);
					continue;
				}
				else {
					lEdges = lEdges.concat(edge.target.edgesAtLevel(level-1));
				}
			}
			return lEdges;
		}
				
		/**
		 * Override to handle child Node and Edge addition
		 * @param	child 
		 * @return
		 */
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D {
			super.addChild(child);
			if (child is Node) {
				addNode(child as Node);
			}
			else if (child is Edge){
				_edges.push(child);
				Edge(child).init();
			}
			
			return child;
		}
		
		/**
		 * Auto-generates Edge child to link to target node
		 * @param  target Target node
		 */
		public function addNode(target:Node):void {
			var edge:Edge = new Edge();
			edge.target = target;		
			addChild(edge);			
			target.inherit(edge.source);			
		}
		
		/**
		 * If not customized, inherit source node attributes and set hierarchy properties
		 */
		private function inherit(source:Node):void {
			
			if (geometry == defaultGeometry){
				geometry = source.geometry;
			}
			if (material == defaultMaterial) {
				material = source.material;
			}
			
			index = source.edges.length - 1;
			_numLevel = source.numLevel + 1; 
		}
		
		
		
	}

}