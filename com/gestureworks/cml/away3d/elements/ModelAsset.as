package com.gestureworks.cml.away3d.elements 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.library.AssetLibrary;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.NearShadowMapMethod;
	import away3d.materials.TextureMaterial;
	import com.gestureworks.cml.core.CMLObjectList;
	import flash.geom.Vector3D;
	/**
	 * ... TODO MAY SPLIT INTO MESH/OBJ3D AND MATERIAL AS-SETS
	 */
	public class ModelAsset extends Group 
	{
		private var _material:String;
		
		public function ModelAsset() 
		{
			super();
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void
		{
		}
		
		public function update():void
		{
			if (AssetLibrary.getAsset(this.id).assetType == "mesh" || AssetLibrary.getAsset(this.id).assetType =="container")
			{
				var groupObj3D:ObjectContainer3D = ObjectContainer3D(AssetLibrary.getAsset(this.id));
				
				groupObj3D.x = this.x;
				groupObj3D.y = this.y;
				groupObj3D.z = this.z;
				groupObj3D.pivotPoint = new Vector3D(this.pivot.split(",")[0], this.pivot.split(",")[1], this.pivot.split(",")[2]); 
				groupObj3D.rotationX = this.rotationX;
				groupObj3D.rotationY = this.rotationY;
				groupObj3D.rotationZ = this.rotationZ;
				if ( this.lookat) //overides any rotation above
					groupObj3D.lookAt(new Vector3D(this.lookat.split(",")[0], this.lookat.split(",")[1], this.lookat.split(",")[2]));
				groupObj3D.scaleX = this.scaleX;
				groupObj3D.scaleY = this.scaleY;
				groupObj3D.scaleZ = this.scaleZ;
				
				if (material && CMLObjectList.instance.getId(material) && groupObj3D is away3d.entities.Mesh )
				away3d.entities.Mesh(groupObj3D).material = CMLObjectList.instance.getId(material).material;
			}
			
			if (AssetLibrary.getAsset(this.id).assetType == "material")
			{
				var material:MaterialBase = MaterialBase(AssetLibrary.getAsset(this.id));
				
				if (material is ColorMaterial)
				{
					ColorMaterial(material).alpha = this.alpha;
				}
				else //texture
				{
					TextureMaterial(material).alpha = this.alpha;

					
				}
			}
		}
		
		public function get material():String { return _material; }		
		public function set material(value:String):void 
		{
			_material = value;
		}
		
	}

}