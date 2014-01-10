package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.interfaces.IContainer;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.utils.Dictionary;
	
	/**
	 * This class creates a Mesh geometry that can be applied to a Mesh. It extends the Away3D Mesh class to add CML support.
	 */
	public class Mesh extends away3d.entities.Mesh implements IContainer, ICSS, IState  {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;

		// ICSS
		private var _className:String;
		
		// IState
		private var _stateId:String;

		// CML refs
		private var _gref:XML; // geometry
		private var _mref:XML; // material			
		
		/**
		 * Virtual transform object.
		 */
		public var vto:TouchContainer3D;			
		
		/**
		 * @inheritDoc
		 */
		public function Mesh () {
			super(null, null);
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
			
			if (gref) {
				s = String(gref);
				if (s.charAt(0) == "#") {
					s = s.substr(1);
				}
				geometry = document.getElementById(s); 	
			}
			
			if (mref) {
				s = String(mref);
				if (s.charAt(0) == "#") {
					s = s.substr(1);
				}
				material = document.getElementById(s) as MaterialBase;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function parseCML(cml:XMLList):XMLList {
			
			if (cml.@geometry != undefined) {
				cml.@gref = cml.@geometry;
				delete cml.@geometry;
			}			
			
			if (cml.@material != undefined) {
				cml.@mref = cml.@material;
				delete cml.@material;
			}				
			
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
		public function get cmlIndex():int {return _cmlIndex};
		public function set cmlIndex(value:int):void {
			_cmlIndex = value;
		}	
		
		/**
		 * @inheritDoc
		 */
		public function get childList():ChildList { return _childList;}
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
		public function get className():String { return _className ; }
		public function set className(value:String):void
		{
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
		
		/*
		 * Geometry reference
		 */
		public function get gref():* { return _gref; }	
		public function set gref(geom:*):void {
			_gref = geom;
		}
		
		/*
		 * Material reference
		 */
		public function get mref():* { return _mref; }		
		public function set mref(mat:*):void { 
			_mref = mat;
		}
		
		/**
		 * Sets whether touch events are processed on this object. Same as mouseEnabled.
		 */
		public function get touchEnabled():Boolean { return mouseEnabled; }
		public function set touchEnabled(value:Boolean):void {
			mouseEnabled = value;
		}
		
		/**
		 * Sets scene and handles the vto's view assignment when the scene is added to CML Camera.
		 */
		override public function set scene(value:Scene3D):void {
			super.scene = value;
			if (value) {
				value.addEventListener(StateEvent.CHANGE, function addedToView(e:StateEvent):void {
					if (e.property == "addedToView") {
						value.removeEventListener(StateEvent.CHANGE, addedToView);
						vto.view = e.value;
					}
				});
			}
		}
		
	}
}