package com.gestureworks.cml.away3d.elements {
	import away3d.lights.DirectionalLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.utils.document;
	
	/**
	 * LightPicker is used to apply single or multiple Lights to a Material.
	 * The Material references the LightPicker id by the Materials lightPicker.
	 * A Material can only have one light picker assigned.
	 * LightPickers lightIDs reference the Lights id.
	 * Lights can be shared by LightPickers and placed anywhere in the display list.
	 *
	 */
	public class LightPicker extends Container3D {
		
		private var _slp:StaticLightPicker;
		private var _lights:Vector.<Light> = new Vector.<Light>();
		private var lightPickerLightsArr:Array = [];
		private var _shadowLight:DirectionalLight;
		
		public function LightPicker() {
			super();
		}
		
		/**
		 * Initialisation method
		*/ 
		override public function init():void {			
			
			for each(var light:Light in lights){
				if (light.castsShadows && light.type == Light.DIRECTIONAL )
					shadowLight = DirectionalLight(light.light);				
				lightPickerLightsArr.push(light.light);
			}
			
			_slp = new StaticLightPicker(lightPickerLightsArr);
		}
		
		public function get slp():StaticLightPicker { return _slp; }	
		public function set slp(value:StaticLightPicker):void {
			_slp = value;
		}
		
		public function get lights():Vector.<Light> { return _lights; }
		public function set lights(value:*):void {
			if (value is XML) {
				var reg:RegExp = /[\s\r\n]*/gim;
				value = value.replace(reg, '');				
				for each(var id:String in String(value).split(","))
					_lights.push(document.getElementById(id));
			}
		}
		
		public function get shadowLight():DirectionalLight { return _shadowLight; }		
		public function set shadowLight(value:DirectionalLight):void {
			_shadowLight = value;
		}
		
		/**
		 * Custom CML parse routine to add local Light 
		 * @param	cml
		 * @return
		 */
		override public function parseCML(cml:XMLList):XMLList {
			var node:XML = XML(cml);
			var obj:Object;
			
			for each(var item:XML in node.*) {
				
				if (item.name() == "Light") {					
					obj = CMLParser.instance.createObject(item.name());
					CMLParser.instance.attrLoop(obj, XMLList(item)); 
					obj.updateProperties();
					obj.init();
					delete cml[item.name()];
					lights.push(obj);
				}					
			}
			
			CMLParser.instance.parseCML(this, cml);
			return cml.*;
		}		
	
	}

}