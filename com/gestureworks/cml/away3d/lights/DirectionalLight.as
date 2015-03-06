package com.gestureworks.cml.away3d.lights {
	import away3d.lights.DirectionalLight;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.materials.methods.SimpleShadowMapMethodBase;
	import away3d.materials.methods.SoftShadowMapMethod;
	import com.gestureworks.cml.away3d.interfaces.ILight;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.utils.Dictionary;
	
	/**
	 * This class creates a directionarl light that can be applied to a Material. It extends the Away3D DirectionalLight class to add CML support.
	 */
	public class DirectionalLight extends away3d.lights.DirectionalLight implements IObject, ICSS, IState, ILight {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// ICSS
		private var _className:String;			
		
		// IState
		private var _stateId:String;
		
		// 3D
		private var _shadowType:String = "soft";
	
		/**
		 * The shadow method applied to this light.
		 */
		public var shadowMethod:SimpleShadowMapMethodBase;
		
		/**
		 * @inheritDoc
		 */	
		public function DirectionalLight() {
			super();
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;				
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function init():void {
			if (castsShadows) {
				if (shadowType == "hard") {
					shadowMethod = new HardShadowMapMethod(this);
				}
				else {
					shadowMethod = new SoftShadowMapMethod(this);
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
		public function tweenState(sId:*=null, tweenTime:Number = 1, onComplete:Function=null):void {
			if (StateUtils.tweenState(this, sId, tweenTime)) {
				_stateId = sId;
			}
		}		
		
		//////////////////////////////////////////////////////////////
		// 3D
		//////////////////////////////////////////////////////////////
		
		/**
		 * Sets the shadow type (hard or soft) if castShadow = "true". 
		 */
		public function get shadowType():String { return _shadowType;  }
		public function set shadowType(value:String):void {
			_shadowType = value;
		}		
	}
}