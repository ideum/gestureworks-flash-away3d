package com.gestureworks.cml.away3d.interfaces {
	import com.gestureworks.interfaces.ITouchObject3D;
	/**
	 * Implements Node objects.
	 * @author Ideum
	 */
	public interface INode { 
	
	//private linkNodes:Vector<NodeLink>
	
	/**
	 * Fixes the orientation to the camera's view
	 * @default true
	 */
	function get lookAtCamera():Boolean;
	function set lookAtCamera(val:Boolean):void;
	
	//addNode function to manage child node addition
	
	/**
	 * Returns the expanded (child node display) state of the node
	 * @return
	 * @default false
	 */
	function expanded():Boolean;
	
	/**
	 * Display child nodes
	 * @param level The child level to expand to
	 */
	function expand(level:int=int.MAX_VALUE):void;
	
	/**
	 * Hide child nodes
	 * @param level The child level to contract to
	 */
	function contract(level:int=0):void;
	
	/**
	 * Expands/contracts based on expanded state
	 */
	function toggle():void;
	
	/**
	 * Automatically expands/contracts when the nodes surface is within a certain distance from the camera
	 * @return
	 */
	function autoToggle():Boolean;
	
	/**
	 * Distance threshold that determines autoToggle
	 * @return
	 */
	function autoToggleThreshold():Number;
	
	/**
	 * Hide on expand and displays on contract
	 * @return
	 */
	function autoToggleVisibility():Boolean
	
	/**
	 * Reset node transformations to initial state
	 * @param level Resets all levels up to specified node level
	 */
	function reset(level:int = int.MAX_VALUE):void;
	
	/**
	 * List of child node index references to link to
	 */
	function get links():String;
	function set links(value:String):void;
	
	/**
	 * The node content
	 */
	function get content():*;
	function set content(value:*):void;	
	
	/**
	 * Graph index only used when nested within a NodeGraph
	 */
	function get index():int;
	function set index(value:int):void;
	
	/**
	 * The heiarchy level relative to the root node
	 */
	function get level():int;
	
	}
}