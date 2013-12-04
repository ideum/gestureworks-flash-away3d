package com.gestureworks.cml.away3d.interfaces {
	import com.gestureworks.interfaces.ITouchObject3D;
	/**
	 * Implements NodeGraph objects.
	 * @author Ideum
	 */
	public interface INodeGraph { }		
	
	/**
	 * A string defining vertices and edges of a node graph. For example 12:0-1,2-3,3-4,4-5,5-6,6-1,1-7,2-8,3-9,4-10,5-11,6-12, where 12 is
	 * the node count and proceeding comma delimited values are link declarations.
	 */
	function get graph():String;
	function set graph(g:String):void;
	
}