package com.gestureworks.cml.elements
{
	import com.gestureworks.cml.events.StateEvent;
	import flash.events.*;
	import flash.geom.*;
	import org.openzoom.flash.components.MultiScaleImage;
	import org.openzoom.flash.components.SceneNavigator;
	import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
	import org.openzoom.flash.viewport.constraints.CenterConstraint;
	import org.openzoom.flash.viewport.constraints.CompositeConstraint;
	import org.openzoom.flash.viewport.constraints.FillConstraint;
	import org.openzoom.flash.viewport.constraints.ScaleConstraint;
	import org.openzoom.flash.viewport.constraints.VisibilityConstraint;
	import org.openzoom.flash.viewport.constraints.ZoomConstraint;
	import org.openzoom.flash.viewport.controllers.TouchController;
	import org.openzoom.flash.viewport.transformers.TweenerTransformer;
	 
	/**
	 * The Gigapixel element loads a gigapixel image. Gigapixel images are 
	 * extremely high resolution images that can be navigated made by tiling smaller 
	 * images in a seamless, pyramid structured fashion. It has following 
	 * parameters:minScaleConstraint, src, loaded, image,smoothPanning. 
	 * 
	 * <codeblock xml:space="preserve" class="+ topic/pre pr-d/codeblock ">
		
		var gpElement:Gigapixel = new Gigapixel();
		gpElement.src = "space.xml";
		gpElement.x = 500;
		gpElement.width = 600;
		gpElement.height = 600;
		gpElement.mouseChildren = true;
		addChild(gpElement);
		gpElement.init();
		
	 * </codeblock>
	 * 
	 * @author Josh
	 * @see Panoramic
	 */
	public class Gigapixel extends TouchContainer
	{
		private var _clickZoomInFactor:Number = 1.7
		private var _scaleZoomFactor:Number = 1.4
    	public var smoothPanning:Boolean = true;
		public var image:MultiScaleImage
    	private var sceneNavigator:SceneNavigator
    	private var scaleConstraint:ScaleConstraint;
		private var _hotspots:Array = [];
		
		/**
		 * Constructor
		 */
		public function Gigapixel()
		{
			super();
		}
		
		private var _toggleHotspots:Boolean = true;
		/**
		 * Set the visibility of hotspots.
		 */
		public function get toggleHotspots():Boolean { return _toggleHotspots; }
		public function set toggleHotspots(value:Boolean):void {
			_toggleHotspots = value;
			flipHotspots(_toggleHotspots);
		}
		
		private var _minScaleConstraint:Number = 0.001;
		/**
		 * sets the scaling
		 * @default = 0.001;
		 */
		public function get minScaleConstraint():Number { return _minScaleConstraint; }
		public function set minScaleConstraint(value:Number):void {
			_minScaleConstraint = value;
		}
		
		private var _visibilityRatio:Number = 0.6;
		/**
		 * Sets how much of the gigapixel must be seen. Setting it to 1 will ensure no border is ever seen within the viewer.
		 * @default 0.6
		 */
		public function get visibilityRatio():Number { return _visibilityRatio; }
		public function set visibilityRatio(value:Number):void {
			_visibilityRatio = value;
		}
		
		private var _srcXML:String = "";
		[Deprecated(replacement = "src")]
		/**
		 * Sets the src xml file
		 * @default 
		 */	
		public function get srcXML():String{return _srcXML;}
		public function set srcXML(value:String):void
		{			
			_srcXML = value;
			_src = value;
		}
		
		private var _src:String = "";
		/**
		 * Sets the src xml file
		 */		
		public function get src():String{return _srcXML;}
		public function set src(value:String):void
		{			
			_src = value;
		}

		private var _loaded:Boolean;
		/**
		 * Indicated whether the gigaPixel image is loaded
		 */
		public function get loaded():Boolean { return _loaded; }
		
		public function get sceneWidth():Number { return image.sceneWidth; }
		public function get sceneHeight():Number { return image.sceneHeight; }
		
		public function get viewportWidth():Number { return image.viewportWidth; }
		public function get viewportHeight():Number { return image.viewportHeight; }
		
		private var _viewportX:Number;
		public function get viewportX():Number { 
			if (image) return image.viewportX;
			else return _viewportX;
		}
		public function set viewportX(value:Number):void {
			_viewportX = value;
			if (image)
				panTo(value, image.viewportX);
		}
		
		private var _viewportY:Number;
		public function get viewportY():Number { 
			if (image) return image.viewportY;
			else return _viewportY;
		}
		public function set viewportY(value:Number):void {
			_viewportY = value;
			if (image)
				panTo(image.viewportY, value);
		}
		
		private var _zoom:Number;
		public function get zoom():Number {
			if (image) return image.zoom;
			else return _zoom;
		}
		public function set zoom(value:Number):void {
			_zoom = value;
			if (image)
				image.zoomTo(_zoom);
		}
		
		public function get hotspots():Array { return _hotspots; }
		public function set hotspots(value:Array):void {
			_hotspots = value;
		}
		
		public function localToScene(p:Point):Point {
			return image.localToScene(p);
		}
		
		private function onEnterFrame(e:Event):void {
			for (var i:Number = 0; i < _hotspots.length; i++) {
				if (!(contains(_hotspots[i])))
					addChild(_hotspots[i]);
				var point:Point = image.sceneToLocal(new Point(_hotspots[i].sceneX, _hotspots[i].sceneY));
				_hotspots[i].x = point.x;
				_hotspots[i].y = point.y;
			}
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void
		{ 
						while (this.numChildren > 0) {
				if (this.getChildAt(0) is Hotspot) {
					_hotspots.push(this.getChildAt(0));
				}
				removeChildAt(0);
			}
			
			/*if (image)
				image.dispose();*/
			
			
			image = new MultiScaleImage();
			image.mouseChildren = true;
			if (!image.hasEventListener(Event.COMPLETE))
				image.addEventListener(Event.COMPLETE, image_completeHandler)
			
			// Add transformer for smooth zooming
			var transformer:TweenerTransformer = new TweenerTransformer()
			transformer.easing = "EaseOut";
			transformer.duration = 1 // seconds
			
			image.transformer = transformer;
			image.controllers = [new TouchController()]
	
			var constraint:CompositeConstraint = new CompositeConstraint()
			var zoomConstraint:ZoomConstraint = new ZoomConstraint()
			zoomConstraint.minZoom = 0.1;
			
			scaleConstraint = new ScaleConstraint()
			scaleConstraint.minScale = _minScaleConstraint;
				
			var centerConstraint:CenterConstraint = new CenterConstraint()
			var visibilityConstraint:VisibilityConstraint = new VisibilityConstraint()
			visibilityConstraint.visibilityRatio = _visibilityRatio;
			constraint.constraints = [zoomConstraint, scaleConstraint, centerConstraint, visibilityConstraint];
	
			image.constraint = constraint;
			image.source = _src;
			
			if (width != 0 && height == 0) {
				var aspectW:Number = image.sceneHeight / image.sceneWidth;
				height = aspectW * width;
			} else if (height !=0 && width == 0) {
				var aspectH:Number = image.sceneWidth / image.sceneHeight;
				width = height * aspectH;
			}
			
			image.width = width;
			image.height = height;
			
			addChild(image);
			
			for (var i:Number = 0; i < _hotspots.length; i++) {
				if (!(contains(_hotspots[i])))
					addChild(_hotspots[i]);
				var point:Point = image.sceneToLocal(new Point(_hotspots[i].sceneX, _hotspots[i].sceneY));
				_hotspots[i].x = point.x;
				_hotspots[i].y = point.y;
			}
			
			if (_hotspots.length > 0 && !hasEventListener(Event.ENTER_FRAME)) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		
		private function image_completeHandler(event:Event):void
		{
			var descriptor:IMultiScaleImageDescriptor = image.source as IMultiScaleImageDescriptor;
			if (descriptor)
				scaleConstraint.maxScale = descriptor.width / image.sceneWidth;
			
			if (isNaN(_zoom)) {
				_zoom = image.zoom;
			}
			else zoom = _zoom;
			
			if (_viewportX && _viewportY) {
				panTo(_viewportX, _viewportY, true);
			}
			else if (_viewportX && !_viewportY)
				panTo(_viewportX, image.viewportY, true);
			else if (_viewportY && !_viewportX)
				panTo(image.viewportX, _viewportY, true);
				
			_loaded = true;
			dispatchEvent(new StateEvent(StateEvent.CHANGE, this.id, "loaded", loaded));
		}
		
		private function flipHotspots(onOff:Boolean):void {
			
			for (var i:int = 0; i < _hotspots.length; i++) 
			{
				_hotspots[i].visible = onOff;
			}
		}
		
		public function panTo(x:Number, y:Number, immediately:Boolean = false):void {
			image.panTo(x, y, immediately);
		}
		
		/**
		 * Dispose method and remove listener
		 */
		override public function dispose():void
		{
			scaleConstraint = null;
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			while (this.numChildren > 0){
				this.removeChildAt(0);
			}
			
			if (image)
			{
				image.removeEventListener(Event.COMPLETE, image_completeHandler);
				//image.dispose();
				image = null;
			}	
			
			super.dispose();
		}
	}
}