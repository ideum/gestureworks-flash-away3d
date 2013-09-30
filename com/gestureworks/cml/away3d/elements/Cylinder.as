package com.gestureworks.cml.away3d.elements {
	import away3d.core.base.Geometry;
	import away3d.primitives.CylinderGeometry;
	import com.gestureworks.cml.element.Container;
	
	/**
	 * ...
	 */
	public class Cylinder extends Container {
		private var _topRadius:Number = 50;
		private var _bottomRadius:Number = 50;
		private var _height:Number = 100;
		private var _segmentsW:uint = 16;
		private var _segmentsH:uint = 1;
		private var _topClosed:Boolean = true;
		private var _bottomClosed:Boolean = true;
		private var _surfaceClosed:Boolean = true;
		private var _yUp:Boolean;
		private var _geometry:Geometry;
		
		public function Cylinder() {
			super();
			
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void {
			_geometry = new CylinderGeometry(_topRadius, _bottomRadius, _height, _segmentsW, _segmentsH, _topClosed, _bottomClosed, _surfaceClosed, _yUp); 
			
			if (this.parent is Mesh)
				Mesh(this.parent).geometry = _geometry
		}
		
		/**
		 * The radius of the top end of the cylinder.
		 *  @default 50
		 */
		public function get topRadius():Number {
			return _topRadius;
		}
		
		public function set topRadius(value:Number):void {
			_topRadius = value;
		}
		
		/**
		 * The radius of the bottom end of the cylinder.
		 *  @default 50
		 */
		public function get bottomRadius():Number {
			return _bottomRadius;
		}
		
		public function set bottomRadius(value:Number):void {
			_bottomRadius = value;
		}
		
		/**
		 * The height of the cylinder.
		 *  @default 100
		 */
		public override function get height():Number {
			return _height;
		}
		
		public override function set height(value:Number):void {
			_height = value;
		}
		
		/**
		 * Defines the number of horizontal segments that make up the cylinder.
		 *  @default 16.
		 */
		public function get segmentsW():uint {
			return _segmentsW;
		}
		
		public function set segmentsW(value:uint):void {
			_segmentsW = value;
		}
		
		/**
		 * Defines the number of vertical segments that make up the cylinder.
		 * @default 1
		 */
		public function get segmentsH():uint {
			return _segmentsH;
		}
		
		public function set segmentsH(value:uint):void {
			_segmentsH = value;
		}
		
		/**
		 * Defines whether the top end of the cylinder is closed (true) or open.
		 *  @default true
		 */
		public function get topClosed():Boolean {
			return _topClosed;
		}
		
		public function set topClosed(value:Boolean):void {
			_topClosed = value;
		}
		
		/**
		 * Defines whether the surface of the cylinder is closed (true) or open.
		 *  @default true
		 */
		public function get surfaceClosed():Boolean {
			return _surfaceClosed;
		}
		
		public function set surfaceClosed(value:Boolean):void {
			_surfaceClosed = value;
		}
		
		/**
		 * Defines whether the bottom end of the cylinder is closed (true) or open.
		 *  @default true
		 */
		public function get bottomClosed():Boolean {
			return _bottomClosed;
		}
		
		public function set bottomClosed(value:Boolean):void {
			_bottomClosed = value;
		}
		
		/**
		 * Defines whether the cylinder poles should lay on the Y-axis (true) or on the Z-axis (false).
		 *  @default true
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