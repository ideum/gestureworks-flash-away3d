package com.gestureworks.cml.element.away3d 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import com.gestureworks.cml.element.Element;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * 
	 */
	public class SceneCamera extends Group 
	{
		private var _ortho:Boolean = false;
		private var _fov:Number = 60;
		private var _projectionHeight:Number = 500;
		private var _clipping:String = "20,3000"; //"near,far"
		private var _viewPos:String; //"x,y"
		private var _viewDim:String;//"wh"
		private var _viewBackgroundColor:uint = 0xCCCCCC;
		private var _transform3D:Matrix3D;
		private var _camera:Camera3D;
		private var _lens:LensBase;
		
		public function SceneCamera() 
		{
			super();
			_camera = new Camera3D()
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void
		{
			displayComplete();
		}
		
		/**
		 * CML callback Initialisation
		 */
		override public function displayComplete():void
		{
			//trace("###SCENE CAMERA displayComplete ###")
			if (_ortho)
			{
				_lens = new OrthographicLens(_projectionHeight);
			}
			else
			_lens = new PerspectiveLens(_fov);
			
			_lens.near = _clipping.split(",")[0];
			_lens.far = clipping.split(",")[1];
			
			_camera.lens = _lens;
			_camera.x = this.x;
			_camera.y = this.y;
			_camera.z = this.z;
			
			_camera.rotationX = this.rotationX;
			_camera.rotationY = this.rotationY;
			_camera.rotationZ = this.rotationZ;
			
			if (this.lookat) //overides any rotation above
				_camera.lookAt(new Vector3D(this.lookat.split(",")[0], this.lookat.split(",")[1], this.lookat.split(",")[2]));
			
			_camera.scaleX = this.scaleX;
			_camera.scaleY = this.scaleY;
			_camera.scaleZ = this.scaleZ;
			
			if (this.parent is Scene)
			{
				Scene(this.parent).updateViewFromCamera();
			}
			
			
		}
		
		public function get ortho():Boolean 
		{
			return _ortho;
		}
		
		public function set ortho(value:Boolean):void 
		{
			_ortho = value;
		}
		
		public function get fov():Number 
		{
			return _fov;
		}
		
		public function set fov(value:Number):void 
		{
			_fov = value;
		}
		
		public function get projectionHeight():Number 
		{
			return _projectionHeight;
		}
		
		public function set projectionHeight(value:Number):void 
		{
			_projectionHeight = value;
		}
		
		public function get clipping():String 
		{
			return _clipping;
		}
		
		public function set clipping(value:String):void 
		{
			_clipping = value;
		}
		
		public function get viewPos():String 
		{
			return _viewPos;
		}
		
		public function set viewPos(value:String):void 
		{
			if (value !="")
			_viewPos = value;
		}
		
		public function get viewDim():String 
		{
			return _viewDim;
		}
		
		public function set viewDim(value:String):void 
		{
			_viewDim = value;
		}
		
		public function get viewBackgroundColor():uint 
		{
			return _viewBackgroundColor;
		}
		
		public function set viewBackgroundColor(value:uint):void 
		{
			_viewBackgroundColor = value;
		}
		
		public function get transform3D():Matrix3D 
		{
			return _transform3D;
		}
		
		public function set transform3D(value:Matrix3D):void 
		{
			_transform3D = value;
		}
		
		public function getCamera():Camera3D 
		{
			return _camera;
		}
		
		public function set camera(value:Camera3D):void 
		{
			_camera = value;
		}
		
		public function get lens():LensBase 
		{
			return _lens;
		}
		
		public function set lens(value:LensBase):void 
		{
			_lens = value;
		}
		
		
	}

}