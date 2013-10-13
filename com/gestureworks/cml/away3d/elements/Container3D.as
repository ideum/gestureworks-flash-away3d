package com.gestureworks.cml.away3d.elements {
	import com.gestureworks.cml.core.*;
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.interfaces.*;
	import com.gestureworks.cml.managers.*;
	
	public class Container3D extends TouchContainer3D {		
		/**
		 * Constructor
		 */
		public function Container3D() {
			super();
			mouseChildren = true;
		}			
	}
}