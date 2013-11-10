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
	import com.gestureworks.cml.utils.document;
	import flash.geom.Vector3D;
	
	public class ModelAsset extends TouchContainer3D 
	{
		public var mesh:away3d.entities.Mesh;
		public var container3D:ObjectContainer3D;
		public var _material:MaterialBase;		
		public var geometry:away3d.core.base.Geometry;
		
		private var mref:XML;
		
		public function ModelAsset() 
		{
			super();
		}
		
		public function update():void
		{
			var t:String = AssetLibrary.getAsset(id).assetType;
			
			if (t == "mesh") {
				mesh = away3d.entities.Mesh(AssetLibrary.getAsset(id));
				mesh.mouseEnabled = true;
				vto = mesh;
				touch3d = true;							
				TouchManager3D.registerTouchObject(this);		
			}
			else if (t == "container")	{
				container3D = ObjectContainer3D(AssetLibrary.getAsset(id));
				TouchManager3D.registerTouchObject(container3D);		
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
				
				if (mref)
					material = mref;
				if (material && obj is away3d.entities.Mesh ) {
					away3d.entities.Mesh(obj).material = material;
				}

			}
			
			if (AssetLibrary.getAsset(id).assetType == "material") {
				var material:MaterialBase = MaterialBase(AssetLibrary.getAsset(id));
				if (material is ColorMaterial) {
					ColorMaterial(material).alpha = alpha;
				}
				else 
					TextureMaterial(material).alpha = alpha;
			}
		}
		
		public function get material():* { return _material; }		
		public function set material(value:*):void {
			if (value is XML) {
				mref = value;
				value = document.getElementById(value);
			}
			if (value is MaterialBase)
				_material = value;
				
		}
		
	}

}