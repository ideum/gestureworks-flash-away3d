package com.gestureworks.cml.away3d.elements {
	import away3d.lights.LightBase;
	import com.gestureworks.cml.away3d.utils.StaticLightPickerMod;
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
	 * This class creates a LightPicker. It extends the Away3D StaticLightPickerMod class to add CML support.
	 */
	public class LightPicker extends com.gestureworks.cml.away3d.utils.StaticLightPickerMod implements IObject, ICSS  {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// ICSS
		private var _className:String;			
		
		// 3D
		private var _lref:XML;

		/**
		 * @inheritDoc
		 */	
		public function LightPicker(lights:Array=null) {
			super(lights);
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;				
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function init():void {
			var larray:Array = [];
			var lightp:Array = [];
			var reg:RegExp = /[\s\r\n]*/gim;
			
			if (lref) {
				larray = String(lref).split(",");
			}
			
			for each(var l:String in larray) {
				l = l.replace(reg, '');	
				
				if (l.charAt(0) == "#") {
					l = l.substr(1);
				}
				
				var light:LightBase = document.getElementById(l);
				lightp.push(light);		
			}
			
			lights = lightp;	
		}			
		
		//////////////////////////////////////////////////////////////
		// ICML
		//////////////////////////////////////////////////////////////	
		
		/**
		 * @inheritDoc
		 */
		public function parseCML(cml:XMLList):XMLList {
			if (cml.@lights != undefined) {
				cml.@lref = cml.@lights;
				delete cml.@lights;
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
		// 3D
		//////////////////////////////////////////////////////////////		
		
		public function get lref():XML { return _lref; }
		public function set lref(value:XML):void {
			_lref = value;
		}		
	}
}