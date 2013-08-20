package com.gestureworks.cml.element.away3d 
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
	public class Sound3d extends Container3D 
	{
		private var s3d:Sound3D;
		private var sound:Sound;
		private var soundObj3D:ObjectContainer3D;
		
		public function Sound3d() 
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
			
			s3d = new Sound3D(sound, soundObj3D, null, 1, 1000);
			s3d.x = this.x;
			s3d.y = this.y;
			s3d.z = this.z;
			s3d.pivotPoint = new Vector3D(this.pivot.split(",")[0], this.pivot.split(",")[1], this.pivot.split(",")[2]); 
			s3d.rotationX = this.rotationX;
			s3d.rotationY = this.rotationY;
			s3d.rotationZ = this.rotationZ;
			if ( this.lookat) //overides any rotation above
				s3d.lookAt(new Vector3D(this.lookat.split(",")[0], this.lookat.split(",")[1], this.lookat.split(",")[2]));
			s3d.scaleX = this.scaleX;
			s3d.scaleY = this.scaleY;
			s3d.scaleZ = this.scaleZ;

			if (this.parent is Scene)
			Scene(this.parent).addChild3D(s3d);
			
			if (this.parent is Group)
			Group(this.parent).addChild3D(s3d);
			
			if (this.parent is Mesh)
			Mesh(this.parent).addChild3D(s3d);
			*/
		}
		
		//public function addChild3D(child:ObjectContainer3D):void
		//{
			//addChild(child);
		//}
		
	}

}