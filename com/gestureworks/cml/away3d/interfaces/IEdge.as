package com.gestureworks.cml.away3d.interfaces {
	import com.gestureworks.interfaces.ITouchObject3D;
	/**
	 * Implements Edge objects.
	 * @author Ideum
	 */
	public interface IEdge { 
	
		function get target():INode;
		function set target(value:INode):void;
	}
}