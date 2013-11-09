package com.gestureworks.cml.away3d.geometries {
	import away3d.primitives.CubeGeometry;
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
	 * This class creates cube geometry that can be applied to a Mesh. It extends the Away3D CubeGeometry class to add CML support.
	 */
	public class CubeGeometry extends away3d.primitives.CubeGeometry implements IObject, ICSS, IState, IGeometry  {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// ICSS
		private var _className:String;		
		
		// IState
		private var _stateId:String;	
		
		/**
		 * @inheritDoc
		 */		
		public function CubeGeometry(width:Number = 100, height:Number = 100, depth:Number = 100, segmentsW:uint = 1, segmentsH:uint = 1, segmentsD:uint = 1, tile6:Boolean = true) {
			super(width, height, depth, segmentsW, segmentsH, segmentsD, tile6);
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
		public function init():void {}		
		
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
		
	}
}