package com.gestureworks.away3d.utils
{
	import away3d.lights.PointLight;
	import com.gestureworks.objects.MotionPointObject;
	import flash.geom.Vector3D;
	
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.utils.*;
	import away3d.primitives.LineSegment;
	import away3d.entities.SegmentSet;
	
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.objects.HandObject;
	
	public class MotionVisualizer3D extends ObjectContainer3D
	{
		//////////////////////////////////////////////////////////////////////
		// public
		//////////////////////////////////////////////////////////////////////	
		
		public var drawHands:Boolean = true;
		public var drawPoints:Boolean = true;
		public var drawClusters:Boolean = false;
		public var drawGestures:Boolean = false;
		
		public var cO:ClusterObject;
		public var trO:TransformObject;
		
		public var lightPicker:StaticLightPicker;
		
		//////////////////////////////////////////////////////////////////////
		// private
		//////////////////////////////////////////////////////////////////////	
		
		private var ts:TouchSprite;
		
		private var lines:SegmentSet;
		
		private var clines:SegmentSet;
		
		private var seg:SegmentSet;
		
		private var pvector:LineSegment;
		private var v0:Vector3D;
		private var v1:Vector3D;
		
		//hand skeleton
		private var ballList:Array = new Array();
		private var fingerList:Array = new Array();
		private var vfingerList:Array = new Array();
		private var wballList:Array = new Array();
		private var kballList:Array = new Array();
		private var palmList:Array = new Array();
		private var ringList:Array = new Array();
		
		//interaction points
		private var iballList:Array = new Array();
		private var iringList:Array = new Array();
		// cluster
		private var cballList:Array = new Array();
		// gesture
		private var gballList:Array = new Array();
		
	
		private var RAD_DEG:Number = 180/Math.PI
		private var DEG_RAD:Number = Math.PI / 180; 
		
		private var step:Number = 10 * DEG_RAD;
		private var i:uint;
		
		public function MotionVisualizer3D():void
		{
			trace("auto init 3d vis", ts);
		}
		
		public function init():void 
		{
			trace("init 3d vis");

			//////////////////////////////////////////////////////////////////////
			// create hand object
			//////////////////////////////////////////////////////////////////////
			//// build sphere geometry
			var sg2:SphereGeometry = new SphereGeometry(2);
			var sg4:SphereGeometry = new SphereGeometry(4);
			var sg6:SphereGeometry = new SphereGeometry(6);
			var sg8:SphereGeometry = new SphereGeometry(8);
			var sg10:SphereGeometry = new SphereGeometry(10);
			//// build cylinder geometry
			//var cg1:CylinderGeometry = new CylinderGeometry(1, 1, 1, 2, 1, false, false, true, false);
			//var cg0:WireframeCylinder = new WireframeCylinder(1,1, 1, 2, 1, 0xFFFFFF,1);
			//var cg1:WireframeCylinder = new WireframeCylinder(10,10, 10, 32, 16, 0xFFFF00,1);
			//var cg2:WireframeCylinder = new WireframeCylinder(50, 50, 1, 32, 1, 0xFFFFFF,1);
			//// build plane
			var plane:PlaneGeometry = new PlaneGeometry(180, 220, 1, 1, true, true);
				
			// fingertips	
			for (i = 0; i < 12; i++) 
			{
				var sMat:ColorMaterial = new ColorMaterial(0x006600, 0.6);
					sMat.alphaBlending = true;
					sMat.lightPicker = lightPicker;
				var smesh:Mesh = new Mesh(sg4, sMat);
				var ball:ObjectContainer3D = new ObjectContainer3D();
					ball.addChild(smesh);
					ballList.push(ball);
				this.addChild(ball);
			}
			

			// finger plane projections (12)
			// knuckle points ()
			var sMat2:ColorMaterial = new ColorMaterial(0xFFFFFF,0.4);
				sMat2.alphaBlending = true;
				sMat2.lightPicker = lightPicker;
				
	
				for (i = 0; i < 10; i++) 
				{
					/*
				var sMat8:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.6);
					sMat8.alphaBlending = true;
					sMat8.lightPicker = lightPicker;
				var smesh:Mesh = new Mesh(cg1, sMat8);
				var finger:ObjectContainer3D = new ObjectContainer3D();
					//finger.x = -50;
					finger.addChild(smesh);
					fingerList.push(finger);
				this.addChild(finger);
				*/
				var cg0:WireframeCylinder = new WireframeCylinder(1,1, 1, 2, 1, 0xFFFFFF,1);
					fingerList.push(cg0);
				this.addChild(cg0);
				}
				
				for (i = 0; i < 10; i++) 
				{
				//var sMat9:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.6);
					//sMat9.alphaBlending = true;
					//sMat9.lightPicker = lightPicker;
				//var smesh2:Mesh = new Mesh(cg1, sMat9);
				//var vfinger:ObjectContainer3D = new ObjectContainer3D();
					
					//vfinger.addChild(smesh2);
					//vfingerList.push(vfinger);
				//this.addChild(vfinger);
					
				var cg1:WireframeCylinder = new WireframeCylinder(1,1, 1, 4, 1, 0xFFFF00,1);
					vfingerList.push(cg1);
				this.addChild(cg1);
				}
				
				
			for (i = 0; i < 14; i++) 
			{
				var wsmesh:Mesh = new Mesh(sg2, sMat2);
				var wball:ObjectContainer3D = new ObjectContainer3D();
					wball.addChild(wsmesh);
					wballList.push(wball);
				this.addChild(wball);
			}
			
			
			
			// palm plane
			for (i = 0; i < 2; i++) 
			{	
				
				var mat:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.1);
					mat.bothSides = true;
					mat.alphaBlending = true;
					mat.lightPicker = lightPicker;
					//mat.blendMode = BlendMode.ADD;
				var palmplane:Mesh = new Mesh(plane, mat);	
					palmList.push(palmplane);
				this.addChild(palmplane);
				
				
				// palm ring
				//var sMat10:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.6);
					//sMat10.alphaBlending = true;
					//sMat10.lightPicker = lightPicker;
				//var scmesh:Mesh = new Mesh(cg2, sMat10);
				
				//var ring:ObjectContainer3D = new ObjectContainer3D();
					//ring.addChild(scmesh);
					//ring.addChild(cg2);
					//ringList.push(ring);
				//this.addChild(ring);
				var cg2:WireframeCylinder = new WireframeCylinder(50,50, 1, 32, 16, 0xFFFFFF,1);
					ringList.push(cg2);
				this.addChild(cg2);
			}
			


			
			
			
			
			
			
			
			
			/////////////////////////////////////////////////////////////////////////////
			// INTERACTION POINTS////////////////////////////////////////////////////////
				for (i = 0; i < 20; i++) 
				{
					var iMat1:ColorMaterial = new ColorMaterial(0x006600, 1);
					iMat1.lightPicker = lightPicker;
					var ismesh1:Mesh = new Mesh(sg2, iMat1);
					var iball:ObjectContainer3D = new ObjectContainer3D();
						iball.addChild(ismesh1);
						iballList.push(iball);
					this.addChild(iball);
				}
				
				
				// interative point ring
				for (i= 0; i < 20; i++) 
				{
					var iring:ObjectContainer3D = new ObjectContainer3D();
					var ring0:SegmentSet = new SegmentSet();
					iring.addChild(ring0);
						iringList.push(iring);
					this.addChild(iring);
				}
				
			///////////////////////////////////////////////////////////////////////////
			//CLUSTER /////////////////////////////////////////////////////////////////
			var iMat:ColorMaterial = new ColorMaterial(0xFFAE1F, 0.8);
			iMat.lightPicker = lightPicker;
				var ismesh:Mesh = new Mesh(sg6, iMat);
				var cball:ObjectContainer3D = new ObjectContainer3D();
					cball.addChild(ismesh);
					cballList.push(cball);
				this.addChild(cball);
				
			// cluster lines
			clines = new SegmentSet();
			this.addChild(clines);	
			
			/////////////////////////////////////////////////////////////////////////////
			//GESTURE////////////////////////////////////////////////////////////////////
			for (i = 0; i < 10; i++) 
			{
				var iMat0:ColorMaterial = new ColorMaterial(0x6666FF, 0.6);
				iMat0.lightPicker = lightPicker;
				var ismesh0:Mesh = new Mesh(sg10, iMat0);
				var gball:ObjectContainer3D = new ObjectContainer3D();
					gball.addChild(ismesh0);
					gballList.push(gball);
				this.addChild(gball);
			}
		}

		
	
		private function clearHand():void
		{
			for (i = 0; i < ballList.length; i++)
				{
					ballList[i].x = 0;
					ballList[i].y = 0;
					ballList[i].z = 0;
					ballList[i].visible = false;
				}
				
				for (i = 0; i <fingerList.length; i++)
				{
					fingerList[i].x = 0;
					fingerList[i].y = 0;
					fingerList[i].z = 0;
					fingerList[i].scaleZ = 100;
					fingerList[i].visible = false;
				}
				
				for (i = 0; i <vfingerList.length; i++)
				{
					vfingerList[i].x = 0;
					vfingerList[i].y = 0;
					vfingerList[i].z = 0;
					vfingerList[i].scaleZ = 100;
					vfingerList[i].visible = false;
				}
				
				for (i = 0; i < wballList.length; i++)
				{
					wballList[i].x = 0;
					wballList[i].y = 0;
					wballList[i].z = 0;
					wballList[i].visible = false;
				}
				
				for ( i = 0; i < kballList.length; i++)
				{
					kballList[i].x = 0;
					kballList[i].y = 0;
					kballList[i].z = 0;
					kballList[i].visible = false;
				}
				
				
				
				
				
				for ( i = 0; i < iballList.length; i++)
				{
					iballList[i].x = 0;
					iballList[i].y = 0;
					iballList[i].z = 0;
					iballList[i].visible = false;
				}
				
				for ( i = 0; i < gballList.length; i++)
				{
					gballList[i].x = 0;
					gballList[i].y = 0;
					gballList[i].z = 0;
					gballList[i].visible = false;
				}
				
				for ( i = 0; i < iringList.length; i++)
				{
					iringList[i].x = 0;
					iringList[i].y = 0;
					iringList[i].z = 0;
					iringList[i].visible = false;
					iringList[i].getChildAt(0).removeAllSegments();
				}
				
				
				for ( i = 0; i < palmList.length; i++)
				{
					palmList[i].visible = false;
					ringList[i].visible = false;
				}
				
				
				
				
				cballList[0].visible = false;
		}
		
		
		private function drawHand():void
		{
			//trace("test", cO.motionArray.length,ballList.length);
			
			var hn:uint = cO.handList.length;
			
			for (var j:int = 0; j < hn ; j++) 
			{
				var hand:HandObject = cO.handList[j];				
				var n:uint = 10+j //(hn*5 + (j+1));

				//draw fav projection
				wballList[n].visible = true;	
				wballList[n].position  = cO.handList[j].projectedFingerAveragePosition;
			
			
			for ( i = 0; i < cO.handList[j].fingerList.length; i++) 
			{		
				var pt:MotionPointObject  = cO.handList[j].fingerList[i];
				var palm_pt:MotionPointObject =  cO.handList[j].palm;
				
				
				if (vfingerList[i+j*5]) 
				{
					var f:Number = 30;
					var vd:Vector3D = new Vector3D (f*pt.direction.x, f*pt.direction.y, f*pt.direction.z);
					var v:Vector3D = pt.position.add(vd);

					vfingerList[i+j*5].visible = true;
					vfingerList[i + j * 5].position = new Vector3D(pt.position.x + vd.x*0.5, pt.position.y + vd.y*0.5, pt.position.z + vd.z*0.5);
					vfingerList[i + j * 5].lookAt(v);
					vfingerList[i + j * 5].scaleZ = vd.length;
					//vfingerList[i + j * 5].getChildAt(0).material.color = 0xFFFF00; //yellow
					//vfingerList[i + j * 5].getChildAt(0).material.lightPicker = lightPicker;
				}
				
				if (fingerList[i+j*5]) 
				{
					var dv:Number = Vector3D.distance(pt.position, palm_pt.position);
					var dx:Number = (pt.position.x - palm_pt.position.x)
					var dy:Number = (pt.position.y - palm_pt.position.y)
					var dz:Number = (pt.position.z - palm_pt.position.z)

					fingerList[i+j*5].visible = true;
					fingerList[i + j * 5].position = new Vector3D(palm_pt.position.x + dx*0.5,palm_pt.position.y + dy*0.5,palm_pt.position.z + dz*0.5);
					fingerList[i + j * 5].lookAt(pt.position)
					fingerList[i + j * 5].scaleZ = dv;
					//fingerList[i + j * 5].getChildAt(0).material.color = 0xFFFFFF; //white
					//fingerList[i + j * 5].getChildAt(0).material.lightPicker = lightPicker;
				}
				
				
				
				if (ballList[i+j*5]) 
				{
					////////////////////////////////////////////////////////////////////////////
					// draw fingers
					//var pt:MotionPointObject  = cO.handList[j].fingerList[i];
						
						ballList[i+j*5].visible = true;	
						ballList[i+j*5].position  = pt.position;
						ballList[i+j*5].getChildAt(0).material.color = 0x00FF00; //green
						ballList[i+j*5].getChildAt(0).material.lightPicker = lightPicker;
						
						// ball shadow
						wballList[i+j*5].visible = true;	
						wballList[i+j*5].position  = pt.palmplane_position;
						
						if (pt.fingertype == "thumb")   
						{
							ballList[i+j*5].getChildAt(0).material.color = 0xFF0000; //red
							ballList[i + j * 5].getChildAt(0).material.lightPicker = lightPicker;
						}

						//if (pt.fingertype == "index") //yellow // blue
						//if (pt.fingertype == "middle") 	//orange
						//if (pt.fingertype == "ring")  //pink
						//if (pt.fingertype == "pinky") // green
				}
			}
			
			/////////////////////////////////////////////////////////////////////////////////
			// draw palm data 
			
			var palm:MotionPointObject = cO.handList[j].palm;
			
			if((palmList[j])&&(ringList[j]))
			{
				var d:int = 20;
				var v0:Vector3D = new Vector3D(palm.position.x * 1, palm.position.y * 1, palm.position.z * 1);
				var v1:Vector3D = new Vector3D(palm.direction.x * d, palm.direction.y * d, palm.direction.z * d);
				var v2:Vector3D = new Vector3D(palm.normal.x*d, palm.normal.y*d, palm.normal.z*d);
				//var v1 = new Vector3D(v.x,v.y,v.y);
				//var v2 = new Vector3D(100,100,100);
				var v02:Vector3D = v0.add(v2);
				var v01:Vector3D = v0.add(v1);
				
				//lines.addSegment(new LineSegment(v0, v02, 0xFF0000, 0xFF0000, 1));
				//lines.addSegment(new LineSegment(v0, v01, 0xFF0000, 0xFF0000, 1));
				
					//draw palm ring
					var r:Number = cO.handList[j].sphereRadius; //GW radius not leap
					//var r2:Number = 0.3*r;
					
					//ringList[j].
					
					
					// remove segments
					//ringList[j].removeAllSegments();
					
					for (var theta0:Number = 0; theta0 < 360; theta0 += step) 
					{
						var vv1:Vector3D = new Vector3D(r * Math.cos(theta0), 0, r * Math.sin(theta0));
						var vv2:Vector3D = new Vector3D(r * Math.cos(theta0 + step), 0, r * Math.sin(theta0 + step));
						
						//var vv12 = new Vector3D(r2*Math.cos(theta0), 0, r2*Math.sin(theta0));
						//var vv22 = new Vector3D(r2*Math.cos(theta0+step), 0, r2*Math.sin(theta0+step));
						
						//ringList[j].addSegment(new LineSegment(vv1, vv2, 0xFFFFFF, 0xFFFFFF, 1));
					}
					
					var rotX:Number = RAD_DEG * Math.asin(palm.normal.x);
					//var rotY:Number = RAD_DEG*Math.asin(palm.normal.y);
					var rotZ:Number = RAD_DEG*Math.asin(palm.normal.z);
					var rotXd:Number = RAD_DEG*Math.asin(palm.direction.x);
					
					ringList[j].visible = true;
					ringList[j].rotateTo(-rotZ, 0, rotX);
					ringList[j].position = palm.position;
					
					palmList[j].visible = true;
					palmList[j].position = cO.handList[j].position; 
					palmList[j].rotateTo(-rotZ, 0, rotX);
					//palmList[j].rotate(new Vector3D(0, 1, 0), rotXd)
				}
				/////////////////////////////////////////////////////////////////////////////////////////
			
			}
		}
			
		
		private function drawInteractionPoints():void
		{
	
			// draw interaction points
			for ( i = 0; i < cO.iPointArray.length; i++) 
			{
				//trace("ipoint", cO.iPointArray.length );
				
				//trace("ipoint",i,cO.iPointArray[i].position );
				if (iballList[i]) 
				{
					iballList[i].visible = true;	
					iballList[i].position  = cO.iPointArray[i].position;
					
					
					
					if (cO.iPointArray[i].type == "pinch") 
					{
						//trace("pinch");
						iballList[i].getChildAt(0).material.color = 0x00FFFF; //orange 0xE3716B
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					if (cO.iPointArray[i].type == "push") //pin
					{
						//trace("push"); 
						iballList[i].getChildAt(0).material.color = 0xFFFF00; // yellow
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
						
					}
					if (cO.iPointArray[i].type == "trigger") 
					{
						//trace("trigger");
						iballList[i].getChildAt(0).material.color = 0xc44dbe; //pink
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					if (cO.iPointArray[i].type == "hook") 
					{
						//trace("hook");
						iballList[i].getChildAt(0).material.color = 0x0000FF; //blue
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					if (cO.iPointArray[i].type == "tool") 
					{
						//trace("tool");
						iballList[i].getChildAt(0).material.color = 0xFFFF00; //
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					if (cO.iPointArray[i].type == "finger_average") 
					{
						//trace("fav");
						iballList[i].getChildAt(0).material.color = 0x000000; //black
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					if (cO.iPointArray[i].type == "palm") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					
					if (cO.iPointArray[i].type == "finger") 
					{
						//trace("finger",cO.iPointArray[i].position.x,cO.iPointArray[i].position.y);
						iballList[i].getChildAt(0).material.color = 0x00FF00; //green
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					
					if (cO.iPointArray[i].type == "thumb") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xFF0000; //red
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
					
					if (cO.iPointArray[i].type == "frame") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xE3716B; //salmon pink
						iballList[i].getChildAt(0).material.lightPicker = lightPicker;
					}
				}	
				
				
				if (iringList[i]) 
				{
					iringList[i].visible = true;	
					iringList[i].position  = cO.iPointArray[i].position;
					
					var segset:SegmentSet = iringList[i].getChildAt(0)
					var s:Number = 20 * DEG_RAD;
					var r0:Number = 6;
					var t:Number = 0
					var vv1:Vector3D;
					var vv2:Vector3D;
					
					if (cO.iPointArray[i].type == "pinch") 
					{
						//trace("pinch");
						r0 = 8
						//iringList[i].getChildAt(0).material.color = 0x00FFFF; //orange 0xE3716B
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0x00FFFF, 0x00FFFF, 2));
						}
						
					}
					if (cO.iPointArray[i].type == "push") //pin
					{
						//trace("push"); 
						//iringList[i].getChildAt(0).material.color = 0xFFFF00; // yellow
						r0 = 9
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xFFFF00, 0xFFFF00, 2));
						}
						
						
					}
					if (cO.iPointArray[i].type == "trigger") 
					{
						//trace("trigger");
						//iringList[i].getChildAt(0).material.color = 0xc44dbe; //pink
						r0 = 10
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xc44dbe, 0xc44dbe, 2));
						}
					}
					if (cO.iPointArray[i].type == "hook") 
					{
						//trace("hook");
						//iringList[i].getChildAt(0).material.color = 0x0000FF; //blue
						r0 = 12
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0x0000FF, 0x0000FF, 2));
						}
					}
					if (cO.iPointArray[i].type == "tool") 
					{
						//trace("tool");
						//iringList[i].getChildAt(0).material.color = 0xFFFF00; //
					}
					
					
					if (cO.iPointArray[i].type == "finger_average") 
					{
						//trace("fav");
						r0 = 6;
						//trace(iringList[i].getChildAt(0).getSegment(0).color0 = 0x000000);
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0x000000, 0x000000, 2));
						}
						
					}
					if (cO.iPointArray[i].type == "palm") 
					{
						//trace("palm");
						r0 = 6;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xFFFFFF, 0xFFFFFF, 2));
						}
					}
					
					
					
					
					if (cO.iPointArray[i].type == "finger") 
					{
						//trace("palm");
						r0 = 5;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0x00FF00, 0x00FF00, 2));
						}
					}
					
					if (cO.iPointArray[i].type == "thumb") 
					{
						//trace("palm");
						r0 = 8;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xFF0000, 0xFF0000, 2));
						}
					}
					
					if (cO.iPointArray[i].type == "frame") 
					{
						//trace("palm");
						r0 = 12;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for ( t = 0; t < 360; t += s) 
						{
							 vv1 = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							 vv2 = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xE3716B, 0xE3716B, 2));
						}
					}		
				}
				
			}	
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		//ip draw cluster
		private function drawClusterData():void
		{
			trace("draw cluster data" );
			clines.visible = true;
			clines.removeAllSegments();
			
			var ipn:uint = cO.iPointArray.length;
			
			trace(ipn);
			
			//cluster web
			for (var i:int = 0; i < ipn; i++) 
			{	
				for (var j:int = 0; j < ipn; j++) 
				{
					if (i != j) clines.addSegment(new LineSegment(cO.iPointArray[i].position,cO.iPointArray[j].position, 0xFFAE1F, 0xFFAE1F, 2));
				}
			}
			
			// cluster center
			cballList[0].visible = true;
			cballList[0].position = new Vector3D(cO.x, cO.y, cO.z)
			
			//trace(this.cO.x,this.cO.x - this.cO.width);
			
			//cluster box
			var v1x:Vector3D =  new Vector3D (cO.x -(cO.width * 0.5), cO.y, cO.z);
			var v2x:Vector3D =  new Vector3D (cO.x + (cO.width * 0.5), cO.y, cO.z);
			var v1y:Vector3D =  new Vector3D (cO.x, cO.y - (cO.height * 0.5), cO.z);
			var v2y:Vector3D =  new Vector3D (cO.x, cO.y + (cO.height* 0.5),cO.z);
			var v1z:Vector3D =  new Vector3D (cO.x, cO.y, cO.z - (cO.length * 0.5));
			var v2z:Vector3D =  new Vector3D (cO.x, cO.y, cO.z + (cO.length * 0.5));
			
			clines.addSegment(new LineSegment(v1x, v2x , 0xFFFF33, 0xFFFF33, 2));
			clines.addSegment(new LineSegment(v1y, v2y , 0xFFFF33, 0xFFFF33, 2));
			clines.addSegment(new LineSegment(v1z, v2z , 0xFFFF33, 0xFFFF33, 2));
		}
		
		private function drawGestureEvents():void
		{
			var period:int = 10;
			
			if (this.cO.history.length > period)
			{
			for (var h:int = 0; h < period; h++) 
			{
				if (this.cO.history[h])
				{
				var gpn:uint = this.cO.history[h].gPointArray.length
				
					//gesture points
					for (var i:int = 0; i < gpn; i++) 
					{	
						if (gballList[i]) 
						{
							gballList[i].visible = true;	
							gballList[i].position  = cO.history[h].gPointArray[i].position;
							
							// SIDE TAP 
							if (cO.history[h].gPointArray[i].type == "x tap") {
								gballList[i].getChildAt(0).material.color = 0xFFFF00;
								trace("x tap ball");
							}
							// KEY TAP
							if (cO.history[h].gPointArray[i].type == "y tap") {
								gballList[i].getChildAt(0).material.color = 0xFF0000;
								trace("y tap ball");
							}
							// SCREEN TAP
							if (cO.history[h].gPointArray[i].type == "z tap") {
								gballList[i].getChildAt(0).material.color = 0x00FFFF;
								trace("z tap ball");
							}
							
							// HOLD GESTURE POINT
							if (cO.history[h].gPointArray[i].type == "hold") {
								gballList[i].getChildAt(0).material.color = 0x0000FF;
								trace("hold ball");
							}
						}
						
					}
				}
			}
			}
			
		}
		
		
		public function updateDisplay():void
		{			
			if (drawHands) {
				clearHand();
				drawHand();
			}
			//if (drawPoints) drawInteractionPoints();
			//if (drawClusters) 
				//drawClusterData();
			//if (drawGestures) drawGestureEvents();
		}
		

	}
}
