package com.gestureworks.cml.away3d.elements {
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.TextureUtils;
	import away3d.utils.Cast;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.element.Graphic;
	import com.gestureworks.cml.element.Image;
	import com.gestureworks.cml.element.Text;
	import com.gestureworks.cml.managers.FileManager;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 *
	 */
	public class Material extends Container3D {
		private var _src:String;
		private var _color:uint = 0xCCCCCC;
		private var _material:MaterialBase;
		private var _lightPickerRef:String;
		private var _mipmap:Boolean = true;
		private var _blendmode:String = "normal";
		private var _repeat:Boolean = false;
		private var _bothSides:Boolean = false;
		private var _bitmapData:BitmapData;
		private var _alphaBlending:Boolean;
		private var _alphaThreshold:Number;
		
		public function Material() {
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
			
			if (color) {
				material = new ColorMaterial(_color, alpha);
			}
			if (this._src) {
				var fileData:Loader = (FileManager.fileList.getKey(this.src)) as flash.display.Loader;
				_bitmapData = new BitmapData(fileData.width, fileData.height, true, 0x000000);
				_bitmapData.draw(fileData.content);
				this.material = new TextureMaterial(new BitmapTexture(_bitmapData, _mipmap));
				updateTM();
			}
			
			if (this.numChildren > 0 && this.getChildAt(0) is Image) {
				this.material = new TextureMaterial(Cast.bitmapTexture(this.getChildAt(0)));
				updateTM();
				this.removeChildAt(0);
			}
			
			//child Graphic or TEXT TAG
			if (this.numChildren > 0 && (this.getChildAt(0) is Graphic || this.getChildAt(0) is Text)) {
				var g:*
				var m:Matrix
				var maxX:Number = 0;
				var maxY:Number = 0;
				//get total size
				for (var i:uint = 0; i < this.numChildren; i++) {
					g = this.getChildAt(i);
					maxX = Math.max(g.x + g.width, maxX);
					maxY = Math.max(g.y + g.height, maxY);
				}
				
				var max:Number = TextureUtils.getBestPowerOf2(Math.max(maxX, maxY));
				_bitmapData = new BitmapData(max, max, true, 0x0);
				while (this.numChildren > 0) {
					g = this.getChildAt(0);
					m = new Matrix();
					m.tx = g.x;
					m.ty = g.y;
					_bitmapData.draw(g, m);
					this.removeChildAt(0);
				}
				this.material = new TextureMaterial(new BitmapTexture(_bitmapData, _mipmap));
				updateTM();
			}
			
			this.material.blendMode = _blendmode;
			this.material.repeat = _repeat;
			this.material.bothSides = _bothSides;
			
			if(_lightPickerRef && material.lightPicker ==null)
			updateLightPicker();
			
			if (this.parent is Mesh)
				Mesh(this.parent).material = material;
		}
		
		private function updateTM():void {
			TextureMaterial(material).alpha = alpha;
			TextureMaterial(material).alphaBlending = _alphaBlending;
			TextureMaterial(material).alphaThreshold = _alphaThreshold;
		}
		
		public function updateLightPicker():void {
			
			//trace("######### MATERIAL set the lightpicker")
			
			if (_lightPickerRef && material.lightPicker ==null)
			{
				if (CMLObjectList.instance.getId(this._lightPickerRef))
				{
					this.material.lightPicker = CMLObjectList.instance.getId(this._lightPickerRef).slp;
					
				}
				else
					throw new Error("id "+ _lightPickerRef+" LightPicker not found")
				
				
				if (material.lightPicker && DirectionalLight(CMLObjectList.instance.getId(this._lightPickerRef).shadowLight)) {
					//Could add other shadow types
					if (material is TextureMaterial)
						TextureMaterial(material).shadowMethod = new SoftShadowMapMethod(DirectionalLight(CMLObjectList.instance.getId(this._lightPickerRef).shadowLight));
					else
						ColorMaterial(material).shadowMethod = new SoftShadowMapMethod(DirectionalLight(CMLObjectList.instance.getId(this._lightPickerRef).shadowLight));
				}
			}
		}
		
		/**
		 * ColorMaterial color
		 * @default "0XCCCCCC"
		 */
		public function get color():uint {
			return uint(_color);
		}
		
		public function set color(value:uint):void {
			_color = uint(value);
		}
		
		/**
		 * Reference to the LightPicker to enable lights on this material.
		 */
		public function get lightPickerRef():String {
			return _lightPickerRef;
		}
		
		public function set lightPickerRef(value:String):void {
			_lightPickerRef = value;
		}
		
		/**
		 * Path to the image file
		 */
		public function get src():String {
			return _src;
		}
		
		public function set src(value:String):void {
			_src = value;
		}
		
		/**
		 * Indicates whether or not any used textures should use mipmapping.
		 */
		public function get mipmap():Boolean {
			return _mipmap;
		}
		
		public function set mipmap(value:Boolean):void {
			_mipmap = value;
		}
		
		/**
		 * The blend mode to use when drawing this renderable. The following blend modes are supported:
		 * <ul>
		 * <li>BlendMode.NORMAL: No blending, unless the material inherently needs it</li>
		 * <li>BlendMode.LAYER: Force blending. This will draw the object the same as NORMAL, but without writing depth writes.</li>
		 * <li>BlendMode.MULTIPLY</li>
		 * <li>BlendMode.ADD</li>
		 * <li>BlendMode.ALPHA</li>
		 * </ul>
		 */
		public function get blendmode():String {
			return _blendmode;
		}
		
		public function set blendmode(value:String):void {
			_blendmode = value;
		}
		
		/**
		 * Indicates whether or not any used textures should be tiled.
		 */
		public function get repeat():Boolean {
			return _repeat;
		}
		
		public function set repeat(value:Boolean):void {
			_repeat = value;
		}
		
		/**
		 * Defines whether or not the material should perform backface culling.
		 */
		public function get bothSides():Boolean {
			return _bothSides;
		}
		
		public function set bothSides(value:Boolean):void {
			_bothSides = value;
		}
		
		/**
		 * The minimum alpha value for which pixels should be drawn. This is used for transparency that is either
		 * invisible or entirely opaque, often used with textures for foliage, etc.
		 * Recommended values are 0 to disable alpha, or 0.5 to create smooth edges. Default value is 0 (disabled).
		 */
		public function get alphaThreshold():Number {
			return _alphaThreshold;
		}
		
		public function set alphaThreshold(value:Number):void {
			_alphaThreshold = value;
		}
		
		/**
		 * Indicate whether or not the material has transparency. If binary transparency is sufficient, for
		 * example when using textures of foliage, consider using alphaThreshold instead.
		 */
		public function get alphaBlending():Boolean {
			return _alphaBlending;
		}
		
		public function set alphaBlending(value:Boolean):void {
			_alphaBlending = value;
		}
		
		/**
		 * Away3D Material
		 */
		public function get material():MaterialBase {
			return _material;
		}
		
		public function set material(value:MaterialBase):void {
			if (material != value)
				_material = value;
		}
	
	}

}