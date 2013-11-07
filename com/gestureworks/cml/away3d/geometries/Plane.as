package com.gestureworks.cml.away3d.geometries {
	import away3d.core.base.Geometry;
	import away3d.primitives.PlaneGeometry;
	import com.gestureworks.cml.away3d.interfaces.IGeometry;
	import com.gestureworks.cml.core.CMLObject;
	import com.gestureworks.cml.elements.Container;
	
	/**
	 * ...
	 *
	 */
	public class Plane extends CMLObject implements IGeometry {
		private var _width:Number = 100;
		private var _height:Number = 100;
		private var _segmentsW:uint = 1;
		private var _segmentsH:uint = 1;
		private var _yUp:Boolean = true;
		private var _doubleSided:Boolean = false;
		private var _geometry:Geometry;
		
		public function Plane() {
			super();
		}
		
		/**
		 * Initialisation method
		 */
		public function init():void {			
			_geometry = new PlaneGeometry(_width, _height, _segmentsW, _segmentsH, _yUp, _doubleSided); 
		}
		
		/**
		 * The width of the plane.
		 * @default 100
		 */
		public function get width():Number { return _width; }		
		public function set width(value:Number):void {
			_width = value;
		}
		
		/**
		 * The height of the plane.
		 * @default 100
		 */
		public function get height():Number { return _height; }	
		public function set height(value:Number):void {
			_height = value;
		}
		
		/**
		 * The number of segments that make up the plane along the X-axis.
		 * @default 1
		 */
		public function get segmentsW():uint { return _segmentsW;}		
		public function set segmentsW(value:uint):void {
			_segmentsW = value;
		}
		
		/**
		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or
		 * false, respectively.
		 * @default 1
		 */
		public function get segmentsH():uint { return _segmentsH;}		
		public function set segmentsH(value:uint):void {
			_segmentsH = value;
		}
		
		/**
		 * yUp Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false).
		 * @default true
		 */
		public function get yUp():Boolean { return _yUp; }		
		public function set yUp(value:Boolean):void {
			_yUp = value;
		}
		
		/**
		 * Defines whether the plane will be visible from both sides, with correct vertex normals (as opposed to bothSides on Material).
		 * @default false
		 */
		public function get doubleSided():Boolean { return _doubleSided; }		
		public function set doubleSided(value:Boolean):void {
			_doubleSided = value;
		}
		
		/**
		 * Away3d Geometry
		 */
		public function get geometry():Geometry { return _geometry; }		
		public function set geometry(value:Geometry):void {
			_geometry = value;
		}
	
	}

}