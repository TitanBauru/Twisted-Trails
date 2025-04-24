
/*=================================================================================================
	These functions are independent, so if you delete them from the asset, it will not interfere
	with other features of PPFX.
=================================================================================================*/

// Feather ignore all

/// @desc Create DisplaceMap renderer. This will be responsible for drawing the displace objects on a surface and sending it to the PPFX_Renderer() instance.
/// @returns {Struct}
function PPFX_DisplaceMapRenderer() constructor {
	__ppf_trace($"Displacemap Renderer created", 3);
	
	// Base
	__surface = -1;
	__surfaceWidth = 0;
	__surfaceHeight = 0;
	__renderResolution = 1;
	__oldRenderResolution = __renderResolution;
	__oldInputSurfaceWidth = 0;
	__oldInputSurfaceHeight = 0;
	
	// Misc
	__objectsArray = [];
	__allowRendering = true;
	__destroyed = false;
	
	#region Private Methods
		/// @ignore
		static __cleanSurface = function() {
			if (surface_exists(__surface)) surface_free(__surface);
		}
	#endregion
	
	#region Public Methods
	
	/// @desc Destroy displacemap system, freeing it from memory.
	static Destroy = function() {
		__cleanSurface();
		__destroyed = true;
	}
	
	/// @method AddObject(object)
	/// @desc Adds a displacemap object to the renderer. The system will call the Draw event of the added object whenever it exists.
	/// @param {Asset.GMObject} object Distortion object that will be used to call the Draw Event. Example: An object that renders rain with normal maps.
	static AddObject = function(object) {
		array_push(__objectsArray, object);
	}
	
	/// @method RemoveObject(object)
	/// @desc This function removes a previously added renderer object.
	/// @param {Asset.GMObject} object The renderer object.
	static RemoveObject = function(object) {
		var _array = __objectsArray;
		var i = 0, isize = array_length(_array);
		repeat(isize) {
			var _object = _array[i];
			if (_object == object) {
				array_delete(_array, i, 1); i -= 1;
				exit;
			}
			++i;
		}
	}
	
	/// @method SetRenderResolution(resolution)
	/// @desc This function modifies the final rendering resolution of the shockwaves surface, based on a percentage (0 to 1).
	/// @param {real} resolution Value from 0 to 1. Useful for pixelated effects. Default scale is 1.
	static SetRenderResolution = function(_resolution=1) {
		__renderResolution = clamp(_resolution, 0.01, 1);
	}
	
	/// @desc Get the surface used in the displacemap system. Used for debugging generally.
	/// @param {Struct} system_index description
	static GetSurface = function() {
		return __surface;
	}
	
	#endregion
	
	#region Render
	
	/// @method Render(renderer)
	/// @desc Renderize displacemap surface. Please note that this will not draw the surface, only generate the content.
	/// Basically this function will call the Draw Event of the objects in the array and draw them on the surface.
	/// This surface will be sent to the Post-processing renderer automatically.
	/// @param {Struct} renderer The returned variable by "new PPFX_Renderer()".
	/// @param {Bool} isRoomSpace If true, things will be drawn in room space (using camera). Note that this does not influence the internal surface size.
	static Render = function(_renderer=undefined, _isRoomSpace=true) {
		if (__destroyed) exit;
		
		// Checks
		if (_renderer == undefined) {
			if (__allowRendering) {
				__allowRendering = false;
				__ppf_trace("DisplaceMapRenderer: Post-processing renderer does not exist. Unable to proceed", 1);
			}
			exit;
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
			// send "normal map" texture to ppfx (you only need to reference it once - when the surface is created, for example)
			_renderer.SetEffectParameter(FF_DISPLACEMAP, PP_DISPLACEMAP_TEXTURE, surface_get_texture(__surface));
		}
		surface_set_target(__surface, _inputSurface);
			draw_clear(make_color_rgb(128, 128, 255));
			gpu_push_state();
			gpu_set_zwriteenable(false);
			gpu_set_tex_filter(true);
			gpu_set_tex_repeat(false);
			//gpu_set_blendmode_ext(bm_dest_color, bm_src_color);
			var _camera = -1, _camX = 0, _camY = 0, _camW = 0, _camH = 0,
				_array = __objectsArray,
				_surfW = __surfaceWidth,
				_surfH = __surfaceHeight;
			if (_isRoomSpace) {
				_camera = view_get_camera(view_current);
				_camX = __ppf_camera_get_view_x(_camera);
				_camY = __ppf_camera_get_view_y(_camera);
				_camW = __ppf_camera_get_view_width(_camera);
				_camH = __ppf_camera_get_view_height(_camera);
				camera_apply(_camera);
			}
			var _oldDepth = gpu_get_depth();
			var i = 0, isize = array_length(_array);
			repeat(isize) {
				// draw normal map sprites to distort screen
				with(_array[i]) {
					cam = _camera;
					camX = _camX;
					camY = _camY;
					camW = _camW;
					camH = _camH;
					surfaceWidth = _surfW;
					surfaceHeight = _surfH;
					gpu_set_depth(depth);
					event_perform(ev_draw, 0);
				}
				++i;
			}
			gpu_set_depth(_oldDepth);
			gpu_pop_state();
		surface_reset_target();
	}
	
	#endregion
}
