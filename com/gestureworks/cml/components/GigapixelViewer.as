package com.gestureworks.cml.components
{
	import com.gestureworks.cml.element.*;
	import com.gestureworks.cml.events.*;
	import com.gestureworks.cml.kits.*;
	import com.gestureworks.core.*;
	import flash.display.*;
	import flash.events.*;
	import org.openzoom.flash.components.*;
	import org.openzoom.flash.viewport.constraints.*;
	import org.tuio.*;
	
	/**
	 * The GigapixelViewer component is primarily meant to display a Gigapixel element and its associated meta-data.
	 * 
	 * <p>It is composed of the following: 
	 * <ul>
	 * 	<li>gigapixel</li>
	 * 	<li>front</li>
	 * 	<li>back</li>
	 * 	<li>menu</li>
	 * 	<li>frame</li>
	 * 	<li>background</li>
	 * </ul></p>
	 * 
	 * <p>The width and height of the component are automatically set to the dimensions of the Gigapixel element unless it is 
	 * previously specifed by the component.</p>
	 * 
	 * <p>Multiple windows can independently display individual images with different sizes and orientations. The Gigapixel elements are 
	 * already touch enabled and should not be placed in touchContainers. The image windows can be interactively moved around stage, scaled 
	 * and rotated using multitouch gestures additionaly the image can be panned and zoomed using multitouch gesture inside the image 
	 * window.</p>
	 * 
	 * <codeblock xml:space="preserve" class="+ topic/pre pr-d/codeblock ">
	  

			
	 * </codeblock>
	 * 
	 * @author Josh
	 * @see Component
	 * @see com.gestureworks.cml.element.Gigapixel
	 * @see com.gestureworks.cml.element.TouchContainer
	 */
	public class GigapixelViewer extends Component
	{
		private var info:*;

		//------ image settings ------//
		private var _clickZoomInFactor:Number = 1.7
		private var _scaleZoomFactor:Number = 1.4
    	public var smoothPanning:Boolean = true;
    	private var sceneNavigator:SceneNavigator;
    	private var scaleConstraint:ScaleConstraint;
	
		/**
		 * gigaPixelViewer Constructor
		 */
	  	public function GigapixelViewer()
		{
			super();
		}
		
		private var _gigapixel:*;
		/**
		 * Sets the gigapixel element.
		 * This can be set using a simple CSS selector (id or class) or directly to a display object.
		 * Regardless of how this set, a corresponding display object is always returned. 
		 */		
		public function get gigapixel():* {return _gigapixel}
		public function set gigapixel(value:*):void 
		{
			if (!value) return;
			
			if (value is DisplayObject)
				_gigapixel = value;
			else 
				_gigapixel = searchChildren(value);					
		}
		
		private var _minScaleConstraint:Number = 0.001;
		public function get minScaleConstraint():Number { return _minScaleConstraint; }
		public function set minScaleConstraint(value:Number):void {
			if(!isNaN(value) && value >=0){
				_minScaleConstraint = value;
			}
		}
		
		/**
		 * Initialization function
		 */
		override public function init():void 
		{			
			// automatically try to find elements based on css class - this is the v2.0-v2.1 implementation
			if (!gigapixel)
				gigapixel = searchChildren(".gigapixel_element");
			if (!menu)
				menu = searchChildren(".menu_container");
			if (!frame)
				frame = searchChildren(".frame_element");
			if (!front)
				front = searchChildren(".gigapixel_container");
			if (!back)
				back = searchChildren(".info_container");				
			if (!background)
				background = searchChildren(".info_bg");	
			
			// automatically try to find elements based on AS3 class
			if (!gigapixel)
				gigapixel = searchChildren(Gigapixel);
				gigapixel.addEventListener(StateEvent.CHANGE, onStateEvent);
			
			super.init();
		}		
		
		override protected function updateLayout(event:* = null):void 
		{
			// update width and height to the size of the image, if not already specified
			if (!width && gigapixel)
				width = gigapixel.width;
			if (!height && gigapixel)
				height = gigapixel.height;
				
			super.updateLayout(event);
		}
		
		override protected function onStateEvent(event:StateEvent):void
		{	
			super.onStateEvent(event);
			
			if (event.value == "loaded") {
				height = gigapixel.height;
				width = gigapixel.width;
				gigapixel.removeEventListener(StateEvent.CHANGE, onStateEvent);
				
				updateLayout();
			}
		}
		
		/**
		 * Dispose method to nullify the attributes and remove listener
		 */
		override public function dispose():void
		{
			super.dispose();
			info = null;
			if (gigapixel)
			{
				gigapixel.removeEventListener(StateEvent.CHANGE, onStateEvent);
				gigapixel = null;
			}		
		}
	}
}