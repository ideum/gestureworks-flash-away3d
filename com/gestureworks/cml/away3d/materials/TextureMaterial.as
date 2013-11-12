package com.gestureworks.cml.away3d.materials {
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.Texture2DBase;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * This class creates a color material that can be applied to a Mesh. It extends the Away3D ColorMaterial class to add CML support.
	 */
	public class TextureMaterial extends away3d.materials.TextureMaterial implements IObject, ICSS, IState {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// ICSS
		private var _className:String;			
		
		// IState
		private var _stateId:String;	
		
		// 3D 
		private var _tref:XML;
		private var _lpref:XML;
		
		/**
		 * @inheritDoc
		 */	
		public function TextureMaterial(texture:Texture2DBase = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true) {
			super(texture, smooth, repeat, mipmap);
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;	
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);			
		}
		
		/**
		 * @inheritDoc
		 */
		public function init():void {
			var s:String;
			
			if (tref) {
				s = String(tref);
				if (s.charAt(0) == "#") {
					s = String(s).substr(1);
				}
				texture = document.getElementById(s); 	
			}	
			if (lpref) {
				s = String(lpref);
				if (s.charAt(0) == "#") {
					s = String(s).substr(1);
				}
				lightPicker = document.getElementById(s); 	
			}					
		}				
		
		/**
		 * @private
		 * Ensures that this comes last
		 */
		private function cmlInit(e:Event):void {
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);	
			if (lightPicker) {
				for each (var l:* in LightPickerBase(lightPicker).allPickedLights) {
					if (l.shadowMethod) {
						shadowMethod = l.shadowMethod;
					}
				}
			}
		}		
		
		//////////////////////////////////////////////////////////////
		// ICML
		//////////////////////////////////////////////////////////////	
		
		/**
		 * @inheritDoc
		 */
		public function parseCML(cml:XMLList):XMLList {
			return CMLParser.parseCML(this, cml);
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
		public function get cmlIndex():int { return _cmlIndex; }
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

		/**
		 * @inheritDoc
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
		public function get stateId():* { return _stateId; }
		public function set stateId(value:*):void {
			_stateId = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function loadState(sId:* = null, recursion:Boolean = false):void { 
			if (StateUtils.loadState(this, sId, recursion)) {
				_stateId = sId;
			}
		}	
		
		/**
		 * @inheritDoc
		 */
		public function saveState(sId:* = null, recursion:Boolean = false):void { 
			StateUtils.saveState(this, sId, recursion); 
		}		
		
		/**
		 * @inheritDoc
		 */
		public function tweenState(sId:*= null, tweenTime:Number = 1):void {
			if (StateUtils.tweenState(this, sId, tweenTime)) {
				_stateId = sId;
			}
		}		
		
		//////////////////////////////////////////////////////////////
		// 3D
		//////////////////////////////////////////////////////////////
	
		
		/*
		 * Texture reference
		 */
		public function get tref():XML { return _tref; }
		public function set tref(value:XML):void {
			_tref = value;
		}		
		
		/**
		 * LightPicker reference
		 */
		public function get lpref():XML { return _lpref; }
		public function set lpref(value:XML):void {
			_lpref = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateLightPicker():void {}
		
	}
}