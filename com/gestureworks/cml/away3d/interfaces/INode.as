package com.gestureworks.cml.away3d.interfaces {
	import com.gestureworks.cml.away3d.elements.Edge;
	import com.gestureworks.cml.away3d.elements.Node;
	
	/**
	 * Implements Node objects.
	 * @author Ideum
	 */
	public interface INode { 
	
	/**
	 * Fixes the orientation to the camera's view
	 * @default false
	 */
	function get lookAtCamera():Boolean;
	function set lookAtCamera(value:Boolean):void;
	
	/**
	 * Returns the expanded (child node display) state of the node
	 * @return
	 * @default true
	 */
	function get expanded():Boolean;
	
	/**
	 * Flag indicating the node is directed (has directional edges) or undirected (standard edge)
	 * @return
	 * @default false
	 */
	function get directed():Boolean;
	
	/**
	 * Flag indicating whether the node is a leaf (has no edges)
	 * @return
	 */
	function get isLeaf():Boolean;
	
	/**
	 * Flag indicating whether the node is a root node (has no parent node)
	 * @return
	 */
	function get isRoot():Boolean;
	
	/**
	 * Returns the root node
	 */
	function get root():Node;
	
	/**
	 * Determines if node is a target of this node
	 * @param	node
	 */	
	function isTarget(node:Node):Boolean;
	
	/**
	 * Trasfer transformations to root node
	 */
	function get groupTransform():Boolean;
	function set groupTransform(value:Boolean):void;
	
	/**
	 * Display child nodes down the number of levels specified
	 * @param level The number of levels to expand down to
	 */
	function expand(levelCnt:int = int.MAX_VALUE):void;
	
	/**
	 * Hide child nodes up to the number of levels specified
	 * @param level The number of levels to collapse up to
	 */
	function collapse(levelCnt:int=0):void;
	
	/**
	 * Expands/collapses based on current expanded state
	 */
	function toggle():void;
	
	/**
	 * Automatically expands/collapses when the nodes surface is within a certain distance from the camera
	 * @return
	 * @default false
	 */
	function get autoToggle():Boolean;
	function set autoToggle(value:Boolean):void;
	
	/**
	 * Distance threshold that determines autoToggle
	 * @return
	 * @default 0
	 */
	function get autoToggleThreshold():Number;
	function set autoToggleThreshold(value:Number):void;	
	
	/**
	 * Hide on expand and displays on collapse
	 * @return
	 * @default true
	 */
	function get autoToggleVisibility():Boolean;
	function set autoToggleVisibility(value:Boolean):void;
	
	/**
	 * Reset node transformations to initial state up to specified node level
	 * @param level numerical level relative to 
	 */
	function reset(level:int = int.MAX_VALUE):void;
	
	/**
	 * Comma delimited string of node references to assign as target nodes. References can be a combination of ids (denoted by a prepended '#'), 
	 * classes (denoted by a prepended '.'), sibling indices (valid child node integer), relative hiearchy paths. 
	 */
	function get targets():String;
	function set targets(value:String):void;
	
	/**
	 * Sibling node index
	 */
	function get index():int;
	function set index(value:int):void;
	
	/**
	 * The string corresponding to the numeric heiarchy level relative to the root node. The string convention is the lower-case character corresponding
	 * to the numeric level position in alphabet (i.e. 0 -> a, 1 -> b, ...25 -> z). Characters are duplicated and appended on each level increment
	 * of 26 (i.e. 26 -> aa, 27 -> bb, .... 52 -> aaa).
	 */
	function get level():String;
	
	/**
	 * The numeric heiarchy level relative to the root node (i.e. root node is 0, children of root are on level 1, etc.).
	 */
	function get numLevel():int;
	
	/**
	 * Id of the node in the heiarchy derived from its level and sibling index (i.e. second child of the root node is b1).
	 * This id is not intended to be unique and can be shared by nodes on the same level with different parents. Relative referencing should
	 * only be performed with hierarchy path. 
	 */
	function get nodeId():String;
	
	/**
	 * The node hiearchy path. Concatenated string of node id's representing the ancestral path of the node (e.g. a1-b2-c0). 
	 */
	function get hierarchy():String;
	
	/**
	 * Node label
	 */
	function get label():String;
	function set label(value:String):void;
	
	/**
	 * Return node edges
	 */
	function get edges():Vector.<Edge>;
	
	/**
	 * Auto-generates Edge child to link to target node. A target node does not have to be a child node but a child node is
	 * always a target. 
	 * @param  target Target node
	 */	
	function addTargetNode(target:Node):void;
	
	/**
	 * Returns sibling node by target index
	 * @param	index Target index
	 * @return
	 */	
	function siblingNode(index:int):Node;
	
	/**
	 * Returns target node by index
	 * @param	index Target index
	 * @return
	 */	
	function nodeByIndex(index:int):Node;
	
	/**
	 * If assigned, all edges of this node will inherit this Edge object's geometry and material 
	 */
	function get edgeMesh():Edge;
	function set edgeMesh(value:Edge):void;	
	
	}
}