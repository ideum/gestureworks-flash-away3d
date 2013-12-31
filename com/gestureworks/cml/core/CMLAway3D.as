package com.gestureworks.cml.core 
{
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.away3d.layouts.Circle3DLayout;
	import com.gestureworks.cml.away3d.layouts.Random3DLayout;
	/** 
	 * The CMLAway3D class is the registry file for classes that are capable of
	 * being loaded by the CML Parser.
	 * 
	 * <p>You can register your own class for CML loading by placing your class file
	 * in either no package, or one of the following packages: </p>
	 * 
	 * <ul>
	 *  <li>com.gestureworks.cml.away3d.elements</li>
	 *  <li>com.gestureworks.cml.away3d.geometries</li>
	 *  <li>com.gestureworks.cml.away3d.materials</li>
	 * </ul>
	 * 
	 * <p>Register custom packages by pushing into the CMLCore.packages array.
	 * 
	 * <p>You can then use one of the following procedures to register your class:</p>
	 * <listing version="3.0">com.gestureworks.cml.elements.CustomClass; CustomClass;</listing>
	 * <p>or</p>
	 * <listing version="3.0">CMLCore.classes.push(CMLCustomClass);</listing>
	 * 
	 * @author Ideum
	 * @see com.gestureworks.cml.core.CML_CORE
	 */	
	public class CMLAway3D { }
	
	// elements
	import com.gestureworks.cml.away3d.elements.Camera; Camera;
	import com.gestureworks.cml.away3d.elements.Container3D; Container3D;
	import com.gestureworks.cml.away3d.elements.Light; Light;
	import com.gestureworks.cml.away3d.elements.LightPicker; LightPicker;
	import com.gestureworks.cml.away3d.elements.Material; Material;
	import com.gestureworks.cml.away3d.elements.Mesh; Mesh;
	import com.gestureworks.cml.away3d.elements.Model; Model;
	import com.gestureworks.cml.away3d.elements.ModelAsset; ModelAsset;
	import com.gestureworks.cml.away3d.elements.Scene; Scene;
	import com.gestureworks.cml.away3d.elements.SkyBox; SkyBox;
	import com.gestureworks.cml.away3d.elements.Geometry; Geometry;
	import com.gestureworks.cml.away3d.elements.Texture; Texture;
	import com.gestureworks.cml.away3d.elements.Layout3D; Layout3D;
	import com.gestureworks.cml.away3d.elements.Node; Node;
	import com.gestureworks.cml.away3d.elements.NodeGraph; NodeGraph;
	import com.gestureworks.cml.away3d.elements.Edge; Edge;
	
	// light
	import com.gestureworks.cml.away3d.lights.PointLight; PointLight;	
	import com.gestureworks.cml.away3d.lights.DirectionalLight; DirectionalLight;	
	
	// geomtries
	import com.gestureworks.cml.away3d.geometries.CapsuleGeometry; CapsuleGeometry;
	import com.gestureworks.cml.away3d.geometries.ConeGeometry; ConeGeometry;
	import com.gestureworks.cml.away3d.geometries.CubeGeometry; CubeGeometry;
	import com.gestureworks.cml.away3d.geometries.CylinderGeometry; CylinderGeometry;	
	import com.gestureworks.cml.away3d.geometries.NURBSGeometry; NURBSGeometry;	
	import com.gestureworks.cml.away3d.geometries.PlaneGeometry; PlaneGeometry;
	import com.gestureworks.cml.away3d.geometries.SphereGeometry; SphereGeometry;
	import com.gestureworks.cml.away3d.geometries.TorusGeometry; TorusGeometry;
	
	// materials
	import com.gestureworks.cml.away3d.materials.ColorMaterial; ColorMaterial;
	import com.gestureworks.cml.away3d.materials.TextureMaterial; TextureMaterial;	
	
	// textures
	import com.gestureworks.cml.away3d.textures.BitmapTexture; BitmapTexture;	
	import com.gestureworks.cml.away3d.textures.VideoTexture; VideoTexture;	
	import com.gestureworks.cml.away3d.textures.VideoCameraTexture; VideoCameraTexture;	
	import com.gestureworks.cml.away3d.textures.Render2DTexture; Render2DTexture;	
	
	// layouts
	com.gestureworks.cml.away3d.layouts.Random3DLayout;	Random3DLayout;
	com.gestureworks.cml.away3d.layouts.Circle3DLayout;	Circle3DLayout;
	
}