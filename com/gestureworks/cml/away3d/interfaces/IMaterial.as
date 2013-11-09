package com.gestureworks.cml.away3d.interfaces {
	import away3d.materials.lightpickers.LightPickerBase;
	
	/**
	 * Implements Material objects.
	 * @author Ideum
	 */	
	public interface IMaterial {
		
		/**
		 * Returns asssets type.
		 */
		function get assetType():String;

		/**
		 * The light picker used by the material to provide lights to the material if it supports lighting.
		 * @see away3d.materials.lightpickers.LightPickerBase
		 * @see away3d.materials.lightpickers.StaticLightPicker
		 */
		function get lightPicker():LightPickerBase;		
		function set lightPicker(value:LightPickerBase):void;
		
		/**
		 * Indicates whether or not any used textures should use mipmapping. Defaults to true.
		 */
		function get mipmap():Boolean;
		function set mipmap(value:Boolean):void;

		/**
		 * Indicates whether or not any used textures should use smoothing.
		 */
		function get smooth():Boolean;
		function set smooth(value:Boolean):void;
		
		/**
		 * Indicates whether or not any used textures should be tiled. If set to false, texture samples are clamped to
		 * the texture's borders when the uv coordinates are outside the [0, 1] interval.
		 */
		function get repeat():Boolean;
		function set repeat(value:Boolean):void;
		
		/**
		 * Defines whether or not the material should cull triangles facing away from the camera.
		 */
		function get bothSides():Boolean;
		function set bothSides(value:Boolean):void;

		/**
		 * Updates light picker
		 */
		function updateLightPicker():void;
		
		/**
		 * Cleans up resources owned by the material, including passes. Textures are not owned by the material since they
		 * could be used by other materials and will not be disposed.
		 */
		function dispose():void;		
		
	}	
}