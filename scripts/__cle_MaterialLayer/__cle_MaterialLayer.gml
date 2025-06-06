
// Feather ignore all

/// @desc Creates a new material renderer for layers. A material refers to the properties of an object's surface. Any type of layer can be used as material (backgrounds, asset, instances, tile layer, etc).
/// 
/// You can add MULTIPLE room layers to this renderer, and they will be rendered inside a single surface (NOTE: for EACH CRYSTAL_PASS: NORMALS, MATERIAL, LIGHT, EMISSIVE... you need a DIFFERENT Crystal_MaterialLayer, which will be sent to the Crystal_Renderer() when tou call .Apply()..
/// When using "Material", you can embed Metallic, Roughness and AO in the same Crystal_MaterialLayer(), using the parameters from .AddLayers().
/// 
/// The depth of this material defines the drawing depth of the material surface, which contains all rendered layers of this material. Each individual layer is drawn at its own depth, despite being within the surface (useful for individual layer ordering).
/// WARNING: If the depth of things (including instances) changes dynamically, this may cause them to go out of range of where they are being rendered within the surface, making the material "not visible". This is NOT A BUG.
/// @method Crystal_MaterialLayer(type, layerEffect)
/// @param {Real} depth This is the drawing depth of the internal surface, which includes all rendered layers of THIS material layer. Setting the depth incorrectly can cause you to not realize that you are rendering underneath other layers!
/// @param {Enum.CRYSTAL_PASS} pass Defines the type of content of the layers to be rendered on the renderer's internal surface. Example: CRYSTAL_PASS.NORMALS. Necessary for the lighting system to understand the type of data it is processing.
/// @param {Struct} layerEffect Define which layer effect you want to be applied to the layer. Example: new Crystal_LayerFX_*. Use undefined if you don't want to add an effect. If you have more Material Layers, you can use the same effect struct created previously.
/// @param {Bool} drawEnable If it is enabled, in addition to rendering on the layer, it will draw the layer in the room. Useful if you are generating layer effects and still want to draw the layer in the room.
function Crystal_MaterialLayer(_depth, _pass, _layerEffect=undefined, _drawEnable=false) constructor {
	// Note: the surface is not rendered in the first frame because the final deferred surface is only available in the next frame, if everything is being created at the same time in the first room...
	// base
	__destroyed = false;
	__applied = false;
	__pass = _pass;
	__layerEffect = _layerEffect;
	__isDrawEnabled = _drawEnable;
	__isRenderEnabled = true;
	__ranges = []; // each range contains the start and the end layer
	__rangesSize = 0;
	__rangeIndex = 0;
	__surface = -1; // surface containing all contents from the range (each range can contain normal, emissive, ao data etc)
	__surfaceWidth = 0;
	__surfaceHeight = 0;
	__surfaceCamera = -1;
	__worldCamera = -1;
	__timeSource = undefined;
	__oldViewCurrent = -1;
	
	// properties
	//enabled = true;
	self.depth = _depth; // the surface (with layers) depth. all layers inside will "sort" with the depth too
	emission = 1;
	
	// misc
	__renderer = undefined;
	__surfaceNeedsHDR = false;
	switch(_pass) {
		case CRYSTAL_PASS.EMISSIVE:
		case CRYSTAL_PASS.LIGHT:
		case CRYSTAL_PASS.COMBINE:
			__surfaceNeedsHDR = true;
			break;
	}
	
	#region Private Methods
	
	/// @ignore
	__step = function() {
		if (!__isRenderEnabled) exit;
		// create surface once. this surface is used by all ranges for this layer renderer
		var _sourceSurf = __renderer.__sourceSurface;
		if (!surface_exists(_sourceSurf)) exit;
		__surfaceWidth = surface_get_width(_sourceSurf);
		__surfaceHeight = surface_get_height(_sourceSurf);
		if (surface_get_width(__surface) != __surfaceWidth || surface_get_height(__surface) != __surfaceHeight) {
			surface_free(__surface);
		}
		if (!surface_exists(__surface)) {
			__surface = surface_create(__surfaceWidth, __surfaceHeight, __surfaceNeedsHDR ? __renderer.__surfaceFormat : surface_rgba8unorm);
		}
		__rangeIndex = 0;
	}
	
	// This will run for each range of layers you have added using .AddLayers()
	// start of the range
	/// @ignore
	__rangeBeginRender = function() {
		// reset the current processing range index if the view changed
		if (view_current != __oldViewCurrent) {
			__oldViewCurrent = view_current;
			__rangeIndex = 0;
		}
		
		// this is executed following the room layer depth/order
		if (__isRenderEnabled && event_type == ev_draw && event_number == 0) {
			var _sourceSurf = __renderer.__sourceSurface;
			__worldCamera = view_get_camera(view_current); //camera_get_active();
			if (!surface_exists(__surface) || !surface_exists(_sourceSurf) || __worldCamera == -1) exit;
			
			// renderize layer/layers contents inside the surface
			surface_set_target(__surface, _sourceSurf);
				// clear the surface only in the first layer of all ranges, to prevent ghosting in the frame buffer
				if (__rangeIndex == 0) {
					draw_clear_ext(c_black, 0); // alpha must be 0 always, because the surface will be drawn on top of other things. The color is irrelevant here
				}
				camera_apply(__worldCamera);
				gpu_push_state();
				gpu_set_zwriteenable(false);
				//gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha); // must-have inside render target
				// if there is a subtype, write in different channels (for materials only)
				var _range = __ranges[__rangeIndex];
				if (_range.materialType != undefined) {
					// the alpha channel must always be activated, since materials also have an alpha channel.
					// to write rim lighting to the alpha channel, it is necessary to reset the alpha channel and then rewrite over it (TODO).
					switch(_range.materialType) {
						case CRYSTAL_MATERIAL.METALLIC: // R
							gpu_set_colorwriteenable(true, false, false, true);
							break;
						case CRYSTAL_MATERIAL.ROUGHNESS: // G
							gpu_set_colorwriteenable(false, true, false, true);
							break;
						case CRYSTAL_MATERIAL.AO: // B
							gpu_set_colorwriteenable(false, false, true, true);
							break;
						case CRYSTAL_MATERIAL.MASK: // A
							gpu_set_colorwriteenable(false, false, false, true);
							shader_set(__cle_shWriteToAlpha);
							break;
					}
				}
		}
	}
	
	// end of the range
	/// @ignore
	__rangeEndRender = function() {
		if (__isRenderEnabled && event_type == ev_draw && event_number == 0) {
				if (!surface_exists(__surface)) exit;
				//shader_reset();
				gpu_set_colorwriteenable(true, true, true, true);
				gpu_set_blendmode(bm_normal);
				gpu_pop_state();
			surface_reset_target();
			
			// draw the layer (if enabled) after rendering all the layers of this renderer
			if (__isDrawEnabled && __rangeIndex == __rangesSize-1) {
				// create a temporary orthographic camera to draw the surface on the screen
				if (__surfaceCamera == -1) {
					__surfaceCamera = camera_create_view(0, 0, __surfaceWidth, __surfaceHeight);
				} else {
					camera_set_view_size(__surfaceCamera, __surfaceWidth, __surfaceHeight);
				}
				camera_apply(__surfaceCamera);
				// draw surface on screen
				draw_surface_stretched(__surface, 0, 0, __surfaceWidth, __surfaceHeight);
				// re-apply current camera matrix
				camera_apply(__worldCamera);
			}
			__rangeIndex += 1;
		}
	}
	
	/// @ignore
	static __sortLayersArray = function(_a, _b) {
		return _b.topDepth - _a.topDepth;
	}
	
	/// @ignore
	static __cleanSurface = function() {
		if (surface_exists(__surface)) surface_free(__surface);
	}
	
	#endregion
	
	#region Public Methods
	/// @desc Destroys the material from memory. You should call this when you change rooms, for example. Useful for the Clean-Up Event.
	static Destroy = function() {
		// remove functions from the layers
		var i = 0, isize = array_length(__ranges), _layer = undefined;
		repeat(isize) {
			_layer = __ranges[i];
			layer_script_begin(_layer.bottomLayerId, -1);
			layer_script_end(_layer.topLayerId, -1);
			++i;
		}
		// destroy step time source
		if (__timeSource != undefined) {
			time_source_destroy(__timeSource);
			__timeSource = undefined;
		}
		// destroy surface and its camera
		__cleanSurface();
		if (__surfaceCamera != -1) camera_destroy(__surfaceCamera);
		__destroyed = true;
		__applied = false;
		return self;
	}
	
	/// @desc Call this after setting up the material and it will be sent to the last created renderer (or set with `crystal_set_renderer()`).
	/// @method Apply(renderer)
	/// @param {Struct.Crystal_Renderer} renderer The renderer to add the group for rendering. If not specified, adds to the last created renderer (or set with crystal_set_renderer()).
	static Apply = function(_renderer=global.__CrystalCurrentRenderer) {
		// Checks
		// if already applied, do nothing.
		if (__applied) {
			__crystal_trace("MaterialLayer not applied. Material already rendering!", 1);
			return;
		}
		// check if renderer exists
		if (_renderer == undefined) {
			__crystal_trace("MaterialLayer not applied. Renderer not found. (creation order?)", 1);
			return;
		}
		__renderer = _renderer;
		// check if there are any layers added
		if (array_length(__ranges) == 0) {
			__crystal_trace("MaterialLayer not applied. No layers added to it", 1);
			return;
		}
		// check for effects and check if it's compatible
		if (__layerEffect != undefined) {
			if (__layerEffect.__pass != __pass) {
				__crystal_trace("MaterialLayer not applied, effect not compatible with Material pass", 1);
				return;
			}
		}
		// Initialize function execution for this layer renderer
		if (__timeSource == undefined) {
			__timeSource = time_source_create(time_source_game, 1, time_source_units_frames, __step, [], -1);
			time_source_start(__timeSource);
		}
		// sort layers array based on depth, to make sure the order is depth-based and functions are correctly executed in order
		array_sort(__ranges, __sortLayersArray);
		// Setup layer scripts
		var i = 0, isize = array_length(__ranges), _range = undefined;
		repeat(isize) {
			// for each range of layers, define render scripts: START > renderize > END
			_range = __ranges[i];
			// apply scripts on the depth-ordered layers array
			layer_script_begin(_range.bottomLayerId, __rangeBeginRender);
			layer_script_end(_range.topLayerId, __rangeEndRender);
			++i;
		}
		__rangesSize = i; // 4
		
		// Add to renderer (once)
		_renderer.__addMaterialLayer(self);
		__applied = true;
		__destroyed = false;
	}
	
	/// @desc Add a range of layers for material rendering. You can add as many as you need! You don't need to add the bottom layer if you want to render only one layer in the range.
	/// Remember that the content of the layers must match the type of data you are processing: Emissive, Normals, etc. If you need to add different content, you will need another Crystal_MaterialLayer.
	/// @method AddLayers(topLayer, bottomLayer, type)
	/// @param {Id.Layer} topLayerId The top room layer id to render contents from.
	/// @param {Id.Layer} bottomLayerId The bottom room layer id to render contents from.
	/// @param {Enum.CRYSTAL_MATERIAL} materialType Useful for material. Example: CRYSTAL_MATERIAL.AO
	static AddLayers = function(_topLayerId, _bottomLayerId=_topLayerId, _materialType=undefined) {
		if (!layer_exists(_topLayerId)) {
			__crystal_trace($"MaterialLayer, layer not found: '{layer_get_name(_topLayerId)}'", 1);
			return;
		}
		if (!layer_exists(_bottomLayerId) && _bottomLayerId!=_topLayerId) {
			__crystal_trace($"MaterialLayer, layer not found: '{layer_get_name(_bottomLayerId)}'", 1);
			return;
		}
		__crystal_exception(layer_get_depth(_topLayerId) > layer_get_depth(_bottomLayerId), $"Inverted layer range order: {layer_get_name(_topLayerId)} ({layer_get_depth(_topLayerId)}), {layer_get_name(_bottomLayerId)} ({layer_get_depth(_bottomLayerId)})");
		// add range of layers to this material
		array_push(__ranges, {
			topLayerId : _topLayerId,
			bottomLayerId : _bottomLayerId,
			topDepth : layer_get_depth(_topLayerId),
			materialType : _materialType
		});
	}
	
	/// @desc Toggle MaterialLayer rendering. If disabled, this material will not render the layers (plural) to the internal surface, saving CPU and GPU. This means that the surface content will not be updated and may disappear if you resize the game window etc.
	/// @method SetRenderEnable(enabled)
	/// @param {Bool} enabled Toggle rendering.
	/// @param {Bool} clearMemory If true and "enabled" is false, cleans the internal surfaces from VRAM.
	static SetRenderEnable = function(_enabled=-1, _clearMemory=true) {
		if (_enabled == -1) {
			__isRenderEnabled = !__isRenderEnabled;
		} else {
			__isRenderEnabled = _enabled;
		}
		if (!__isRenderEnabled && _clearMemory) {
			if (surface_exists(__surface)) surface_free(__surface);
		}
	}
	
	/// @desc Toggle material drawing in the room. If disabled, the material will continue to draw in the Crystal renderer with its layers, but will not draw the raw surface with layers in the room.
	/// Enabling this is generally only useful if you are using layer effects (from Crystal).
	/// @method SetDrawEnable(enabled)
	/// @param {Bool} enabled Toggle drawing.
	static SetDrawEnable = function(_enabled=-1) {
		if (_enabled == -1) {
			__isDrawEnabled = !__isDrawEnabled;
		} else {
			__isDrawEnabled = _enabled;
		}
	}
	#endregion
}
