package com.gestureworks.cml.away3d.elements {
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.TouchEvent3D;
	import away3d.materials.MaterialBase;
	import com.gestureworks.away3d.Away3DTouchObject;
	import com.gestureworks.cml.core.CMLObjectList;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 */
	public class Mesh extends Group {
		private var _geometry:Geometry;
		private var _mesh:away3d.entities.Mesh;
		private var _material:MaterialBase;
		private var _geometryId:String = "";
		private var _materialId:String = "";
		private var _groupObj3D:ObjectContainer3D;
		private var _touchEnabled:Boolean = false;
		private var _castsShadows:Boolean = true;
		
		public function Mesh() {
			super();
			mesh = new away3d.entities.Mesh(null, null);
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
			
			if (this.geometryId && CMLObjectList.instance.getId(this.geometryId))
				geometry = CMLObjectList.instance.getId(this.geometryId).geometry;
			
			if (this.materialId && CMLObjectList.instance.getId(this.materialId))
				material = CMLObjectList.instance.getId(this.materialId).material;
			
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
			
			if (this._touchEnabled) {
				//Need a way to search for the Gesture Tag so this can be set
				//var st:AwayTouchObject = new AwayTouchObject(this);
				//var st:Away3DTouchObject = new Away3DTouchObject(mesh);
				//st.gestureList = {"n-drag": true, "n-rotate": true, "n-scale": true};
				//st.disableNativeTransform = false;
				//st.gestureReleaseInertia = false;
				//
				//enableListeners();
			}
		
		}
		
		private function enableListeners():void {
			//trace("Mesh enablelisteners")
			//SEE GROUP CLASS
			
			mesh.addEventListener(TouchEvent3D.TOUCH_BEGIN, ontouch);
			mesh.addEventListener(TouchEvent3D.TOUCH_MOVE, ontouch);
			mesh.addEventListener(TouchEvent3D.TOUCH_END, ontouch);
		}
		
		/*
		 * Away3D Geometry
		 */
		public function get geometry():Geometry {
			return mesh.geometry;
		}
		
		public function set geometry(geom:Geometry):void {
			mesh.geometry = geom;
		}
		
		/*
		 * Away3D material
		 */
		public function get material():MaterialBase {
			return mesh.material;
		}
		
		public function set material(mat:MaterialBase):void {
			mesh.material = mat;
		}
		
		/**
		 * Geometry
		 * gets the geometry with matching id
		 */
		public function get geometryId():String {
			return _geometryId;
		}
		
		public function set geometryId(value:String):void {
			_geometryId = value;
		}
		
		/**
		 * Material 
		 * gets the material with matching id
		 */
		public function get materialId():String {
			return _materialId;
		}
		
		public function set materialId(value:String):void {
			_materialId = value;
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
		
		public override function get touchEnabled():Boolean {
			return _touchEnabled;
		}
		
		public override function set touchEnabled(value:Boolean):void {
			_touchEnabled = value;
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
		
		/*public function get touchEnabled():Boolean
		   {
		   return _touchEnabled;
		   }
		
		   public function set touchEnabled(value:Boolean):void
		   {
		   _touchEnabled = value;
		 }*/
		
		override public function addChild3D(child:ObjectContainer3D):void {
			mesh.addChild(child);
		}
	
	}

}