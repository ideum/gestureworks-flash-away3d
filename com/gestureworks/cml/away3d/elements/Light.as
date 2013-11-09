package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.NearShadowMapMethod;
	import com.gestureworks.cml.away3d.interfaces.IMaterial;
	import com.gestureworks.cml.core.CMLObjectList;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 */
	public class Light extends TouchContainer3D {
		public static const DIRECTIONAL:String = "directional";
		public static const POINT:String = "point";
		private var _lightPicker:String;
		private var _type:String;
		private var _fallOff:Number = 100000;
		private var _radius:Number = 90000;
		private var _ambient:Number = 0;
		private var _ambientColor:uint = 0xffffff;
		private var _diffuse:Number = 1;
		private var _diffuseColor:uint = 0xffffff;
		private var _direction:String = "0,-1,1";
		private var _light:LightBase;
		private var _shadowMethod:NearShadowMapMethod;
		private var _castsShadows:Boolean = false;
		
		public function Light() {
			super();
		
		}
		
		/**
		 * Initialisation method
		*/ 
		override public function init():void {
			
			if (_light) {
				_light.ambient = _ambient;
				_light.ambientColor = _ambientColor;
				_light.diffuse = _diffuse;
				_light.color = _diffuseColor;
				_light.castsShadows = _castsShadows;
				
				if (_type == POINT) {
					PointLight(_light).radius = _radius;
					PointLight(_light).fallOff = _fallOff;
				}
				
				if (this.parent is TouchContainer3D)
					TouchContainer3D(this.parent).addChild3D(_light);
				
				light.x = this.x;
				light.y = this.y;
				light.z = this.z;
				light.pivotPoint = new Vector3D(this.pivot.split(",")[0], this.pivot.split(",")[1], this.pivot.split(",")[2]);
				light.rotationX += this.rotationX;
				light.rotationY += this.rotationY;
				light.rotationZ += this.rotationZ;
				if (this.lookat) //overides any rotation above
					light.lookAt(new Vector3D(this.lookat.split(",")[0], this.lookat.split(",")[1], this.lookat.split(",")[2]));
				//light.scaleX = this.scaleX;
				//light.scaleY = this.scaleY;
				//light.scaleZ = this.scaleZ;
				
				//need to update any materials previously set
				for each (var m:IMaterial in CMLObjectList.instance.getClass(IMaterial))
					if (m && m.lightPicker == null)
						m.updateLightPicker();
			}
		
		}
		
		public function get type():String { return _type; }		
		public function set type(value:String):void {
			_type = value;			
			if (_type == POINT)
				light = new PointLight();
			
			else if (type == DIRECTIONAL)
				light = new DirectionalLight(direction.split(",")[0], direction.split(",")[1], direction.split(",")[2]);
			
			if(light)
				light.name = id;			
		}
		
		public function get direction():String { return _direction; }		
		public function set direction(value:String):void {
			_direction = value;
		}
		
		public function get ambient():Number { return _ambient; }		
		public function set ambient(value:Number):void {
			_ambient = value;
		}
		
		public function get ambientColor():uint { return _ambientColor; }		
		public function set ambientColor(value:uint):void {
			_ambientColor = value;
		}
		
		public function get diffuse():Number { return _diffuse; }		
		public function set diffuse(value:Number):void {
			_diffuse = value;
		}
		
		public function get diffuseColor():uint { return _diffuseColor; }		
		public function set diffuseColor(value:uint):void {
			_diffuseColor = value;
		}
		
		public function get light():LightBase { return _light; }		
		public function set light(value:LightBase):void {
			_light = value;
		}
		
		public function get fallOff():Number { return _fallOff; }		
		public function set fallOff(value:Number):void {
			_fallOff = value;
		}
		
		public function get radius():Number { return _radius; }		
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		public function get shadowMethod():NearShadowMapMethod { return _shadowMethod; }		
		public function set shadowMethod(value:NearShadowMapMethod):void {
			_shadowMethod = value;
		}
		
		public function get castsShadows():Boolean { return _castsShadows; }		
		public function set castsShadows(value:Boolean):void {
				_castsShadows = value;
		}
		
		public function get lightPicker():String { return _lightPicker; }		
		public function set lightPicker(value:String):void {
			_lightPicker = value;
		}
		
		override public function addChild3D(child:ObjectContainer3D):void {
			light.addChild(child);
		}
	
	}

}