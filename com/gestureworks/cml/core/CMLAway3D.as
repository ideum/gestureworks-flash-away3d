package com.gestureworks.cml.core 
{
	import com.gestureworks.away3d.TouchManager3D;
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
	 * </ul>
	 * 
	 * <p>Register custom packages by pushing into the CMLCore.packages array.
	 * 
	 * <p>You can then use one of the following procedures to register your class:</p>
	 * <listing version="3.0">com.gestureworks.cml.element.CustomClass; CustomClass;</listing>
	 * <p>or</p>
	 * <listing version="3.0">CMLCore.classes.push(CMLCustomClass);</listing>
	 * 
	 * @author Ideum
	 * @see com.gestureworks.cml.core.CML_CORE
	 */	
	public class CMLAway3D {}

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
	
	import com.gestureworks.cml.away3d.geometries.Cube; Cube;
	import com.gestureworks.cml.away3d.geometries.Cylinder; Cylinder;	
	import com.gestureworks.cml.away3d.geometries.Plane; Plane;
	import com.gestureworks.cml.away3d.geometries.Sphere; Sphere;
}