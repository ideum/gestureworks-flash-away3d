package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import com.gestureworks.cml.core.CMLObjectList;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 */
	public class Model extends Group {
		private var _src:String;
		private var _lightPickerRef:String;
		
		public function Model() {
			super();
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void {
			Parsers.enableAllBundled();
			//TODO namespace and context
			AssetLibrary.load(new URLRequest(this._src));
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, initObjects);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);
		}
		
		private function assetComplete(e:AssetEvent):void {
			
			//	trace(e.asset.name +"\t" + e.asset.assetType );
			
			if (e.asset is ObjectContainer3D && ObjectContainer3D(e.asset).parent == null) {
				if (this.parent is com.gestureworks.cml.element.away3d.Scene)
					com.gestureworks.cml.element.away3d.Scene(this.parent).addChild3D(ObjectContainer3D(e.asset));
				
				if (this.parent is com.gestureworks.cml.element.away3d.Group)
					com.gestureworks.cml.element.away3d.Group(this.parent).addChild3D(ObjectContainer3D(e.asset));
				
				if (this.parent is com.gestureworks.cml.element.away3d.Mesh)
					com.gestureworks.cml.element.away3d.Mesh(this.parent).addChild3D(ObjectContainer3D(e.asset));
			}
			
			
			if (e.asset is MaterialBase)
			
				if (this.lightPickerRef && CMLObjectList.instance.getId(this.lightPickerRef)) {
					MaterialBase(e.asset).lightPicker = CMLObjectList.instance.getId(this.lightPickerRef).slp;
					
					//if (e.asset is ColorMaterial)
						//ColorMaterial(e.asset).shadowMethod = Light(CMLObjectList.instance.getId(this._lightRef)).shadowMethod;
					//else
						//TextureMaterial(e.asset).shadowMethod = Light(CMLObjectList.instance.getId(this._lightRef)).shadowMethod;
					
				}
		
		}
		
		private function initObjects(e:LoaderEvent):void {
			displayComplete();
		}
		
		/**
		 * CML callback Initialisation
		 */
		override public function displayComplete():void {
			//trace("### Model  displayComplete ###");
			
			for (var i:uint = 0; i < this.numChildren; i++) {
				if (this.getChildAt(i) is ModelAsset)
					ModelAsset(this.getChildAt(i)).update()
			}
		
		}
		
		public function get src():String {
			return _src;
		}
		
		public function set src(value:String):void {
			_src = value;
		}
		
		public function get lightPickerRef():String {
			return _lightPickerRef;
		}
		
		public function set lightPickerRef(value:String):void {
			_lightPickerRef = value;
		}
	
	}

}