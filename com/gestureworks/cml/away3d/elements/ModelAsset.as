package com.gestureworks.cml.away3d.elements 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import com.gestureworks.cml.utils.document;
	import flash.geom.Vector3D;
	/**
	 * ... TODO MAY SPLIT INTO MESH/OBJ3D AND MATERIAL AS-SETS
	 */
	public class ModelAsset extends TouchContainer3D 
	{
		private var _material:MaterialBase;
		private var mref:XML;
		
		public function ModelAsset() 
		{
			super();
		}
		
		public function update():void
		{
			if (AssetLibrary.getAsset(id).assetType == "mesh" || AssetLibrary.getAsset(id).assetType =="container")
			{
				var obj3D:ObjectContainer3D = ObjectContainer3D(AssetLibrary.getAsset(id));
				
				obj3D.x = x;
				obj3D.y = y;
				obj3D.z = z;
				obj3D.pivotPoint = new Vector3D(pivot.split(",")[0], pivot.split(",")[1], pivot.split(",")[2]); 
				obj3D.rotationX = rotationX;
				obj3D.rotationY = rotationY;
				obj3D.rotationZ = rotationZ;
				if ( lookat) //overides any rotation above
					obj3D.lookAt(new Vector3D(lookat.split(",")[0], lookat.split(",")[1], lookat.split(",")[2]));
				obj3D.scaleX = scaleX;
				obj3D.scaleY = scaleY;
				obj3D.scaleZ = scaleZ;
				
				if (mref)
					material = mref;
				if (material && obj3D is away3d.entities.Mesh )
					away3d.entities.Mesh(obj3D).material = material;
			}
			
			if (AssetLibrary.getAsset(id).assetType == "material")
			{
				var material:MaterialBase = MaterialBase(AssetLibrary.getAsset(id));
				
				if (material is ColorMaterial)
				{
					ColorMaterial(material).alpha = alpha;
				}
				else //texture
				{
					TextureMaterial(material).alpha = alpha;

					
				}
			}
		}
		
		public function get material():* { return _material; }		
		public function set material(value:*):void {
			if (value is XML) {
				mref = value;
				value = document.getElementById(value).material;
			}
			if (value is MaterialBase)
				_material = value;
				
		}
		
	}

}