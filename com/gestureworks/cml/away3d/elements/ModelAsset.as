package com.gestureworks.cml.away3d.elements 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.utils.document;
	import flash.geom.Vector3D;
	
	public class ModelAsset extends TouchContainer3D 
	{
		public var mesh:away3d.entities.Mesh;
		public var container3D:ObjectContainer3D;
		public var material:MaterialBase;		
		public var geometry:away3d.core.base.Geometry;
		
		private var _mref:XML;
		
		public function ModelAsset() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			var s:String;

			if (mref) {
				s = String(mref);
				if (s.charAt(0) == "#") {
					s = s.substr(1);
				}
				material = document.getElementById(s); 
			}	
		}		
		
		/**
		 * @inheritDoc
		 */
		override public function parseCML(cml:XMLList):XMLList {
		
			if (cml.@material != undefined) {
				cml.@mref = cml.@material;
				delete cml.@material;
			}				
			
			return CMLParser.parseCML(this, cml);
		}	
		
		/**
		 * Updates linkage
		 */
		public function update():void {
			var t:String = AssetLibrary.getAsset(id).assetType;
			
			if (t == "mesh") {
				mesh = away3d.entities.Mesh(AssetLibrary.getAsset(id));
			}
			else if (t == "container")	{
				container3D = ObjectContainer3D(AssetLibrary.getAsset(id));
			}
			else if (t == "material") {
				material = MaterialBase(AssetLibrary.getAsset(id));
			}		
			else if (t == "geometry") {
				geometry = away3d.core.base.Geometry(AssetLibrary.getAsset(id));
			}
			
			if (t == "mesh" || t =="container") {
				var obj:ObjectContainer3D = ObjectContainer3D(AssetLibrary.getAsset(id));
				
				obj.x = x;
				obj.y = y;
				obj.z = z;
				
				obj.pivotPoint = new Vector3D(pivot.split(",")[0], pivot.split(",")[1], pivot.split(",")[2]); 
				
				obj.rotationX = rotationX;
				obj.rotationY = rotationY;
				obj.rotationZ = rotationZ;
				
				if ( lookat) { //overides any rotation above
					obj.lookAt(new Vector3D(lookat.split(",")[0], lookat.split(",")[1], lookat.split(",")[2]));
				}
				
				obj.scaleX = scaleX;
				obj.scaleY = scaleY;
				obj.scaleZ = scaleZ;
				
				
				obj.mouseEnabled = mouseEnabled;
				obj.mouseChildren = mouseChildren;			
				
				vto = obj;								
				TouchManager3D.registerTouchObject(this);
				

				if (material && obj is away3d.entities.Mesh ) {
					away3d.entities.Mesh(obj).material = material;
				}

			}
			
			if (AssetLibrary.getAsset(id).assetType == "material") {
				material = MaterialBase(AssetLibrary.getAsset(id));
				if (material is ColorMaterial) {
					ColorMaterial(material).alpha = alpha;
				}
				else 
					TextureMaterial(material).alpha = alpha;
			}
		}
		
		/*
		 * Material reference
		 */
		public function get mref():* { return _mref; }		
		public function set mref(mat:*):void { 
			_mref = mat;
		}
		
	}

}