package com.gestureworks.cml.away3d.interfaces {
	import away3d.cameras.Camera3D;
	import away3d.core.base.IMaterialOwner;
	import away3d.core.base.IRenderable;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.traverse.EntityCollector;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.passes.MaterialPassBase;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	
	/**
	 * Implements Material objects.
	 * @author Ideum
	 */	
	public interface IMaterial {
		
		/**
		 * Returns asssets type.
		 */
		function get assetType():String;

		/**
		 * The light picker used by the material to provide lights to the material if it supports lighting.
		 * @see away3d.materials.lightpickers.LightPickerBase
		 * @see away3d.materials.lightpickers.StaticLightPicker
		 */
		function get lightPicker():LightPickerBase;		
		function set lightPicker(value:LightPickerBase):void;
		
		/**
		 * Indicates whether or not any used textures should use mipmapping. Defaults to true.
		 */
		function get mipmap():Boolean;
		function set mipmap(value:Boolean):void;

		/**
		 * Indicates whether or not any used textures should use smoothing.
		 */
		function get smooth():Boolean;
		function set smooth(value:Boolean):void;

		/**
		 * The depth compare mode used to render the renderables using this material.
		 * @see flash.display3D.Context3DCompareMode
		 */
		function get depthCompareMode():String;
		function set depthCompareMode(value:String):void;
		
		/**
		 * Indicates whether or not any used textures should be tiled. If set to false, texture samples are clamped to
		 * the texture's borders when the uv coordinates are outside the [0, 1] interval.
		 */
		function get repeat():Boolean;
		function set repeat(value:Boolean):void;
		
		/**
		 * Cleans up resources owned by the material, including passes. Textures are not owned by the material since they
		 * could be used by other materials and will not be disposed.
		 */
		function dispose():void;
		
		/**
		 * Defines whether or not the material should cull triangles facing away from the camera.
		 */
		function get bothSides():Boolean;
		function set bothSides(value:Boolean):void;
		
		/**
		 * The blend mode to use when drawing this renderable. The following blend modes are supported:
		 * <ul>
		 * <li>BlendMode.NORMAL: No blending, unless the material inherently needs it</li>
		 * <li>BlendMode.LAYER: Force blending. This will draw the object the same as NORMAL, but without writing depth writes.</li>
		 * <li>BlendMode.MULTIPLY</li>
		 * <li>BlendMode.ADD</li>
		 * <li>BlendMode.ALPHA</li>
		 * </ul>
		 */
		function get blendMode():String;
		
		/**
		 * Indicates whether visible textures (or other pixels) used by this material have
		 * already been premultiplied. Toggle this if you are seeing black halos around your
		 * blended alpha edges.
		 */
		function get alphaPremultiplied():Boolean;
		function set alphaPremultiplied(value:Boolean):void;
		
		/**
		 * Indicates whether or not the material requires alpha blending during rendering.
		 */
		function get requiresBlending():Boolean;
		
		/**
		 * An id for this material used to sort the renderables by material, which reduces render state changes across
		 * materials using the same Program3D.
		 */
		function get uniqueId():uint;
		
		/**
		 * The amount of passes used by the material.
		 * @private
		 */
		function get numPasses():uint;
		
		/**
		 * Indicates that the depth pass uses transparency testing to discard pixels.
		 * @private
		 */
		function hasDepthAlphaThreshold():Boolean;

		/**
		 * Sets the render state for the depth pass that is independent of the rendered object. Used when rendering
		 * depth or distances (fe: shadow maps, depth pre-pass).
		 *
		 * @param stage3DProxy The Stage3DProxy used for rendering.
		 * @param camera The camera from which the scene is viewed.
		 * @param distanceBased Whether or not the depth pass or distance pass should be activated. The distance pass
		 * is required for shadow cube maps.
		 *
		 * @private
		 */
		function activateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean = false):void;

		/**
		 * Clears the render state for the depth pass.
		 *
		 * @param stage3DProxy The Stage3DProxy used for rendering.
		 *
		 * @private
		 */
		function deactivateForDepth(stage3DProxy:Stage3DProxy):void;

		/**
		 * Renders a renderable using the depth pass.
		 *
		 * @param renderable The IRenderable instance that needs to be rendered.
		 * @param stage3DProxy The Stage3DProxy used for rendering.
		 * @param camera The camera from which the scene is viewed.
		 * @param viewProjection The view-projection matrix used to project to the screen. This is not the same as
		 * camera.viewProjection as it includes the scaling factors when rendering to textures.
		 *
		 * @private
		 */
		function renderDepth(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void;

		/**
		 * Indicates whether or not the pass with the given index renders to texture or not.
		 * @param index The index of the pass.
		 * @return True if the pass renders to texture, false otherwise.
		 *
		 * @private
		 */
		function passRendersToTexture(index:uint):Boolean;
		
		/**
		 * Sets the render state for a pass that is independent of the rendered object. This needs to be called before
		 * calling renderPass. Before activating a pass, the previously used pass needs to be deactivated.
		 * @param index The index of the pass to activate.
		 * @param stage3DProxy The Stage3DProxy object which is currently used for rendering.
		 * @param camera The camera from which the scene is viewed.
		 * @private
		 */
		function activatePass(index:uint, stage3DProxy:Stage3DProxy, camera:Camera3D):void;

		/**
		 * Clears the render state for a pass. This needs to be called before activating another pass.
		 * @param index The index of the pass to deactivate.
		 * @param stage3DProxy The Stage3DProxy used for rendering
		 *
		 * @private
		 */
		function deactivatePass(index:uint, stage3DProxy:Stage3DProxy):void;
		/**
		 * Renders the current pass. Before calling renderPass, activatePass needs to be called with the same index.
		 * @param index The index of the pass used to render the renderable.
		 * @param renderable The IRenderable object to draw.
		 * @param stage3DProxy The Stage3DProxy object used for rendering.
		 * @param entityCollector The EntityCollector object that contains the visible scene data.
		 * @param viewProjection The view-projection matrix used to project to the screen. This is not the same as
		 * camera.viewProjection as it includes the scaling factors when rendering to textures.
		 */
		function renderPass(index:uint, renderable:IRenderable, stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, viewProjection:Matrix3D):void;
		
		//
		// MATERIAL MANAGEMENT
		//
		/**
		 * Mark an IMaterialOwner as owner of this material.
		 * Assures we're not using the same material across renderables with different animations, since the
		 * Program3Ds depend on animation. This method needs to be called when a material is assigned.
		 *
		 * @param owner The IMaterialOwner that had this material assigned
		 *
		 * @private
		 */
		function addOwner(owner:IMaterialOwner):void;
		
		/**
		 * Removes an IMaterialOwner as owner.
		 * @param owner
		 * @private
		 */
		function removeOwner(owner:IMaterialOwner):void;
		
		/**
		 * A list of the IMaterialOwners that use this material
		 *
		 * @private
		 */
		function get owners():Vector.<IMaterialOwner>;
		
		/**
		 * Performs any processing that needs to occur before any of its passes are used.
		 *
		 * @private
		 */
		function updateMaterial(context:Context3D):void;
		
		/**
		 * Deactivates the last pass of the material.
		 *
		 * @private
		 */
		function deactivate(stage3DProxy:Stage3DProxy):void;
		
		/**
		 * Marks the shader programs for all passes as invalid, so they will be recompiled before the next use.
		 * @param triggerPass The pass triggering the invalidation, if any. This is passed to prevent invalidating the
		 * triggering pass, which would result in an infinite loop.
		 *
		 * @private
		 */
		function invalidatePasses(triggerPass:MaterialPassBase):void;
		
		/**
		 * Updates light picker
		 */
		function updateLightPicker():void;
		
	}	
}