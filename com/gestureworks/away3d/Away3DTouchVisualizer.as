package com.gestureworks.away3d
{
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.utils.*;
	import com.gestureworks.cml.utils.ArrayUtils;
	import com.gestureworks.cml.utils.List;
	import com.gestureworks.core.*;
	import com.gestureworks.objects.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class Away3DTouchVisualizer extends ObjectContainer3D
	{
		public var maxPoints:int = 10;
		public var maxTrails:int = 60;
		
		private var ts:TouchSprite;
		private var view:View3D;
		private var stage:Stage;		
		private var lightPicker:StaticLightPicker;
		private var manager:Away3DTouchManager;
		
		private var points:Array;
		private var trails:Array;		

		private var geom:SphereGeometry;		
		private var sphereMat:ColorMaterial;
		private var trailMat:ColorMaterial;
	
		public function Away3DTouchVisualizer(view3D:View3D, stage2D:Stage, lightPick:StaticLightPicker) 
		{
			super();
			
			view = view3D;
			stage = stage2D;
			lightPicker = lightPick;
			
			points = new Array;
			trails = new Array;
			
			geom = new SphereGeometry;
			geom.radius = 15;
			geom.segmentsH = 50;
			geom.segmentsW = 50;
			
			manager = new Away3DTouchManager(view);
			sphereMat = new ColorMaterial;
			sphereMat.alphaBlending = true;
			sphereMat.alpha = 1;
			sphereMat.color = 0xFFAE1F;
			sphereMat.lightPicker = lightPicker;
			sphereMat.smooth = true;
			
			// preload touch points
			for (var i:int = 0; i < maxPoints; i++) { 
				var m:Mesh = new Mesh(geom);
				m.material = sphereMat;
				points.push(m);
			}			
			
			// preload touch trails
			for (var i:int = 0; i < maxPoints; i++) { 
				trails.push(new Array());				
				for (var j:int = 0; j < maxTrails; j++) {
					var m:Mesh = new Mesh(geom);	
					trailMat = new ColorMaterial();
					trailMat.alphaBlending = true;
					trailMat.alpha = 1;
					trailMat.color = 0x9BD6EA;
					trailMat.lightPicker = lightPicker;
					trailMat.smooth = true;	
					m.material = trailMat;
					trails[i].push(m);					
				}
			}
			
			ts = new TouchSprite();
			ts.graphics.beginFill(0xFFFFFF, 0);
			ts.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			ts.graphics.endFill();
			ts.gestureList = { "n-drag":true, "n-tap":true };
			stage.addChild(ts);
						
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd); 
		}
				
		private function onTouchBegin(e:TouchEvent):void 
		{
			
		}		

		private function onTouchMove(e:TouchEvent):void 
		{
		}
		
		private function onTouchEnd(e:TouchEvent):void 
		{

		}		
		
	
		
		public function update():void
		{
			var i:int;
			var j:int;
			var newPt:Point;
			var histLength:int;
			var pt:PointObject;
			var n:int = (ts.N <= maxPoints) ? ts.N : maxPoints;			
			var m:Mesh;
			var ptData:Point;
			var num:int;
			
			// POINTS
			
			// clear
			for (i = 0; i < maxPoints; i++) {
				m = points[i];
				if (contains(m))
					removeChild(m);
			}				
			
			// add
			for (i = 0; i < n; i++) {
				ptData = manager.convertScreenData(ts.pointArray[i].x, ts.pointArray[i].y);			
				m = points[i];
				m.x = ptData.x;
				m.y = ptData.y;
				addChild(m);
			}				
			
			
			// TRAILS	
			
			// fade out
			for (i = 0; i < maxPoints; i++) {
				for (j = 0; j < trails[i].length; j++) {					
					trails[i][j].material.alpha -= .1;
					if (trails[i][j].material.alpha <= 0) {
						if (contains(trails[i][j])) {
							removeChild(trails[i][j]);
						}
					}
				}
			}	
			
			// add
			for (i = 0; i < n; i++) {			
				pt = ts.cO.pointArray[i];								
				
				histLength = pt.history.length;
				num = (histLength <= maxTrails) ? histLength : maxTrails;
				
				for (j = histLength-1; j >= 0; j--) {	
					newPt = manager.convertScreenData(pt.history[j].x, pt.history[j].y);
					trails[i][j].x = newPt.x;
					trails[i][j].y = newPt.y;				
					trails[i][j].z = j*50+50;					
					trails[i][j].material.alpha = 1 - (1 / 60) * j;
					addChild(trails[i][j]);
				}
			}			
			
		}	
	
	}
}