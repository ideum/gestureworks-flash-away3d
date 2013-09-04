package com.gestureworks.away3d 
{
	/** 
	 * The CML_Away3D class is the registry file for Away3D-exclusive classes that are capable of
	 * being load by the CML Parser.
	 * 
	 * <p>You can register your own Away3D class for CML loading by placing your class file
	 * in either no package, or one of the following packages:</p>
	 * 
	 * <ul>
	 *	<li>com.gestureworks.away3d</li>
	 *	<li>com.gestureworks.cml.away3d.elements</li>
	 *	<li>com.gestureworks.cml.elements</li>
	 * </ul>
	 * 
	 * <p>You can then use the following import syntax to register your class:</p>
	 * <code>com.gestureworks.cml.elements.CustomClass; CustomClass;</code>
	 *
	 *
	 * @author Ideum
	 * @see com.gestureworks.cml.core.CML_CORE
	 */	 
	public class CML_Away3D { }

	import com.gestureworks.cml.away3d.elements.Camera3D; Camera3D;
	import com.gestureworks.cml.away3d.elements.Container3D; Container3D;
	import com.gestureworks.cml.away3d.elements.Cube; Cube;
	import com.gestureworks.cml.away3d.elements.Cylinder; Cylinder;
	import com.gestureworks.cml.away3d.elements.Group; Group;
	import com.gestureworks.cml.away3d.elements.Light; Light;
	import com.gestureworks.cml.away3d.elements.LightPicker; LightPicker;
	import com.gestureworks.cml.away3d.elements.Material; Material;
	import com.gestureworks.cml.away3d.elements.Mesh; Mesh;
	import com.gestureworks.cml.away3d.elements.Model; Model;
	import com.gestureworks.cml.away3d.elements.ModelAsset; ModelAsset;
	import com.gestureworks.cml.away3d.elements.Plane; Plane;
	import com.gestureworks.cml.away3d.elements.Scene; Scene;
	import com.gestureworks.cml.away3d.elements.SkyBox; SkyBox;
	import com.gestureworks.cml.away3d.elements.Sound3D; Sound3D;
	import com.gestureworks.cml.away3d.elements.Sphere; Sphere;
}