package com.gestureworks.cml.components
{
	import com.gestureworks.cml.elements.*;
	import com.gestureworks.cml.elements.Panoramic;
	import com.gestureworks.cml.events.*;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.geom.*;
	
	/**
	 * The PanoramicViewer component is primarily meant to display a Panoramic element and its associated meta-data.
	 * 
	 * <p>It is composed of the following: 
	 * <ul>
	 * 	<li>panoramic</li>
	 * 	<li>front</li>
	 * 	<li>back</li>
	 * 	<li>menu</li>
	 * 	<li>frame</li>
	 * 	<li>background</li>
	 * </ul></p>
	 *  
	 * <p>The width and height of the component are automatically set to the dimensions of the Panoramic element unless it is 
	 * previously specifed by the component.</p>
	 * 
	 * <codeblock xml:space="preserve" class="+ topic/pre pr-d/codeblock ">
	  

			
	 * </codeblock>
	 * 
	 * @author Josh
	 * @see Component
	 * @see com.gestureworks.cml.elements.Panoramic
	 * @see com.gestureworks.cml.elements.TouchContainer
	 */		 
	public class PanoramicViewer extends Component
	{	
		/**
		 * Constructor
		 */
		public function PanoramicViewer()
		{
			super();
		}

		private var _panoramic:*;
		/**
		 * Sets the panoramic element.
		 * This can be set using a simple CSS selector (id or class) or directly to a display object.
		 * Regardless of how this set, a corresponding display object is always returned. 
		 */		
		public function get panoramic():* {return _panoramic}
		public function set panoramic(value:*):void 
		{
			if (!value) return;
			
			if (value is DisplayObject)
				_panoramic = value;
			else 
				_panoramic = searchChildren(value);					
		}			
		
		/**
		 * Initialization function
		 */
		override public function init():void 
		{			
			// automatically try to find elements based on css class - this is the v2.0-v2.1 implementation
			if (!panoramic)
				panoramic = searchChildren(".panoramic_element");
			if (!menu)
				menu = searchChildren(".menu_container");
			if (!frame)
				frame = searchChildren(".frame_element");
			if (!front)
				front = searchChildren(".image_container");
			if (!back)
				back = searchChildren(".info_container");				
			if (!background)
				background = searchChildren(".info_bg");	
			
			// automatically try to find elements based on AS3 class
			if (!panoramic)
				panoramic = searchChildren(Panoramic);
		
			super.init();
		}
		
		override protected function updateLayout(event:*=null):void 
		{
			// update width and height to the size of the video, if not already specified
			if (!width && panoramic)
				width = panoramic.width;
			if (!height && panoramic)
				height = panoramic.height;
				
			super.updateLayout();
		}
		
		/**
		 * Dispose method to nullify the attributes and remove listener
		 */
		override public function dispose():void {
			super.dispose();
			panoramic = null;					
		}
	}
}