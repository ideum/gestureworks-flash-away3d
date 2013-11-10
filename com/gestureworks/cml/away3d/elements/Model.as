package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.AssetLibraryBundle;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.MaterialBase;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * This class loads a 3D Model file.
	 */
	public class Model extends ObjectContainer3D implements IObject, ICSS, IState {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// IState
		private var _stateId:String		
		
		// 3D
		private var _debug:Boolean = false;
		private var _src:String;
		private var _lpref:XML;
		private var _lightPicker:LightPicker;
		
		/**
		 * Virtual transform object.
		 */
		public var vto:TouchContainer3D;	
		
		/**
		 * @inheritDoc
		 */		
		public function Model() {
			super();	
			vto = TouchManager3D.registerTouchObject(this) as TouchContainer3D;
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;				
		}
		
		//////////////////////////////////////////////////////////////
		// ICML
		//////////////////////////////////////////////////////////////	
		
		/**
		 * @inheritDoc
		 */
		public function init():void {
			
			var s:String;
			
			if (lpref) {
				s = String(lpref);
				if (s.charAt(0) == "#") {
					s = s.substr(1);
				}
				lightPicker = document.getElementById(s); 	
			}
			
			Parsers.enableAllBundled();
			AssetLibraryBundle.getInstance(String(cmlIndex)).addEventListener(LoaderEvent.RESOURCE_COMPLETE, initObjects);
			AssetLibraryBundle.getInstance(String(cmlIndex)).addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);
			AssetLibraryBundle.getInstance(String(cmlIndex)).load(new URLRequest(src), null, String(cmlIndex));			
		}
		
		/**
		 * @inheritDoc
		 */
		public function parseCML(cml:XMLList):XMLList {	
			
			if (cml.@lightPicker != undefined) {
				cml.@lpref = cml.@lightPicker;
				delete cml.@lightPicker;
			}	
			
			return CMLParser.instance.parseCML(this, cml);
		}
		
		//////////////////////////////////////////////////////////////
		// IOBJECT
		//////////////////////////////////////////////////////////////		
		
		/**
		 * @inheritDoc
		 */
		public var state:Dictionary;		
		
		/**
		 * @inheritDoc
		 */
		public function get cmlIndex():int { return _cmlIndex };
		public function set cmlIndex(value:int):void {
			_cmlIndex = value;
		}	
		
		/**
		 * @inheritDoc
		 */
		public function get childList():ChildList { return _childList; }
		public function set childList(value:ChildList):void { 
			_childList = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function postparseCML(cml:XMLList):void {}
			
		/**
		 * @inheritDoc
		 */
		public function updateProperties(state:*=0):void {
			CMLParser.updateProperties(this, state);		
		}	
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void {
			super.dispose();
		}		
		
		
		//////////////////////////////////////////////////////////////
		//  ICSS 
		//////////////////////////////////////////////////////////////

		private var _className:String;
		/**
		 * sets the class name of displayobject
		 */
		public function get className():String { return _className; }
		public function set className(value:String):void {
			_className = value;
		}		
		
		//////////////////////////////////////////////////////////////
		// ISTATE
		//////////////////////////////////////////////////////////////				
		
		/**
		 * @inheritDoc
		 */
		public function get stateId():* {return _stateId};
		public function set stateId(value:*):void
		{
			_stateId = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function loadState(sId:* = null, recursion:Boolean = false):void { 
			if (StateUtils.loadState(this, sId, recursion)) {
				StateUtils.loadState(vto, sId, recursion);
				_stateId = sId;
			}
		}	
		
		/**
		 * @inheritDoc
		 */
		public function saveState(sId:* = null, recursion:Boolean = false):void { 
			StateUtils.saveState(this, sId, recursion); 
			StateUtils.saveState(vto, sId, recursion); 
		}		
		
		/**
		 * @inheritDoc
		 */
		public function tweenState(sId:*= null, tweenTime:Number = 1):void {
			if (StateUtils.tweenState(this, sId, tweenTime)) {
				StateUtils.tweenState(vto, sId, tweenTime);
				_stateId = sId;
			}
		}		
		
		//////////////////////////////////////////////////////////////
		// IContainer
		//////////////////////////////////////////////////////////////				
		
		/**
		 * @inheritDoc
		 */
		public function addAllChildren():void {		
			var n:int = childList.length;
			for (var i:int = 0; i < childList.length; i++) {
				if (childList.getIndex(i) is ObjectContainer3D)				
					addChild(childList.getIndex(i));
				if (n != childList.length)
					i--;
			}
		}	
		
		//////////////////////////////////////////////////////////////
		// 3D
		//////////////////////////////////////////////////////////////		
		
		/**
		 * Sets the model file path.
		 */
		public function get src():String { return _src; }		
		public function set src(value:String):void {
			_src = value;
		}		
		
		/**
		 * Sets the light picker.
		 */
		public function get lightPicker():* { return _lightPicker; }		
		public function set lightPicker(value:*):void {
				_lightPicker = value;
		}
		
		/**
		 * Sets the light picker reference.
		 */		
		public function get lpref():XML { return _lpref;}
		public function set lpref(value:XML):void {
			_lpref = value;
		}		
		
		/**
		 * Sets debug status.
		 */
		public function get debug():Boolean { return _debug; }
		public function set debug(value:Boolean):void {
			_debug = value;
		}
		
		/**
		 * Sets whether touch events are processed on this object. Same as mouseEnabled.
		 */
		public function get touchEnabled():Boolean { return mouseEnabled; }
		public function set touchEnabled(value:Boolean):void {
			mouseEnabled = value;
		}
		
		
		/**
		 * @private
		 * Assets loaded callback function.
		 */
		private function assetComplete(e:AssetEvent):void {
			
			if (e.asset.assetNamespace != String(cmlIndex)) 
				return;
			
			trace(e.asset.name +"\t" + e.asset.assetType );	
			
			if (e.asset is ObjectContainer3D) {
				ObjectContainer3D(e.asset).mouseEnabled = mouseEnabled;								
				ObjectContainer3D(e.asset).mouseChildren = mouseChildren;								
			}
			
			if (e.asset is ObjectContainer3D && ObjectContainer3D(e.asset).parent == null) {
				addChild(ObjectContainer3D(e.asset));
			}
			if (e.asset is MaterialBase) {			
				if (lightPicker) {
					MaterialBase(e.asset).lightPicker = lightPicker;
					//if (e.asset is ColorMaterial)
						//ColorMaterial(e.asset).shadowMethod = Light(CMLObjectList.instance.getId(this._lightRef)).shadowMethod;
					//else
						//TextureMaterial(e.asset).shadowMethod = Light(CMLObjectList.instance.getId(this._lightRef)).shadowMethod;
				}
			}
		}
		
		private function initObjects(e:LoaderEvent):void {
			for each (var item:* in childList) {
				
				if (item is ModelAsset) {
					ModelAsset(item).update()
				}
			}
		}

	}
}