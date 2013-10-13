package com.gestureworks.cml.away3d.geometries {
	import away3d.core.base.Geometry;
	import away3d.primitives.SphereGeometry;
	import com.gestureworks.cml.away3d.interfaces.IGeometry;
	import com.gestureworks.cml.core.CMLObject;
	import com.gestureworks.cml.element.Container;
	
	/**
	 * ...
	 */
	public class Sphere extends CMLObject implements IGeometry {
		private var _radius:Number = 50;
		private var _segmentsW:uint = 16;
		private var _segmentsH:uint = 12;
		private var _yUp:Boolean = true;
		private var _geometry:Geometry;
		
		public function Sphere() {
			super();
		}
		
		/**
		 * Initialisation method
		 */
		public function init():void {			
			_geometry = new SphereGeometry(_radius,  _segmentsW, _segmentsH, _yUp);		
		}
		
		/**
		 * Defines radius of Sphere
		 * @default "50"
		 */
		public function get radius():Number { return _radius; }		
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		/**
		* Defines the number of vertical segments that make up the sphere. 
		* @default 16.
		 */
		public function get segmentsW():uint { return _segmentsW; }		
		public function set segmentsW(value:uint):void {
			_segmentsW = value;
		}
		
		/**
		* Defines the number of horizontal segments that make up the sphere. 
		* @default 12.
		 */
		public function get segmentsH():uint { return _segmentsH; }		
		public function set segmentsH(value:uint):void {
			_segmentsH = value;
		}
		
		/**
		 * Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).
		 * @default true
		 */
		public function get yUp():Boolean { return _yUp; }		
		public function set yUp(value:Boolean):void {
			_yUp = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get geometry():Geometry { return _geometry; }		
		public function set geometry(value:Geometry):void {
			if (_geometry != value)
				_geometry = value;
		}
	
	}

}