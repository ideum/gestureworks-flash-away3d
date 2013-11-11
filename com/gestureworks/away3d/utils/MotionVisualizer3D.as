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
	
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.HandObject;
	
	public class MotionVisualizer3D extends ObjectContainer3D
	{
		//////////////////////////////////////////////////////////////////////
		// public
		//////////////////////////////////////////////////////////////////////	
		
		public var drawHands:Boolean = true;
		public var drawPoints:Boolean = true;
		public var drawClusters:Boolean = true;
		public var drawGestures:Boolean = true;
		
		public var cO:ClusterObject;
		public var trO:TransformObject;
		public var tiO:TimelineObject;
		
		public var lightPicker:StaticLightPicker;
		
		//////////////////////////////////////////////////////////////////////
		// private
		//////////////////////////////////////////////////////////////////////	
		private var ts:TouchSprite;
		
		// TODO: CONVERT TO VECTORS
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
		private var celementList:Array = new Array();
		private var clinkList:Array = new Array();
		private var cvectorList:Array = new Array();
		// gesture
		private var gballList:Array = new Array();
		
		
		//EVENTS //TODO: CONVERT TO VECTORS
		private var	gestureEventArray:Array = new Array();
		//private var	gesturePoinArray:Array = new Array();
		
	
		private var RAD_DEG:Number = 180/Math.PI
		private var DEG_RAD:Number = Math.PI / 180; 
		
		private var step:Number = 10 * DEG_RAD;
		private var i:uint;
		
		public function MotionVisualizer3D():void
		{
			//trace("auto init 3d visualizer", ts);
		}
		
		public function init():void 
		{
			//trace("init 3d visualizer");

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
			var cg1:CylinderGeometry = new CylinderGeometry(1, 1, 1, 2, 2, false, false, true, false);
			var cg2:CylinderGeometry = new CylinderGeometry(1, 1, 1, 2, 2, false, false, true, false);
			//// build plane
			var plane:PlaneGeometry = new PlaneGeometry(180, 220, 1, 1, true, true);
			///////////////////////////////////////////////////////////////////////////////////////
			// fingertips
			for (i = 0; i < 12; i++) 
			{
				var sMat:ColorMaterial = new ColorMaterial(0x006600, 0.6);
					sMat.alphaBlending = true;
					//sMat.lightPicker = lightPicker;
				var smesh:Mesh = new Mesh(sg4, sMat);
				var ball:ObjectContainer3D = new ObjectContainer3D();
					ball.mouseEnabled = false;
					ball.addChild(smesh);
					ballList.push(ball);
				this.addChild(ball);
			}

			// finger plane projections (12)
			// knuckle points and shadow points
			var sMat2:ColorMaterial = new ColorMaterial(0xFFFFFF,0.4);
				sMat2.alphaBlending = true;
				sMat2.lightPicker = lightPicker;
			
			// finger to palm vectors
			var sMat8:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.6);
					sMat8.alphaBlending = true;
				
				for (i = 0; i < 10; i++) 
				{
					var ksmesh:Mesh = new Mesh(cg1, sMat8);
					var finger:ObjectContainer3D = new ObjectContainer3D();
						finger.mouseEnabled = false;
						finger.addChild(ksmesh);
						fingerList.push(finger);
					this.addChild(finger);
				}
			
			//finger direction vectors
			var sMat9:ColorMaterial = new ColorMaterial(0xFFFF00, 0.6);
				sMat9.alphaBlending = true;
			
				for (i = 0; i < 10; i++) 
				{
					var smesh2:Mesh = new Mesh(cg1, sMat9);
					var vfinger:ObjectContainer3D = new ObjectContainer3D();
						vfinger.mouseEnabled = false;
						vfinger.addChild(smesh2);
						vfingerList.push(vfinger);
					this.addChild(vfinger);
				}
			// shadow balls including fav point
			for (i = 0; i < 14; i++) 
			{
				var wsmesh:Mesh = new Mesh(sg2, sMat2);
				var wball:ObjectContainer3D = new ObjectContainer3D();
					wball.mouseEnabled = false;
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
				var palmplane:Mesh = new Mesh(plane, mat);	
					palmList.push(palmplane);
				this.addChild(palmplane);
				
				var cg50:WireframeCylinder = new WireframeCylinder(50, 50, 1, 32, 16, 0xFFFFFF, 1);
					cg50.mouseEnabled = false;
					ringList.push(cg50);
				this.addChild(cg50);
			}
			

			/////////////////////////////////////////////////////////////////////////////
			// INTERACTION POINTS////////////////////////////////////////////////////////
				for (i = 0; i < 20; i++) 
				{
					var iMat1:ColorMaterial = new ColorMaterial(0x006600, 1);
						//iMat1.lightPicker = lightPicker;
					var ismesh1:Mesh = new Mesh(sg2, iMat1);
					var iball:ObjectContainer3D = new ObjectContainer3D();
						iball.mouseEnabled = false;
						iball.addChild(ismesh1);
						iballList.push(iball);
					this.addChild(iball);
					
					// interative point ring
					var cg3:WireframeCylinder = new WireframeCylinder(15, 15, 1, 16, 8, 0xFFFFFF, 0.5);
						cg3.mouseEnabled = false;
						iringList.push(cg3);
					this.addChild(cg3);
				}
				
			///////////////////////////////////////////////////////////////////////////
			//CLUSTER /////////////////////////////////////////////////////////////////
			var iMat:ColorMaterial = new ColorMaterial(0xFFFF33, 0.8);
				iMat.lightPicker = lightPicker;
				var ismesh:Mesh = new Mesh(sg6, iMat);
				var cball:ObjectContainer3D = new ObjectContainer3D();
					cball.mouseEnabled = false;
					cball.addChild(ismesh);
					celementList.push(cball);
				this.addChild(cball);
				
				
				var sMat11:ColorMaterial = new ColorMaterial(0xFFFF33, 0.8);
					sMat11.alphaBlending = true;
				
				// cluster lines
				for (i = 0; i < 3; i++) 
				{
					var smesh5:Mesh = new Mesh(cg2, sMat11);
					var cline:ObjectContainer3D = new ObjectContainer3D();
						cline.mouseEnabled = false;
						cline.addChild(smesh5);
						celementList.push(cline);
					this.addChild(cline);
				}
				
				var sMat12:ColorMaterial = new ColorMaterial(0xFFAE1F, 0.8);
					sMat12.alphaBlending = true;
				
				//cluster link lines
				for (i = 0; i < 40; i++) 
				{
					var smesh6:Mesh = new Mesh(cg2, sMat12);
					var clinkline:ObjectContainer3D = new ObjectContainer3D();
						clinkline.mouseEnabled = false;
						clinkline.addChild(smesh6);
						clinkList.push(clinkline);
					this.addChild(clinkline);
				}	
			
			/////////////////////////////////////////////////////////////////////////////
			//GESTURE////////////////////////////////////////////////////////////////////
			for (i = 0; i < 10; i++) 
			{
				var iMat0:ColorMaterial = new ColorMaterial(0x6666FF, 0.6);
					iMat0.lightPicker = lightPicker;
				var ismesh0:Mesh = new Mesh(sg10, iMat0);
				var gball:ObjectContainer3D = new ObjectContainer3D();
					gball.mouseEnabled = false;
					gball.addChild(ismesh0);
					gballList.push(gball);
				this.addChild(gball);
			}
		}

		
	
		private function clearHand():void
		{
				//fingertips
				for (i = 0; i < ballList.length; i++)
				{
					ballList[i].x = 0;
					ballList[i].y = 0;
					ballList[i].z = 0;
					ballList[i].visible = false;
				}
				//finger vectors
				for (i = 0; i <fingerList.length; i++)
				{
					fingerList[i].x = 0;
					fingerList[i].y = 0;
					fingerList[i].z = 0;
					fingerList[i].scaleZ = 100;
					fingerList[i].visible = false;
				}
				//fingertip vector
				for (i = 0; i <vfingerList.length; i++)
				{
					vfingerList[i].x = 0;
					vfingerList[i].y = 0;
					vfingerList[i].z = 0;
					vfingerList[i].scaleZ = 100;
					vfingerList[i].visible = false;
				}
				// motion point shadows
				for (i = 0; i < wballList.length; i++)
				{
					wballList[i].x = 0;
					wballList[i].y = 0;
					wballList[i].z = 0;
					wballList[i].visible = false;
				}
				// knuckle points
				for ( i = 0; i < kballList.length; i++)
				{
					kballList[i].x = 0;
					kballList[i].y = 0;
					kballList[i].z = 0;
					kballList[i].visible = false;
				}
				//palm objects
				for ( i = 0; i < palmList.length; i++)
				{
					palmList[i].visible = false;
					ringList[i].visible = false;
				}
		}
		
		private function clearInteractionPoints():void
		{
				//////////////////////////////////////////
				//interaction points
				for ( i = 0; i < iballList.length; i++)
				{
					iballList[i].x = 0;
					iballList[i].y = 0;
					iballList[i].z = 0;
					iballList[i].visible = false;
					
					iringList[i].x = 0;
					iringList[i].y = 0;
					iringList[i].z = 0;
					iringList[i].visible = false;
				}
		}
		
		private function clearCluster():void
		{
				////////////////////////////////////
				// cluster elements (points and lines)
				for ( i = 0; i < celementList.length; i++)
				{
					celementList[i].x = 0;
					celementList[i].y = 0;
					celementList[i].z = 0;
					celementList[i].visible = false;
				}
				
				for ( i = 0; i < clinkList.length; i++)
				{
					clinkList[i].x = 0;
					clinkList[i].y = 0;
					clinkList[i].z = 0;
					clinkList[i].visible = false;
				}
		}
		
		private function clearGestures():void
		{
				////////////////////////////////////	
				//gesturepoints
				for ( i = 0; i < gballList.length; i++)
				{
					gballList[i].x = 0;
					gballList[i].y = 0;
					gballList[i].z = 0;
					gballList[i].visible = false;
				}
		}
		
		
		private function drawHand():void
		{
			//trace("draw hand", cO.motionArray.length, ballList.length);
			
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
				}
				
				
				
				if (ballList[i+j*5]) 
				{
						////////////////////////////////////////////////////////////////////////////
						// draw fingers
						ballList[i+j*5].visible = true;	
						ballList[i+j*5].position  = pt.position;
						ballList[i+j*5].getChildAt(0).material.color = 0x00FF00; //green
						
						// ball shadow
						wballList[i+j*5].visible = true;	
						wballList[i+j*5].position  = pt.palmplane_position;
						
						if (pt.fingertype == "thumb")   
						{
							ballList[i+j*5].getChildAt(0).material.color = 0xFF0000; //red
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
				var v02:Vector3D = v0.add(v2);
				var v01:Vector3D = v0.add(v1);
				
				//lines.addSegment(new LineSegment(v0, v02, 0xFF0000, 0xFF0000, 1));
				//lines.addSegment(new LineSegment(v0, v01, 0xFF0000, 0xFF0000, 1));
				
					//draw palm ring
					//var r:Number = cO.handList[j].sphereRadius; //GW radius not leap

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
			//trace("ipoint", cO.iPointArray.length);
			
			// draw interaction points
			for ( i = 0; i < cO.iPointArray.length; i++) 
			{	
				//trace("ipoint",i,cO.iPointArray[i].position );
				
				if ((cO.iPointArray[i])&&(iballList[i])&&(iringList[i])) 
				{
					iballList[i].visible = true;
					iringList[i].visible = true;
					iballList[i].position  = cO.iPointArray[i].position;	
					iringList[i].position  = cO.iPointArray[i].position;
					
					if (cO.iPointArray[i].type == "pinch") 
					{
						//trace("pinch");
						iballList[i].getChildAt(0).material.color = 0x00FFFF; //orange 0xE3716B
						iringList[i].scaleX = 0.6;
						iringList[i].scaleY = 0.6;
						iringList[i].color = 0x00FFFFF;
						
					}
					if (cO.iPointArray[i].type == "push") //pin
					{
						//trace("push"); 
						iballList[i].getChildAt(0).material.color = 0xFFFF00; // yellow
						iringList[i].scaleX = 0.8;
						iringList[i].scaleY = 0.8;
						iringList[i].color = 0xFFFF00;
						
					}
					if (cO.iPointArray[i].type == "trigger") 
					{
						//trace("trigger");
						iballList[i].getChildAt(0).material.color = 0xc44dbe; //pink
						iringList[i].scaleX = 0.9;
						iringList[i].scaleY = 0.9;
						iringList[i].color = 0xc44dbe;
					}
					if (cO.iPointArray[i].type == "hook") 
					{
						//trace("hook");
						iballList[i].getChildAt(0).material.color = 0x0000FF; //blue
						iringList[i].scaleX = 1;
						iringList[i].scaleY = 1;
						iringList[i].color = 0x0000FF;
					}
					if (cO.iPointArray[i].type == "tool") 
					{
						//trace("tool");
						iballList[i].getChildAt(0).material.color = 0xFFFF00; //
						iringList[i].scaleX = 0.8;
						iringList[i].scaleY = 0.8;
						iringList[i].color = 0xFFFF00;
					}
					if (cO.iPointArray[i].type == "finger_average") 
					{
						//trace("fav");
						iballList[i].getChildAt(0).material.color = 0x000000; //black
						iringList[i].scaleX = 0.5;
						iringList[i].scaleY = 0.5;
						iringList[i].color = 0x000000;
					}
					if (cO.iPointArray[i].type == "palm") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xFFFFFF; //white
						iringList[i].scaleX = 0.5;
						iringList[i].scaleY = 0.5;
						iringList[i].color = 0xFFFFFF;
					}
					
					if (cO.iPointArray[i].type == "finger") 
					{
						//trace("finger",cO.iPointArray[i].position.x,cO.iPointArray[i].position.y);
						iballList[i].getChildAt(0).material.color = 0x00FF00; //green
						iringList[i].scaleX = 0.5;
						iringList[i].scaleY = 0.5;
						iringList[i].color = 0x00FF00;
					}
					
					if (cO.iPointArray[i].type == "thumb") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xFF0000; //red
						iringList[i].scaleX = 0.6;
						iringList[i].scaleY = 0.6;
						iringList[i].color = 0xFF0000;
					}
					
					if (cO.iPointArray[i].type == "frame") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xE3716B; //salmon pink
						iringList[i].scaleX = 1;
						iringList[i].scaleY = 1;
						iringList[i].color = 0xE3716B;
					}	
				}
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////
		//ip draw cluster
		private function drawClusterData():void
		{
			var ipn:uint = cO.iPointArray.length;
			//trace("draw cluster data",ipn);
			if(ipn){
				// cluster center
				celementList[0].visible = true;
				celementList[0].position = new Vector3D(cO.x, cO.y, cO.z)

				//cluster box //0xFFFF33, 2
				celementList[1].visible = true;
				celementList[1].position = new Vector3D(cO.x, cO.y, cO.z);
				celementList[1].lookAt(new Vector3D (10000,0,0));
				celementList[1].scaleZ = cO.width;
				//celementList[1].getChildAt(0).material.color = 0xFFFF33;
				
				celementList[2].visible = true;
				celementList[2].position = new Vector3D(cO.x, cO.y, cO.z);
				celementList[2].lookAt(new Vector3D (0,10000,0));
				celementList[2].scaleZ = cO.height;
				//celementList[2].getChildAt(0).material.color = 0xFFFF33;
				
				celementList[3].visible = true;
				celementList[3].position = new Vector3D(cO.x, cO.y, cO.z);
				celementList[3].lookAt(new Vector3D (0,0,10000));
				celementList[3].scaleZ = cO.length;
				//celementList[3].getChildAt(0).material.color = 0xFFFF33;
				
				}
				
				//cluster web
				for (var i:int = 0; i < ipn; i++) 
				{	
					// NEED THE COUNT BACK TO ELIMINATE DUPLICATES
					for (var j:int = 0; j < ipn; j++) 
					{
						if (i != j) 
						{
							//0xFFAE1F 2
							if ((clinkList[i * ipn + j])&&(cO.iPointArray[i])&&(cO.iPointArray[j]))
							{
								
								clinkList[i * ipn + j].visible = true;
								//FIND MID POINT
								clinkList[i*ipn+j].position = new Vector3D(0.5*(cO.iPointArray[i].position.x + cO.iPointArray[j].position.x), 0.5*(cO.iPointArray[i].position.y + cO.iPointArray[j].position.y) , 0.5*(cO.iPointArray[i].position.z + cO.iPointArray[j].position.z) );
								// SET LENGTH
								var dist:Number = Vector3D.distance(cO.iPointArray[i].position, cO.iPointArray[j].position);
								clinkList[i*ipn+j].scaleZ = dist;
								// POINT TO INTERACTIONPOINT
								clinkList[i * ipn + j].lookAt(cO.iPointArray[j].position);
							}
						}
					}
				}
			
			
			
	
		}
		
		private function drawGestureEvents():void
		{
			//trace("3d motion gesture events visualizer",gpn)
		
			///////////////////////////////////////////////////////////////////////
			// SHOW GESTURE POINT OBJECTS
			///////////////////////////////////////////////////////////////////////
			/*
			 *
			var period:int = 10;
			
			if (this.cO.history.length > period)
			{
			for (var h:int = 0; h < period; h++) 
			{
				if (this.cO.history[h])
				{
				var gpn:uint = this.cO.history[h].gPointArray.length
				
				//trace("3d motion gesture events visualizer", gpn)
			
					//gesture points
					for (var i:int = 0; i < gpn; i++) 
					{	
						if (gballList[i]) 
						{
							gballList[i].visible = true;	
							gballList[i].position  = cO.history[h].gPointArray[i].position;
							
							// SIDE TAP // YELLOW
							if (cO.history[h].gPointArray[i].type == "x tap") {
								gballList[i].getChildAt(0).material.color = 0xFFFF00;
								//trace("x tap ball");
							}
							// KEY TAP // RED
							if (cO.history[h].gPointArray[i].type == "y tap") {
								gballList[i].getChildAt(0).material.color = 0xFF0000;
								//trace("y tap ball");
							}
							// SCREEN TAP // GREEN
							if (cO.history[h].gPointArray[i].type == "z tap") {
								gballList[i].getChildAt(0).material.color = 0x00FFFF;
								//trace("z tap ball");
							}
							
							// HOLD GESTURE POINT // BLUE
							if (cO.history[h].gPointArray[i].type == "hold") {
								gballList[i].getChildAt(0).material.color = 0x0000FF;
								//trace("hold ball");
							}
							
							// DRAG GESTURE POINT //WHITE
							if (cO.history[h].gPointArray[i].type == "drag") {
								gballList[i].getChildAt(0).material.color = 0xFFFFFF;
								//trace("hold ball");
							}
						}
						
					}
				}
			}
			}*/
			
			////////////////////////////////////////////////////////////////////////
			// SHOW GESTURE EVENTS
			////////////////////////////////////////////////////////////////////////
			
				var scan_time:int = 60; //1000ms
				var hold_linger:int = 30;
				var tap_linger:int = 30;
				
				//trace("visulaize event frame",ts.tiO.timelineOn,ts.tiO.history.length,GestureGlobals.frameID);
				
				if(tiO){
				for (var i:uint = 0; i < scan_time; i++) 
					{
						//trace(tiO.history.length)
					if (tiO.history[i])
						{
						gestureEventArray = tiO.history[i].gestureEventArray;
						//if(gestureEventArray.length)trace("gesture event array--------------------------------------------",gestureEventArray.length);

								for (var j:uint=0; j < gestureEventArray.length; j++) 
								{
									if (gballList[j]) 
									{
										//trace(gestureEventArray[j].type, gestureEventArray[j].value.x, gestureEventArray[j].value.y, gestureEventArray[j].value.z);
										gballList[j].visible = true;	
										gballList[j].position  = new Vector3D (gestureEventArray[j].value.x,gestureEventArray[j].value.y,gestureEventArray[j].value.z);
										//trace(gballList[j].position)
										
										// y tap gesture ball //RED
										if ((gestureEventArray[j].type == "motion_ytap") && (i < tap_linger))gballList[j].getChildAt(0).material.color = 0xFF0000;
										// x tap gesture ball //YELLOW
										if ((gestureEventArray[j].type =="motion_xtap")&&(i<tap_linger))gballList[j].getChildAt(0).material.color = 0xFFFF00;
										// z tap gesture ball //GREEN
										if ((gestureEventArray[j].type =="motion_ztap")&&(i<tap_linger))gballList[j].getChildAt(0).material.color = 0x00FFFF;
										// hold gesture ball //BLUE
										if ((gestureEventArray[j].type =="motion_hold")&&(i<hold_linger))gballList[j].getChildAt(0).material.color = 0x0000FF;
									}
								}
						}
					}
				}
		}
		
		
		public function updateDisplay():void
		{			
			clearHand();
			
			
			if (drawHands) 
			{
				drawHand();
			}
			if (drawPoints) 
			{
				clearInteractionPoints()
				drawInteractionPoints();
			}
			if (drawClusters) 
			{
				clearCluster();
				drawClusterData();
			}
			if (drawGestures) 
			{
				clearGestures();
				drawGestureEvents();
			}
		}
		

	}
}
