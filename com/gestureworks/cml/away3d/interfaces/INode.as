package com.gestureworks.cml.away3d.interfaces {
	import com.gestureworks.interfaces.ITouchObject3D;
	/**
	 * Implements Node objects.
	 * @author Ideum
	 */
	public interface INode { 
	
	//private edges:Vector<Edge>
	
	/**
	 * Fixes the orientation to the camera's view
	 * @default true
	 */
	function get lookAtCamera():Boolean;
	function set lookAtCamera(val:Boolean):void;
	
	//addTarget function to manage child node linking
	
	/**
	 * Returns the expanded (child node display) state of the node
	 * @return
	 * @default false
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
	function get leaf():Boolean;	
	
	/**
	 * Display child nodes
	 * @param level The child level to expand to
	 */
	function expand(level:int = 1):void;
	
	/**
	 * Hide child nodes
	 * @param level The child level to collapse to
	 */
	function collapse(level:int=0):void;
	
	/**
	 * Expands/collapses based on current expanded state
	 */
	function toggle():void;
	
	/**
	 * Automatically expands/collapses when the nodes surface is within a certain distance from the camera
	 * @return
	 */
	function autoToggle():Boolean;
	
	/**
	 * Distance threshold that determines autoToggle
	 * @return
	 */
	function autoToggleThreshold():Number;
	
	/**
	 * Hide on expand and displays on collapse
	 * @return
	 */
	function autoToggleVisibility():Boolean
	
	/**
	 * Reset node transformations to initial state up to specified node level
	 * @param level numerical level relative to 
	 */
	function reset(level:int = int.MAX_VALUE):void;
	
	/**
	 * List of node index, class, or id references to link to
	 */
	function get targets():String;
	function set targets(value:String):void;
	
	/**
	 * The node content
	 */
	function get content():*;
	function set content(value:*):void;	
	
	/**
	 * Sibling node index
	 */
	function get index():int;
	function set index(value:int):void;
	
	/**
	 * The heiarchy level relative to the root node
	 */
	function get level():String;
	
	/**
	 * The node hiearchy path 
	 */
	function get hierarchy():String;
	
	/**
	 * Node label
	 */
	function get label():String;
	function set label(value:String):void;
	
	}
}