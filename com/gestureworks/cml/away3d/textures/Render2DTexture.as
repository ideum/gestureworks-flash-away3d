package com.gestureworks.cml.away3d.textures {
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.TextureUtils;
	import com.gestureworks.cml.away3d.interfaces.ITexture;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	/**
	 * This class creates a bitmap texture that can be applied to a Material. It extends the Away3D BitmapTexture class to add CML support.
	 */
	public class Render2DTexture extends away3d.textures.BitmapTexture implements IObject, ICSS, IState, ITexture {
		
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
		public function Render2DTexture(bitmapData:BitmapData=null, generateMipmaps:Boolean = true) {
			super(bitmapData, generateMipmaps);
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;				
		}
		
		/**
		 * @inheritDoc
		 */
		public function init():void {			
			var b:Bitmap;
			
			for each (var child:* in childList) {
				if (child is DisplayObjectContainer) {
					var max:Number = TextureUtils.getBestPowerOf2(Math.max(child.width, child.height));
					child.width = max;
					child.height = max;
					b = DisplayUtils.toBitmap(child, true);
					break;
				}
			}
			
			if (b) { 
				bitmapData = b.bitmapData;
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