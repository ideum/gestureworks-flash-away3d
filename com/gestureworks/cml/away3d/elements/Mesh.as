package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.away3d.utils.CML3DUtils;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 */
	public class Mesh extends away3d.entities.Mesh implements IObject, ICSS, IState  {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// IState
		private var _stateId:String

		// CML refs
		private var _gref:XML; // geometry
		private var _mref:XML; // material			
		
		/**
		 * Constructor
		 */
		public function Mesh () {
			super(null, null);
			vto = TouchManager3D.registerTouchObject(this) as TouchContainer3D;
			vto.away3d = true;
			mouseEnabled = true;
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;	
		}

		
		//////////////////////////////////////////////////////////////
		// ICML
		//////////////////////////////////////////////////////////////	
		
		/**
		 * CML initialization
		 */
		public function init():void {
			var s:String;
			
			if (gref) {
				if (String(gref).charAt(0) == "#") {
					s = String(gref).substr(1);
				}
				geometry = document.getElementById(s); 	
			}
			
			if (mref) {
				if (String(mref).charAt(0) == "#") {
					s = String(mref).substr(1);
				}
				material = document.getElementById(s).material; 
			}	
		}
		
		/**
		 * Custom CML parse routine
		 * @param	cml
		 * @return
		 */
		public function parseCML(cml:XMLList):XMLList {
			var node:XML = XML(cml);
			var obj:Object;
			var tag:String;
			var isGeo:Boolean;
			
			for each(var item:XML in node.*) {
				if (CML3DUtils.isGeometry(item.name())) {					
					obj = CMLParser.createObject(item.name());
					CMLParser.attrLoop(obj, XMLList(item));
					obj.updateProperties();
					obj.init();					
					geometry = obj.geometry;
					delete cml[item.name()];
				}									
			}			
			return CMLParser.parseCML(this, cml);
		}
		
		//////////////////////////////////////////////////////////////
		// IOBJECT
		//////////////////////////////////////////////////////////////		
		
		/**
		 * Property states
		 */
		public var state:Dictionary;		
		
		/**
		 * Sets the cml index
		 */
		public function get cmlIndex():int {return _cmlIndex};
		public function set cmlIndex(value:int):void
		{
			_cmlIndex = value;
		}	
		
		/**
		 * Sets cml childlist
		 */
		public function get childList():ChildList { return _childList;}
		public function set childList(value:ChildList):void { 
			_childList = value;
		}
		
		/**
		 * Postparse method
		 * @param	cml
		 */
		public function postparseCML(cml:XMLList):void {}
			
		/**
		 * Update properties of child
		 * @param	state
		 */
		public function updateProperties(state:*=0):void {
			CMLParser.updateProperties(this, state);		
		}	
		
		/**
		 * Destructor
		 */
		override public function dispose():void {}		
		
		
		//////////////////////////////////////////////////////////////
		//  ICSS 
		//////////////////////////////////////////////////////////////

		private var _className:String;
		/**
		 * sets the class name of displayobject
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
		 * Sets the state id
		 */
		public function get stateId():* {return _stateId};
		public function set stateId(value:*):void
		{
			_stateId = value;
		}
		
		/**
		 * Loads state by index number. If the first parameter is NaN, the current state will be saved.
		 * @param sIndex State index to be loaded.
		 * @param recursion If true the state will load recursively through the display list starting at the current display ojbect.
		 */
		public function loadState(sId:* = null, recursion:Boolean = false):void { 
			if (StateUtils.loadState(this, sId, recursion)) {
				StateUtils.loadState(vto, sId, recursion);
				_stateId = sId;
			}
		}	
		
		/**
		 * Save state by index number. If the first parameter is NaN, the current state will be saved.
		 * @param sIndex State index to save.
		 * @param recursion If true the state will save recursively through the display list starting at the current display ojbect.
		 */
		public function saveState(sId:* = null, recursion:Boolean = false):void { 
			StateUtils.saveState(this, sId, recursion); 
			StateUtils.saveState(vto, sId, recursion); 
		}		
		
		/**
		 * Tween state by stateIndex from current to given state index. If the first parameter is null, the current state will be used.
		 * @param sIndex State index to tween.
		 * @param tweenTime Duration of tween
		 */
		public function tweenState(sId:*= null, tweenTime:Number = 1):void {
			if (StateUtils.tweenState(this, sId, tweenTime)) {
				StateUtils.tweenState(vto, sId, tweenTime);
				_stateId = sId;
			}
		}		
		
		//////////////////////////////////////////////////////////////
		// GestureWorks
		//////////////////////////////////////////////////////////////			
		
		/**
		 * Virtual transform object
		 */
		public var vto:TouchContainer3D;
		
		
		//////////////////////////////////////////////////////////////
		// Display
		//////////////////////////////////////////////////////////////				
		
		/**
		 * Searches the child and adds to the list
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
		
	
	}

}