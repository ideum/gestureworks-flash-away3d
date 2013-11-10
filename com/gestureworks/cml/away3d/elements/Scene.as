package com.gestureworks.cml.away3d.elements {
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.pick.PickingType;
	import away3d.utils.Cast;
	import com.gestureworks.cml.elements.*;
	import com.gestureworks.cml.events.*;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	 *
	 */
	public class Scene extends TouchContainer3D {
		private var _ortho:Boolean = false;
		private var _fov:Number = 60;
		private var _projectionHeight:Number = 500;
		private var _clipping:String = "20,3000"; //"near,far"
		private var _viewPos:String = "0,0"; //"x,y"
		private var _viewDim:String; //"wh"
		private var _viewAntiAlias:int = 4;
		private var _viewBgColor:uint = 0x555555;
		
		
		// Away3D view instances vect
		private var _viewVct:Vector.<View3D> = new Vector.<View3D>;
		public var scene:Scene3D;
		private var stage3DProxy:Stage3DProxy;
		private var lastRot:Number = 0;
		private var curRot:Number;
		private var camerasVct:Vector.<com.gestureworks.cml.away3d.elements.Camera> = new Vector.<com.gestureworks.cml.away3d.elements.Camera>;
		private var _stageProxyColor:uint = 0x0;
		
		/**
		 * Constructor
		 */
		public function Scene(stage:Stage = null) {
			super();
			scene = new Scene3D();
			mouseChildren = true;
			//stage3DProxy = DefaultStage3D.getInstance(stage).stage3DProxy;
		}
		
		/**
		 * method searches the child and adds to the list
		 */
		override public function addAllChildren():void {		
			var n:int = childList.length;
			for (var i:int = 0; i < childList.length; i++) {
				if (childList.getIndex(i) is ObjectContainer3D)				
					scene.addChild(childList.getIndex(i));
				if (n != childList.length)
					i--;
			}
		}			
		

		/**
		 * Initialisation method
		 */
		override public function init():void {
			for (var i:uint = 0; i < this.numChildren; i++)
				if (this.getChildAt(i) is com.gestureworks.cml.away3d.elements.Camera)
					camerasVct.push(com.gestureworks.cml.away3d.elements.Camera(this.getChildAt(i)));
			
			if (camerasVct.length > 0) {
			//	for each (var c:SceneCamera in camerasVct)
					createView(camerasVct[0]);
			}
			else
				createView();
			
			setupUI();			
		}
		
		override public function addChild3D(child:ObjectContainer3D):void {
			scene.addChild(child);
		}
		
		private function createView(sceneCamera:com.gestureworks.cml.away3d.elements.Camera = null):void {
			var cam:away3d.cameras.Camera3D
			if (sceneCamera) {
				cam = sceneCamera.getCamera();
			}
			else {
				cam = new away3d.cameras.Camera3D((_ortho) ? new OrthographicLens(_projectionHeight) : new PerspectiveLens(_fov));
				cam.lens.near = _clipping.split(",")[0];
				cam.lens.far = _clipping.split(",")[1];
			}
			
			var view:View3D = new View3D(scene, cam);			
			if (_viewPos) {
				view.x = _viewPos.split(",")[0];
				view.y = _viewPos.split(",")[1];
			}
			if (_viewDim) {
				view.width = _viewDim.split(",")[0];
				view.height = _viewDim.split(",")[1];
			}
			
			//view.mousePicker = PickingType.RAYCAST_BEST_HIT;
			view.forceMouseMove = true;
			view.touchPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
			view.background = Cast.bitmapTexture(new BitmapData(2, 2, false, _viewBgColor));
			//view.stage3DProxy = stage3DProxy;
			//stage3DProxy.color = _stageProxyColor;
			//stage3DProxy.antiAlias = _viewAntiAlias;
			//view.shareContext = true;
			//TODO REMOVE WHEN TOUCH IS ENABLED
			//view.forceMouseMove = true;

			viewVct.push(view);
		}
		
		//called from the SceneCamera
		public function updateViewFromCamera():void {
			for (var i:uint = 0; i < viewVct.length; i++) {
				if (com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewPos) {
					View3D(viewVct[i]).x = com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewPos.split(",")[0];
					View3D(viewVct[i]).y = com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewPos.split(",")[1];
				}
				
				if (com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewDim) {
					View3D(viewVct[i]).width = com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewDim.split(",")[0];
					View3D(viewVct[i]).height = com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewDim.split(",")[1];
				}
				View3D(viewVct[i]).background = Cast.bitmapTexture(new BitmapData(2, 2, false, com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewBgColor));
				View3D(viewVct[i]).background = Cast.bitmapTexture(new BitmapData(2, 2, false, com.gestureworks.cml.away3d.elements.Camera(camerasVct[i]).viewBgColor));
			}
		}
		
		private function setupUI():void {
			for each (var v:View3D in viewVct) {
				addChild(v);
			}
			
			//stage3DProxy.addEventListener(Event.ENTER_FRAME, tick);
			addEventListener(Event.ENTER_FRAME, tick);
		
		}
		
		private function tick(e:Event):void {
			for each (var v:View3D in viewVct) {
				v.render();
			}
		}
		
		public function get ortho():Boolean { return _ortho; }		
		public function set ortho(value:Boolean):void {
			_ortho = value;
		}
		
		public function get fov():Number { return _fov; }		
		public function set fov(value:Number):void {
			_fov = value;
		}
		
		public function get projectionHeight():Number { return _projectionHeight; }		
		public function set projectionHeight(value:Number):void {
			_projectionHeight = value;
		}
		
		public function get clipping():String { return _clipping; }		
		public function set clipping(value:String):void {
			_clipping = value;
		}
		
		public function get viewPos():String { return _viewPos; }		
		public function set viewPos(value:String):void {
			_viewPos = value;
		}
		
		public function get viewDim():String { return _viewDim; }		
		public function set viewDim(value:String):void {
			_viewDim = value;
		}
		
		public function get viewAntiAlias():int { return _viewAntiAlias; }		
		public function set viewAntiAlias(value:int):void {
			_viewAntiAlias = value;
		}
		
		public function get viewBgColor():uint { return _viewBgColor; }		
		public function set viewBgColor(value:uint):void {
			_viewBgColor = value;
		}
		
		public function get stageProxyColor():uint { return _stageProxyColor; }		
		public function set stageProxyColor(value:uint):void {
			_stageProxyColor = value;
		}
		
		public function get viewVct():Vector.<View3D> { return _viewVct; }
		
		/**
		 * Dispose methods to nullify children
		 */
		override public function dispose():void {
			super.dispose();
		
			//TODO
		}
	}
}