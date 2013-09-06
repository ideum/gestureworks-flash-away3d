package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.MaterialBase;
	import com.gestureworks.cml.core.CMLObjectList;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 */
	public class Model extends Group {
		private var _src:String;
		private var _lRef:String;
		
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
				if (this.parent is Scene)
					Scene(this.parent).addChild3D(ObjectContainer3D(e.asset));
				
				if (this.parent is Group)
					Group(this.parent).addChild3D(ObjectContainer3D(e.asset));
				
				if (this.parent is Mesh)
					Mesh(this.parent).addChild3D(ObjectContainer3D(e.asset));
			}
			
			
			if (e.asset is MaterialBase)
			
				if (this.lRef && CMLObjectList.instance.getId(this.lRef)) {
					MaterialBase(e.asset).lightPicker = CMLObjectList.instance.getId(this.lRef).slp;
					
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
		
		public function get lRef():String {
			return _lRef;
		}
		
		public function set lRef(value:String):void {
			_lRef = value;
		}
	
	}

}