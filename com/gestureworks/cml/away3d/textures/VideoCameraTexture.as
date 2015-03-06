package com.gestureworks.cml.away3d.textures {
	import away3d.textures.WebcamTexture;
	import com.gestureworks.cml.away3d.interfaces.ITexture;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.media.Camera;
	import flash.utils.Dictionary;
	
	/**
	 * This class creates a video texture that can be applied to a Material. It extends the Away3D VideoTexture class to add CML support.
	 */
	public class VideoCameraTexture extends away3d.textures.WebcamTexture implements IObject, ICSS, IState, ITexture {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// ICSS
		private var _className:String;			
		
		// IState
		private var _stateId:String;
		
		// 3D
		private var _src:String;
		
		/**
		 * @inheritDoc
		 */	
		public function VideoCameraTexture(cameraWidth:uint = 320, cameraHeight:uint = 240, materialSize:uint = 256, autoStart:Boolean = true, camera:Camera = null, smoothing:Boolean = true) {
			super(cameraWidth, cameraHeight, materialSize, autoStart, camera, smoothing);
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;				
		}
		
		/**
		 * @inheritDoc
		 */
		public function init():void {}			
		
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
		 * Sets file source
		 * @param value File path
		 */
		public function get src():String { return _src;}
		public function set src(value:String):void {
			_src = value;
		}		
		
	}
}