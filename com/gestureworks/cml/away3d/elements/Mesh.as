package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.TouchEvent3D;
	import away3d.materials.MaterialBase;
	import com.gestureworks.away3d.Away3DTouchObject;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.utils.document;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 */
	public class Mesh extends Group {
		private var _mesh:away3d.entities.Mesh;
		private var gref:XML;
		private var mref:XML;
		private var _groupObj3D:ObjectContainer3D;
		private var _touchEnabled:Boolean = false;
		private var _castsShadows:Boolean = true;
		
		public function Mesh() {
			super();
			mesh = new away3d.entities.Mesh(null, null);
			target = mesh;
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void {
			//trace("### Mesh  displayComplete ###")
			mesh.name = this.id;
			mesh.x = this.x;
			mesh.y = this.y;
			mesh.z = this.z;
			mesh.pivotPoint = new Vector3D(this.pivot.split(",")[0], this.pivot.split(",")[1], this.pivot.split(",")[2]);
			mesh.rotationX = this.rotationX;
			mesh.rotationY = this.rotationY;
			mesh.rotationZ = this.rotationZ;
			if (this.lookat) //overides any rotation above
				mesh.lookAt(new Vector3D(this.lookat.split(",")[0], this.lookat.split(",")[1], this.lookat.split(",")[2]));
			mesh.scaleX = this.scaleX;
			mesh.scaleY = this.scaleY;
			mesh.scaleZ = this.scaleZ;
			
			if (!(gref is Geometry))
				geometry = gref;
			
			if(!(mref is MaterialBase))	
				material = mref;
			
			if (this.parent is Scene)
				Scene(this.parent).addChild3D(mesh);
			
			if (this.parent is Group)
				Group(this.parent).addChild3D(mesh);
			
			if (this.parent is Mesh)
				Mesh(this.parent).addChild3D(mesh);
			
			if (this.parent is Light)
				Light(this.parent).addChild3D(mesh);
				
			mesh.castsShadows = _castsShadows;
			
			mesh.mouseEnabled = true;
			mesh.mouseChildren = true;		
		}
		
		/*
		 * Away3D Geometry
		 */
		public function get geometry():* { return mesh.geometry; }	
		public function set geometry(geom:*):void {
			if (geom is XML) {
				gref = geom;
				geom = document.getElementById(geom).geometry
			}
			if(geom is Geometry)
				mesh.geometry = geom;
		}
		
		/*
		 * Away3D material
		 */
		public function get material():* { return mesh.material; }		
		public function set material(mat:*):void { 
			if (mat is XML) {
				mref = mat;
				mat = document.getElementById(mat).material;				
			}
			if(mat is MaterialBase)
				mesh.material = mat; 
		}
		
		
		/*
		 * Away3d mesh.
		 */
		public function get mesh():away3d.entities.Mesh {
			return _mesh;
		}
		
		public function set mesh(value:away3d.entities.Mesh):void {
			_mesh = value;
			_groupObj3D = value;
		}
		
		public override function get groupObj3D():ObjectContainer3D {
			return _mesh;
		}
		
		/**
		 * Whether this mesh casts shadows
		 * @default true
		 */
		public function get castsShadows():Boolean 
		{
			return _castsShadows;
		}
		
		public function set castsShadows(value:Boolean):void 
		{
			_castsShadows = value;
		}
		
		override public function addChild3D(child:ObjectContainer3D):void {
			mesh.addChild(child);
		}
	
	}

}