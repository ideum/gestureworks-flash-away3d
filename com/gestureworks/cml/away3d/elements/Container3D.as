package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.away3d.utils.CML3DUtils;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
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
	public class Container3D extends ObjectContainer3D implements IContainer, ICSS, IState  {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;

		// ICSS
		private var _className:String;
		
		// IState
		private var _stateId:String;	
		
		/**
		 * Virtual transform object.
		 */
		public var vto:TouchContainer3D;			
		
		/**
		 * @inheritDoc
		 */
		public function Container3D () {
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
			
			
			
		}
		
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
				if (childList[i] is ObjectContainer3D)				
					addChild(childList[i]);
				else if (childList[i] is Light) {
					addChild(childList[i].childList[0]);
				}
				if (n != childList.length)
					i--;
			}
		}			
		
		//////////////////////////////////////////////////////////////
		// 3D
		//////////////////////////////////////////////////////////////			
		

	}
}