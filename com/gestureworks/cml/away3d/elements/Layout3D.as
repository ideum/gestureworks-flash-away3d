package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import com.gestureworks.away3d.utils.LayoutTransforms;
	import com.gestureworks.cml.away3d.interfaces.ILayout3D;
	import com.gestureworks.cml.core.CMLObject;
	import com.greensock.easing.Ease;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getDefinitionByName;
	import nodes.CategoryNode;

	/**
	 * Loads Layout3D instances in CML through the ref attribute 
	 * and serves as the abstract class for all 3D layouts.
	 */
	public class Layout3D extends CMLObject implements ILayout3D {
		
		public var name:String;
		public var children:Array;		
				
		private var _tween:Boolean = true;
		private var _tweenTime:Number = 500;
		private var _autoplay:Boolean = true;
		private var _easing:Ease;
		private var _onComplete:Function;
		private var _onCompleteParams:Array;
		private var _onUpdate:Function;		
		private var _onUpdateParams:Array;
		private var _continuousTransform:Boolean = false;
		
		protected var m:Matrix3D;
		protected var childTransforms:Vector.<LayoutTransforms>;
		protected var childTweens:Array;	
		protected var _layoutTween:TimelineLite;

		
		/**
		 * Constructor
		 */
		public function Layout3D() {
			super();
			childTransforms = new Vector.<LayoutTransforms>;
			m = new Matrix3D;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parseCML(cml:XMLList):XMLList {		
			var rXML:XMLList = new XMLList;
			if (cml.@ref != undefined) {
				var ref:String = String(cml.@ref);
				var cp:XMLList = cml.copy();
				cp.setName(ref);				
				delete cp.@ref;
				rXML = cp;
			}			
			return rXML;
		}	
		
		/**
		 * TODO: Move to utility class
		 * @param	types Specific object types to include
		 */
		public static function getChildren(container:ObjectContainer3D, types:Array = null):Array {
			var children:Array = [];
			var child:Object3D;
			var instance:*;
			for (var i:int = 0; i < container.numChildren; i++) {
				child = container.getChildAt(i);
				if (!types) {
					children.push(child);
				}			
				else {
					for each(var type:Class in types) {
						if (child is type) {
							children.push(child);
						}
					}
				}
			}
			return children; 
		}
					
		public function layout(container:ObjectContainer3D):void {
			var i:int;
			var child:Object3D;
			var t:LayoutTransforms;
			
			var node:CategoryNode = null;
			if (container is CategoryNode) {
				node = container as CategoryNode;
			}
			
			if (!children)
				children = getChildren(container);
			
			if (tween) {
								
				if (_layoutTween && _layoutTween._active) {
					_layoutTween.eventCallback("onUpdate", onUpdate, onUpdateParams);
					_layoutTween.eventCallback("onComplete", onComplete, onCompleteParams);
					return;
				}
				
				childTweens = [];
				
				var tx:Number;
				var ty:Number;
				var tz:Number;
				
				var rx:Number;
				var ry:Number;
				var rz:Number;
				
				var sx:Number;
				var sy:Number;
				var sz:Number;
				
				for (i=0; i < children.length; i++){
					child = Object3D(children[i]);
					t = LayoutTransforms(childTransforms[i]);
					tx = t.pos.x;
					ty = t.pos.y;
					tz = t.pos.z;
					
					rx = t.rot.x;
					ry = t.rot.y;
					rz = t.rot.z;
					
					sx = t.sca.x;
					sy = t.sca.y;
					sz = t.sca.z;					
					
					if (_continuousTransform) {
						tx += child.x;
						ty += child.y;
						tz += child.z;
						
						rx += child.rotationX;
						ry += child.rotationY;
						rz += child.rotationZ;
						
						sx *= child.scaleX;
						sy *= child.scaleY;
						sz *= child.scaleZ;
					}
					
					if(node != null) {
						node.setChildPosition(child, t.pos);
					}
					
					// position
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { x:tx, ease:easing } ));
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { y:ty, ease:easing } ));
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { z:tz, ease:easing } ));	
					
					// rotation
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { rotationX:rx, ease:easing } ));
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { rotationY:ry, ease:easing } ));
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { rotationZ:rz, ease:easing } ));	
					
					// scale
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { scaleX:sx, ease:easing } ));
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { scaleY:sy, ease:easing } ));
					childTweens.push(TweenLite.to(child, tweenTime / 1000, { scaleZ:sz, ease:easing } ));						
				}	
				
				if (_layoutTween) {
					_layoutTween.clear();
					_layoutTween.vars.onComplete = onComplete;
					_layoutTween.vars.onCompleteParams = onCompleteParams;
					_layoutTween.vars.onUpdate = onUpdateParams;
					_layoutTween.vars.onUpdateParams = onUpdateParams;					
				}
				else {
					_layoutTween = new TimelineLite( { onComplete:onComplete, onCompleteParams:onCompleteParams, onUpdate:onUpdate, onUpdateParams:onUpdateParams } );
				}
				_layoutTween.gotoAndStop(0);	
				_layoutTween.appendMultiple(childTweens);
				
				if (_autoplay) {
					_layoutTween.play();
				}
			}
			else {
				for (i = 0; i < children.length; i++) {
					child = Object3D(children[i]);
					
					if (_continuousTransform) {
						m = child.transform;
					}
					else {
						m.identity();
					}
					
					t = LayoutTransforms(childTransforms[i]);	
					
					if(node != null) {
						node.setChildPosition(child, t.pos);
					}
					
					m.appendTranslation(t.pos.x, t.pos.y, t.pos.z);	
					m.appendRotation(t.rot.x, Vector3D.X_AXIS);
					m.appendRotation(t.rot.y, Vector3D.Y_AXIS);
					m.appendRotation(t.rot.z, Vector3D.Z_AXIS);								
					m.appendScale(t.sca.x, t.sca.y, t.sca.z); 	
					
					child.transform = m;
				}
			}
		}
		
		/**
		 * Kills the tweening of the provided child. If a child is not provided, the group tween is killed.
		 * @param	child  
		 */
		public function killTween(child:*=null):void {
			if (layoutTween) {
				if(!child)
					layoutTween.kill();
				else
					layoutTween.kill(null, child);
			}
		}		
		
		
		/**
		 * Flag indicating the display objects will animate to their layout positions. If false,
		 * the objects will be positioned at initialization.
		 * @default true
		 */
		public function get tween():Boolean { return _tween; }
		public function set tween(t:Boolean):void
		{
			_tween = t;
		}		
		
		/**
		 * The time(ms) the display objects will take to move into positions.
		 * @default 500
		 */
		public function get tweenTime():Number { return _tweenTime; }
		public function set tweenTime(t:Number):void
		{
			_tweenTime = t;
		}

		/**
		 * Specifies the easing equation. Argument must be an Ease instance or a String defining the Ease class
		 * either by property syntax or class name (e.g. Expo.easeOut or ExpoOut). 
		 */
		public function get easing():* { return _easing; }
		public function set easing(e:*):void
		{
			if (!(e is Ease))
			{   
				var value:String = e.toString();				
				if (value.indexOf(".ease") != -1)
					value = value.replace(".ease", "");
				
				var easingType:Class = getDefinitionByName("com.greensock.easing." + value) as Class;
				e = new easingType();
			}
			if (e is Ease)
				_easing = e;
		}		
		
		/**
		 * Function to call on layout complete.
		 */
		public function get onComplete():Function { return _onComplete; }
		public function set onComplete(f:Function):void
		{
			_onComplete = f;
		}
		
		/**
		 * Parameters to pass to the onComplete function.
		 */
		public function get onCompleteParams():Array { return _onCompleteParams; }
		public function set onCompleteParams(params:Array):void {
			_onCompleteParams = params;
		}
		
		/**
		 * Function to call on layout update.
		 */
		public function get onUpdate():Function { return _onUpdate; }
		public function set onUpdate(f:Function):void
		{
			_onUpdate = f;
		}	
		
		/**
		 * Parameters to pass to the onUpdate function.
		 */
		public function get onUpdateParams():Array { return _onUpdateParams; }
		public function set onUpdateParams(params:Array):void {
			_onUpdateParams = params;
		}		
		
		/**
		 * Read-only accessor to layout tweener.
		 */
		public function get layoutTween():TimelineLite {
			return _layoutTween;
		}
		
		/**
		 * Automatically tweens when layout method is called. If false you
		 * call play() on the layoutTween property.
		 */
		public function get autoplay():Boolean {
			return _autoplay;
		}
		public function set autoplay(value:Boolean):void {
			_autoplay = value;
		}
	
		/**
		 * Flag indicating the application of a transform relative to the current transform. If this flag is turned off, the transformation is 
		 * reset with the principle layout attributes. (e.g. Given an object with a rotation of 45 degrees, applying a rotation of 10 in continuous mode
		 * will set the object's rotation to 55. In non-continuous mode, applying a rotation of 10 degrees will set the object's rotation to 10).
		 * @default true;
		 */
		public function get continuousTransform():Boolean { return _continuousTransform; }
		public function set continuousTransform(c:Boolean):void
		{
			_continuousTransform = c;
		}		
	}
}