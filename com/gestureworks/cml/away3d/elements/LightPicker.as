package com.gestureworks.cml.element.away3d {
	import away3d.lights.DirectionalLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.element.Element;
	
	/**
	 * LightPicker is used to apply single or multiple Lights to a Material.
	 * The Material references the LightPicker id by the Materials lightPickerRef.
	 * A Material can only have one light picker assigned.
	 * LightPickers lightIDs reference the Lights id.
	 * Lights can be shared by LightPickers and placed anywhere in the display list.
	 *
	 */
	public class LightPicker extends Element {
		
		private var _slp:StaticLightPicker;
		private var _lightIDs:String;
		private var lightPickerLightsArr:Array = [];
		private var _shadowLight:DirectionalLight;
		
		public function LightPicker() {
			super();
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void {
			displayComplete();
		}
		
		/**
		 * CML callback Initialisation
		 */
		override public function displayComplete():void {
			
			var lightClass:Light;
			var lightID:String;
			
			for each (lightID in this._lightIDs.split(",")) {
				lightClass = CMLObjectList.instance.getId(lightID);
				if (!lightClass)
					throw Error("Light with id = \"" + lightID + "\" not found in cml.");
				
				if (lightClass.light == null)
					Light.createLight(lightClass);
					
				if (lightClass.castsShadows && lightClass.type == Light.DIRECTIONAL )
					shadowLight = DirectionalLight(CMLObjectList.instance.getId(lightClass.id).light);
				
				lightPickerLightsArr.push(CMLObjectList.instance.getId(lightClass.id).light);
				//lightPickerLightsArr.push(lightClass.light);
			}
			
			_slp = new StaticLightPicker(lightPickerLightsArr);
		}
		
		public function get slp():StaticLightPicker {
			return _slp;
		}
		
		public function set slp(value:StaticLightPicker):void {
			_slp = value;
		}
		
		public function get lightIDs():String {
			return _lightIDs;
		}
		
		public function set lightIDs(value:String):void {
			var reg:RegExp = /[\s\r\n]*/gim;
			value = value.replace(reg, '');
			_lightIDs = value;
		}
		
		public function get shadowLight():DirectionalLight 
		{
			return _shadowLight;
		}
		
		public function set shadowLight(value:DirectionalLight):void 
		{
			_shadowLight = value;
		}
	
	}

}