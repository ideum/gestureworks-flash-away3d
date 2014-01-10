package com.gestureworks.cml.away3d.elements {
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.core.pick.PickingType;
	import away3d.utils.Cast;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.State;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.interfaces.ICSS;
	import com.gestureworks.cml.interfaces.IObject;
	import com.gestureworks.cml.interfaces.IState;
	import com.gestureworks.cml.utils.ChildList;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.utils.StateUtils;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 * This class creates capsule geometry that can be applied to a Mesh. It extends the Away3D CapsuleGeometry class to add CML support.
	 */
	public class Camera extends away3d.cameras.Camera3D implements IObject, ICSS, IState  {
		
		// IObject
		private var _cmlIndex:int;
		private var _childList:ChildList;
		
		// ICSS
		private var _className:String;			
		
		// IState
		private var _stateId:String;	
		
		// 3D
		private var _lensX:XML;
		
		private var _ortho:Boolean = false;
		private var _fov:Number = 60;
		private var _projectionHeight:Number = 500;
		private var _clipping:String = "20,3000";	 //"near,far"
		
		private var _view:View3D;
		private var _viewPos:String; //"x,y"
		private var _viewDim:String; //"w,h"
		private var _color:uint = 0x000000;
		
		/**
		 * Virtual transform object.
		 */
		public var vto:TouchContainer3D;		
		
		/**
		 * @inheritDoc
		 */	
		public function Camera(lens:LensBase = null) {
			super(lens);
			vto = TouchManager3D.registerTouchObject(this) as TouchContainer3D;			
			state = new Dictionary(false);
			state[0] = new State(false);
			_childList = new ChildList;				
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function init():void {
			
			// scene
			var scn:Scene = document.getElementsByTagName(Scene)[0];
			scene = scn.scene3D;
						
			// view
			view = new View3D(scene, this);		
			scene.dispatchEvent(new StateEvent(StateEvent.CHANGE, null, "addedToView", view));
			vto.view = view;
			view.touchPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
			
			if (viewDim) {
				view.width = viewDim.split(",")[0];
				view.height = viewDim.split(",")[1];
			}
			
			if (viewPos) {
				view.x = viewDim.split(",")[0];
				view.y = viewDim.split(",")[1];
			}
		
			view.background = Cast.bitmapTexture(new BitmapData(2, 2, false, _color));
			scn.addView(view);
				
			
			// lens
			if (lensX == "orthographic") {
				lens = new OrthographicLens(_projectionHeight);
			}
			else {
				lens = new PerspectiveLens(_fov);			
			}
			
			if (clipping) {
				lens.near = _clipping.split(",")[0];
				lens.far = clipping.split(",")[1];
			}
		}		
		
		//////////////////////////////////////////////////////////////
		// ICML
		//////////////////////////////////////////////////////////////	
		
		/**
		 * @inheritDoc
		 */
		public function parseCML(cml:XMLList):XMLList {
			
			if (cml.@lens != undefined) {
				cml.@lensX = cml.@lens;
				delete cml.@lens;
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
		 * Sets the camera's lens type (orthographic or prospective).
		 */		
		public function get lensX():XML { return _lensX; }
		public function set lensX(value:XML):void {
			_lensX = value;
		}
		
		/**
		 * Sets the field of view when lens is prospective. 
		 */
		public function get fov():Number { return _fov; }		
		public function set fov(value:Number):void { 
			_fov = value;
		}
		
		/**
		 * Sets the projections height when lens is orthogrphic. 
		 */		
		public function get projectionHeight():Number { return _projectionHeight; }		
		public function set projectionHeight(value:Number):void {
			_projectionHeight = value;
		}
		
		/**
		 * Sets the near and far clipping planes as comma sepeated list.
		 */
		public function get clipping():String { return _clipping; }
		public function set clipping(value:String):void { 
			_clipping = value;
		}
		
		/**
		 * Sets the background render color.
		 */
		public function get color():uint { return _color; }		
		public function set color(value:uint):void { 
			_color = value;
		}		

		/**
		 * Sets the camera's view.
		 */
		public function get view():View3D { return _view; }
		public function set view(value:View3D):void {
			_view = value;
		}

		/**
		 * Sets the view position as a comma seperated list.
		 */
		public function get viewPos():String { return _viewPos; }		
		public function set viewPos(value:String):void {
			_viewPos = value;
		}
		
		/**
		 * Sets the view dimensions as a comma seperated list.
		 */
		public function get viewDim():String { return _viewDim; }		
		public function set viewDim(value:String):void {
			_viewDim = value;
		}
		
	}
}