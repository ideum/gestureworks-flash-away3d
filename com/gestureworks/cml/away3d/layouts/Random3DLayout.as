package com.gestureworks.cml.away3d.layouts {
	import away3d.containers.ObjectContainer3D;
	import com.gestureworks.away3d.utils.LayoutTransforms;
	import com.gestureworks.cml.away3d.elements.Layout3D;
	import com.gestureworks.cml.layouts.Layout;
	import com.gestureworks.cml.utils.NumberUtils;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class Random3DLayout extends Layout3D {
		
		private var _posMin:Vector3D;
		private var _posMax:Vector3D;
		
		private var _rotMin:Vector3D;
		private var _rotMax:Vector3D;		
		
		private var _scaMin:Vector3D;
		private var _scaMax:Vector3D;
		
		private var _scaleMin:Number;
		private var _scaleMax:Number;
		
		private var scaleSet:Boolean;
				
		public function Random3DLayout() {
			super();
			
			posMin = new Vector3D(0, 0, 0);
			posMax = new Vector3D(0, 0, 0);	
			
			rotMin = new Vector3D(0, 0, 0);
			rotMax = new Vector3D(0, 0, 0);			
						
			scaMin = new Vector3D(1, 1, 1);
			scaMax = new Vector3D(1, 1, 1);
			
			scaleMin = 1; 
			scaleMax = 1; 
			
			scaleSet = false;
		}
		
		override public function layout(container:ObjectContainer3D):void {
			
			var i:int;
			var layoutTransforms:LayoutTransforms;		
			childTransforms.length = 0;
			
			for (i = 0; i < container.numChildren; i++) {								
				layoutTransforms = new LayoutTransforms;
				
				layoutTransforms.pos = new Vector3D(NumberUtils.randomNumber(posMin.x, posMax.x),
					NumberUtils.randomNumber(posMin.y, posMax.y),
					NumberUtils.randomNumber(posMin.z, posMax.z));
					
				layoutTransforms.rot = new Vector3D(NumberUtils.randomNumber(rotMin.x, rotMax.x),
					NumberUtils.randomNumber(rotMin.y, rotMax.y),
					NumberUtils.randomNumber(rotMin.z, rotMax.z));
										
				// scale
				if (scaleSet) {
					var scaleAmt:Number = NumberUtils.randomNumber(scaleMin, scaleMax);
					layoutTransforms.sca = new Vector3D(scaleAmt, scaleAmt, scaleAmt);	
				}
				else {				
					layoutTransforms.sca = new Vector3D(NumberUtils.randomNumber(scaMin.x, scaMax.x),
						NumberUtils.randomNumber(scaMin.y, scaMax.y),
						NumberUtils.randomNumber(scaMin.z, scaMax.z));			
				}						
				
				childTransforms.push(layoutTransforms);
			}
			
			super.layout(container);
		}
		
		/**
		 * Sets random min position as 3D vector.
		 */
		public function get posMin():Vector3D {
			return _posMin;
		}
		public function set posMin(value:Vector3D):void {
			_posMin = value;
		}
		
		/**
		 * Sets random max position as 3D vector.
		 */		
		public function get posMax():Vector3D {
			return _posMax;
		}
		public function set posMax(value:Vector3D):void {
			_posMax = value;
		}
		
		/**
		 * Sets random min rotation as 3D vector.
		 */		
		public function get rotMin():Vector3D {
			return _rotMin;
		}
		public function set rotMin(value:Vector3D):void {
			_rotMin = value;
		}
		
		/**
		 * Sets random max rotation as 3D vector.
		 */		
		public function get rotMax():Vector3D {
			return _rotMax;
		}
		public function set rotMax(value:Vector3D):void {
			_rotMax = value;
		}
		
		/**
		 * Sets random min scale as 3D vector.
		 */		
		public function get scaMin():Vector3D {
			return _scaMin;
		}
		public function set scaMin(value:Vector3D):void {
			_scaMin = value;
		}

		/**
		 * Sets random min scale as 3D vector.
		 */		
		public function get scaMax():Vector3D {
			return _scaMax;
		}
		public function set scaMax(value:Vector3D):void {
			_scaMax = value;
		}
		
		/**
		 * Sets random min scale as number applies equal scaling along all dimensions.
		 */			
		public function get scaleMin():Number {
			return _scaleMin;
		}
		public function set scaleMin(value:Number):void {
			_scaleMin = value;
			scaleSet = true;
		}

		/**
		 * Sets random max scale as number applies equal scaling along all dimensions.
		 */				
		public function get scaleMax():Number {
			return _scaleMax;
		}
		public function set scaleMax(value:Number):void {
			_scaleMax = value;
			scaleSet = true;
		}
		
	}
}