package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.MaterialBase;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.utils.document;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 */
	public class Model extends TouchContainer3D {
		private var _src:String;
		private var _lightPicker:LightPicker;
		private var lref:XML;
		
		public function Model() {
			super();			
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void {
			super.init();
			Parsers.enableAllBundled();
			//TODO namespace and context
			AssetLibrary.load(new URLRequest(this._src));
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, initObjects);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);
		}
		
		private function assetComplete(e:AssetEvent):void {
			
			//	trace(e.asset.name +"\t" + e.asset.assetType );
			
			if (e.asset is ObjectContainer3D && ObjectContainer3D(e.asset).parent == null) {
				if (this.parent is TouchContainer3D)
					TouchContainer3D(this.parent).addChild3D(ObjectContainer3D(e.asset));
				target = e.asset;
			}
			
			
			if (e.asset is MaterialBase)
			
				if (lightPicker) {
					MaterialBase(e.asset).lightPicker = lightPicker.slp;
					
					//if (e.asset is ColorMaterial)
						//ColorMaterial(e.asset).shadowMethod = Light(CMLObjectList.instance.getId(this._lightRef)).shadowMethod;
					//else
						//TextureMaterial(e.asset).shadowMethod = Light(CMLObjectList.instance.getId(this._lightRef)).shadowMethod;
					
				}
		
		}
		
		private function initObjects(e:LoaderEvent):void {
			for (var i:uint = 0; i < this.numChildren; i++) {
				if (this.getChildAt(i) is ModelAsset)
					ModelAsset(this.getChildAt(i)).update()
			}
		}
		
		public function get src():String { return _src; }		
		public function set src(value:String):void {
			_src = value;
		}
		
		public function get lightPicker():* { return _lightPicker; }		
		public function set lightPicker(value:*):void {
			if (value is XML) {
				lref = value;
				value = document.getElementById(lref);
			}
			if (value is LightPicker)
				_lightPicker = value;
		}
		
		override public function parseCML(cml:XMLList):XMLList 
		{
			var node:XML = XML(cml);			
			for each(var item:XML in node.*) {
				
				if (item.name()=="LightPicker") {					
					lightPicker = CMLParser.instance.createObject(item.name());
					CMLParser.instance.attrLoop(lightPicker, XMLList(item)); 
					lightPicker.updateProperties();
					
					for each(var light:Light in lightPicker.lights) 
						light.updateProperties();						
					
					lightPicker.parseCML(XMLList(item));						
					lightPicker.init();
					delete cml[item.name()];
				}					
			}
			
			CMLParser.instance.parseCML(this, cml);
			return cml.*;
		}
	
	}

}