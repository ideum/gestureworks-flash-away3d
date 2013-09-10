package com.gestureworks.away3d
{
	import away3d.events.TouchEvent3D;
	import away3d.lights.PointLight;
	import com.gestureworks.cml.away3d.elements.Sphere;
	import com.gestureworks.cml.utils.ArrayUtils;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.PointObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
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
	
	public class Away3DTouchVisualizer extends ObjectContainer3D
	{
		private var ts:TouchSprite;
		private var view:View3D;
		private var lightPicker:StaticLightPicker;
		private var stage:Stage;
		private var manager:Away3DTouchManager;
		
		private var spheres:Dictionary;
		private var trails:Array;
		private var history:Dictionary;
		private var historyArray:Array;
		private var mat:ColorMaterial;
		private var matTrails:ColorMaterial;
		private var geom:SphereGeometry;
		private var maxPoints:int = 10;
		private var maxTrails:int = 60;
		private var hist:int = 0;
	
		public function Away3DTouchVisualizer(view3D:View3D, stage2D:Stage, lightPick:StaticLightPicker) 
		{
			super();
			
			view = view3D;
			stage = stage2D;
			lightPicker = lightPick;
			
			spheres = new Dictionary(true);
			history = new Dictionary(true);
			historyArray = new Array;
			trails = new Array;
			
			manager = new Away3DTouchManager(view);
			mat = new ColorMaterial();
			mat.alphaBlending = true;
			mat.alpha = 1;
			mat.color = 0xFFAE1F;
			mat.lightPicker = lightPicker;
			mat.smooth = true;
			

			
			
			geom = new SphereGeometry;
			geom.radius = 15;
			geom.segmentsH = 50;
			geom.segmentsW = 50;
			
			for (var i:int = 0; i < maxPoints; i++) { 
				trails.push(new Array());				
				for (var j:int = 0; j < maxTrails; j++) {
					var m:Mesh = new Mesh(geom);	
				
					trails[i].push(m);

					matTrails = new ColorMaterial();
					matTrails.alphaBlending = true;
					matTrails.alpha = 1;
					matTrails.color = 0x9BD6EA;
					matTrails.lightPicker = lightPicker;
					matTrails.smooth = true;	
					m.material = matTrails;
				}
			}
			
			
			// add options to overide externally
			ts = new TouchSprite();
			ts.graphics.beginFill(0xFFFFFF, 0);
			ts.graphics.drawRect(0, 0, 1920, 1080);
			ts.graphics.endFill();
			ts.gestureList = { "n-drag":true, "n-tap":true };
			stage.addChild(ts);
						
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd); 
		}
				
		private function onTouchBegin(e:TouchEvent):void 
		{
			var m:Mesh = new Mesh(geom);
			var pt:Point = manager.convertScreenData(e.stageX, e.stageY);				
			m.x = pt.x;
			m.y = pt.y;
			m.material = mat;
			addChild(m);
			
			spheres[e.touchPointID] = m;	
			
			//trace("touch begin");						
		}		

		private function onTouchMove(e:TouchEvent):void 
		{
			var m:Mesh = spheres[e.touchPointID];
			var pt:Point = manager.convertScreenData(e.stageX, e.stageY);
			m.x = pt.x;
			m.y = pt.y;
			//trace("touch move");
		}
		
		private function onTouchEnd(e:TouchEvent):void 
		{
			removeChild(spheres[e.touchPointID]);
			delete spheres[e.touchPointID];
			
			//trace("touch end");
		}		
		
		public function update():void
		{
			var n:int = (ts.N <= maxPoints) ? ts.N : maxPoints;
			
			var i:int;			
			var newPt:Point;			
			
			for (i = 0; i < n; i++) {			
				var pt:PointObject = ts.cO.pointArray[i];
				
				hist = pt.history.length;
				
				if (hist < 0) hist = 0;
				
				var k:int = 0;
				var num:int = (hist <= maxTrails) ? hist : maxTrails;
				
				for (k = 0; k < num; k++) {	
					//newPt = manager.convertScreenData(pt.history[0].x, pt.history[0].y);
					newPt = manager.convertScreenData(pt.history[k].x, pt.history[k].y);
					trails[i][k].x = newPt.x;
					trails[i][k].y = newPt.y;				
					trails[i][k].z += 1 * k;					
					trails[i][k].material.alpha -= .001 * k;
					addChild(trails[i][k]);	
				}			
				
			}			
			
			for (var i:int = 0; i < trails.length; i++) {
				for (var j:int = 0; j < trails[i].length; j++) {					
					if (trails[i][j].material.alpha <= 0) {
						trails[i][j].material.alpha = 1;
						trails[i][j].z = 0;		
						if (contains(trails[i][j]))
							removeChild(trails[i][j]);						
					}
				}	
			}
			
			
			
			
		}	
		

	}
}