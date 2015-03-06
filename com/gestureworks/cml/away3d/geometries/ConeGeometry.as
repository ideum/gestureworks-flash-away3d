package com.gestureworks.cml.away3d.geometries {
	import away3d.primitives.ConeGeometry;
	import com.gestureworks.cml.away3d.interfaces.IGeometry;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.utils.Dictionary;
	
	/**
	 * This class creates cone geometry that can be applied to a Mesh. It extends the Away3D ConeGeometry class to add CML support.
	 */
	public class ConeGeometry extends away3d.primitives.ConeGeometry implements IObject, ICSS, IState, IGeometry  {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// IState
		private var _stateId:String;	
		
		public function ConeGeometry(radius:Number = 50, height:Number = 100, segmentsW:uint = 16, segmentsH:uint = 15, yUp:Boolean = true) {
			super(radius, height, segmentsW, segmentsH, yUp);
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
		public function init():void {}
		
		/**
		 * Custom CML parse routine
		 * @param	cml
		 * @return
		 */
		public function parseCML(cml:XMLList):XMLList {
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
		 * Sets the state id
		 */
		public function get stateId():* { return _stateId; }
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
		}		
		
		/**
		 * Tween state by stateIndex from current to given state index. If the first parameter is null, the current state will be used.
		 * @param sIndex State index to tween.
		 * @param tweenTime Duration of tween
		 */
		public function tweenState(sId:*=null, tweenTime:Number = 1, onComplete:Function=null):void {
			if (StateUtils.tweenState(this, sId, tweenTime)) {
				_stateId = sId;
			}
		}		
		
	}
}