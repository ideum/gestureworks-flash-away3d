package com.gestureworks.cml.element.away3d {
	import away3d.core.base.Geometry;
	import away3d.primitives.SphereGeometry;
	import com.gestureworks.cml.element.Element;
	
	/**
	 * ...
	 */
	public class Sphere extends Element {
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
		override public function init():void {
			displayComplete();
		}
		
		/**
		 * CML callback Initialisation
		 */
		override public function displayComplete():void {
			
			_geometry = new SphereGeometry(_radius,  _segmentsW, _segmentsH, _yUp);
			
			if (this.parent is Mesh)
				Mesh(this.parent).geometry = _geometry;
		
		}
		
		/**
		 * Defines radius of Sphere
		 * @default "50"
		 */
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		/**
		* Defines the number of vertical segments that make up the sphere. 
		* @default 16.
		 */
		public function get segmentsW():uint {
			return _segmentsW;
		}
		
		public function set segmentsW(value:uint):void {
			_segmentsW = value;
		}
		
		/**
		* Defines the number of horizontal segments that make up the sphere. 
		* @default 12.
		 */
		public function get segmentsH():uint {
			return _segmentsH;
		}
		
		public function set segmentsH(value:uint):void {
			_segmentsH = value;
		}
		
		/**
		 * Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).
		 * @default true
		 */
		public function get yUp():Boolean {
			return _yUp;
		}
		
		public function set yUp(value:Boolean):void {
			_yUp = value;
		}
		
		/**
		 * Away3d Geometry
		 */
		public function get geometry():Geometry {
			return _geometry;
		}
		
		public function set geometry(value:Geometry):void {
			if (_geometry != value)
				_geometry = value;
		}
	
	}

}