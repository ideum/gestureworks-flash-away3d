package com.gestureworks.cml.elements
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SkyBox;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapCubeTexture;
	import away3d.utils.Cast;
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.element.Image;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.cml.events.*;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import flash.events.*;
	import flash.geom.*;
	
	
	/**
	 * The Panoramic element provides a touch-enabled, 3-Dimensional panorama using the Away3D 4 library.
	 * 
	 * <p>The Panoramic element has two projection types: sphere, or cube, which may be set using the projectionType attribute/property.</p>
	 * 
	 * <p>For a sphere projectionType, a single, spherical panoramic image needs to be provided in an Image element. The maximum size of the panorama's longest edge 
	 * can be no greater than 2048, and this may be set in the CML or Actionscript rather than resizing the actual image file itself. If using CML, this Image element tag 
	 * should be added between the open and close tags of the Panoramic element to make it a child of the Panoramic; in AS3 the Image should be added to the 
	 * Panoramic element object as a child, and the object should be initialized after the image's Event.Complete is called.</p>
	 * 
	 * <p>For a cube projectionType, six cubic panorama images need to be provided in CML or AS3 in the same way as the sphere. In AS3 each image should have its Event.Complete 
	 * called and added to the Panoramic element's display list before the init() method is called. Cubic faces must be sized in powers of 2. The maximum size for cubic 
	 * faces is 2,048 pixels wide, and 2,048 tall. Cubic faces should be perfectly square.</p>
	 * 
	 * <p>The Panoramic element will actually consist of two objects, the Away3D projection/view, and a TouchContainer which holds the projection and provides 
	 * the enabled touch interaction.</p>
	 *
	 * <codeblock xml:space="preserve" class="+ topic/pre pr-d/codeblock ">
	 *
		var pano = new Panoramic();
		pano.projectionType = "cube";
		pano.cubeFace = true;
		pano.width = 700;
		pano.height = 500;
		pano.x = 500;
		pano.fovMin = 30;
		pano.fovMax = 200;
		pano.mouseChildren = true;
		
		var touchC:TouchContainer = new TouchContainer();
		touchC.nestedTransform = false;
		touchC.gestureEvents = true;
		touchC.mouseChildren = false;
		touchC.disableAffineTransform = true;
		touchC.disableNativeTransform = true;
		touchC.gestureList = { "n-drag":true, "n-scale":true };
		touchC.init();
		
		var imageRight:Image = new Image();
		imageRight.width = 1024;
		imageRight.open("../../../../assets/panoramic/30kabah_r.jpg");
		imageRight.addEventListener(Event.COMPLETE, imageComplete);
		
		var imageLeft:Image = new Image();
		imageLeft.width = 1024;
		imageLeft.open("../../../../assets/panoramic/30kabah_l.jpg");
		imageLeft.addEventListener(Event.COMPLETE, imageComplete);
		
		var imageUp:Image = new Image();
		imageUp.width = 1024;
		imageUp.open("../../../../assets/panoramic/30kabah_u.jpg");
		imageUp.addEventListener(Event.COMPLETE, imageComplete);
		
		var imageDown:Image = new Image();
		imageDown.width = 1024;
		imageDown.open("../../../../assets/panoramic/30kabah_d.jpg");
		imageDown.addEventListener(Event.COMPLETE, imageComplete);
		
		var imageFront:Image = new Image();
		imageFront.width = 1024;
		imageFront.open("../../../../assets/panoramic/30kabah_f.jpg");
		imageFront.addEventListener(Event.COMPLETE, imageComplete);
		
		var imageBack:Image = new Image();
		imageBack.width = 1024;
		imageBack.open("../../../../assets/panoramic/30kabah_b.jpg");
		imageBack.addEventListener(Event.COMPLETE, imageComplete);
		
		function imageComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, imageComplete);
			e.target.init();
			
			if ( counter == 5 ) {
				
				pano.addChild(imageRight);
				pano.addChild(imageLeft);
				pano.addChild(imageUp);
				pano.addChild(imageDown);
				pano.addChild(imageFront);
				pano.addChild(imageBack);
				
				pano.addChild(touchC);
				
				pano.init();
				
				addChild(pano);
			}
			else { counter++; }
		}
	 *
	 * </codeblock>
	 * 
	 * @author Josh
	 * @see Gigapixel
	 */
	public class Panoramic extends TouchContainer
	{	
		private var panoramicTouch:TouchContainer;
		private var faceNum:int = 0;
		
		private var camController:HoverController;
		private var _skyBox:SkyBox;
		private var _lens:PerspectiveLens;
		
		private var cam:Camera3D;
		private var pview:View3D;
		private var cube_face:Array = new Array();
		private var shape_net:TextureMaterial;
		
		private var _fov:Number = 90; 
		private var _yaw:Number = 45;
		private var _roll:Number = 0;
		private var _pitch:Number = 8; 
		
		private const DRAG_LIMITER:Number = 0.25;
		private const SCALE_MULTIPLIER:Number = 50;
	
		/**
		 * Constructor
		 */
		public function Panoramic()
		{
			super();
			panoramicTouch = new TouchContainer();
		}
		
		private var _cubeFace:Boolean = true;
		/**
		 * Sets default projection geometry
		 * @default false
		 */		
		public function get cubeFace():Boolean{return _cubeFace;}
		public function set cubeFace(value:Boolean):void
		{			
			_cubeFace = value;
		}
		
		private var _projectionType:String = "cube";
		/**
		 * Sets default projection geometry
		 * @default "cube"
		 */		
		public function get projectionType():String{return _projectionType;}
		public function set projectionType(value:String):void
		{			
			_projectionType = value;
		}
		
		private var _fovMax:Number = 150;
		/**
		 * Sets maximum spread of the field of view. This is how wide the viewing angle can be. Larger means more of the panorama is seen at once,
		 * but too large can mean things can look skewed or warped, or even get turned inside out.
		 * @default 150
		 */		
		public function get fovMax():Number{return _fovMax;}
		public function set fovMax(value:Number):void
		{			
			_fovMax = value;
		}
		
		private var _fovMin:Number = 50;
		private var largeSphere:Mesh;
		/**
		 * Sets the minimum spread of the field of view. This is how narrow the viewing angle can be. Smaller means less total area of the panorama can be
		 * seen, but the viewing area that is available is in much greater detail, and appears "foved" in.
		 * @default 50
		 */		
		public function get fovMin():Number{return _fovMin;}
		public function set fovMin(value:Number):void
		{			
			_fovMin = value;
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void
		{
			if (projectionType == "cube"){
				var counter:Number = 0;
				while (this.numChildren > 0) {
					
					if (this.getChildAt(0) is TouchContainer) {
						panoramicTouch = TouchContainer(this.getChildAt(0));
					}
					
					if (this.getChildAt(0) is Image && counter < 6) {
						cube_face.push(this.getChildAt(0));
						counter++;
					}
					this.removeChildAt(0);
				}
			}
			else if (projectionType == "sphere") {
				while (this.numChildren > 0) {
					if (this.getChildAt(0) is TouchContainer) {
						panoramicTouch = TouchContainer(this.getChildAt(0));
					}
					
					if (this.getChildAt(0) is Image) {
						shape_net = new TextureMaterial(Cast.bitmapTexture(this.getChildAt(0)))
					}
					
					this.removeChildAt(0);
				}
			}
			
			setupUI();
		}
		
		private function setupUI():void
		{ 
			addChild(panoramicTouch);
			// create a "hovering" camera
			
			cam = new Camera3D();
			camController = new HoverController(cam);
			
			// create a viewport
			_lens = new PerspectiveLens(90);
			pview = new View3D();
			pview.width = width;
			pview.height = height;
			pview.camera = cam;
			cam.lens = _lens;
			
			panoramicTouch.addChild(pview);
			
			//----------------------------------// 
			
			// add a huge surrounding sphere
			if(_projectionType =="sphere"){
				
				largeSphere = new Mesh(new SphereGeometry(this.width, 32, 32), shape_net);
				largeSphere.scaleX = -1;
				largeSphere.position = cam.position;
				
				camController = null;
				
				pview.scene.addChild(largeSphere);
				pview.render();
			}
			
			if (_projectionType == "cube") {
				
				var bmCubeText:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(cube_face[0]), Cast.bitmapData(cube_face[1]), Cast.bitmapData(cube_face[2]), Cast.bitmapData(cube_face[3]), Cast.bitmapData(cube_face[4]), Cast.bitmapData(cube_face[5]));
				//															right							left							up							down							front							back
				_skyBox = new SkyBox(bmCubeText);
				pview.scene.addChild(_skyBox);
				pview.render();
			}
			
			panoramicTouch.addEventListener(GWGestureEvent.DRAG, gestureDragHandler);
			panoramicTouch.addEventListener(GWGestureEvent.SCALE, gestureScaleHandler);
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, update);
		}
		
		/**
		 * updates camera angle
		 * @param	e
		 */
		public function update(e:GWEvent):void
		{	
			if(_skyBox){
				camController.tiltAngle = _pitch;
				camController.panAngle = _yaw;
				_lens.fieldOfView = _fov;
				camController.update();
			}
			
			if (largeSphere) {
				cam.rotateTo(_pitch, _yaw, 0);
				_lens.fieldOfView = _fov;
			}
			
		  	pview.render(); 
		}
		
		// yaw and pitch control
		private function gestureDragHandler(e:GWGestureEvent):void 
		{
			_yaw += e.value.drag_dx * DRAG_LIMITER;
			_pitch += e.value.drag_dy * DRAG_LIMITER;
		}
		
		// scale control
		private function gestureScaleHandler(event:GWGestureEvent):void 
		{
			if (_fovMin < _fov < _fovMax) _fov -= event.value.scale_dsx * SCALE_MULTIPLIER;
			if (_fov > _fovMax) _fov = _fovMax;
			if (_fov < _fovMin) _fov = _fovMin;
		}	
		
		/**
		 * Dispose methods to nullify children
		 */
		override public function dispose():void {
			super.dispose();
			
			GestureWorks.application.removeEventListener(GWEvent.ENTER_FRAME, update);
			panoramicTouch.removeEventListener(GWGestureEvent.DRAG, gestureDragHandler);
			panoramicTouch.removeEventListener(GWGestureEvent.SCALE, gestureScaleHandler);
			
			while (panoramicTouch.numChildren > 0 ) {
				panoramicTouch.removeChildAt(0);
			}
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			
			if (largeSphere)
				largeSphere = null;
			if (_skyBox)
				_skyBox = null;
			panoramicTouch = null;
			cam = null;
			pview = null;
			camController = null;
		}
	}
}