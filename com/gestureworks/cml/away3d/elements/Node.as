package com.gestureworks.cml.away3d.elements {
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Matrix3DUtils;
	import away3d.entities.Sprite3D;
	import away3d.events.Object3DEvent;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.TextureUtils;
	import com.gestureworks.cml.away3d.geometries.SphereGeometry;
	import com.gestureworks.cml.away3d.interfaces.INode;
	import com.gestureworks.cml.away3d.layouts.CircleLayout3D;
	import com.gestureworks.cml.away3d.materials.ColorMaterial;
	import com.gestureworks.cml.away3d.materials.TextureMaterial;
	import com.gestureworks.cml.elements.Graphic;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.objects.GestureObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import physics.NodePhysics;
	
	/**
	 * Provides Node hiearchy management and graph construction. By default, all <code>Node</code> descendants inherit attributes and settings
	 * of the parent unless customized. 
	 * @author Ideum
	 */
	public class Node extends Mesh implements INode {
		
		private const ASCII_START:int = 97;
		
		protected var _lookAtCamera:Boolean = false;
		protected var _expanded:Boolean = true;
		protected var _initializeExpanded:Boolean = true;
		protected var _directed:Boolean = false;
		protected var _toggleOnTap:Boolean = false;
		protected var _autoToggle:Boolean = false;
		protected var _autoToggleThreshold:Number = 500;
		protected var _autoToggleVisibility:Boolean = true;
		protected var _hideOnCollapse:Boolean = false;
		protected var _targets:String;
		protected var _index:int = NaN;
		protected var _label:String;
		protected var _labelText:Text;
		protected var _numLevel:int = 0;
		protected var _hierarchy:String;
		protected var _camera:Camera3D;
		protected var _labelPosition:Vector3D = new Vector3D(50, 100, 0);
		
		protected var _root:Node;		
		protected var _edges:Vector.<Edge> = new Vector.<Edge>();
		protected var _allEdges:Dictionary = new Dictionary();
		protected var _edgeMesh:Edge;
		protected var _eref:XML; //edge mesh		
		
		protected var defaultGeometry:SphereGeometry = new SphereGeometry();
		protected var defaultMaterial:ColorMaterial = new ColorMaterial(0xFF0000); 
		protected var labelMesh:away3d.entities.Mesh;
		protected var _hideLabel:Boolean;
		
		public var edgeFactory:Function;
		
		public var expandLayout:Layout3D = new CircleLayout3D(200, new Vector3D(90));
		public var collapseLayout:Layout3D = new CircleLayout3D(.001, new Vector3D(90));
		
		protected var _nodePhysics:NodePhysics = null;
		public function get nodePhysics():NodePhysics { return _nodePhysics; }
		protected var _childrenPositions:Dictionary = new Dictionary();
		
		public var released:Boolean = true;
		
		/**
		 * Constructor
		 */
		public function Node() {
			super();
			geometry = defaultGeometry;
			material = defaultMaterial;	
		}
		
		/**
		 * Initialization function
		 */
		override public function init():void {
			super.init();
			
			if (eref) {
				var s:String = String(eref);
				if (s.charAt(0) == "#") {
					s = s.substr(1);
				}
				edgeMesh = document.getElementById(s);
				if (edgeMesh && edgeMesh.parent)
					edgeMesh.parent.removeChild(edgeMesh);
			}
			
			_root = ancestors.pop();
			
			if (targets)
				parseTargets();
			
			initLayouts();			
			initEdges();
			
			if (!initializeExpanded) {	
				collapse();
			}
			if(vto.view && (label || lookAtCamera)){
				View3D(vto.view).camera.addEventListener(Object3DEvent.POSITION_CHANGED, faceCamera);
				faceCamera();
			}
			
			registerListeners();
			
			// position label
			labelPosition = labelPosition;
		}	
		
		public function initPhysics():void {
			if (_nodePhysics != null) {
				return;
			}
			
			_nodePhysics = new NodePhysics(this);
			
			for (var i:int = 0; i != childList.length; ++i) {
				var child:* = childList.getIndex(i);
				if (child is Node) {
					var node:Node = child as Node;
					if (node != null) {
						node.initPhysics();
					}
				}
			}
		}
		
		/**
		 * Initialize expanded and collapsed state layouts
		 */
		private function initLayouts():void {
			if (collapseLayout) {
				collapseLayout.children = Layout3D.getChildren(this, [Node]);
			}			
			if (expandLayout) {				
				expandLayout.children = Layout3D.getChildren(this, [Node]);
				expandLayout.tween = false;
				expandLayout.layout(this);				
			}			
		}
		
		/**
		 * Register listeners based on settings and active gestures
		 */
		private function registerListeners():void {
			if (toggleOnTap) {
				for each(var go:GestureObject in vto.gO.pOList) {
					if (go.gesture_type == "tap") {
						vto.addEventListener(GWGestureEvent.TAP, toggle);
						break;
					}
				}
			}						
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parseCML(cml:XMLList):XMLList {
			
			if (cml.@edgeMesh != undefined) {
				cml.@eref = cml.@edgeMesh;
				delete cml.@edgeMesh;
			}
			
			
			return super.parseCML(cml);
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
		public function get expanded():Boolean { 
			return _expanded; 
		}
		
		public function get childExpanded():Boolean {
			
			for (var i:int = 0; i != childList.length; ++i) {
				var child:* = childList.getIndex(i);
				if (child is Node) {
					var node:Node = child as Node;
					if (node != null) {
						if (node.expanded) {
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get initializeExpanded():Boolean { return _initializeExpanded; }
		public function set initializeExpanded(value:Boolean):void {
			_initializeExpanded = value;
		}
		
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
		public function get root():Node { return _root; }	
		
		/**
		 * @inheritDoc
		 */
		public function expand(levelCnt:int = 1):void {	
			if (!levelCnt){
				return;				
			}	
			
			levelCnt--;
			for each(var edge:Edge in _edges) {
				edge.target.expand(levelCnt);
			}
			
			if (expandLayout) {
				expandLayout.children = Layout3D.getChildren(this, [Node]);
				expandLayout.tween = true;
				expandLayout.layout(this);			
			}
			if (hideOnCollapse) {
				hideChildren(false);
			}
			
			_expanded = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function collapse(levelCnt:int = 0):void {		
			
			var e:Vector.<Edge> = edgesAtLevel(levelCnt);
			for each(var edge:Edge in e) {
				edge.target.collapse();
			}				
			
			if (collapseLayout) {
				if(hideOnCollapse){
					collapseLayout.onComplete = hideChildren;
					collapseLayout.onCompleteParams = [true];
				}
				collapseLayout.layout(this);				
			}
			else if (hideOnCollapse) {
				hideChildren(true);
			}
			
			_expanded = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toggle(e:GWGestureEvent=null):void {
			if (_expanded)
				collapse();
			else
				expand();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get toggleOnTap():Boolean { return _toggleOnTap; }
		public function set toggleOnTap(value:Boolean):void {
			_toggleOnTap = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoToggle():Boolean { return _autoToggle; } 
		public function set autoToggle(value:Boolean):void {
			_autoToggle = value;
			if (value && vto.view) {
				View3D(vto.view).camera.addEventListener(Object3DEvent.POSITION_CHANGED, cameraDistance);				
			}
			else if(vto.view) {
				View3D(vto.view).camera.removeEventListener(Object3DEvent.POSITION_CHANGED, cameraDistance);								
			}
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
		public function get hideOnCollapse():Boolean { return _hideOnCollapse; }
		public function set hideOnCollapse(value:Boolean):void {
			_hideOnCollapse = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function reset(level:int = int.MAX_VALUE):void {
			//loadState(0);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get targets():String { return _targets; }
		public function set targets(value:String):void {
			_targets = value;
		}
		
		/**
		 * Parse target node references and assign corresponding targets
		 */
		private function parseTargets():void {
			var tgtRefs:Array = targets.split(",");
			var tgts:Array = [];
			var flag:String;
			
			for each(var tgtRef:String in tgtRefs) {
				flag = tgtRef.charAt(0);
				
				if(flag == "#"){
					tgts.push(document.getElementById(tgtRef));
				}
				else if(flag == "."){
					tgts = tgts.concat(document.getElementsByClassName(tgtRef));
				}
				else if (!isNaN(parseInt(tgtRef))) {
					tgts.push(siblingNode(parseInt(tgtRef)));
				}
				else{
					tgts.push(nodeByHiearchy(tgtRef));
				}				
			}
			
			for each(var tgt:Node in tgts) {
				if (tgt)
					addTargetNode(tgt);
			}
		}		
		
		/**
		 * @inheritDoc
		 */
		public function siblingNode(index:int):Node {
			if (!parent is Node)
				return null;
			return Node(parent).nodeByIndex(index);
		}		
		
		/**
		 * @inheritDoc
		 */
		public function nodeByIndex(index:int):Node {
			for each(var edge:Edge in edges) {
				if (edge.target.index == index)
					return edge.target;
			}
			return null;
		}
		
		/**
		 * Recursivley search node tree for hiearchy path reference
		 * @param	hiearchy
		 * @param	node
		 * @return
		 */
		private function nodeByHiearchy(hiearchy:String, node:Node=null):Node {
			if (!node)
				node = Node(root);
				
			if (node.hierarchy != hiearchy) {
				for each(var edge:Edge in node.edges) {
					node = nodeByHiearchy(hiearchy, edge.target);
					if (node.hierarchy == hiearchy)
						break;
				}
			}
				
			return node;
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
			if (!_hierarchy)
				_hierarchy = nodeId;
			return _hierarchy;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get ancestors():Vector.<Node> {
			return ancestorNodes(this);
		}	
		
		/**
		 * Recursively collects ancestors
		 * @param	n 
		 * @return
		 */
		private function ancestorNodes(n:Node):Vector.<Node> {
			var a:Vector.<Node> = new Vector.<Node>();
			if (!n) {
				return a;
			}
			
			a.push(n);
			if (n.parent is Node) {
				a = a.concat(ancestorNodes(Node(n.parent)));
			}
			return a;			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get descendants():Vector.<Node> {
			return descendantNodes(this);
		}
		
		/**
		 * Recursively collects descendants
		 * @param	n
		 * @return
		 */
		private function descendantNodes(n:Node):Vector.<Node> {
			var a:Vector.<Node> = new Vector.<Node>();
			if (n != this){
				a.push(n);
			}
			for each(var edge:Edge in n.edges) {
				a = a.concat(descendantNodes(edge.target));
			}
			return a;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get label():String { return _label; }
		public function set label(value:String):void {
			if (_label == value)
				return;
				
			_label = value;
			
			var text:Text = new Text();
			text.str = value;
			text.background = false;
			text.color = 0xFFFFFF;
			text.fontSize = 40;
			text.border = false;
			text.borderColor = 0xFFFFFF;
			text.autosize = true;
			text.init();
			text.width += 4;
			text.height += 4;
			
			text.width = TextureUtils.getBestPowerOf2(Math.max(text.width, text.height));
			text.height = text.width;
														
			var bmd:BitmapData = new BitmapData(text.width, text.height, true, 0x00000000);
			bmd.draw(text);
			var bitmap:Bitmap = new Bitmap(bmd, "auto", true);
			
			var texture:TextureMaterial = new TextureMaterial(new BitmapTexture(bitmap.bitmapData, true) );
			texture.alphaBlending = true;
			
			labelMesh.position = labelPosition;
			addChild(labelMesh);			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get labelText():* { return _labelText; }
		public function set labelText(value:*):void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hideLabel():Boolean { return _hideLabel; }
		public function set hideLabel(value:Boolean):void {
			if (labelMesh) {
				labelMesh.visible = !value;
			}
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
		 * @inheritDoc
		 */
		public function get edgeMesh():Edge { return  _edgeMesh; }
		public function set edgeMesh(value:Edge):void {
			_edgeMesh = value;
		}
		
		/**
		 * Edge mesh reference
		 */
		public function get eref():* { return _eref; }
		public function set eref(value:*):void {
			_eref = value;
		}
				
		/**
		 * Override to handle special child registration
		 * @param	child 
		 * @return
		 */
		override public function addChild(child:ObjectContainer3D):ObjectContainer3D {
			super.addChild(child);
			if (child is Node) {
				addTargetNode(child as Node);
			}
			//transfer node graph children to node parent
			else if (child is NodeGraph) {
				NodeGraph(child).init();
				while(child.numChildren) {
					Node(addChild(child.getChildAt(0))).init();
				}
				super.removeChild(child);
			}
			
			return child;
		}
		
		/**
		 * Initialize all edges
		 */
		private function initEdges():void {
			for each(var edge:Edge in edges) {
				if (edgeMesh) {					
					edge.geometry = edgeMesh.geometry;
					edge.material = edgeMesh.material;
				}				
				edge.init();
			}
			if (expandLayout) {
				expandLayout.onComplete = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addTargetNode(target:Node):void {
			if (isTarget(target)){
				return; 
			}
			target.inherit(this);
			var edge:Edge = (edgeFactory) ? edgeFactory.call() : new Edge; 
			edge.target = target;	
			edges.push(edge);
			addChild(edge);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isTarget(node:Node):Boolean {
			for each(var edge:Edge in edges) {
				if (edge.target == node)
					return true;
			}
			return false;
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
			if (!gref) {
				gref = source.gref;				
			}
			if (!mref) {
				mref = source.mref;				
			}
			if (!eref) {
				eref = source.eref;
			}
			if (!edgeMesh) {
				edgeMesh = source.edgeMesh;
			}	
			if (emptyGestureList) {
				vto.gestureList = source.vto.gestureList;
			}
			
			touchEnabled = source.touchEnabled;
			toggleOnTap = source.toggleOnTap;
			initializeExpanded = source.initializeExpanded;
			hideOnCollapse = source.hideOnCollapse;
			index = source.edges.length;
			_numLevel = source.numLevel + 1; 
			_hierarchy = source.hierarchy + "-" + nodeId;
		}
		
		/**
		 * Returns true if gestureList is empty and false otherwise
		 */
		private function get emptyGestureList():Boolean {
			var isEmpty:Boolean = true;
			for (var n:* in vto.gestureList) {
				isEmpty = false;
				break;
			}
			return isEmpty;
		}
		
		/**
		 * The node's label will align it's top-left corner to the center
		 * of the node. This property will offset from that position.
		 * @default Vector3D(50,35,0)
		 */
		public function get labelPosition():Vector3D {
			return _labelPosition;
		}
		
		public function set labelPosition(value:Vector3D):void {
			
		}
				
		/**
		 * Controls camera distance auto-toggling
		 * @param	e
		 */
		private function cameraDistance(e:Object3DEvent):void {
			if (Math.abs(vto.distance) <= autoToggleThreshold && !expanded)
				expand();
			else if (Math.abs(vto.distance) > autoToggleThreshold && expanded)
				collapse();
		}
		
		/**
		 * Orients node towards camera
		 * @param	e
		 */
		private function faceCamera(e:Object3DEvent = null):void {
			if (lookAtCamera)
				lookAt(View3D(vto.view).camera.scenePosition);
		}
		
		/**
		 * Hide/displays edges and associated target nodes
		 * @param	hide 
		 */
		protected function hideChildren(hide:Boolean = true):void {
			for each(var edge:Edge in edges) {
				edge.visible = !hide;
				edge.target.visible = !hide;
			}
		}	
		
		public function update(timeElapsed:Number):void {
			
		}
		
		public function get worldPosition():Vector3D {
			invalidateSceneTransform();
			return scenePosition;
		}
		
		public function set worldPosition(worldPosition:Vector3D):void {
			if (parent == null) {
				return;
			}
			position = parent.inverseSceneTransform.transformVector(worldPosition);
			invalidateSceneTransform();
		}
		
		private var _deltaMovement:Vector3D = new Vector3D();
		public function get deltaMovement():Vector3D {
			return _deltaMovement;
		}
		
		public function set deltaMovement(delta:Vector3D):void {
			_deltaMovement = delta;
		}
		
		public function setChildPosition(child:*, position:Vector3D):void {
			if (child == null) {
				return;
			}
			
			if (child is Node) {
				var node:Node = child as Node;
				if (node != null) {
					_childrenPositions[node] = position;
				}
			}
		}
		
		public function get concatenatedRotationZ():Number {
			if (isRoot) {
				return rotationZ;
			}
			else {
				return Node(parent).concatenatedRotationZ + rotationZ; 
			}
		}
		
		public function getHasChild(node:Node):Boolean {
			return (_childrenPositions[node] != null);
		}
		
		public function getChildStartPosition(node:Node):Vector3D {
			
			if (!getHasChild(node)) {
				return new Vector3D(0.0, 0.0, 0.0);
			}
			
			var position:Vector3D = new Vector3D(_childrenPositions[node].x, _childrenPositions[node].y, 0.0);
			if (position == null) {
				return new Vector3D(0.0, 0.0, 0.0);
			}
			
			var matrix:Matrix3D = new Matrix3D;
			matrix.identity();
			matrix.appendRotation(concatenatedRotationZ, Vector3D.Z_AXIS);
			
			position = matrix.transformVector(position);
			
			return position.add(scenePosition);
		}
				
		public function userBeganTouch():void {
			trace("Node began touch");
			_nodePhysics.stopUpdatingSpring();
		}
		
		public function userTouchUpdate():void {
		//	trace("Node moved");
		}

		public function userTouchRelease():void {
			trace("Node touch release");
			released = true;
			if(!isRoot) {
				_nodePhysics.springToPosition();
				_nodePhysics.startUpdatingSpring();
			}
		}
	}

}