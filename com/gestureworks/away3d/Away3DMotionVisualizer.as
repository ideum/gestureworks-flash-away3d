package com.gestureworks.away3d
{
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
	
	
	public class Away3DMotionVisualizer extends ObjectContainer3D
	{
		private var ts:TouchSprite;
		
		private var lines:SegmentSet;
		private var vlines:SegmentSet;
		private var flines:SegmentSet;
		private var glines:SegmentSet;
		private var clines:SegmentSet;
		
		private var seg:SegmentSet;
		
		private var pvector:LineSegment;
		private var v0:Vector3D;
		private var v1:Vector3D;
		
		private var ballList:Array = new Array();
		private var wballList:Array = new Array();
		private var iballList:Array = new Array();
		private var iringList:Array = new Array();
		private var kballList:Array = new Array();
		private var palmList:Array = new Array();
		private var ringList:Array = new Array();
		private var cballList:Array = new Array();
		private var gballList:Array = new Array();
		
		//private var grid:WireframeAxesGrid;
		private var RAD_DEG:Number = 180/Math.PI
		private var DEG_RAD:Number = Math.PI / 180; 
		
		public var cO:ClusterObject;
		public var trO:TransformObject;
		
		var step:Number = 10*DEG_RAD;
		
		public function Away3DMotionVisualizer():void
		{
			trace("auto init 3d vis", ts);
			//ts = t_s;
		}
		
		public function init():void 
		{
			trace("init 3d vis");
			
			//cO = ts.cO;
			//trO = ts.trO;
			
			//////////////////////////////////////////////////////////////////////
			// create hand object
			//////////////////////////////////////////////////////////////////////
			
			var sg2:SphereGeometry = new SphereGeometry(2);
			var sg4:SphereGeometry = new SphereGeometry(4);
			var sg6:SphereGeometry = new SphereGeometry(6);
			var sg8:SphereGeometry = new SphereGeometry(8);
			var sg10:SphereGeometry = new SphereGeometry(10);
				
			// fingertips	
			for (var i:int = 0; i < 12; i++) 
			{
				var sMat:ColorMaterial = new ColorMaterial(0x006600, 0.6);
					sMat.alphaBlending = true;
				var smesh:Mesh = new Mesh(sg4, sMat);
				var ball:ObjectContainer3D = new ObjectContainer3D();
					ball.addChild(smesh);
					ballList.push(ball);
				this.addChild(ball);
			}
			
			// finger plane projections (12)
			// knuckle points ()
			var sMat2 = new ColorMaterial(0xFFFFFF,0.4);
				sMat2.alphaBlending = true;
			
			for (var i:int = 0; i < 14; i++) 
			{
				var wsmesh:Mesh = new Mesh(sg2, sMat2);
				var wball:ObjectContainer3D = new ObjectContainer3D();
					wball.addChild(wsmesh);
					wballList.push(wball);
				this.addChild(wball);
			}
			
			// palm plane
			for (var i:int = 0; i < 2; i++) 
			{
				var plane:PlaneGeometry = new PlaneGeometry(180, 220, 1, 1, true, true);
				var mat:ColorMaterial = new ColorMaterial(0xFFFFFF, 0.1);
					mat.bothSides = true;
					mat.alphaBlending = true;
					//mat.blendMode = BlendMode.ADD;
				var palmplane:Mesh = new Mesh(plane, mat);	
					palmList.push(palmplane);
				this.addChild(palmplane);
				
				// palm ring
				var ring:SegmentSet = new SegmentSet();
					ringList.push(ring);
				this.addChild(ring);
			}
			
			//
			
			lines = new SegmentSet();
			addChild(lines);
			
			// finger vectors
			vlines = new SegmentSet();
			addChild(vlines);
			// finger lines
			flines = new SegmentSet();
			addChild(flines);
			// ghost finger lines
			glines = new SegmentSet();
			//glines.alphaBlending = true;
			addChild(glines);
			
			

			for (var i:int = 0; i < 10; i++) 
			{
					vlines.addSegment(new LineSegment(new Vector3D(0, 0, 0), new Vector3D(100, 100, 100), 0xFFFF33, 0xFFFF33, 2));
					flines.addSegment(new LineSegment(new Vector3D(0, 0, 0), new Vector3D(100, 100, 100), 0xFFFF33, 0xFFFF33, 2));
					glines.addSegment(new LineSegment(new Vector3D(0, 0, 0), new Vector3D(100, 100, 100), 0xFFFF33, 0xFFFF33, 2));
			}
			
			for (var i:int = 0; i < 4; i++) 
			{
					lines.addSegment(new LineSegment(new Vector3D(0, 0, 0), new Vector3D(100, 100, 100), 0xFFFF33, 0xFFFF33, 2));
			}
			

			//seg = new SegmentSet;
				//seg.addSegment(new LineSegment(new Vector3D(0, 0, 0), new Vector3D(100, 100, 100), 0xFFFF33, 0xFFFF33, 2));
			//addChild(seg);
			

			// INTERACTION POINT///////////////////////////////////////////////////////////////////////////
				for (var i:int = 0; i < 20; i++) 
				{
					var iMat:ColorMaterial = new ColorMaterial(0x006600, 1);
					var ismesh:Mesh = new Mesh(sg2, iMat);
					var iball:ObjectContainer3D = new ObjectContainer3D();
						iball.addChild(ismesh);
						iballList.push(iball);
					this.addChild(iball);
				}
				// interative point ring
				for (var i:int = 0; i < 20; i++) 
				{
					var iring:ObjectContainer3D = new ObjectContainer3D();
					var ring0:SegmentSet = new SegmentSet();
					iring.addChild(ring0);
						iringList.push(iring);
					this.addChild(iring);
				}
				
			
			//CLUSTER /////////////////////////////////////////////////////////////////
			var iMat:ColorMaterial = new ColorMaterial(0xFFAE1F, 0.8);
				var ismesh:Mesh = new Mesh(sg6, iMat);
				var cball:ObjectContainer3D = new ObjectContainer3D();
					cball.addChild(ismesh);
					cballList.push(cball);
				this.addChild(cball);
				
			// cluster lines
			clines = new SegmentSet();
			this.addChild(clines);	
			
			
			//GESTURE////////////////////////////////////////////////////////////////////
			for (var i:int = 0; i < 10; i++) 
			{
				var iMat:ColorMaterial = new ColorMaterial(0x6666FF, 0.6);
				var ismesh:Mesh = new Mesh(sg10, iMat);
				var gball:ObjectContainer3D = new ObjectContainer3D();
					gball.addChild(ismesh);
					gballList.push(gball);
				this.addChild(gball);
			}
		}

		
	
		private function clearHand():void
		{
			for (var i:int = 0; i < ballList.length; i++)
				{
					ballList[i].x = 0;
					ballList[i].y = 0;
					ballList[i].z = 0;
					ballList[i].visible = false;
				}
				
				for (var i:int = 0; i < wballList.length; i++)
				{
					wballList[i].x = 0;
					wballList[i].y = 0;
					wballList[i].z = 0;
					wballList[i].visible = false;
				}
				
				for (var i:int = 0; i < kballList.length; i++)
				{
					kballList[i].x = 0;
					kballList[i].y = 0;
					kballList[i].z = 0;
					kballList[i].visible = false;
				}
				
				for (var i:int = 0; i < iballList.length; i++)
				{
					iballList[i].x = 0;
					iballList[i].y = 0;
					iballList[i].z = 0;
					iballList[i].visible = false;
				}
				
				for (var i:int = 0; i < gballList.length; i++)
				{
					gballList[i].x = 0;
					gballList[i].y = 0;
					gballList[i].z = 0;
					gballList[i].visible = false;
				}
				
				for (var i:int = 0; i < iringList.length; i++)
				{
					iringList[i].x = 0;
					iringList[i].y = 0;
					iringList[i].z = 0;
					iringList[i].visible = false;
					iringList[i].getChildAt(0).removeAllSegments();
				}
				
				for (var i:int = 0; i < palmList.length; i++)
				{
					palmList[i].visible = false;
					ringList[i].visible = false;
				}
				
				
				vlines.visible = false;
				flines.visible = false;
				glines.visible = false;
				lines.visible = false;
				cballList[0].visible = false;
				
				//vlines.removeAllSegments();
				//flines.removeAllSegments();
				//glines.removeAllSegments();
				//lines.removeAllSegments();
				//seg.removeAllSegments();
				
				//trace("seg index",vlines.numChildren,flines.numChildren,glines.numChildren)
				
				for (var i:int = 0; i < 10; i++) 
				{
					//vlines.getSegment(i).dispose;
					vlines.removeSegmentByIndex(i);
					flines.removeSegmentByIndex(i);
					glines.removeSegmentByIndex(i);
				}
				
				for (var i:int = 0; i < 4; i++) 
				{
					lines.removeSegmentByIndex(i);
				}
				
				/*
				for (var theta0:Number = 0; theta0 < 360; theta0 += step) 
					{
						var index:int = theta0/step
						ringList[0].removeSegmentByIndex(index);
						ringList[1].removeSegmentByIndex(index);
					}
				*/
		}
		
		
		private function drawHand():void
		{
			//trace("test", cO.motionArray.length,ballList.length);
			vlines.visible = true;
			flines.visible = true;
			glines.visible = true;
			lines.visible = true;			
		

			var hn = cO.handList.length;
			
			for (var j:int = 0; j < hn ; j++) 
			{
			var hand:HandObject = cO.handList[j];
		
				
				var n = 10+j //(hn*5 + (j+1));

				//draw fav projection
				wballList[n].visible = true;	
				wballList[n].position  = cO.handList[j].projectedFingerAveragePosition;
			
			
			for (var i:int = 0; i < cO.handList[j].fingerList.length; i++) 
			{
				
				
				
				if (ballList[i+j*5]) 
				{
					////////////////////////////////////////////////////////////////////////////
					// draw fingers
					var pt  = cO.handList[j].fingerList[i];
						
						ballList[i+j*5].visible = true;	
						ballList[i+j*5].position  = pt.position;
						ballList[i+j*5].getChildAt(0).material.color = 0x00FF00; //green
						
						// ball shadow
						wballList[i+j*5].visible = true;	
						wballList[i+j*5].position  = pt.palmplane_position;
						
						// finger vector
						var f:Number = 30;
						var vd:Vector3D = new Vector3D (f*pt.direction.x, f*pt.direction.y, f*pt.direction.z);
						var v1d:Vector3D = pt.position;
						var v000:Vector3D = vd.add(v1d);
						
						
						//vlines.addSegment(new LineSegment(v1d, v000, 0xFFFFFF, 0xFFFFFF, 2));
						//vlines.getSegment(i + j * 5).updateSegment(v1d, v000,new Vector3D(0,0,0), 0xFFFFFF, 0xFFFFFF, 2);
						//flines.getSegment(i + j * 5).updateSegment(cO.handList[j].position, v1d, new Vector3D(0,0,0),0xFFFFFF, 0xFFFFFF, 3);
						//glines.getSegment(i + j * 5).updateSegment(cO.handList[j].palm.position, pt.palmplane_position, new Vector3D(0, 0, 0), 0xFFFFFF, 0xFFFFFF, 1);
						
						vlines.addSegment(new LineSegment(v1d, v000, 0xFFFFFF, 0xFFFFFF, 2));
						flines.addSegment(new LineSegment(cO.handList[j].position, v1d,0xFFFFFF, 0xFFFFFF, 3));
						glines.addSegment(new LineSegment(cO.handList[j].palm.position, pt.palmplane_position, 0xFFFFFF, 0xFFFFFF, 1));
						
						
						//trace(cO.motionArray[i].palmplane_position.x,cO.motionArray[i].palmplane_position.y,cO.motionArray[i].palmplane_position.z);

						if (pt.fingertype == "thumb")  ballList[i+j*5].getChildAt(0).material.color = 0xFF0000; //red
						//if (pt.fingertype == "index") //yellow // blue
						//if (pt.fingertype == "middle") 	//orange
						//if (pt.fingertype == "ring")  //pink
						//if (pt.fingertype == "pinky") // green
				}
				
				
				
			}
			
			
											/////////////////////////////////////////////////////////////////////////////////
											// draw palm data 
											
											var palm = cO.handList[j].palm;
											
											
											
											if((palmList[j])&&(ringList[j]))
											{
												palmList[j].visible = true;
												palmList[j].position = cO.handList[j].position; 
												
												var d:int = 20;
												var v0 = new Vector3D(palm.position.x * 1, palm.position.y * 1, palm.position.z * 1);
												var v1 = new Vector3D(palm.direction.x * d, palm.direction.y * d, palm.direction.z * d);
												var v2 = new Vector3D(palm.normal.x*d, palm.normal.y*d, palm.normal.z*d);
												//var v1 = new Vector3D(v.x,v.y,v.y);
												//var v2 = new Vector3D(100,100,100);
												var v02 = v0.add(v2);
												var v01 = v0.add(v1);
												
												lines.addSegment(new LineSegment(v0, v02, 0xFF0000, 0xFF0000, 5));
												lines.addSegment(new LineSegment(v0, v01, 0xFF0000, 0xFF0000, 5));
												
												
												
													//draw palm ring
													var r:Number = cO.handList[j].sphereRadius; //GW radius not leap
													//var r2:Number = 0.3*r;
													
													
													// remove segments
													ringList[j].removeAllSegments();
													
													for (var theta0:Number = 0; theta0 < 360; theta0 += step) 
													{
														var vv1 = new Vector3D(r*Math.cos(theta0), 0, r*Math.sin(theta0));
														var vv2 = new Vector3D(r * Math.cos(theta0 + step), 0, r * Math.sin(theta0 + step));
														
														//var vv12 = new Vector3D(r2*Math.cos(theta0), 0, r2*Math.sin(theta0));
														//var vv22 = new Vector3D(r2*Math.cos(theta0+step), 0, r2*Math.sin(theta0+step));
														
														ringList[j].addSegment(new LineSegment(vv1, vv2, 0xFFFFFF, 0xFFFFFF, 1));
													}
													
													var rotX:Number = RAD_DEG * Math.asin(palm.normal.x);
													//var rotY:Number = RAD_DEG*Math.asin(palm.normal.y);
													var rotZ:Number = RAD_DEG*Math.asin(palm.normal.z);
													var rotXd:Number = RAD_DEG*Math.asin(palm.direction.x);
													
													ringList[j].visible = true;
													ringList[j].rotateTo(-rotZ, 0, rotX);
													ringList[j].position = palm.position;
													
													palmList[j].rotateTo(-rotZ, 0, rotX);
													//palmList[j].rotate(new Vector3D(0, 1, 0), rotXd)
												}
												/////////////////////////////////////////////////////////////////////////////////////////
			
			}
		}
			
		
		private function drawInteractionPoints():void
		{
	
			// draw interaction points
			for (var i:int = 0; i < cO.iPointArray.length; i++) 
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
					}
					if (cO.iPointArray[i].type == "push") //pin
					{
						//trace("push"); 
						iballList[i].getChildAt(0).material.color = 0xFFFF00; // yellow
					}
					if (cO.iPointArray[i].type == "trigger") 
					{
						//trace("trigger");
						iballList[i].getChildAt(0).material.color = 0xc44dbe; //pink
					}
					if (cO.iPointArray[i].type == "hook") 
					{
						//trace("hook");
						iballList[i].getChildAt(0).material.color = 0x0000FF; //blue
					}
					if (cO.iPointArray[i].type == "tool") 
					{
						//trace("tool");
						iballList[i].getChildAt(0).material.color = 0xFFFF00; //
					}
					if (cO.iPointArray[i].type == "finger_average") 
					{
						//trace("fav");
						iballList[i].getChildAt(0).material.color = 0x000000; //black
					}
					if (cO.iPointArray[i].type == "palm") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xFFFFFF; //black
					}
					
					if (cO.iPointArray[i].type == "finger") 
					{
						//trace("finger",cO.iPointArray[i].position.x,cO.iPointArray[i].position.y);
						iballList[i].getChildAt(0).material.color = 0x00FF00; //green
					}
					
					if (cO.iPointArray[i].type == "thumb") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xFF0000; //red
					}
					
					if (cO.iPointArray[i].type == "frame") 
					{
						//trace("palm");
						iballList[i].getChildAt(0).material.color = 0xE3716B; //salmon pink
					}
				}	
				
				
				if (iringList[i]) 
				{
					iringList[i].visible = true;	
					iringList[i].position  = cO.iPointArray[i].position;
					
					var segset = iringList[i].getChildAt(0)
					var s:Number = 20 * DEG_RAD;
					var r0:Number = 6;
					
					if (cO.iPointArray[i].type == "pinch") 
					{
						//trace("pinch");
						r0 = 8
						//iringList[i].getChildAt(0).material.color = 0x00FFFF; //orange 0xE3716B
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0x00FFFF, 0x00FFFF, 2));
						}
						
					}
					if (cO.iPointArray[i].type == "push") //pin
					{
						//trace("push"); 
						//iringList[i].getChildAt(0).material.color = 0xFFFF00; // yellow
						r0 = 9
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xFFFF00, 0xFFFF00, 2));
						}
						
						
					}
					if (cO.iPointArray[i].type == "trigger") 
					{
						//trace("trigger");
						//iringList[i].getChildAt(0).material.color = 0xc44dbe; //pink
						r0 = 10
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xc44dbe, 0xc44dbe, 2));
						}
					}
					if (cO.iPointArray[i].type == "hook") 
					{
						//trace("hook");
						//iringList[i].getChildAt(0).material.color = 0x0000FF; //blue
						r0 = 12
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
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
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0x000000, 0x000000, 2));
						}
						
					}
					if (cO.iPointArray[i].type == "palm") 
					{
						//trace("palm");
						r0 = 6;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xFFFFFF, 0xFFFFFF, 2));
						}
					}
					
					
					
					
					if (cO.iPointArray[i].type == "finger") 
					{
						//trace("palm");
						r0 = 5;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0x00FF00, 0x00FF00, 2));
						}
					}
					
					if (cO.iPointArray[i].type == "thumb") 
					{
						//trace("palm");
						r0 = 8;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
							segset.addSegment(new LineSegment(vv1, vv2, 0xFF0000, 0xFF0000, 2));
						}
					}
					
					if (cO.iPointArray[i].type == "frame") 
					{
						//trace("palm");
						r0 = 12;
						//iringList[i].getChildAt(0).material.color = 0xFFFFFF; //black
						
						for (var t:Number = 0; t < 360; t += s) 
						{
							var vv1:Vector3D = new Vector3D(r0*Math.cos(t), 0, r0*Math.sin(t));
							var vv2:Vector3D = new Vector3D(r0 * Math.cos(t + s), 0, r0 * Math.sin(t + s));	
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
			//trace("draw cluster data" );
			clines.visible = true;
			clines.removeAllSegments();
			
			var ipn = cO.iPointArray.length
			
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
			var v1x =  new Vector3D (cO.x -(cO.width * 0.5), cO.y, cO.z);
			var v2x =  new Vector3D (cO.x + (cO.width * 0.5), cO.y, cO.z);
			var v1y =  new Vector3D (cO.x, cO.y - (cO.height * 0.5), cO.z);
			var v2y =  new Vector3D (cO.x, cO.y + (cO.height* 0.5),cO.z);
			var v1z =  new Vector3D (cO.x, cO.y, cO.z - (cO.length * 0.5));
			var v2z =  new Vector3D (cO.x, cO.y, cO.z + (cO.length * 0.5));
			
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
				var gpn = this.cO.history[h].gPointArray.length
				
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
				// draw 3d hand (raw touch)
				
				clearHand();
				drawHand();
				
				// draw ips and cluster data
				//drawInteractionPoints();
				//drawClusterData();
				
				// draw gesture event data
				//drawGestureEvents();
				
				
		}
		

	}
}
