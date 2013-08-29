package com.gestureworks.cml.away3d.elements 
{
	import away3d.audio.Sound3D;
	import away3d.containers.ObjectContainer3D;
	import com.gestureworks.cml.element.away3d.Container3D;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	/**
	 * ...
	 * 
	 */
	public class Sound3D extends Container3D 
	{
		private var s3D:away3d.audio.Sound3D;
		private var sound:Sound;
		private var soundObj3D:ObjectContainer3D;
		
		public function Sound3D() 
		{
			super();
		}
		
		/**
		 * Initialisation method
		 */
		override public function init():void
		{
			displayComplete();
		}
		
		/**
		 * CML callback Initialisation
		 */
		override public function displayComplete():void
		{
			//TODO
			/*
			
			s3D = new Sound3D(sound, soundObj3D, null, 1, 1000);
			s3D.x = this.x;
			s3D.y = this.y;
			s3D.z = this.z;
			s3D.pivotPoint = new Vector3D(this.pivot.split(",")[0], this.pivot.split(",")[1], this.pivot.split(",")[2]); 
			s3D.rotationX = this.rotationX;
			s3D.rotationY = this.rotationY;
			s3D.rotationZ = this.rotationZ;
			if ( this.lookat) //overides any rotation above
				s3D.lookAt(new Vector3D(this.lookat.split(",")[0], this.lookat.split(",")[1], this.lookat.split(",")[2]));
			s3D.scaleX = this.scaleX;
			s3D.scaleY = this.scaleY;
			s3D.scaleZ = this.scaleZ;

			if (this.parent is Scene)
			Scene(this.parent).addChild3D(s3D);
			
			if (this.parent is Group)
			Group(this.parent).addChild3D(s3D);
			
			if (this.parent is Mesh)
			Mesh(this.parent).addChild3D(s3D);
			*/
		}
		
		//public function addChild3D(child:ObjectContainer3D):void
		//{
			//addChild(child);
		//}
		
	}

}