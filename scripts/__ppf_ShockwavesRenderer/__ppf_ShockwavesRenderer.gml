
/*=================================================================================================
	These functions are independent, so if you delete them from the asset, it will not interfere
	with other features of PPFX.
=================================================================================================*/

// Feather ignore all

/// @desc Create shockwaves renderer. This will be responsible for drawing the shockwave objects on a surface and sending it to the PPFX_Renderer() instance.
/// @returns {Struct}
function PPFX_ShockwaveRenderer() constructor {
	__ppf_trace($"Shockwaves renderer created", 3);
	
	// Base
	__surface = -1;
	__surfaceWidth = 0;
	__surfaceHeight = 0;
	__renderResolution = 1;
	__oldRenderResolution = __renderResolution;
	__oldInputSurfaceWidth = 0;
	__oldInputSurfaceHeight = 0;
	
	// Misc
	__shockwaveObject = __ppf_objShockwave;
	__allowRendering = true;
	__destroyed = false;
	
	#region Private Methods
		/// @ignore
		static __cleanSurface = function() {
			if (surface_exists(__surface)) surface_free(__surface);
		}
	#endregion
	
	#region Public Methods
	
	/// @desc Destroy shockwave system, freeing it from memory.
	static Destroy = function() {
		__cleanSurface();
		__destroyed = true;
	}
	
	/// @method SetObject(object)
	/// @desc Defines which object is the parent of shockwaves, the system will draw any instance of it, when created.
	/// @param {Asset.GMObject} object Distortion object that will be used to call the Draw Event. Example: [obj_shockwave].
	static SetObject = function(_object) {
		__shockwaveObject = _object;
		return self;
	}
	
	/// @method RemoveObject(object)
	/// @desc This function removes a previously setted shockwave object.
	/// @param {Asset.GMObject} object The shockwave object.
	static RemoveObject = function(_object) {
		__shockwaveObject = undefined;
		return self;
	}
	
	/// @method SetRenderResolution(resolution)
	/// @desc This function modifies the final rendering resolution of the shockwaves surface, based on a percentage (0 to 1).
	/// @param {real} resolution Value from 0 to 1. Useful for pixelated effects. Default scale is 1.
	static SetRenderResolution = function(_resolution=1) {
		__renderResolution = clamp(_resolution, 0.01, 1);
		return self;
	}
	
	/// @desc Get the surface used in the shockwave system. Used for debugging generally.
	/// @method GetSurface()
	/// @param {Struct} system_index description
	static GetSurface = function() {
		return __surface;
	}
	
	/// @desc Returns the rendering resolution percentage (0 to 1).
	/// @method GetRenderResolution()
	/// @returns {real} Normalized size.
	static GetRenderResolution = function() {
		return __renderResolution;
	}
	
	#endregion
	
	#region Render
	
	/// @method Render(renderer)
	/// @desc Renderize shockwave surface. Please note that this will not draw the surface, only generate the content.
	/// Basically this function will call the Draw Event of the objects in the array and draw them on the surface.
	/// This surface will be sent to the Post-processing renderer automatically, for it to draw the shockwaves.
	/// @param {Struct} _renderer The returned variable by "new PPFX_Renderer()".
	static Render = function(_renderer=undefined) {
		if (__destroyed) exit;
		
		// Checks
		if (_renderer == undefined) {
			if (__allowRendering) {
				__allowRendering = false;
				__ppf_trace("ShockwavesRenderer: Post-processing renderer does not exist. Unable to proceed", 1);
			}
			exit;
		}
		
		// do nothing if the ppfx renderer's surface doesn't exists
		if (!_renderer.__allowRendering || __shockwaveObject == undefined) exit;
		
		// verify if there are any shockwaves instances, if not, disable everything (for performance)
		if (instance_number(__shockwaveObject) <= 0) {
			if (__allowRendering) {
				__allowRendering = false;
				_renderer.SetEffectEnable(FF_SHOCKWAVES, false);
				__cleanSurface();
			}
			exit;
		} else {
			if (!__allowRendering) {
				__allowRendering = true;
				_renderer.SetEffectEnable(FF_SHOCKWAVES, true);
			}
		}
		
		// Get input surface from renderer
		var _inputSurface = _renderer.__stackSurfaces[0];
		var _inputSurfaceWidth = _renderer.__renderSurfaceWidth;
		var _inputSurfaceHeight = _renderer.__renderSurfaceHeight;
		if (!surface_exists(_inputSurface) || _inputSurfaceWidth <= 0 || _inputSurfaceHeight <= 0) exit;
		
		// if different resolution, delete stuff to be updated
		if (_inputSurfaceWidth != __oldInputSurfaceWidth || _inputSurfaceHeight != __oldInputSurfaceHeight || __renderResolution != __oldRenderResolution) {
			__oldInputSurfaceWidth = _inputSurfaceWidth;
			__oldInputSurfaceHeight = _inputSurfaceHeight;
			__oldRenderResolution = __renderResolution;
			__cleanSurface();
			__surfaceWidth = _inputSurfaceWidth * __renderResolution;
			__surfaceHeight = _inputSurfaceHeight * __renderResolution;
			__surfaceWidth -= frac(__surfaceWidth);
			__surfaceHeight -= frac(__surfaceHeight);
		}
		
		// Generate distortion surface
		if (!surface_exists(__surface)) {
			__surface = surface_create(__surfaceWidth, __surfaceHeight);
		}
		surface_set_target(__surface, _inputSurface);
			draw_clear(make_color_rgb(128, 128, 255));
			gpu_push_state();
			gpu_set_zwriteenable(false);
			gpu_set_tex_filter(true);
			gpu_set_blendmode_ext(bm_dest_color, bm_src_color);
			camera_apply(view_get_camera(view_current));
			shader_set(__ppf_shBlendNormals);
			// draw normal map sprites to distort screen
			var _oldDepth = gpu_get_depth();
			with(__shockwaveObject) {
				gpu_set_depth(depth);
				event_perform(ev_draw, 0);
			}
			gpu_set_depth(_oldDepth);
			shader_reset();
			gpu_pop_state();
		surface_reset_target();
		
		// send "normal map" texture to ppfx (you only need to reference it once
		_renderer.SetEffectParameter(FF_SHOCKWAVES, PP_SHOCKWAVES_TEXTURE, surface_get_texture(__surface));
	}
	
	#endregion
}

/// @desc Create a new shockwave instance. Note: this is just to make it easier, you can use instance_create_layer directly too.
/// @param {Real} x The horizontal X position the object will be created at.
/// @param {Real} y The vertical Y position the object will be created at.
/// @param {String|Id.Layer} layer_id The layer ID (or name) to assign the created instance to.
/// @param {Real} index The shockwave shape (image_index).
/// @param {Real} scale The shockwave size (default: 1).
/// @param {Real} speedd The shockwave speed
/// @param {Asset.GMObject} object The object to be created (shockwave object).
/// @param {Asset.GMAnimCurve} anim_curve The animation curve to be used by shockwave object. It must contain the parameters "scale" and "alpha", which range from 0 to 1.
/// @returns {Id.Instance} Instance id.
function shockwave_instance_create(_x, _y, _layerId, _index=0, _scale=1, _speed=1, _object=__ppf_objShockwave, _animCurve=__ppf_acShockwave) {
	var _inst = instance_create_layer(_x, _y, _layerId, _object, {
		visible : false,
		image_index : _index,
		scale : _scale,
		spd : _speed,
		animCurve : _animCurve
	});
	return _inst;
}
