package com.gestureworks.cml.elements
{
	import away3d.cameras.*;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.core.base.SubMesh;
	import away3d.core.partition.LightNode;
	import away3d.debug.*;
	import away3d.entities.Mesh;
	import away3d.events.*;
	import away3d.library.*;
	import away3d.library.assets.*;
	import away3d.lights.*;
	import away3d.loaders.parsers.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.utils.*;
	import flash.net.URLRequest;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.element.Image;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.cml.events.*;
	import com.gestureworks.cml.kits.*;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.geom.*;
	
	
	/**
	 * The Model3d class takes in a 3d file (.OBJ, or .3ds), and loads it in. Tilt gestures can be used to rotate the model in 3D space, and regular drag and scale gestures
	 * can be used to drag and scale it on the screen. .MTL files are optional when loading an OBJ.
	 *
	 * <codeblock xml:space="preserve" class="+ topic/pre pr-d/codeblock ">
	 *
		
	 *
	 * </codeblock>
	 * 
	 * @author Josh
	 * @see Panoramic
	 */
	public class Model3D extends TouchContainer
	{	
		//Touch container
		private var modelTouch:TouchContainer;
		
		private var myContainer:ObjectContainer3D;
		
		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;
		
		//scene objects
		private var light:DirectionalLight; // TODO: Allow for loading in custom lighting settings.
		private var lightPicker:StaticLightPicker;
		private var model:Mesh;
		
		private var colorMaterial:ColorMaterial;
		private var textureMaterial:TextureMaterial; // TODO: Incorporate custom textures.
		
		private var modelYaw:Number = 0;
		private var modelPitch:Number = 0;
		private var modelRoll:Number = 0;
		
		private var model_X:Number = 0;
		private var model_Y:Number = 0;
		
		/**
		 * Constructor
		 */
		public function Model3D()
		{
			//init();
			super();
			
			modelTouch = new TouchContainer();
		}
		
		private var _src:String;
		public function get src():String { return _src; }
		public function set src(value:String):void {
			_src = value;
		}
		
		private var _color:uint = 0xffffff;
		public function get color():uint { return _color; }
		public function set color(value:uint):void {
			_color = value;
		}
		
		private var _specularity:Number = 0;
		/**
		 * How shiny the model is.
		 */
		public function get specularity():Number { return _specularity; }
		public function set specularity(value:Number):void {
			_specularity = value;
		}
		
		private var _material:String;
		public function get material():String { return _material; }
		public function set material(value:String):void {
			_material = value;
		}
		
		private var bitmapMaterial:TextureMaterial;
		private var loader:Loader;
		private var counter:Number = 0;
		private var model_Z:Number = 0;
		
		override public function displayComplete():void {
			super.displayComplete();
			init();
		}
		
		/**
		 * Global initialise function
		 */
		override public function init():void
		{
			super.init();
			while (this.numChildren > 0) {
				
				if (this.getChildAt(0) is TouchContainer) {
					modelTouch = TouchContainer(this.getChildAt(0));
				}
				
				this.removeChildAt(0);
			}
			
			initEngine();
			initLights();
			//initMaterials();
			initObjects();
			initListeners();
		}
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			addChild(modelTouch);
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.LEFT;
			
			scene = new Scene3D();
			
			camera = new Camera3D();
			
			camera.lens = new OrthographicLens(); // TODO: Add lens property, also custom class for creating a view.
			
			view = new View3D();
			view.antiAlias = 4;
			view.scene = scene;
			view.camera = camera;
			
			//setup controller to be used on the camera
			cameraController = new HoverController(camera, null, 0, 0, 1000);
			
			view.addSourceURL("srcview/index.html");
			addChild(view);
			
			myContainer = new ObjectContainer3D();
			view.scene.addChild(myContainer);
		}
		
		/**
		 * Initialise the lights in a scene
		 */
		private function initLights():void
		{
			light = new DirectionalLight();
			//light.z = 1;
			light.direction = new Vector3D( 0, 0, -1);
			light.color = 0xffddbb;
			light.ambient = 1;
			lightPicker = new StaticLightPicker([light]);
			
			scene.addChild(light);
		}
		
		/**
		 * Initialise the materials
		 */
		private function initMaterials(mod:Mesh):void
		{
			var mats:Array;
			if (_material) {
				mats = _material.split(".");
				if (mats[1] != "mtl") {
					loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMaterial);
					loader.load(new URLRequest(_material));
					
					function onMaterial(e:Event):void {
						var bitmap:Bitmap = Bitmap(loader.content);
						var bitmapData:BitmapData = bitmap.bitmapData;
						bitmapMaterial = new TextureMaterial(Cast.bitmapTexture(bitmapData));
						mod.material = bitmapMaterial;
					}
					
				}
				else if (mats[1] == "mtl") {
					AssetLibrary.load( new URLRequest(_material));
				}
				else {
					colorMaterial = new ColorMaterial(_color);
					colorMaterial.shadowMethod = new FilteredShadowMapMethod(light);
					colorMaterial.lightPicker = lightPicker;
					colorMaterial.specular = 0.5;
					
					for each (var m:SubMesh in mod.subMeshes){
						m.material = colorMaterial;
					}
				}
			}
			
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			//default available parsers to all
			Parsers.enableAllBundled();
			
			var urlRequest:URLRequest = new URLRequest(_src);
			
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			//AssetLibrary.loadData(new model());
			AssetLibrary.load(urlRequest);
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, onEnterFrame);
			//TODO: add scale and drag.
			
			addEventListener(GWGestureEvent.DRAG, dragHandler);
			addEventListener(GWGestureEvent.TILT, tiltHandler);
			addEventListener(GWGestureEvent.SCALE, scaleHandler);
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:GWEvent):void
		{
			if(model){
				
				myContainer.x = model_X;
				myContainer.y = model_Y;
				//myContainer.z += model_Z;
				//camera.z = model_Z;
				//model_Z += 0.001;
				//model.geometry.scale(model_Z);
				myContainer.scaleX = model_Z;
				myContainer.scaleY = model_Z;
				myContainer.scaleZ = model_Z;
				
				myContainer.rotationY = modelYaw;
				myContainer.rotationX = modelPitch;
				myContainer.rotationZ = modelRoll;
			}
			
			view.render();
		}
		
		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{			
			if (event.asset.assetType == AssetType.MESH) {
				
				model = event.asset as Mesh;
				model.geometry.scale(scale);
				//model_Z = scale;
				model.name = "Model " + counter;
				//model.castsShadows = true;
				counter++;
				
				initMaterials(model);
				
				myContainer.addChild(model);
				model_Z = myContainer.scaleX;				
			}
			else if (event.asset.assetType == AssetType.MATERIAL) {
				//model.material = event.asset as MaterialBase;
				var tex:*;
				if (event.asset is TextureMaterial)
					tex = event.asset as TextureMaterial;
				else if (event.asset is ColorMaterial)
					tex = event.asset as ColorMaterial;
				//var tex:ColorMaterial = event.asset as ColorMaterial;
				
				tex.specular = 0.5;
				tex.lightPicker = lightPicker;
				//tex.gloss = 30;
				tex.shadowMethod = new FilteredShadowMapMethod(light);
				
				/*if (model){
					for each (var m:SubMesh in model.subMeshes){
						m.material = tex;
					}
				}*/
				//model.material = tex;
				//var tex:MaterialBase = event.asset as MaterialBase;
			}
		}
		
		/**
		 * Tilt listener for touch
		 */
		private function tiltHandler(e:GWGestureEvent):void {
			modelYaw += e.value.tilt_dx * 50;
			modelPitch += e.value.tilt_dy * 50;
		}
		
		private function dragHandler(e:GWGestureEvent):void {
			model_X -= e.value.drag_dx;
			model_Y -= e.value.drag_dy;
		}
		
		private function scaleHandler(e:GWGestureEvent):void {
			model_Z += e.value.scale_dsx;
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}